import { getConnection, In, Repository } from "typeorm";
import Attendance from "../entities/attendance.entity";
import fileService from "./file.service";
import subjectClassroomService from "./subject_classroom.service";
import File from "../entities/file.entity";
import SubjectClassroom from "../entities/subjects_classrooms.entity";

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

    async getByClass(classId: number, options?: Map<String, any>) {
        this.repository = connection.getRepository(Attendance)

        const subject_classroom = await subjectClassroomService.getByClass(classId)
        const owners_ids = subject_classroom.map(subject_classroom => subject_classroom.id);

        const attendance = await this.repository.find({
            where: { owner_id: In(owners_ids), ...options },
            relations: ["attendanceStudents"]
        })
        return attendance
    }

    async delete(id: number) {
        this.repository = connection.getRepository(Attendance)

        const attendance = await this.getById(id)

        await this.repository.remove(attendance)
    }

    async insert(teacherId: string, attendance: any) : Promise<number> {
        const file: File = await fileService.getFile(attendance.file_id)
        const owner: SubjectClassroom = await subjectClassroomService.getBySubjectClassroomTeacher(
            attendance.subject_id, 
            attendance.classroom_id, 
            parseInt(teacherId));

        if(owner === undefined) {
            throw ("Ocorreu um erro ao procurar o Owner");
        }

        this.repository = connection.getRepository(Attendance)

        const attendanceRegister = new Attendance() 
        attendanceRegister.date = attendance.date
        attendanceRegister.description = attendance.description
        attendanceRegister.class_subject = attendance.class_subject
        attendanceRegister.file = file
        attendanceRegister.owner_id = owner.id 

        await this.repository.insert(attendanceRegister)      
        
        return attendanceRegister.id;
    }
}

export default new AttendanceService()