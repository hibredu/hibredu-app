import { Router } from "express";

import HelloWorldController from "../controllers/helloWorld.controller";

const helloWorldRouter = Router();

helloWorldRouter.get("/", HelloWorldController.index);

export default helloWorldRouter;