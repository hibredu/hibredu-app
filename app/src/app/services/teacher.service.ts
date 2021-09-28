import { getConnection, getRepository, Repository } from "typeorm";
import { Classroom } from "../entities/classroom.entity";
import School from "../entities/school.entity";
import SubjectClassroom from "../entities/subjects_classrooms.entity";
import Teacher from "../entities/teacher.entity";

const connection = getConnection()

class TeacherService {

    repository: Repository<Teacher>
    repositorySchool: Repository<School>
    repositoryClassroom: Repository<Classroom>
    repositorySubjectClassroom: Repository<SubjectClassroom>

    async getAll() {
        this.repository = connection.getRepository(Teacher)

        let teachers: Teacher[] = await this.repository.find({ cache: 100000 }) // remove cache

        return teachers.map(teacher => {
            delete teacher.password
            return teacher
        })
    }

    async create(teacher) {
        this.repository = connection.getRepository(Teacher)

        const userExists = await this.repository.findOne({
            where: { email: teacher.email }
        })

        if (userExists) {
            throw new Error("email needs to be unique");
        }

        this.repositorySchool = await connection.getRepository(School)
        this.repositoryClassroom = await connection.getRepository(Classroom)
        this.repositorySubjectClassroom = await connection.getRepository(SubjectClassroom)

        const teacherEntity = new Teacher()
        teacherEntity.name = teacher.name
        teacherEntity.email = teacher.email
        teacherEntity.password = teacher.password
        teacherEntity.phone = teacher.phone
        teacherEntity.school = await this.repositorySchool.findOne({ where: { id: teacher.school_id } }) as unknown as School

        const teacherCreated = await this.repository.save(teacherEntity)
        const subjectClassrooms = []

        for (let index = 0; index < teacher.classrooms.length; index++) {
            const classroom_id = teacher.classrooms[index].id
            const classroom = await this.repositoryClassroom.findOne({ where: { id: classroom_id } }) as unknown as Classroom

            for (let index = 0; index < teacher.subjects.length; index++) {
                const subject_id = teacher.subjects[index].id

                subjectClassrooms.push(await this.repositorySubjectClassroom.create({
                    classrooms_id: classroom.id,
                    teachers_id: teacherCreated.id,
                    school_subjects_id: subject_id
                }))
            }
        }

        delete teacherCreated.password
        return { teacher: teacherCreated, subject_classrooms: subjectClassrooms }
    }

    async getById(id: number) {
        this.repository = connection.getRepository(Teacher)

        return await this.repository.findOne({ where: { id } })
    }

    async getClassesByTeacher(id: number) {
        const teacher = await this.getById(id);
        let classes: Classroom[] = [];

        for (let index = 0; index < teacher.subjects_classrooms.length; index++) {
            const subjects_classrooms = teacher.subjects_classrooms[index];
            classes.push(subjects_classrooms.classroom);
        }

        return classes;
    }

    async update(id: number, teacher): Promise<Teacher> {
        this.repository = connection.getRepository(Teacher)

        let userExists = await this.repository.findOne({
            where: { id },
            cache: 15000 // TODO: remove cache
        })

        if (!userExists) {
            throw new Error("user not found");
        }

        return await this.repository.save({ id: userExists.id, ...teacher })
    }
}

export default new TeacherService()