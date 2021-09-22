import exceljs, { CellValue, Workbook, Worksheet } from "exceljs"

class WorksheetUtils {
    //TYPES
    TYPE_XLSX: string
    TYPE_CSV: string

    //COLUMNS
    COLUMN_NAME: string
    COLUMN_ACTIVITY: string
    COLUMN_TIME_CONTROL: string

    constructor() {
        //TYPES
        this.TYPE_XLSX = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
        this.TYPE_CSV = "text/csv"

        //COLUMNS
        this.COLUMN_NAME = "Nome"
        this.COLUMN_ACTIVITY = "Atividade"
        this.COLUMN_TIME_CONTROL = "Controle de horário"
    }

    async getColumnNames(worksheet: Worksheet) : Promise<CellValue[]> {
        let columnNames: CellValue[] = []
        worksheet.getRow(1).eachCell((cell) => {
            if(cell.value != null){
                columnNames.push(cell.value)
            }
        })      
        return columnNames
    }

    async getColumnExamples(worksheet: Worksheet) : Promise<CellValue[]> {
        let columnExamples: CellValue[] = []
        worksheet.getRow(2).eachCell((cell) => {
            columnExamples.push(cell.value)
        })      
        return columnExamples
    }

    async getColumnSuggestions(worksheet: Worksheet): Promise<CellValue[]> {
        const columnNames: CellValue[] = await this.getColumnNames(worksheet)
        let columnSuggestions: CellValue[] = []
        columnNames.forEach((columnName) => {
            columnSuggestions.push(this._getSuggestionName(columnName.toString()))
        })
        return columnSuggestions
    }

    async getWorksheet(stream, type) : Promise<Worksheet> {
        if(type === this.TYPE_XLSX) {
            const fileWorkbook: Workbook = await new exceljs.Workbook().xlsx.read(stream)
            return fileWorkbook.getWorksheet(1)
        }
    }

    _getSuggestionName(column: string) : string {
        const columnLowerCase: string = column.toLowerCase()
        if(columnLowerCase.includes("nome")){
            return this.COLUMN_NAME
        }
        else if(columnLowerCase.includes("atividade")){
            return this.COLUMN_ACTIVITY
        }
        else if(columnLowerCase.includes("data") || columnLowerCase.includes("hora")) {
            return this.COLUMN_TIME_CONTROL
        }
        else {
            return "-"
        }
    }
}

export default new WorksheetUtils()