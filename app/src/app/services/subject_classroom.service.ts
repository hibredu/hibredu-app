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

        const subjectClassroom = await this.repository.find({ where: { classrooms_id: classId } })

        if (!subjectClassroom) {
            throw new Error("Subject Classroom not found")
        }
        return subjectClassroom
    }

    async getByTeacher(teacherId: number) {
        this.repository = connection.getRepository(SubjectClassroom)

        const subjectClassroom = await this.repository.find({
            where: { teachers_id: teacherId },
            relations: ["classroom", "school_subject", "school", "teacher"]
        })

        if (!subjectClassroom) {
            throw new Error("Subject Classroom not found")
        }
        return subjectClassroom
    }

    async getBySubject(subjectId: number) {
        this.repository = connection.getRepository(SubjectClassroom)

        const subjectClassroom = await this.repository.find({ where: { school_subjects_id: subjectId } })
        return subjectClassroom
    }

    async getBySubjectClassroomTeacher(subjectId: number, classroomId: number, teacherId: number) {
        this.repository = connection.getRepository(SubjectClassroom);
        return await this.repository.findOne({ where: { school_subjects_id: subjectId, classrooms_id: classroomId, teachers_id: teacherId } })
    }

    getSubjectByClass(classId: number) {
        this.repository = connection.getRepository(SubjectClassroom)

        return this.repository.find({
            where: { classrooms_id: classId },
            relations: ["school_subject"]
        })
    }

    async getByStudent(studentId: number) {
        this.repository = connection.getRepository(SubjectClassroom)

        const subjectClassroom = await this.repository.find({
            where: { students_id: studentId },
            relations: ["school_subject", "classroom"]
        })

        if (!subjectClassroom) {
            throw new Error("Subject Classroom not found")
        }
        return subjectClassroom
    }

}

export default new SubjectClassroomService()