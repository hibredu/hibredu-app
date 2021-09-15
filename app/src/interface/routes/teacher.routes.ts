import { Router } from "express";
import teacherController from "../controllers/teacher.controller";

const teacherRouter = Router();

teacherRouter.get('/', teacherController.getAll)
teacherRouter.post('/', teacherController.create)
teacherRouter.patch('/:id', teacherController.update)

export default teacherRouter;

