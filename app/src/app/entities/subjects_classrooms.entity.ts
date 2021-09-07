import { Column, Entity, JoinColumn, ManyToOne, OneToMany, PrimaryGeneratedColumn } from "typeorm";
import { Classroom } from "./classroom.entity";
import SchoolSubjects from "./school_subjects.entity";
import Teacher from "./teacher.entity";

export interface ISubjectsClassrooms {
    id?: number;
    content: string;
    type?: string;
}

@Entity('subjects_classrooms')
export default class SubjectsClassrooms {
    @PrimaryGeneratedColumn('increment')
    id: number;

    @ManyToOne(() => SchoolSubjects, school_subject => school_subject.subjects_classrooms, { eager: true })
    @JoinColumn({ name: 'school_subjects_id' })
    school_subject: string;

    @ManyToOne(() => Classroom, clasroom => clasroom.subjects_classrooms, { eager: true })
    @JoinColumn({ name: 'classrooms_id' })
    classroom: string;

    @ManyToOne(() => Teacher, clasroom => clasroom.subjects_classrooms)
    @JoinColumn({ name: 'teachers_id' })
    teacher: string;

}