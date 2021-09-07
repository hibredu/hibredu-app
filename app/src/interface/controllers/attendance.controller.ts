import { Request, Response } from 'express'
import attendanceService from '../../app/services/attendance.service'

class AttendanceController {

    async getByClass(request: Request, response: Response) {
        const { id } = request.params

        try {
            const attendance = await attendanceService.getByClass(parseInt(id))
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

}

export default new AttendanceController()