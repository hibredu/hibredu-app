import { Router } from "express";
import teacherController from "../controllers/teacher.controller";

const teacherRouter = Router();

teacherRouter.post('/', teacherController.create)

export default teacherRouter;

