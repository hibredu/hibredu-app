import { getConnection, Repository } from "typeorm";
import SubjectClassroom from "../entities/subjects_classrooms.entity";


const connection = getConnection()

class SubjectClassroomService {
    repository: Repository<SubjectClassroom>

    async getAll() {
        this.repository = connection.getRepository(SubjectClassroom)

        const subjectClassroom = await this.repository.find({})

        if (!subjectClassroom) {
            throw new Error("Subject Classroom not found")
        }
        return subjectClassroom
    }

    async getByClass(classId: number) {
        this.repository = connection.getRepository(SubjectClassroom)

        const subjectClassroom = await this.repository.find({ where: { classrooms_id: classId }, cache: 100000 }) // TODO: remove cache

        if (!subjectClassroom) {
            throw new Error("Subject Classroom not found")
        }
        return subjectClassroom
    }

    async getByTeacher(teacherId: number) {
        this.repository = connection.getRepository(SubjectClassroom)

        const subjectClassroom = await this.repository.find({
            where: { teachers_id: teacherId },
            relations: ["classroom", "school_subject", "school", "teacher"],
            cache: 100000 // TODO: remove cache
        })

        if (!subjectClassroom) {
            throw new Error("Subject Classroom not found")
        }
        return subjectClassroom
    }

    async getBySubject(subjectId: number) {
        this.repository = connection.getRepository(SubjectClassroom)

        const subjectClassroom = await this.repository.find({ where: { school_subjects_id: subjectId }, cache: 20000 }) // TODO: remove cache
        return subjectClassroom
    }

    async getBySubjectClassroomTeacher(subjectId: number, classroomId: number, teacherId: number) {
        this.repository = connection.getRepository(SubjectClassroom);
        return await this.repository.findOne({ where: { school_subjects_id: subjectId, classrooms_id: classroomId, teachers_id: teacherId }, cache: 20000 }) // TODO: remove cache
    }

    getSubjectByClass(classId: number) {
        this.repository = connection.getRepository(SubjectClassroom)

        return this.repository.find({
            where: { classrooms_id: classId },
            relations: ["school_subject"],
            cache: 100000 // TODO: remove cache
        })
    }

    async getByStudent(studentId: number) {
        this.repository = connection.getRepository(SubjectClassroom)

        const subjectClassroom = await this.repository.find({
            where: { students_id: studentId },
            relations: ["school_subject", "classroom"],
            cache: 100000 // TODO: remove cache
        })

        if (!subjectClassroom) {
            throw new Error("Subject Classroom not found")
        }
        return subjectClassroom
    }

}

export default new SubjectClassroomService()