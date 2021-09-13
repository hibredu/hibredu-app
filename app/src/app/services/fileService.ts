import { getConnection, Repository } from "typeorm"
import File from "../entities/file.entity";
import suggestionNames from "../shared/utils/suggestionNames";
import exceljs from 'exceljs';

const connection = getConnection()

class FileService {
    repository: Repository<File>

    async saveFile(file: Express.Multer.File){
        this.repository = connection.getRepository(File)

        const fileRegister = new File()
        fileRegister.content = file.buffer
        fileRegister.type = file.mimetype

        await this.repository.insert(fileRegister)

        return fileRegister.id
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
        const excelFile = await workbook.xlsx.load(file.buffer)
        return excelFile.getWorksheet(1)
    }
}

export default new FileService()