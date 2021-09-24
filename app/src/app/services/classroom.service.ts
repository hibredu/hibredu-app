import { getConnection, In, Repository } from "typeorm";
import ActivityStudent from "../entities/activity_student.entity";
import { Classroom } from "../entities/classroom.entity";
import Student from "../entities/student.entity";
import subject_classroomService from "./subject_classroom.service";

const connection = getConnection()

class ClassroomService {

    repository: Repository<Classroom>

    async getAll(teacherId) {
        let classrooms_ids: number[] = []

        this.repository = connection.getRepository(Classroom)

        const subject_classroom = await subject_classroomService.getByTeacher(teacherId)

        for (let subject of subject_classroom) {
            classrooms_ids.push(subject.classroom.id)
        }

        const classrooms = await this.repository.find({ where: { id: In(classrooms_ids) }, relations: ["students"] })
        return classrooms
    }

    async getDeliveredActivities(id: number) {
        const activities: ActivityStudent[] = []

        const repositoryActivities = connection.getRepository(ActivityStudent)
        const classroom = await this.getById(id)
        const students: Student[] = classroom.students;

        for (let student of students) {
            const activitiesToStudents = await repositoryActivities.find({ where: { student: student.id, delivered: true } })
            activities.push(...activitiesToStudents)
        }

        return activities;
    }

    async getDeliveryPercentage(id: number) {
        const activities_delived: ActivityStudent[] = []
        const activities: ActivityStudent[] = []

        const repositoryActivities = connection.getRepository(ActivityStudent)
        const classroom = await this.getById(id)

        const students = classroom.students;

        for (let student of students) {
            const activitiesToStudents = await repositoryActivities.find({ where: { student: student.id } })
            activities.push(...activitiesToStudents)
            activities_delived.push(...activitiesToStudents.filter((activity) => activity.delivered == true))
        }


        const totalActivities = activities.length;
        const totalActivitiesDelivered = activities_delived.length;

        return (totalActivitiesDelivered / totalActivities);
    }

    async getHitRate(id: number) {
        const activities_delived: ActivityStudent[] = []
        let hitRate = 0
        let hitRateTotal = 0

        const repositoryActivities = connection.getRepository(ActivityStudent)
        const classroom = await this.getById(id)

        const students = classroom.students;

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

    async getAttendancePercentage(id: number) {
        const classroom = await this.getById(id)

        const students = classroom.students;

        return students.length
    }

    async getById(id: number): Promise<Classroom> {
        this.repository = connection.getRepository(Classroom)
        return await this.repository.findOne({ where: { id }, relations: ["students"] })
    }

    async getBySchool(schoolId: number): Promise<Classroom[]> {
        this.repository = connection.getRepository(Classroom)
        return await this.repository.find({ where: { school: schoolId } })
    }
}

export default new ClassroomService()