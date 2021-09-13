import { getConnection, getRepository, Repository } from "typeorm"
import File from "../entities/file.entity";
import suggestionNames from "../shared/utils/suggestionNames";
import exceljs from 'exceljs';

const connection = getConnection()

class FileService {
    repository: Repository<File>

    async saveFile(file: Express.Multer.File){
        this.repository = connection.getRepository(File)

        const fileRegister = new File()
        fileRegister.content = file.path
        fileRegister.type = file.mimetype

        await this.repository.insert(fileRegister)

        return fileRegister.id
    }

    async getFile(id: number){
        this.repository = connection.getRepository(File)
        return await this.repository.findOne(id)
    }
    
    async getColumns(file: Express.Multer.File){
        const columnNames = await this._getColumnNames(file)
        const columnExamples = await this._getColumnExamples(file)
        const columnSuggestions = await this._getColumnSuggestions(file)
        let columns = []
        for (var _i = 0; _i < columnNames.length; _i++) {
            let column = [{
                field_name: columnNames[_i],
                example: columnExamples[_i],
                suggestion: columnSuggestions[_i]
            }]
            columns.push(column)
        }
        return columns
    }

    async configureColumns(fileId: number, columns: any[]){        
        this.repository = getRepository(File)

        const file = await this.repository.findOne(fileId)
        const workbook = new exceljs.Workbook()

        if(file.type === "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet") {
            let worksheet = await workbook.xlsx.readFile(file.content)
            //Definindo nomes dos headers
            const row = worksheet.getWorksheet(1).getRow(1)
            columns.forEach((column) => {
                console.log(column.field_name)
                for (var _i = 1; _i <= columns.length; _i++){
                    let cell = row.getCell(_i)
                    if(cell.value === column.field_name) {
                        cell.value = column.final_field
                        break;
                    }   
                }
            })
            row.commit()
            await workbook.xlsx.writeFile(file.content)
        }
    }

    async _getColumnNames(file: Express.Multer.File) {
        const worksheet = await this._getWorksheet(file)
        let columnNames = []
        worksheet.getRow(1).eachCell((cell) => {
            if(cell.value != null){
                columnNames.push(cell.value)
            }
        })      
        return columnNames
    }

    async _getColumnExamples(file: Express.Multer.File){
        const worksheet = await this._getWorksheet(file)
        let columnExamples = []
        worksheet.getRow(2).eachCell((cell) => {
            columnExamples.push(cell.value)
        })      
        return columnExamples
    }

    async _getColumnSuggestions(file: Express.Multer.File){
        const columnNames = await this._getColumnNames(file)
        let columnSuggestions = []
        columnNames.forEach((columnName) => {
            columnSuggestions.push(suggestionNames(columnName))
        })
        return columnSuggestions
    }

    async _getWorksheet(file: Express.Multer.File){
        const workbook = new exceljs.Workbook()

        if(file.mimetype === "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet") {
            const fileWorkbook = await workbook.xlsx.readFile(file.path)
            return fileWorkbook.getWorksheet(1)
        }
        else {
            return null
        }
    }

    async _getWorksheetFromDatabase(file: File){
        const workbook = new exceljs.Workbook()

        if(file.type === "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet") {
            const fileWorkbook = await workbook.xlsx.readFile(file.content.toString())
            return fileWorkbook.getWorksheet(1)
        }
        else {
            return null
        }
    }
}

export default new FileService()