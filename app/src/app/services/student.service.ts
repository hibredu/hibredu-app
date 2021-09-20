import { getConnection, In, Repository } from "typeorm";
import Student from "../entities/student.entity";
import fileService from "./file.service";
import teacherService from "./teacher.service";

const connection = getConnection()

class StudentService {
    repository: Repository<Student>

    async getAll(teacherID) {
        this.repository = connection.getRepository(Student)

        const classes = await teacherService.getClassesByTeacher(teacherID);

        const students = await this.repository.find({ where: { classroom: In(classes) }, order: { name: "ASC" } });
        return students
    }

    async getById(id: number) {
        this.repository = connection.getRepository(Student)

        return await this.repository.findOne({ where: { id }, relations: ["activitiesToStudents", "alerts"] });
    }

    async getByClass(id: number) {
        this.repository = connection.getRepository(Student)

        return await this.repository.find({ where: { classrooms_id: id } });
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

    async insertIfNotExists(fileId: number, classroomId: number) : Promise<void> {
        this.repository = connection.getRepository(Student);

        const studentNames: string[] = await fileService.getStudentNames(fileId);
        studentNames.forEach(async (studentName) => {
            const studentRegistry: Student = await this.repository.findOne({ where: { classrooms_id: classroomId, name: studentName }})
            if(studentRegistry == undefined) {
                const student = new Student()
                student.name = studentName;
                student.classrooms_id = classroomId;
                await this.repository.insert(student)
            }
        });
    }
}

export default new StudentService()