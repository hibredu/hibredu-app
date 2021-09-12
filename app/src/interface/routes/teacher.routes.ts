import { Router } from "express";
import teacherController from "../controllers/teacher.controller";

const teacherRouter = Router();

teacherRouter.post('/', teacherController.create)
teacherRouter.get('/', teacherController.getAll)

export default teacherRouter;

