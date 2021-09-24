import { getConnection, Repository } from "typeorm"
import Question from "../entities/question.entity"
import File from "../entities/file.entity"
import fileService from "./file.service"
import spreadsheetUtils from "../shared/utils/spreadsheet.utils"
import { Worksheet } from "exceljs"

const connection = getConnection()

class QuestionService {
    repository: Repository<Question>

    async insertManyTeams(activityId: number, fileId: number, totalQuestions: number) {
        for(let _i = 1; _i <= totalQuestions; _i++) {
            this.insertTeams(activityId, fileId, _i)
        }
    }

    async insertTeams(activityId: number, fileId: number, questionNumber: number) {
        this.repository = connection.getRepository(Question)
        const question: string = await this.getQuestionNameTeams(fileId, questionNumber)

        if(question != null) {
            const questionRegister = new Question()
            questionRegister.description = question
            //Por enquanto será sempre 1. Estamos contando apenas com alternativas
            questionRegister.total_points = 1
            questionRegister.activities_id = activityId

            this.repository.insert(questionRegister)
        }
    }

    async getQuestionNameTeams(fileId: number, questionNumber: number) : Promise<string> {
        const file: File = await fileService.findById(fileId)
        const worksheet: Worksheet = await spreadsheetUtils.getWorksheet(file)

        const defaultColumns: number = 8
        const columnQuestionDescription: number = defaultColumns + 1 + ((questionNumber - 1) * 3)
        const columnQuestionPoints: number = defaultColumns + 2 + ((questionNumber - 1) * 3)

        const question = worksheet.getRow(1).getCell(columnQuestionDescription).value.toString()
        const isValidQuestion = worksheet.getRow(2).getCell(columnQuestionPoints).value != null

        return isValidQuestion ? question : null
    }

    async getAnswerQuestionTeams(fileId: number, questionNumber: number) : Promise<any[]> {
        let answer: any[] = []
        
        const file: File = await fileService.findById(fileId)
        const worksheet: Worksheet = await spreadsheetUtils.getWorksheet(file)

        const defaultColumns: number = 8
        const columnName: number = 5
        const columnQuestionAnswer: number = defaultColumns + 1 + ((questionNumber - 1) * 3)
        const columnQuestionPoints: number = defaultColumns + 2 + ((questionNumber - 1) * 3)
        
        const isValidQuestion = worksheet.getRow(2).getCell(columnQuestionPoints).value != null
        if(!isValidQuestion)
            return null;
            
        const question: string = worksheet.getRow(1).getCell(columnQuestionAnswer).value.toString()
        worksheet.eachRow((row) => {
            if(row.number > 1) {
                answer.push({
                    student_name: row.getCell(columnName).value.toString(),
                    question: question,
                    answer: row.getCell(columnQuestionAnswer).value.toString(),
                    points: row.getCell(columnQuestionPoints).value.toString()
                })
            }
        })

        return answer
    } 

    async getByActivityId(id: number) {
        this.repository = connection.getRepository(Question)
        return this.repository.find({ where: { activities_id: id }})
    }
}

export default new QuestionService()