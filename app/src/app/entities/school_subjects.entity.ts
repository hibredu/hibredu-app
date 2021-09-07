import { Column, Entity, ManyToOne, OneToMany, PrimaryGeneratedColumn } from "typeorm";
import SubjectsClassrooms from "./subjects_classrooms.entity";

export interface ISchoolSubjects {
    id?: number;
    name?: string;
}

@Entity('school_subjects')
export default class SchoolSubjects {
    @PrimaryGeneratedColumn('increment')
    id: number;

    @Column()
    name: string;

    @OneToMany(() => SubjectsClassrooms, (subjects_classrooms) => subjects_classrooms.school_subject)
    subjects_classrooms: SubjectsClassrooms[];
}