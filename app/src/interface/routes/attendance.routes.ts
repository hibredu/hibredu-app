import { Router } from "express";
import attendanceController from "../controllers/attendance.controller";

const attendanceRouter = Router();

attendanceRouter.get('/class/:id', attendanceController.getByClass)

export default attendanceRouter;

