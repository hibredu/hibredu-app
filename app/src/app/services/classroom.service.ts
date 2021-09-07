import { getConnection, Repository } from "typeorm";
import { Classroom } from "../entities/classroom.entity";
import attendanceService from "./attendance.service";

const connection = getConnection()

class ClassroomService {
    repository: Repository<Classroom>

    async getAll() {
        this.repository = connection.getRepository(Classroom)

        const classrooms = await this.repository.find({ where: {},relations: ["students"] })
        return classrooms
    }

    async getDeliveryPercentage(id: number) {
        const classroom = await this.getById(id)

        const students = classroom.students;
        const totalActivities = students.filter((student) => student.activitiesToStudents).length;
        const totalActivitiesDelivered = students.filter((student) => student.activitiesToStudents?.filter((activity) => activity.delivered == 1).length).length;
        console.log(totalActivities);
        console.log(totalActivitiesDelivered);
        return (totalActivitiesDelivered / totalActivities) * 100;
    }

    async getAttendancePercentage(id: number) {
        const classroom = await this.getById(id)

        const students = classroom.students;

        return students.length
    }

    async getById(id: number): Promise<Classroom> {
        this.repository = connection.getRepository(Classroom)
        return await this.repository.findOne({ where: { id }, relations: ["students"] })
    }
}

export default new ClassroomService()