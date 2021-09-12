import { Column, Entity, OneToMany, PrimaryGeneratedColumn } from "typeorm";
import SubjectClassroom from "./subjects_classrooms.entity";

import Teacher from "./teacher.entity";

@Entity('schools')
export default class School {
    @PrimaryGeneratedColumn('increment')
    id: number;

    @Column()
    name: string;

    @OneToMany(() => Teacher, (teacher) => teacher.school)
    teachers: Teacher[];

    @OneToMany(() => SubjectClassroom, (subjects_classrooms) => subjects_classrooms.school, { onDelete: 'CASCADE' })
    subjects_classrooms: SubjectClassroom[];
}