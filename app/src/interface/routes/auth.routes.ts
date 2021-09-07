import { Router } from "express";
import authController from "../controllers/auth.controller";
import teacherController from "../controllers/teacher.controller";

const authRouter = Router();

authRouter.post('/auth', authController.authenticate)
authRouter.post('/teacher', teacherController.create)

export default authRouter;

