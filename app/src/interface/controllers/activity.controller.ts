import { Request, Response } from 'express'
import activityService from '../../app/services/activity.service'
import activityStudentService from '../../app/services/activity_student.service'
import fileService from '../../app/services/file.service'
import questionService from '../../app/services/question.service'
import questionStudentService from '../../app/services/question_student.service'
import studentService from '../../app/services/student.service'

class ActivityController {
    async sendTeamsSpreadsheet(request: Request, response: Response) {
        const file = request.file

        try {
            const fileId: number = await fileService.insert(file)
            const columns: any[] = await activityService.getTeamsActivityMainColumnsInfo(fileId)
            return response.status(201).json({
                file_id: fileId,
                columns: columns
            })
        } catch (error) {
            response.status(500).json({ error: error.message })
        }
    }

    async insertTeamsActivity(request: Request, response: Response) {
        const teacherId: string = request.userId
        const body: any = request.body

        try {
            await fileService.configureHeaders(body.file_id, body.columns)
            const activityId = await activityService.insert(teacherId, body)
            await questionService.insertManyTeams(activityId, body.file_id, body.number_questions)
            //TODO: Retirar este método. Futuramente os alunos devem ser inseridos em um endpoint separado
            await studentService.insertIfNotExists(body.file_id, body.classroom_id);
            await activityStudentService.insertManyTeams(activityId, body.classroom_id)
            await questionStudentService.insertManyTeams(body.file_id, activityId, body.classroom_id, body.number_questions)
            return response.status(201).json()
        } catch (error) {
            response.status(500).json({ error: error.message })
        }
    }
}

export default new ActivityController()