import { Router } from "express";
import multer from "multer";
import { multerConfig } from "../../infrastructure/middleware/multer.middleware";
import activityController from "../controllers/activity.controller";

const activityRouter = Router();
const upload = multer(multerConfig)

activityRouter.post('/spreadsheet/teams', upload.single("activity"), activityController.sendTeamsSpreadsheet)
activityRouter.post('/', activityController.insertActivity)

export default activityRouter;

