import { Request, Response } from 'express'
import { Between, LessThanOrEqual, MoreThanOrEqual } from 'typeorm'
import attendanceService from '../../app/services/attendance.service'
import fileService from '../../app/services/file.service'
import studentService from '../../app/services/student.service'
import cleanDate from '../../app/shared/utils/cleanData'
import attendanceStudentsService from '../../app/services/attendance_students.service'
import hibredu_rewardsService from '../../app/services/hibredu_rewards.service'

class AttendanceController {

    async getByClass(request: Request, response: Response) {
        const { id } = request.params
        const options: Map<String, any> = new Map()

        try {
            const { before, after } = request.query
            if (after || before) {
                if (!after) {
                    options["created_at"] = LessThanOrEqual(cleanDate(before, 1));
                } else if (!before) {
                    options["created_at"] = MoreThanOrEqual(cleanDate(after, 0));
                } else {
                    options["created_at"] = Between(
                        cleanDate(after, 0),
                        cleanDate(before, 1)
                    )
                }
            }
            const attendance = await attendanceService.getByClass(parseInt(id), options)
            response.status(200).json(attendance)
        } catch (error) {
            response.status(500).json({ error: error.message })
        }
    }

    async getById(request: Request, response: Response) {
        const { id } = request.params

        try {
            const attendance = await attendanceService.getById(parseInt(id), { relations: ["attendanceStudents"] })
            response.status(200).json(attendance)
        } catch (error) {
            if (error.message === 'Attendance not found') {
                response.status(404).json({ error: error.message })
            }
            response.status(500).json({ error: error.message })
        }
    }

    async delete(request: Request, response: Response) {
        const { id } = request.params

        try {
            await attendanceService.delete(parseInt(id))
            response.status(204).json({})
        } catch (error) {
            if (error.message === 'Attendance not found') {
                response.status(404).json({ error: error.message })
            }
            response.status(500).json({ error: error.message })
        }
    }

    async sendTeamsSpreadsheet(request: Request, response: Response) {
        const file = request.file

        try {
            hibredu_rewardsService.insertOrUpdate(request.userId)
            const fileId: number = await fileService.insert(file)
            const columns: any[] = await fileService.getColumnsInfo(fileId)
            return response.status(201).json({
                file_id: fileId,
                columns: columns
            })
        } catch(error) {
            response.status(500).json({ error: error.message })
        }
    }

    async insertAttendance(request: Request, response: Response){
        const teacherId: string = request.userId
        const body: any = request.body
        try {
            await fileService.configureHeaders(body.file_id, body.columns)
            const attendanceId: number = await attendanceService.insert(teacherId, body)
            await studentService.insertIfNotExists(body.file_id, body.classroom_id);
            await attendanceStudentsService.insert(attendanceId, body.classroom_id);            
            return response.status(201).json()
        } catch(error) {
            response.status(500).json({ error: error.message })
        }
    }
}

export default new AttendanceController()