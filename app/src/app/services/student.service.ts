import { getConnection, In, Repository } from "typeorm";
import Student from "../entities/student.entity";
import subject_classroomService from "./subject_classroom.service";
import teacherService from "./teacher.service";

const connection = getConnection()

class StudentService {
    repository: Repository<Student>

    async getAll(teacherID) {
        this.repository = connection.getRepository(Student)

        const classes = await teacherService.getClassesByTeacher(teacherID);

        const students = await this.repository.find({ where: { classrooms_id: In(classes) }, order: { name: "ASC" } });
        console.log("========================= students =========================")
        console.log(students)
        return await Promise.all(students.map(async (student) => {
            return {
                ...student,
                subjects: await subject_classroomService.getSubjectByClass(student.classrooms_id)
            }
        }))
    }

    async getById(id: number) {
        this.repository = connection.getRepository(Student)

        return await this.repository.findOne({ where: { id }, relations: ["activitiesToStudents", "alerts"] });
    }

    async getDeliveryPercentage(id: number) {
        this.repository = connection.getRepository(Student)

        const student = await this.repository.findOne({ where: { id }, relations: ["activitiesToStudents"] });
        const totalActivities = student.activitiesToStudents?.length;
        const totalActivitiesDelivered = student.activitiesToStudents?.filter((activity) => activity.delivered == true).length;
        return (totalActivitiesDelivered / totalActivities) * 100;
    }

    async getDeliveredActivities(id: number) {
        this.repository = connection.getRepository(Student)

        const student = await this.repository.findOne({ where: { id }, relations: ["activitiesToStudents"] });
        const totalActivitiesDelivered = student.activitiesToStudents?.filter((activity) => activity.delivered == true).length;

        return totalActivitiesDelivered;
    }

    async getHitRate(id: number) {
        let hitRate = 0
        let hitRateTotal = 0

        const student = await this.repository.findOne({ where: { id }, relations: ["activitiesToStudents"] });

        const activitiesDelivered = student.activitiesToStudents?.filter((activity) => activity.delivered == true);

        for (let activity of activitiesDelivered) {
            hitRateTotal += activity.activity.max_note
            hitRate += activity.grade
        }

        return (hitRate / hitRateTotal);
    }
}

export default new StudentService()