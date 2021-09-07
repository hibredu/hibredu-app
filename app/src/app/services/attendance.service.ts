import { getConnection, In, Repository } from "typeorm";
import Attendance from "../entities/attendance.entity";
import subject_classroomService from "./subject_classroom.service";

const connection = getConnection()

class AttendanceService {
    repository: Repository<Attendance>

    async getAll() {
        this.repository = connection.getRepository(Attendance)

        const attendance = await this.repository.find({})
        return attendance
    }

    async getById(id: number, options?: any): Promise<Attendance> {
        this.repository = connection.getRepository(Attendance)

        const attendance = await this.repository.findOne(id, options)

        if (!attendance) {
            throw new Error("Attendance not found")
        }

        return attendance
    }

    async getByClass(classId: number) {
        this.repository = connection.getRepository(Attendance)

        const subject_classroom = await subject_classroomService.getByClass(classId)
        const owners_ids = subject_classroom.map(subject_classroom => subject_classroom.id);

        const attendance = await this.repository.find({
            where: { owner_id: In(owners_ids) },
            relations: ["attendanceStudents"]
        })
        return attendance
    }

    async delete(id: number) {
        this.repository = connection.getRepository(Attendance)

        const attendance = await this.getById(id)

        await this.repository.remove(attendance)
    }

}

export default new AttendanceService()