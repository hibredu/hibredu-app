import { getConnection, Repository } from "typeorm";
import School from "../entities/school.entity";

const connection = getConnection()

class SchoolService {

    repository: Repository<School>

    async getAll() {
        this.repository = connection.getRepository(School)

        const schools = await this.repository.find({})
        return schools
    }

    async getById(id: number): Promise<School> {
        this.repository = connection.getRepository(School)
        return await this.repository.findOne({ where: { id }, relations: ["teachers"] })
    }
}

export default new SchoolService()