import { getConnection, Repository } from "typeorm";
import ActivityToStudent from "../entities/activityToStudent.entity";
import { Classroom } from "../entities/classroom.entity";

const connection = getConnection()

class ClassroomService {

    repository: Repository<Classroom>

    async getAll() {
        this.repository = connection.getRepository(Classroom)

        const classrooms = await this.repository.find({ where: {}, relations: ["students"] })
        return classrooms
    }

    async getDeliveredActivities(id: number) {
        const activities: ActivityToStudent[] = []

        const repositoryActivities = connection.getRepository(ActivityToStudent)
        const classroom = await this.getById(id)

        const students = classroom.students;

        for (let student of students) {
            const activitiesToStudents = await repositoryActivities.find({ where: { student: student.id, delivered: true } })
            activities.push(...activitiesToStudents)
        }

        return activities;
    }

    async getDeliveryPercentage(id: number) {
        const activities_delived: ActivityToStudent[] = []
        const activities: ActivityToStudent[] = []

        const repositoryActivities = connection.getRepository(ActivityToStudent)
        const classroom = await this.getById(id)

        const students = classroom.students;

        for (let student of students) {
            console.log(student)
            const activitiesToStudents = await repositoryActivities.find({ where: { student: student.id } })
            activities.push(...activitiesToStudents)
            activities_delived.push(...activitiesToStudents.filter((activity) => activity.delivered == true))
        }


        const totalActivities = activities.length;
        const totalActivitiesDelivered = activities_delived.length;

        return (totalActivitiesDelivered / totalActivities);
    }

    async getHitRate(id: number) {
        const activities_delived: ActivityToStudent[] = []
        let hitRate = 0
        let hitRateTotal = 0

        const repositoryActivities = connection.getRepository(ActivityToStudent)
        const classroom = await this.getById(id)

        const students = classroom.students;

        for (let student of students) {
            console.log(student)
            const activitiesToStudents = await repositoryActivities.find({ where: { student: student.id, delivered: true }, relations: ["activity"] })

            activities_delived.push(...activitiesToStudents)
        }

        for (let activity of activities_delived) {
            hitRateTotal += activity.activity.max_note
            hitRate += activity.grade
        }

        return (hitRate / hitRateTotal);
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