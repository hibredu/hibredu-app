import { Router } from "express";
import schoolController from "../controllers/school.controller";

const schoolRouter = Router();

schoolRouter.get("/", schoolController.getAll.bind(schoolController));
schoolRouter.get("/:id_school/classrooms", schoolController.getSchoolClassrooms.bind(schoolController));

export default schoolRouter;