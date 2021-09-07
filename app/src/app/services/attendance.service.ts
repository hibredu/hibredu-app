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

}

export default new AttendanceService()