import { getConnection, getRepository, Repository } from "typeorm";
import { Teacher } from "../entities/teacher.entity";

const connection = getConnection()

class AuthService {

    repository: Repository<Teacher>

    async createTeacher(teacher: Teacher) {
        this.repository = connection.getRepository(Teacher)

        const userExists = await this.repository.findOne({
            where: { email: teacher.email }
        })

        if (userExists) {
            throw new Error("email needs to be unique");
        }

        await this.repository.save(teacher)
    }
}

export default new AuthService()