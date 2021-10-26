import { Router } from "express";
import overviewController from "../controllers/overview.controller";

const overviewRouter = Router();

overviewRouter.get("/classroom", overviewController.getClassroom.bind(overviewController));
overviewRouter.get("/attendance", overviewController.getAttendance.bind(overviewController));
overviewRouter.get("/activities", overviewController.getActivities.bind(overviewController));
overviewRouter.get("/alerts", overviewController.getAlerts.bind(overviewController));
overviewRouter.get("/attendance/activities", overviewController.getAttendanceActivities.bind(overviewController));
overviewRouter.get("/student/attendance/activities/:id", overviewController.getStudentAttendanceActivities.bind(overviewController));
overviewRouter.get("/classroom/attendance/activities/:id", overviewController.getClassroomAttendanceActivities.bind(overviewController));

export default overviewRouter;