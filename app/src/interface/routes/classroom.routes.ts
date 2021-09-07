import { Router } from "express";
import classroomController from "../controllers/classroom.controller";

const classroomRouter = Router();

classroomRouter.get("/", classroomController.getAll.bind(classroomController));
classroomRouter.get("/:id", classroomController.getById.bind(classroomController));
classroomRouter.get("/:id/delivery", classroomController.findDeliveryPercentage.bind(classroomController));

export default classroomRouter;