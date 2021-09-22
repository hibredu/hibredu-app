import { getConnection, getRepository, Repository } from "typeorm"
import File from "../entities/file.entity";
import exceljs, { Cell, CellValue, Row, Workbook } from 'exceljs';
import WorksheetUtils from "../shared/utils/worksheet.utils";

const connection = getConnection()

class FileService {
    repository: Repository<File>

    async insertFile(file: Express.Multer.File): Promise<number> {
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
    
    async getColumnsInfo(fileId: number): Promise<any[]> {
        const file: File = await this.getFile(fileId)
        const worksheet = await WorksheetUtils.getWorksheet(file.content, file.type)

        const columnNames: CellValue[] = await WorksheetUtils.getColumnNames(worksheet)
        const columnExamples: CellValue[] = await WorksheetUtils.getColumnExamples(worksheet)
        const columnSuggestions: CellValue[] = await WorksheetUtils.getColumnSuggestions(worksheet)

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

    async normalizeHeaders(fileId: number, columns: any[]) : Promise<void> {        
        this.repository = getRepository(File)
        const file: File = await this.repository.findOne(fileId)

        if(file.type === WorksheetUtils.TYPE_XLSX) {
            let workbook: Workbook = await new exceljs.Workbook().xlsx.readFile(file.content)
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
    
    async getStudentNames(fileId: number): Promise<string[]> {
        const file: File = await this.getFile(fileId)
        const worksheet = await WorksheetUtils.getWorksheet(file.content, file.type)

        const columnNames: CellValue[] = await WorksheetUtils.getColumnNames(worksheet)
        let studentNames: string[]
        for (var _i = 1; _i <= columnNames.length; _i++){
            if(columnNames[_i - 1] === WorksheetUtils.COLUMN_NAME){
                studentNames = worksheet.getColumn(_i).values.map((cell) => cell.toString().toUpperCase())
                break;
            }
        }
        
        //REMOVENDO OS 2 PRIMEIROS ÍNDICES. O PRIMEIRO É UNDEFINED E O OUTRO O NOME DA COLUNA
        studentNames.shift();
        studentNames.shift();

        //RETORNANDO APENAS UM DE CADA NOME
        return [ ...new Set( studentNames ) ];
    }
}

export default new FileService()