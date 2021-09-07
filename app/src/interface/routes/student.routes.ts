import { Router } from "express";
import studentController from "../controllers/student.controller";

const studentRouter = Router();

studentRouter.get("/", studentController.getAll.bind(studentController));
studentRouter.get("/:id", studentController.findOne.bind(studentController));
studentRouter.get("/:id/delivery", studentController.findDeliveryPercentage);

export default studentRouter;