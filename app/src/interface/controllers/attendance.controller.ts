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

}

export default new AttendanceController()