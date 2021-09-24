import { getConnection, getRepository, Repository } from "typeorm"
import File from "../entities/file.entity";
import exceljs, { Cell, CellValue, Row, Workbook } from 'exceljs';
import SpreadsheetUtils from "../shared/utils/spreadsheet.utils";
import aws from 'aws-sdk'
import Stream from 'stream';

const connection = getConnection()

class FileService {
    repository: Repository<File>

    async insert(file): Promise<number> {
        this.repository = connection.getRepository(File)

        const fileRegister = new File()
        fileRegister.content = file.path || file.key
        fileRegister.type = file.mimetype

        await this.repository.insert(fileRegister)

        return fileRegister.id
    }

    async storageOrReplaceWorkbook(workbook: Workbook, file: File) {
        const stream = new Stream.PassThrough();

        if(process.env.STORAGE_TYPE === 's3') {
            if (file.type === SpreadsheetUtils.TYPE_XLSX) {
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
            if(file.type === SpreadsheetUtils.TYPE_XLSX) {
                return workbook.xlsx.writeFile(file.content);
            }
        }
    }

    async findById(id: number): Promise<File> {
        this.repository = connection.getRepository(File)
        return await this.repository.findOne(id)
    }

    async getColumnsInfo(fileId: number): Promise<any[]> {
        const file: File = await this.findById(fileId)
        const worksheet = await SpreadsheetUtils.getWorksheet(file)

        const columnNames: CellValue[] = await SpreadsheetUtils.getColumnNames(worksheet)
        const columnExamples: CellValue[] = await SpreadsheetUtils.getColumnExamples(worksheet)
        const columnSuggestions: CellValue[] = await SpreadsheetUtils.getColumnSuggestions(worksheet)

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

    async configureHeaders(fileId: number, columns: any[]) : Promise<void> {        
        this.repository = getRepository(File)
        const file: File = await this.repository.findOne(fileId)

        if(file.type === SpreadsheetUtils.TYPE_XLSX) {
            let workbook: Workbook = await new exceljs.Workbook().xlsx.read(SpreadsheetUtils.getSpreadsheetStream(file))
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
}

export default new FileService()