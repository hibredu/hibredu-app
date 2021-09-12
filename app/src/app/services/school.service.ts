import { getConnection, Repository } from "typeorm";
import School from "../entities/school.entity";
import classroomService from "./classroom.service";

const connection = getConnection()

class SchoolService {

    repository: Repository<School>

    async getAll(): Promise<School[]> {
        this.repository = connection.getRepository(School)

        const schools = await this.repository.find({})
        return schools
    }

    async getById(id: number): Promise<School> {
        this.repository = connection.getRepository(School)
        return await this.repository.findOne({ where: { id }, relations: ["teachers"] })
    }

    async getSchoolClassrooms(id: number) {
        this.repository = connection.getRepository(School)

        const classrooms = []
        const classrooms_ids = []
        const schools: School[] = await this.repository.find({ where: { id }, relations: ["subjects_classrooms"] })

        for (let index = 0; index < schools.length; index++) {
            const school = schools[index];

            for (let index = 0; index < school.subjects_classrooms.length; index++) {
                const subject_classroom = school.subjects_classrooms[index];

                const classroom_id = subject_classroom['classrooms_id']
                if (!classrooms_ids.includes(classroom_id)) {
                    let classroom = await classroomService.getById(classroom_id)
                    delete classroom.students
                    classrooms.push(classroom)
                    classrooms_ids.push(classroom_id)
                }
            }
        }

        return classrooms
    }
}

export default new SchoolService()