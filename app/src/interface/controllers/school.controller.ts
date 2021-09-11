import { Request, Response } from 'express'
import schoolService from '../../app/services/school.service'

class SchoolController {

    async getAll(request: Request, response: Response) {

        try {
            const schools = await schoolService.getAll()

            response.status(200).json(schools)
        } catch (error) {
            response.status(500).json({ error: error.message })
        }
    }

}

export default new SchoolController()