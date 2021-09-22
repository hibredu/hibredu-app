import { getConnection, getRepository, Repository } from "typeorm"
import File from "../entities/file.entity";
import exceljs, { Cell, CellValue, Row, Workbook } from 'exceljs';
import WorksheetUtils from "../shared/utils/worksheet.utils";
import aws from 'aws-sdk'
import fileStream from 'fs'
import Stream from 'stream';

const connection = getConnection()

class FileService {
    repository: Repository<File>

    async insertFile(file): Promise<number> {
        this.repository = connection.getRepository(File)

        const fileRegister = new File()
        fileRegister.content = file.path || file.key
        fileRegister.type = file.mimetype

        await this.repository.insert(fileRegister)

        return fileRegister.id
    }

    async getFile(id: number): Promise<File> {
        this.repository = connection.getRepository(File)
        return await this.repository.findOne(id)
    }

    getSpreadsheetStream(file: File) {
        if(process.env.STORAGE_TYPE === 's3') {
            const s3 = new aws.S3();
            const params = {
                Bucket: process.env.BUCKET_NAME, 
                Key: file.content
            }
            const s3file = s3.getObject(params)
            return s3file.createReadStream()
        }
        else if (process.env.STORAGE_TYPE === 'local') {
            return fileStream.createReadStream(file.content);
        }
    }

    async storageOrReplaceWorkbook(workbook: Workbook, file: File) {
        const stream = new Stream.PassThrough();

        if(process.env.STORAGE_TYPE === 's3') {
            if (file.type === WorksheetUtils.TYPE_XLSX) {
                await workbook.xlsx.write(stream)
                    .then(() => {
                        const s3 = new aws.S3();
                        return s3.upload({
                            Bucket: process.env.BUCKET_NAME, 
                            Key: file.content,
                            Body: stream,
                            ContentType: file.type
                        }).promise()
                    })
                    .then(() => {
                        console.log("Upload feito com sucesso")
                    })
                    .catch(() => {
                        console.log("Erro no upload")
                    })
            }   
        }
        else if (process.env.STORAGE_TYPE === 'local') {
            if(file.type === WorksheetUtils.TYPE_XLSX) {
                return workbook.xlsx.writeFile(file.content);
            }
        }
    }
    
    async getColumnsInfo(fileId: number): Promise<any[]> {
        const file: File = await this.getFile(fileId)
        const worksheet = await WorksheetUtils.getWorksheet(this.getSpreadsheetStream(file), file.type)

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
            let workbook: Workbook = await new exceljs.Workbook().xlsx.read(this.getSpreadsheetStream(file))
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
            await this.storageOrReplaceWorkbook(workbook, file)
        }
    }
    
    async getStudentNames(fileId: number): Promise<string[]> {
        const file: File = await this.getFile(fileId)
        const worksheet = await WorksheetUtils.getWorksheet(this.getSpreadsheetStream(file), file.type)

        const columnNames: CellValue[] = await WorksheetUtils.getColumnNames(worksheet)
        let studentNames: string[]
        for (var _i = 1; _i <= columnNames.length; _i++){
            console.log(worksheet.getColumn(_i).values)
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