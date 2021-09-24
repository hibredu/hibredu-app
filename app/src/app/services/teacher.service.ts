import { getConnection, getRepository, Repository } from "typeorm";
import { Classroom } from "../entities/classroom.entity";
import School from "../entities/school.entity";
import Teacher, { ITeacher } from "../entities/teacher.entity";

const connection = getConnection()

class TeacherService {

    repository: Repository<Teacher>
    repositorySchool: Repository<School>

    async getAll() {
        this.repository = connection.getRepository(Teacher)

        let teachers: Teacher[] = await this.repository.find({ cache: 100000 }) // remove cache

        return teachers.map(teacher => {
            delete teacher.password
            return teacher
        })
    }

    async create(teacher: ITeacher) {
        this.repository = connection.getRepository(Teacher)

        const userExists = await this.repository.findOne({
            where: { email: teacher.email }
        })

        if (userExists) {
            throw new Error("email needs to be unique");
        }

        this.repositorySchool = await connection.getRepository(School)

        const teacherEntity = new Teacher()
        teacherEntity.name = teacher.name
        teacherEntity.email = teacher.email
        teacherEntity.password = teacher.password
        teacherEntity.phone = teacher.phone
        teacherEntity.school = await this.repositorySchool.findOne({ where: { id: teacher.school_id } }) as unknown as School

        return await this.repository.save(teacherEntity)
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

    async update(id: number, teacher: ITeacher): Promise<Teacher> {
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