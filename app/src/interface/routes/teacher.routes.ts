import { Router } from "express";
import schoolSubjectController from "../controllers/schoolSubject.controller";
import teacherController from "../controllers/teacher.controller";

const teacherRouter = Router();

teacherRouter.get('/', teacherController.getAll)
teacherRouter.post('/', teacherController.create)
teacherRouter.patch('/:id', teacherController.update)
teacherRouter.get('/school_subjects', schoolSubjectController.getByTeacher)

export default teacherRouter;

