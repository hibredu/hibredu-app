import { Request, Response } from "express";
import school_subjectService from "../../app/services/school_subject.service";

class SchoolSubjectController {

    async getAll(_: Request, response: Response) {
        const subjects = await school_subjectService.getAll();

        return response.status(200).json(subjects);
    }

    async getByTeacher(request: Request, response: Response) {
        const teacher_id = request.userId
        const subjects = await school_subjectService.getByTeacherId(parseInt(teacher_id));

        return response.status(200).json(subjects);
    }

    async getByTeacherbyClass(request: Request, response: Response) {
        const teacher_id = request.userId
        const class_id = request.params.id
        const subjects = await school_subjectService.getByTeacherIdbyClass(parseInt(teacher_id), parseInt(class_id));

        return response.status(200).json(subjects);
    }
}

export default new SchoolSubjectController();