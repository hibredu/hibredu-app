import { getConnection, In, Repository } from "typeorm";
import Alert from "../entities/alerts.entity";
import subject_classroomService from "./subject_classroom.service";

const connection = getConnection()

class AlertService {
    repository: Repository<Alert>

    async getAll() {
        this.repository = connection.getRepository(Alert)

        const alert = await this.repository.find({})
        return alert
    }

    async getByClass(classId: number) {
        this.repository = connection.getRepository(Alert)
        const alerts = []

        const subject_classroom = await subject_classroomService.getByClass(classId)
        const teachers = subject_classroom.map(subject_classroom => subject_classroom.teachers_id);

        for (const teacher of teachers) {
            const alert = await this.repository.find({ where: { teachers_id: teacher } })
            alerts.push(...alert)
        }

        return alerts
    }

}

export default new AlertService()