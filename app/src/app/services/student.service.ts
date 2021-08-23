import { getConnection, Repository } from "typeorm";
import { Student } from "../entities/student.entity";

const connection = getConnection()

class StudentService {

    repository: Repository<Student>

    async getAll() {
        this.repository = connection.getRepository(Student)

        const student = await this.repository.find({})
        return student
    }

    async getOne(id: number) {
        return await this.repository.findOne({ id });
    }

}

export default new StudentService()