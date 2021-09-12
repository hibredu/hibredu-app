import { getConnection, Repository } from "typeorm";
import ActivityToStudent from "../entities/activityToStudent.entity";
import { Classroom } from "../entities/classroom.entity";
import Student from "../entities/student.entity";
import studentService from "./student.service";

const connection = getConnection()

class OverviewService {
    repository: Repository<Classroom>

    async getDeliveredActivitiesByTeacher(teacherId: number) {
        const activities: ActivityToStudent[] = []

        const repositoryActivities = connection.getRepository(ActivityToStudent)

        const students: Student[] = await studentService.getAll(teacherId)

        for (let student of students) {
            const activitiesToStudents = await repositoryActivities.find({ where: { student: student.id, delivered: true } })
            activities.push(...activitiesToStudents)
        }

        return activities;
    }

    async getDeliveryPercentageByTeacher(teacherId: number) {
        const activities_delived: ActivityToStudent[] = []
        const activities: ActivityToStudent[] = []

        const repositoryActivities = connection.getRepository(ActivityToStudent)
        const students: Student[] = await studentService.getAll(teacherId)

        for (let student of students) {
            const activitiesToStudents = await repositoryActivities.find({ where: { student: student.id } })
            activities.push(...activitiesToStudents)
            activities_delived.push(...activitiesToStudents.filter((activity) => activity.delivered == true))
        }

        const totalActivities = activities.length;
        const totalActivitiesDelivered = activities_delived.length;

        return (totalActivitiesDelivered / totalActivities);
    }

    async getHitRateByTeacher(teacherId: number) {
        const activities_delived: ActivityToStudent[] = []
        let hitRate = 0
        let hitRateTotal = 0

        const repositoryActivities = connection.getRepository(ActivityToStudent)
        const students: Student[] = await studentService.getAll(teacherId)

        for (let student of students) {
            const activitiesToStudents = await repositoryActivities.find({ where: { student: student.id, delivered: true }, relations: ["activity"] })

            activities_delived.push(...activitiesToStudents)
        }

        for (let activity of activities_delived) {
            hitRateTotal += activity.activity.max_note
            hitRate += activity.grade
        }

        return (hitRate / hitRateTotal);
    }
}

export default new OverviewService()