import { Router } from "express";
import schoolSubjectController from "../controllers/schoolSubject.controller";
import teacherController from "../controllers/teacher.controller";

const teacherRouter = Router();

teacherRouter.get('/', teacherController.getAll)
teacherRouter.get('/school_subjects', schoolSubjectController.getByTeacher)
teacherRouter.get('/:id', teacherController.getById)
teacherRouter.post('/', teacherController.create)
teacherRouter.patch('/:id', teacherController.update)

export default teacherRouter;

