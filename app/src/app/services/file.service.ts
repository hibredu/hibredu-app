import { getConnection, getRepository, Repository } from "typeorm"
import File from "../entities/file.entity";
import suggestionNames from "../shared/utils/suggestionNames";
import exceljs, { Cell, CellValue, Row, Workbook, Worksheet } from 'exceljs';

const connection = getConnection()

class FileService {
    repository: Repository<File>
    xlsxType: string

    constructor() {
        this.xlsxType = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
    }

    async saveFile(file: Express.Multer.File): Promise<number> {
        this.repository = connection.getRepository(File)

        const fileRegister = new File()
        fileRegister.content = file.path
        fileRegister.type = file.mimetype

        await this.repository.insert(fileRegister)

        return fileRegister.id
    }

    async getFile(id: number): Promise<File> {
        this.repository = connection.getRepository(File)
        return await this.repository.findOne(id)
    }
    
    async getColumns(file: Express.Multer.File): Promise<any[]> {
        const columnNames: CellValue[] = await this.getColumnNames(file)
        const columnExamples: CellValue[] = await this.getColumnExamples(file)
        const columnSuggestions: CellValue[] = await this.getColumnSuggestions(file)

        let columns: any[] = []
        for (var _i = 0; _i < columnNames.length; _i++) {
            let column: any = [{
                field_name: columnNames[_i],
                example: columnExamples[_i],
                suggestion: columnSuggestions[_i]
            }]
            columns.push(column)
        }
        return columns
    }

    async configureColumns(fileId: number, columns: any[]) : Promise<void> {        
        this.repository = getRepository(File)

        const file: File = await this.repository.findOne(fileId)

        if(file.type === this.xlsxType) {
            let workbook: Workbook = await new exceljs.Workbook().xlsx.readFile(file.content)
            //Definindo nomes dos headers
            const row: Row = workbook.getWorksheet(1).getRow(1)
            columns.forEach((column) => {
                for (var _i = 1; _i <= columns.length; _i++){
                    let cell: Cell = row.getCell(_i)
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

    async getColumnNames(file: Express.Multer.File) : Promise<CellValue[]> {
        const worksheet: Worksheet = await this.getWorksheet(file)
        let columnNames: CellValue[] = []
        worksheet.getRow(1).eachCell((cell) => {
            if(cell.value != null){
                columnNames.push(cell.value)
            }
        })      
        return columnNames
    }

    async getColumnExamples(file: Express.Multer.File) : Promise<CellValue[]> {
        const worksheet: Worksheet = await this.getWorksheet(file)
        let columnExamples: CellValue[] = []
        worksheet.getRow(2).eachCell((cell) => {
            columnExamples.push(cell.value)
        })      
        return columnExamples
    }

    async getColumnSuggestions(file: Express.Multer.File): Promise<CellValue[]> {
        const columnNames: CellValue[] = await this.getColumnNames(file)
        let columnSuggestions: CellValue[] = []
        columnNames.forEach((columnName) => {
            columnSuggestions.push(suggestionNames(columnName.toString()))
        })
        return columnSuggestions
    }

    async getWorksheet(file: Express.Multer.File) : Promise<Worksheet> {
        if(file.mimetype === this.xlsxType) {
            const fileWorkbook: Workbook = await new exceljs.Workbook().xlsx.readFile(file.path)
            return fileWorkbook.getWorksheet(1)
        }
    }

    async getWorksheetFromDatabase(file: File) : Promise<Worksheet> {
        if(file.type === this.xlsxType) {
            const fileWorkbook = await new exceljs.Workbook().xlsx.readFile(file.content.toString())
            return fileWorkbook.getWorksheet(1)
        }
    }
}

export default new FileService()