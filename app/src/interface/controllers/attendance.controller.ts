import { Request, Response } from 'express'
import { Between, LessThanOrEqual, MoreThanOrEqual } from 'typeorm'
import attendanceService from '../../app/services/attendance.service'
import fileService from '../../app/services/fileService'
import cleanDate from '../../app/shared/utils/cleanData'

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

    async sendSpreadsheet(request: Request, response: Response) {
        const file = request.file

        try {
            const columns = await fileService.getColumns(file)
            const fileId = await fileService.saveFile(file);
            return response.status(201).json({
                file_id: fileId,
                columns: columns
            })
        } catch(error) {
            response.status(500).json({ error: error.message })
        }
    }

    async insertAttendance(request: Request, response: Response){
        const body = request.body
        try {
            await fileService.configureColumns(body.file_id, body.columns)
            var attendanceId = await attendanceService.insert(body)
            return response.status(201).json({
                attendance_id: attendanceId
            })
        } catch(error) {
            response.status(500).json({ error: error.message })
        }

        return response.status(200)
    }
}

export default new AttendanceController()