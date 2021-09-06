import { getConnection, Repository } from "typeorm";
import { Classroom } from "../entities/classroom.entity";
import { IStudent } from "../entities/student.entity";

const connection = getConnection()

class ClassroomService {
    repository: Repository<Classroom>

    async getDeliveryPercentage(id: number) {
        this.repository = connection.getRepository(Classroom)

        const classroom = await this.repository.findOne(id)
        const students = classroom.students;
        const totalActivities = students.filter((student) => student.activitiesToStudents).length;
        const totalActivitiesDelivered = students.filter((student) => student.activitiesToStudents.filter((activity) => activity.delivered == 1).length).length;
        console.log(totalActivities);
        console.log(totalActivitiesDelivered);
        return (totalActivitiesDelivered / totalActivities) * 100;
    }

    async getAttendancePercentage(id: number) {
        this.repository = connection.getRepository(Classroom)

        const classroom = await this.repository.findOne(id)


        return 0;
    }

    async getById(id: number) {
        this.repository = connection.getRepository(Classroom)

        return await this.repository.findOne(id)
    }
}

export default new ClassroomService()