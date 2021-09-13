import { Router } from "express";
import attendanceController from "../controllers/attendance.controller";
import multer from "multer";
import { multerConfig } from "../../infrastructure/middleware/multer.middleware";

const attendanceRouter = Router();
const upload = multer(multerConfig)

attendanceRouter.get('/:id', attendanceController.getById)
attendanceRouter.delete('/:id', attendanceController.delete)
attendanceRouter.get('/class/:id', attendanceController.getByClass)
attendanceRouter.post('/spreadsheet', upload.single("attendance"), attendanceController.sendSpreadsheet)
attendanceRouter.post('/', attendanceController.insertAttendance)

export default attendanceRouter;

