import { Router } from "express";
import overviewController from "../controllers/overview.controller";

const overviewRouter = Router();

overviewRouter.get("/classroom", overviewController.getClassroom.bind(overviewController));

export default overviewRouter;