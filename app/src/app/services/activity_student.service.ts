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

    async insert(grade: number, activityId: number, studentId: number, delivered: boolean) {
        this.repository = connection.getRepository(ActivityStudent)

        let activityStudentRegister = new ActivityStudent()
        activityStudentRegister.grade = grade
        activityStudentRegister.activities_id = activityId
        activityStudentRegister.students_id = studentId
        activityStudentRegister.delivered = delivered 

        await this.repository.insert(activityStudentRegister)
    }

    async insertManyTeams(activityId: number, classroomId: number) {
        const grades: any[] = await this.getClassroomGradesTeams(activityId, classroomId);

        grades.forEach(async (gradeInfo) => {
            await this.insert(gradeInfo.number, activityId, gradeInfo.student_id, gradeInfo.delivered)
        });
    }

    async getClassroomGradesTeams(activityId: number, classroomId: number) : Promise<any[]>{        
        const activity: Activity = await activityService.findById(activityId)
        const file: File = await fileService.findById(activity.files_id)
        const worksheet: Worksheet = await spreadsheetUtils.getWorksheet(file)

        const gradesColumnNumber: number = 6 
        const gradesColumn: Column = worksheet.getColumn(gradesColumnNumber)

        const studentNamesColumnNumber: number = 5
        const studentNamesLower: string[] = worksheet.getColumn(studentNamesColumnNumber).values
            .map((studentName) => studentName.toString().toLowerCase())

        const students: Student[] = await studentService.getByClass(classroomId)

        let grades: any[] = []    
        students.forEach((student) => {
            const indexStudent: number = studentNamesLower.indexOf(student.name.toLowerCase())
            const student_id: number = student.id
            let grade: number = 0
            let delivered: boolean = false

            if(indexStudent != -1) {
                grade = parseInt(gradesColumn.values[indexStudent].toString())
                delivered = true
            }
            
            grades.push({
                student_id: student_id,
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