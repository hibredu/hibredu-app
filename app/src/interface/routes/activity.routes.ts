import { Router } from "express";
import multer from "multer";
import { multerConfig } from "../../infrastructure/middleware/multer.middleware";
import activityController from "../controllers/activity.controller";

const activityRouter = Router();
const upload = multer(multerConfig)

activityRouter.get('/classroom/:classroom_id', activityController.getByClassroom)
activityRouter.post('/teams/spreadsheet', upload.single("activity"), activityController.sendTeamsSpreadsheet)
activityRouter.post('/teams', activityController.insertTeamsActivity)

export default activityRouter;

