import { getConnection, Repository } from "typeorm"
import Attendance from "../entities/attendance.entity"
import AttendanceStudent from "../entities/attendance_student.entity"
import Student from "../entities/student.entity"
import attendanceService from "./attendance.service"
import studentService from "./student.service"

const connection = getConnection()

class AttendanceStudentsService {
    repository: Repository<AttendanceStudent>

    async insert(attendanceId: number, classroomId: number) {
        this.repository = connection.getRepository(AttendanceStudent)

        const attendance: Attendance = await attendanceService.getById(attendanceId);
        const presentStudentsNames: string[] = await studentService.getStudentNames(attendance.files_id);
        const allStudents: Student[] = await studentService.getByClass(classroomId)

        allStudents.forEach(async student => {
            const attendanceStudent: AttendanceStudent = new AttendanceStudent()
            attendanceStudent.students_id = student.id;
            attendanceStudent.attendances_id = attendance.id;
            attendanceStudent.present = false;
            const presentStudentsNamesUpperCase = presentStudentsNames.map(name => name.toUpperCase());
    
            // TODO: POR ENQUANTO ELE DA PRESENÇA PARA TODOS OS ALUNOS QUE ESTIVERAM NA AULA EM ALGUM MOMENTO
            if(presentStudentsNamesUpperCase.includes(student.name)) {
                attendanceStudent.present = true;
            }

            await this.repository.insert(attendanceStudent);
        });
    }
}

export default new AttendanceStudentsService()