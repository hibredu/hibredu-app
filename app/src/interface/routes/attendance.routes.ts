import { Router } from "express";
import attendanceController from "../controllers/attendance.controller";
import multer from "multer";

const attendanceRouter = Router();
const upload = multer({ storage: multer.memoryStorage() })

attendanceRouter.get('/:id', attendanceController.getById)
attendanceRouter.delete('/:id', attendanceController.delete)
attendanceRouter.get('/class/:id', attendanceController.getByClass)
attendanceRouter.post('/spreadsheet', upload.single("attendances"), attendanceController.sendSpreadsheet)
attendanceRouter.post('/', attendanceController.sendAttendances)

export default attendanceRouter;

