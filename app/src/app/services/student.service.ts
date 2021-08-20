import { getRepository, Repository } from "typeorm";
import Student from "../entities/student.entity";

class StudentService {

    repository: Repository<Student>

    constructor() {
        (async () => {
            this.repository = await getRepository(Student);
        })();
    }

    async getAll() {
        const student = await this.repository.find({})
        return student
    }

    async getOne(id: number) {
        return await this.repository.findOne({ id });
    }

}

export default new StudentService()