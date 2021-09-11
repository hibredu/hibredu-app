import { Router } from "express";
import schoolController from "../controllers/school.controller";

const schoolRouter = Router();

schoolRouter.get("/", schoolController.getAll.bind(schoolController));

export default schoolRouter;