import { Router } from "express";
import schoolSubjectController from "../controllers/schoolSubject.controller";

const subjectRouter = Router();

subjectRouter.get('/', schoolSubjectController.getAll);

export default subjectRouter;