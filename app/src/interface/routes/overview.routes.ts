import { Router } from "express";
import overviewController from "../controllers/overview.controller";

const overviewRouter = Router();

overviewRouter.get("/classroom", overviewController.getClassroom.bind(overviewController));
overviewRouter.get("/attendance", overviewController.getAttendance.bind(overviewController));
overviewRouter.get("/activities", overviewController.getActivities.bind(overviewController));

export default overviewRouter;