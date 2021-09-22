import { Request, Response } from "express";
import school_subjectService from "../../app/services/school_subject.service";

class SchoolSubjectController {

    async getAll(request: Request, response: Response) {
        const subjects = await school_subjectService.getAll();

        return response.status(200).json(subjects);
    }
}

export default new SchoolSubjectController(); 