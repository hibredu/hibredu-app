import { Request, Response } from 'express'
import classroomService from '../../app/services/classroom.service'

class ClassroomController {
    async findDeliveryPercentage(request: Request, response: Response){
        const { id } = request.params
        let deliveryPercentage: number
        
        try {
            deliveryPercentage = await classroomService.getDeliveryPercentage(parseInt(id))
        } catch (error) {
            response.status(500).json({ error: error.message })
        }

        response.status(200).json({ deliveryPercentage })
    }
}

export default new ClassroomController()