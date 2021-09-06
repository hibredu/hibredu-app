import { Column, Entity, OneToMany, PrimaryGeneratedColumn } from "typeorm";
import Teacher from "./teacher.entity";

@Entity('schools')
export default class School {
    @PrimaryGeneratedColumn('increment')
    id: number;

    @Column()
    name: string;

    @OneToMany(() => Teacher, (teacher) => teacher.school)
    teachers: Teacher[];
}