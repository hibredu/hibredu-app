import { getConnection, In, Repository } from "typeorm";
import SchoolSubjects from "../entities/school_subjects.entity";
import SubjectClassroom from "../entities/subjects_classrooms.entity";



const connection = getConnection()

class SchoolSubjectService {
    repository: Repository<SchoolSubjects>

    async getAll() {
        this.repository = connection.getRepository(SchoolSubjects)

        const subjectClassroom = await this.repository.find({})

        if (!subjectClassroom) {
            throw new Error("School Subject not found")
        }
        return subjectClassroom
    }

    async getByTeacherId(teacherId: number) {
        this.repository = connection.getRepository(SchoolSubjects)
        const subjectClassroomRepository = connection.getRepository(SubjectClassroom)

        const subjectClassroom = await subjectClassroomRepository.find({
            where: {
                teachers_id: teacherId
            },
            cache: 100000
        })

        const schoolSubjects = await this.repository.find({
            where: {
                id: In(subjectClassroom.map(subject => subject.school_subjects_id))
            }
        })

        if (!schoolSubjects) {
            throw new Error("School Subject not found")
        }
        return schoolSubjects
    }

    async getByTeacherIdbyClass(teacher_id, class_id){
        this.repository = connection.getRepository(SchoolSubjects)
        const subjectClassroomRepository = connection.getRepository(SubjectClassroom)

        const subjectClassroom = await subjectClassroomRepository.find({
            where: {
                teachers_id: teacher_id,
                classrooms_id: class_id
            },
            cache: 100000
        })

        const schoolSubjects = await this.repository.find({
            where: {
                id: In(subjectClassroom.map(subject => subject.school_subjects_id))
            }
        })

        if (!schoolSubjects) {
            throw new Error("School Subject not found")
        }
        return schoolSubjects
    }

}

export default new SchoolSubjectService()