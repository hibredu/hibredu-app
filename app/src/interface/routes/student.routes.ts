import { Router } from "express";
import studentController from "../controllers/student.controller";

const studentRouter = Router();

studentRouter.get("/", studentController.getAll);
studentRouter.get("/:id", studentController.findOne);

export default studentRouter;