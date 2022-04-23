import { getConnection, Repository } from "typeorm";
import HibreduRewards from "../entities/hibredu_rewards.entity";

const connection = getConnection()

class HibreduRewardsService {
    repository: Repository<HibreduRewards>

    async insertOrUpdate(teachers_id) {
        try {
            this.repository = connection.getRepository(HibreduRewards)

            const existing = await this.repository.findOne({ where: { teachers_id } })

            if (existing) {
                await this.repository.update(existing.id, { point: (Number(existing.point) + 10) })
            } else {
                await this.repository.save({ teachers_id, point: 1, date: new Date() })
            }
        } catch (error) {
            console.log(error)
        }
    }

    async getByTeacherId(teachers_id) {
        this.repository = connection.getRepository(HibreduRewards)

        return await this.repository.find({ where: { teachers_id } })
    }
}

export default new HibreduRewardsService()