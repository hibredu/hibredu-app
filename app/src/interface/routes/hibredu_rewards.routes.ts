import { Router } from "express";
import hibredu_rewardsController from "../controllers/hibredu_rewards.controller";

const hibredu_rewardsRouter = Router();

hibredu_rewardsRouter.get("/", hibredu_rewardsController.getAll.bind(hibredu_rewardsController));

export default hibredu_rewardsRouter;