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
        this.repository = connection.getRepository(Student)

        return await this.repository.findOne(id);
    }

    async getDeliveryPercentage(id: number) {
        this.repository = connection.getRepository(Student)

        const student = await this.repository.findOne(id);
        const totalActivities = student.activitiesToStudents.length;
        const totalActivitiesDelivered = student.activitiesToStudents.filter((activity) => activity.delivered == 1).length;
        return (totalActivitiesDelivered / totalActivities) * 100;
    }
}

export default new StudentService()