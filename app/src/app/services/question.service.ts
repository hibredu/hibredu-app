import { getConnection, Repository } from "typeorm"
import Question from "../entities/question.entity"
import File from "../entities/file.entity"
import fileService from "./file.service"
import spreadsheetUtils from "../shared/utils/spreadsheet.utils"

const connection = getConnection()

class QuestionService {
    repository: Repository<Question>

    async insertManyTeams(activityId: number, fileId: number, numberQuestions: number) {
        for(let _i = 1; _i <= numberQuestions; _i++) {
            this.insertTeams(activityId, fileId, _i)
        }
    }

    async insertTeams(activityId: number, fileId: number, numberQuestions: number) {
        this.repository = connection.getRepository(Question)
        const question: string = await this.getQuestionNameTeams(fileId, numberQuestions)

        if(question != null) {
            const questionRegister = new Question()
            questionRegister.description = question
            questionRegister.total_points = 1
            questionRegister.activities_id = activityId

            await this.repository.insert(questionRegister)
        }
    }

    async getQuestionNameTeams(fileId: number, questionNumber: number) : Promise<string> {
        const file: File = await fileService.findById(fileId)

        const worksheet = await spreadsheetUtils.getWorksheet(file)

        const defaultColumns: number = 8
        const columnQuestionDescription: number = defaultColumns + 1 + ((questionNumber - 1) * 3)
        const columnQuestionPoints: number = defaultColumns + 2 + ((questionNumber - 1) * 3)

        const question = worksheet.getRow(1).getCell(columnQuestionDescription).value.toString()
        const isValidQuestion = worksheet.getRow(2).getCell(columnQuestionPoints).value != null

        return isValidQuestion ? question : null
    }

    async getAnswerTeamsStudents(fileId: number, questionNumber: number) : Promise<any[]> {
        const file: File = await fileService.findById(fileId)

        const worksheet = await spreadsheetUtils.getWorksheet(file)

        const defaultColumns: number = 8
        const columnName: number = 5
        const columnQuestionAnswer: number = defaultColumns + 1 + ((questionNumber - 1) * 3)
        const columnQuestionPoints: number = defaultColumns + 2 + ((questionNumber - 1) * 3)
  
        let questionStudent: any[] = []
        worksheet.eachRow((row) => {
            if(row.number > 1 && row.getCell(columnQuestionPoints).value != null) {
                console.log(row.getCell(columnName).value)
                console.log(row.getCell(columnQuestionAnswer).value)
                console.log(row.getCell(columnQuestionPoints).value)
                questionStudent.push({
                    name: row.getCell(columnName).value.toString(),
                    answer: row.getCell(columnQuestionAnswer).value.toString(),
                    points: row.getCell(columnQuestionPoints).value.toString()
                })
            }
        })

        return questionStudent
    } 

    async getByActivityId(id: number) {
        this.repository = connection.getRepository(Question)
        return this.repository.find({ where: { activities_id: id }})
    }
}

export default new QuestionService()