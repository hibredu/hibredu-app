import { Router } from "express";
import classroomController from "../controllers/classroom.controller";

const classroomRouter = Router();

classroomRouter.get("/:id/delivery", classroomController.findDeliveryPercentage);

export default classroomRouter;