import { getConnection, Repository } from "typeorm";
import SubjectClassroom from "../entities/subjects_classrooms.entity";


const connection = getConnection()

class SubjectClassroomService {
    repository: Repository<SubjectClassroom>

    async getAll() {
        this.repository = connection.getRepository(SubjectClassroom)

        const subjectClassroom = await this.repository.find({})
        return subjectClassroom
    }

    async getByClass(classId: number) {
        this.repository = connection.getRepository(SubjectClassroom)

        const subjectClassroom = await this.repository.find({ where: { classrooms_id: classId } })
        return subjectClassroom
    }

    async getByTeacher(teacherId: number) {
        this.repository = connection.getRepository(SubjectClassroom)

        const subjectClassroom = await this.repository.find({ where: { teachers_id: teacherId } })
        return subjectClassroom
    }

    async getBySubject(subjectId: number) {
        this.repository = connection.getRepository(SubjectClassroom)

        const subjectClassroom = await this.repository.find({ where: { school_subjects_id: subjectId } })
        return subjectClassroom
    }

}

export default new SubjectClassroomService()