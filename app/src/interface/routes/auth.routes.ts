import { Router } from "express";
import authController from "../controllers/auth.controller";

const authRouter = Router();

authRouter.post('/auth', authController.authenticate)
authRouter.post('/new_user', authController.createUser)

export default authRouter;

