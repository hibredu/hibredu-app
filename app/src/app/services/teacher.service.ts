import { getConnection, getRepository, Repository } from "typeorm";
import School from "../entities/school.entity";
import Teacher, { ITeacher } from "../entities/teacher.entity";

const connection = getConnection()

class TeacherService {

    repository: Repository<Teacher>
    repositorySchool: Repository<School>

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
}

export default new TeacherService()