import { getConnection, Repository } from "typeorm";
import Activity from "../entities/activity.entity";
import ActivityToStudent from "../entities/activityToStudent.entity";
import Attendance from "../entities/attendance.entity";
import { Classroom } from "../entities/classroom.entity";
import Student from "../entities/student.entity";
import studentService from "./student.service";
import subject_classroomService from "./subject_classroom.service";

const connection = getConnection()

interface IAttendanceDelivery {
    delivered: number,
    present: number,
    date: Date
}

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

    async getAttendancesByTeacher(teacherId: number) {
        let attendances: Attendance[] = []
        const subject_classrooms = await subject_classroomService.getByTeacher(teacherId)

        const repositoryAttendances = connection.getRepository(Attendance)

        for (const subject_classroom of subject_classrooms) {
            attendances.push(...await repositoryAttendances.find({ relations: ["file", "attendanceStudents"], where: { owner_id: subject_classroom.id } }))
        }

        return attendances
    }

    async getActivitiesByTeacher(teacherId: number) {
        let activities: Activity[] = []
        const RepositoryActivity = connection.getRepository(Activity)

        const subject_classrooms = await subject_classroomService.getByTeacher(teacherId)

        for (const subject_classroom of subject_classrooms) {
            activities.push(...await RepositoryActivity.find({ relations: ["file", "activitiesToStudents"], where: { owner_id: subject_classroom.id } }))
        }

        return activities
    }

    async getAttendanceActivitiesByTeacher(teacherId: number) {
        let activities: Activity[] = []
        const RepositoryActivity = connection.getRepository(Activity)

        const subject_classrooms = await subject_classroomService.getByTeacher(teacherId)

        for (const subject_classroom of subject_classrooms) {
            activities.push(...await RepositoryActivity.find({ relations: ["file", "activitiesToStudents"], where: { owner_id: subject_classroom.id, type: "attendance" } }))
        }

        return activities
    }

    async getAttendanceByTeacher(teacherId: number) {
        let attendances: Attendance[] = []
        const RepositoryAttendance = connection.getRepository(Attendance)

        const subject_classrooms = await subject_classroomService.getByTeacher(teacherId)

        for (const subject_classroom of subject_classrooms) {
            attendances.push(...await RepositoryAttendance.find({ relations: ["file", "attendanceStudents"], where: { owner_id: subject_classroom.id } }))
        }

        return attendances
    }

    async getAttendanceActivities(deliveredActivities: ActivityToStudent[], attendance: Attendance[]) {
        let attendance_delivered: IAttendanceDelivery[] = []

        const groupedActivities = deliveredActivities.reduce((r, a) => {
            const date = a.created_at.toISOString().substring(0, 10)
            r[date] = r[date] || { delivered: 0, present: 0, date: a.created_at.toISOString().substring(0, 10) };
            if (a.delivered) {
                r[date].delivered += 1
            }
            return r;
        }, Object.create(null));

        const groupedAttendance = attendance.reduce((r, a) => {
            const date = a.created_at.toISOString().substring(0, 10)
            r[date] = r[date] || { delivered: 0, present: 0, date: a.created_at.toISOString().substring(0, 10) };
            r[date].present += a.attendanceStudents.filter(a => a.present == true).length;
            return r;
        }, Object.create(null));

        // Merge the two groups
        for (let key in groupedActivities) {
            if (groupedAttendance[key]) {
                attendance_delivered.push({
                    date: groupedActivities[key].date,
                    delivered: groupedActivities[key].delivered,
                    present: groupedAttendance[key].present
                })
            } else {
                attendance_delivered.push({
                    date: groupedActivities[key].date,
                    delivered: groupedActivities[key].delivered,
                    present: 0
                })
            }
        }

        for (let key in groupedAttendance) {
            if (!groupedActivities[key]) {
                attendance_delivered.push({
                    date: groupedAttendance[key].date,
                    delivered: 0,
                    present: groupedAttendance[key].present
                })
            }
        }

        return attendance_delivered
    }
}

export default new OverviewService()