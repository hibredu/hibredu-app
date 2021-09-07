import { Router } from "express";
import classroomController from "../controllers/classroom.controller";

const classroomRouter = Router();

classroomRouter.get("/", classroomController.getAll);
classroomRouter.get("/:id", classroomController.getById);
classroomRouter.get("/:id/delivery", classroomController.findDeliveryPercentage);

export default classroomRouter;