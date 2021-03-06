import { getConnection, Repository } from "typeorm"
import Activity from "../entities/activity.entity"
import SubjectClassroom from "../entities/subjects_classrooms.entity"
import fileService from "./file.service"
import subjectClassroomService from "./subject_classroom.service"

const connection = getConnection()

class ActivityService {
    repository: Repository<Activity>

    async findById(id: number) {
        this.repository = connection.getRepository(Activity)
        return await this.repository.findOne({ where: { id } })
    }

    async insert(teacherId: string, activity: any): Promise<number> {
        const owner: SubjectClassroom = await subjectClassroomService.getBySubjectClassroomTeacher(
            activity.subject_id,
            activity.classroom_id,
            parseInt(teacherId));

        if (owner === undefined) {
            throw ("Ocorreu um erro ao procurar o Owner");
        }

        this.repository = connection.getRepository(Activity)

        let activityRegister = new Activity()
        activityRegister.name = activity.name
        activityRegister.subject = activity.subject_name
        activityRegister.description = activity.description
        activityRegister.max_note = activity.max_note
        activityRegister.files_id = activity.file_id
        activityRegister.owner_id = owner.id

        //TODO: Pegar a data de criação da atividade
        //activity.date = body.date 

        await this.repository.insert(activityRegister)

        return activityRegister.id
    }

    async getTeamsActivityMainColumnsInfo(fileId: number): Promise<string[]> {
        const columns = await fileService.getColumnsInfo(fileId);
        let mainColumns: string[] = [];

        //Colunas principais no padrão teams
        mainColumns.push(columns[3]) // Email
        mainColumns.push(columns[4]) // Nome
        mainColumns.push(columns[5]) // Total de pontos

        return mainColumns;
    }

    async getByClassroom(classroomId: number) {
        this.repository = connection.getRepository(Activity)

        const subjectClassrooms = await subjectClassroomService.getSubjectByClass(classroomId);

        let activities: Activity[] = [];

        for (let i = 0; i < subjectClassrooms.length; i++) {
            const activitiesBySubject = await this.repository.find({ where: { owner_id: subjectClassrooms[i].id }, relations: ["file"] });
            activities = activities.concat(activitiesBySubject)
        }

        return activities;
    }
}

export default new ActivityService()