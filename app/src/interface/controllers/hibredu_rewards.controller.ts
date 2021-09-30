import { Request, Response } from "express";
import hibredu_rewardsService from "../../app/services/hibredu_rewards.service";

class HibreduRewardsController {

    async getAll(req: Request, response: Response) {
        const teacherID = req.userId

        const hibreduRewards = await hibredu_rewardsService.getByTeacherId(teacherID)

        return response.status(200).json(hibreduRewards);
    }
}

export default new HibreduRewardsController()