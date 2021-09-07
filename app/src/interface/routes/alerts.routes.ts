import { Router } from "express";
import alertController from "../controllers/alert.controller";

const alertRouter = Router();

alertRouter.get('/class/:id', alertController.getByClass)
alertRouter.get('/student/:id', alertController.getByStudent)

export default alertRouter;

