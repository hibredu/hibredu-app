import { getConnection, In, Repository } from "typeorm";
import Student from "../entities/student.entity";
import teacherService from "./teacher.service";

const connection = getConnection()

class StudentService {
    repository: Repository<Student>

    async getAll(teacherID) {
        this.repository = connection.getRepository(Student)

        const classes = await teacherService.getClassesByTeacher(teacherID);

        const students = await this.repository.find({ where: { classroom: In(classes) } });
        return students
    }

    async getById(id: number) {
        this.repository = connection.getRepository(Student)

        return await this.repository.findOne({ where: { id }, relations: ["activitiesToStudents"] });
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