import { Request, Response } from 'express'
import alertService from '../../app/services/alert.service'

class AlertController {

    async getByClass(request: Request, response: Response) {
        const { id } = request.params

        try {
            const alert = await alertService.getByClass(parseInt(id))
            response.status(200).json(alert)
        } catch (error) {
            response.status(500).json({ error: error.message })
        }
    }

    async getByStudent(request: Request, response: Response) {
        const { id } = request.params

        try {
            const alert = await alertService.getByStudent(parseInt(id))
            response.status(200).json(alert)
        } catch (error) {
            response.status(500).json({ error: error.message })
        }
    }

}

export default new AlertController()