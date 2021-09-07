import { Router } from "express";
import attendanceController from "../controllers/attendance.controller";

const attendanceRouter = Router();

attendanceRouter.get('/:id', attendanceController.getById)
attendanceRouter.delete('/:id', attendanceController.delete)
attendanceRouter.get('/class/:id', attendanceController.getByClass)

export default attendanceRouter;

