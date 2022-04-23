import { getConnection, Repository } from "typeorm"
import ActivityStudent from "../entities/activity_student.entity"
import Question from "../entities/question.entity"
import QuestionStudent from "../entities/question_student.entity"
import Student from "../entities/student.entity"
import activityStudentService from "./activity_student.service"
import questionService from "./question.service"
import studentService from "./student.service"

const connection = getConnection()

class QuestionStudentService {
    repository: Repository<QuestionStudent>

    async insert(questionId: number, response: string, points: number, activitiesStudentsId: number) {
        this.repository = connection.getRepository(QuestionStudent)

        let questionStudentRegister = new QuestionStudent()
        questionStudentRegister.questions_id = questionId
        questionStudentRegister.response = response
        questionStudentRegister.points = points
        questionStudentRegister.activities_students_id = activitiesStudentsId

        await this.repository.insert(questionStudentRegister)
    }

    async insertManyTeams(fileId: number, activityId: number, classroomId: number, totalQuestions: number) {
        const questions: Question[] = await questionService.getByActivityId(activityId)
        const students: Student[] = await studentService.getByClass(classroomId)

        for(let _i = 1; _i <= totalQuestions; _i++) {
            const answersQuestion: any[] = await questionService.getAnswerQuestionTeams(fileId, _i)
            if(answersQuestion !== null) {
                answersQuestion.forEach(async (answer) => {
                    const question: Question = questions.find((qt) => qt.description.toLowerCase() === answer.question.toLowerCase())
                    const student: Student = students.find((st) => st.name.toLowerCase() === answer.student_name.toLowerCase())
                    const activityStudent: ActivityStudent = await activityStudentService.findByStudentAndActivity(student.id, activityId)
                    this.insert(question.id, answer.answer, answer.points, activityStudent.id)
                })
            }
        }
    }
}

export default new QuestionStudentService()