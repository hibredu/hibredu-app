import { getConnection, Repository } from "typeorm";
import Activity from "../entities/activity.entity";
import ActivityStudent from "../entities/activity_student.entity";
import Attendance from "../entities/attendance.entity";
import AttendanceStudent from "../entities/attendance_student.entity";
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
        const activities: ActivityStudent[] = []

        const repositoryActivities = connection.getRepository(ActivityStudent)

        const students: Student[] = await studentService.getAll(teacherId)

        for (let student of students) {
            const activitiesToStudents = await repositoryActivities.find({ where: { students_id: student.id, delivered: true }, cache: 15000 }); // TODO: remove cache
            activities.push(...activitiesToStudents)
        }

        return activities;
    }

    async getDeliveryPercentageByTeacher(teacherId: number) {
        const activities_delived: ActivityStudent[] = []
        const activities: ActivityStudent[] = []

        const repositoryActivities = connection.getRepository(ActivityStudent)
        const students: Student[] = await studentService.getAll(teacherId)

        for (let student of students) {
            const activitiesToStudents = await repositoryActivities.find({ where: { students_id: student.id }, cache: 15000 }); // TODO: remove cache
            activities.push(...activitiesToStudents)
            activities_delived.push(...activitiesToStudents.filter((activity) => activity.delivered == true))
        }

        const totalActivities = activities.length;
        const totalActivitiesDelivered = activities_delived.length;

        return (totalActivitiesDelivered / totalActivities);
    }

    async getHitRateByTeacher(teacherId: number) {
        const activities_delived: ActivityStudent[] = []
        let hitRate = 0
        let hitRateTotal = 0

        const repositoryActivities = connection.getRepository(ActivityStudent)
        const students: Student[] = await studentService.getAll(teacherId)

        for (let student of students) {
            const activitiesToStudents = await repositoryActivities.find({ where: { students_id: student.id, delivered: true }, relations: ["activity"], cache: 15000 }); // TODO: remove cache

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
            attendances.push(...await repositoryAttendances.find({ relations: ["file", "attendanceStudents"], where: { owner_id: subject_classroom.id }, cache: 15000 })) // TODO: remove cache
        }

        return attendances
    }

    async getActivitiesByTeacher(teacherId: number) {
        let activities: Activity[] = []
        const RepositoryActivity = connection.getRepository(Activity)

        const subject_classrooms = await subject_classroomService.getByTeacher(teacherId)

        for (const subject_classroom of subject_classrooms) {
            activities.push(...await RepositoryActivity.find({ relations: ["file", "activitiesToStudents"], where: { owner_id: subject_classroom.id }, cache: 15000 })) // TODO: remove cache
        }

        return activities
    }

    async getAttendanceActivitiesByTeacher(teacherId: number) {
        let activities: Activity[] = []
        const RepositoryActivity = connection.getRepository(Activity)

        const subject_classrooms = await subject_classroomService.getByTeacher(teacherId)

        for (const subject_classroom of subject_classrooms) {
            activities.push(...await RepositoryActivity.find({ relations: ["file", "activitiesToStudents"], where: { owner_id: subject_classroom.id, type: "attendance" }, cache: 15000 })) // TODO: remove cache
        }

        return activities
    }

    async getAttendanceByTeacher(teacherId: number) {
        let attendances: Attendance[] = []
        const RepositoryAttendance = connection.getRepository(Attendance)

        const subject_classrooms = await subject_classroomService.getByTeacher(teacherId)

        for (const subject_classroom of subject_classrooms) {
            attendances.push(...await RepositoryAttendance.find({ relations: ["file", "attendanceStudents"], where: { owner_id: subject_classroom.id }, cache: 15000 })) // TODO: remove cache
        }

        return attendances
    }

    async getAttendanceActivities(deliveredActivities: ActivityStudent[], attendance: Attendance[]) {
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

    async getDeliveredActivitiesByStudent(studentId: number) {
        const repositoryActivities = connection.getRepository(ActivityStudent)

        const activities: ActivityStudent[] = await repositoryActivities.find({ where: { students_id: studentId, delivered: true }, cache: 20000 }) // TODO: remove cache

        return activities;
    }

    async getAttendanceByStudent(_: number, studentId: number) {
        let attendances: Attendance[] = []
        const RepositoryAttendanceStudent = connection.getRepository(AttendanceStudent)

        const attendances_students: AttendanceStudent[] = await RepositoryAttendanceStudent.find({ relations: ["attendance"], where: { students_id: studentId }, cache: 20000 }) // TODO: remove cache

        attendances = attendances_students.map(a => {
            let attendance: Attendance = a.attendance
            attendance.attendanceStudents = [a]
            return attendance
        })

        return attendances
    }

    async getDeliveredActivitiesByClassroom(classroomId: number) {
        const repositoryActivities = connection.getRepository(ActivityStudent)

        const studentsByClassroom = await studentService.getByClass(classroomId);

        const activities: ActivityStudent[] = []

        for (let student of studentsByClassroom) {
            const studentAtivities: ActivityStudent[] = await repositoryActivities.find({ where: { students_id: student.id, delivered: true }, cache: 20000 }) // TODO: remove cache
            activities.push(...studentAtivities)
        }
        return activities;
    }

    async getAttendanceByClassroom(classroomId: number) {
        let attendances: Attendance[] = []
        const RepositoryAttendanceStudent = connection.getRepository(AttendanceStudent)

        const studentsByClassroom = await studentService.getByClass(classroomId);

        for (let student of studentsByClassroom) {
            const attendance_student = await this.getAttendanceByStudent(null, student.id)
            attendances.push(...attendance_student)
        }

        return attendances
    }
}

export default new OverviewService()