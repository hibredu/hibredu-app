import { Request, Response } from 'express'
import schoolService from '../../app/services/school.service'

class SchoolController {

    async getAll(_: Request, response: Response) {
        try {
            const schools = await schoolService.getAll()

            response.status(200).json(schools)
        } catch (error) {
            response.status(500).json({ error: error.message })
        }
    }

    async getSchoolClassrooms(request: Request, response: Response) {
        const { id_school } = request.params
        try {
            const school = await schoolService.getSchoolClassrooms(parseInt(id_school))

            response.status(200).json(school)
        } catch (error) {
            response.status(500).json({ error: error.message })
        }
    }

}

export default new SchoolController()