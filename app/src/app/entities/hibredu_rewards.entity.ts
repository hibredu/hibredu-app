import { Column, CreateDateColumn, Entity, JoinColumn, ManyToOne, PrimaryGeneratedColumn } from "typeorm";
import Teacher from "./teacher.entity";


@Entity('hibredu_rewards')
export default class HibreduRewards {
    @PrimaryGeneratedColumn('increment')
    id: number;

    @Column()
    point: number;

    @CreateDateColumn({ type: "timestamp", default: () => "CURRENT_TIMESTAMP(6)" })
    date: Date;

    @Column()
    teachers_id: number;

    @ManyToOne(() => Teacher, teacher => teacher.hibredu_rewards)
    @JoinColumn({ name: 'teachers_id' })
    teacher: Teacher;
}