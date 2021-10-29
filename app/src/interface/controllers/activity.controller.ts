import { Request, Response } from 'express'
import activityService from '../../app/services/activity.service'
import activityStudentService from '../../app/services/activity_student.service'
import fileService from '../../app/services/file.service'
import questionService from '../../app/services/question.service'
import questionStudentService from '../../app/services/question_student.service'
import studentService from '../../app/services/student.service'
import hibredu_rewardsService from '../../app/services/hibredu_rewards.service'

class ActivityController {
    async sendTeamsSpreadsheet(request: Request, response: Response) {
        const file = request.file

        try {
            hibredu_rewardsService.insertOrUpdate(request.userId)
            const fileId: number = await fileService.insert(file)
            const columns: any[] = await activityService.getTeamsActivityMainColumnsInfo(fileId)
            return response.status(201).json({
                file_id: fileId,
                columns: columns
            })
        } catch (error) {
            return response.status(500).json({ error: error?.message || error })
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
            response.status(500).json({ error: error?.message || error })
        }
    }

    async getByClassroom(request: Request, response: Response) {
        const classroomId: number = parseInt(request.params.classroom_id)

        try {
            const activities = await activityService.getByClassroom(classroomId)
            return response.status(200).json(activities)
        } catch (error) {
            return response.status(500).json({ error: error?.message || error })
        }
    }
}

export default new ActivityController()