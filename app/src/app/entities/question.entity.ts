import { Column, Entity, PrimaryGeneratedColumn } from "typeorm";

@Entity('questions')
export default class Question {
    @PrimaryGeneratedColumn('increment')
    id: number

    @Column()
    activities_id: number

    @Column()
    description: string

    @Column()
    total_points: number
}