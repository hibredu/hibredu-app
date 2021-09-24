import { Column, Entity, PrimaryGeneratedColumn } from "typeorm";

@Entity('questions_student')
export default class QuestionStudent {
    @PrimaryGeneratedColumn('increment')
    id: number

    @Column()
    points: number

    @Column()
    response: string

    @Column()
    activities_students_id: number

    @Column()
    questions_id: number
}