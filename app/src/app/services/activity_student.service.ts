import { Column, Worksheet } from "exceljs"
import { getConnection, Repository } from "typeorm"
import Activity from "../entities/activity.entity"
import File from "../entities/file.entity"
import ActivityStudent from "../entities/activity_student.entity"
import Student from "../entities/student.entity"
import spreadsheetUtils from "../shared/utils/spreadsheet.utils"
import activityService from "./activity.service"
import fileService from "./file.service"
import studentService from "./student.service"

const connection = getConnection()

class ActivityStudentService {
    repository: Repository<ActivityStudent>

    async insert(grade: number, studentId: number, delivered: boolean, activityId: number) {
        this.repository = connection.getRepository(ActivityStudent)

        let activityStudentRegister = new ActivityStudent()
        activityStudentRegister.grade = grade
        activityStudentRegister.activities_id = activityId
        activityStudentRegister.students_id = studentId
        activityStudentRegister.delivered = delivered 
        activityStudentRegister.status = delivered ? "Entregue" : "Não entregue"

        await this.repository.insert(activityStudentRegister)
    }

    async insertManyTeams(activityId: number, classroomId: number) {
        const grades: any[] = await this.getClassroomGradesTeams(activityId, classroomId);

        grades.forEach(async (grade) => {
            await this.insert(grade.grade, grade.student_id, grade.delivered, activityId)
        });
    }

    async getClassroomGradesTeams(activityId: number, classroomId: number) : Promise<any[]>{   
        let grades: any[] = []    

        const activity: Activity = await activityService.findById(activityId)
        const file: File = await fileService.findById(activity.files_id)
        const worksheet: Worksheet = await spreadsheetUtils.getWorksheet(file)

        const gradesColumnNumber: number = 6 
        const gradesColumn: Column = worksheet.getColumn(gradesColumnNumber)

        const studentNamesColumnNumber: number = 5
        const studentNamesColumn: Column = worksheet.getColumn(studentNamesColumnNumber)

        const students: Student[] = await studentService.getByClass(classroomId)

        students.forEach((student) => {
            const indexStudent: number = studentNamesColumn.values.map((studentName) => studentName.toString().toLowerCase()).indexOf(student.name.toLowerCase())
            const studentId: number = student.id
            let grade: number = 0
            let delivered: boolean = false

            if(indexStudent != -1) {
                grade = parseInt(gradesColumn.values[indexStudent].toString())
                delivered = true
            }
            
            grades.push({
                student_id: studentId,
                grade: grade,
                delivered: delivered
            })
        })

        return grades;
    }

    async findByStudentAndActivity(studentId: number, activityId: number) {
        this.repository = connection.getRepository(ActivityStudent)
        return await this.repository.findOne({ where: {students_id: studentId, activities_id: activityId}})
    }

}

export default new ActivityStudentService()