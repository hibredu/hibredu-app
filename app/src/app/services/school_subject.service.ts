import { getConnection, Repository } from "typeorm";
import SchoolSubjects from "../entities/school_subjects.entity";



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

}

export default new SchoolSubjectService()