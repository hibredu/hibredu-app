import { Column, Entity, JoinColumn, ManyToOne, OneToMany, PrimaryGeneratedColumn } from "typeorm";
import Attendance from "./attendance.entity";
import { Classroom } from "./classroom.entity";
import SchoolSubjects from "./school_subjects.entity";
import Teacher from "./teacher.entity";

export interface ISubjectClassroom {
    id?: number;
    content: string;
    type?: string;
}

@Entity('subjects_classrooms')
export default class SubjectClassroom {
    @PrimaryGeneratedColumn('increment')
    id: number;

    @Column()
    school_subjects_id: number;

    @Column()
    classrooms_id: number;

    @Column()
    teachers_id: number;

    @ManyToOne(() => SchoolSubjects, school_subject => school_subject.subjects_classrooms, { eager: true })
    @JoinColumn({ name: 'school_subjects_id' })
    school_subject: SchoolSubjects;

    @ManyToOne(() => Classroom, clasroom => clasroom.subjects_classrooms, { eager: true })
    @JoinColumn({ name: 'classrooms_id' })
    classroom: Classroom;

    @ManyToOne(() => Teacher, clasroom => clasroom.subjects_classrooms)
    @JoinColumn({ name: 'teachers_id' })
    teacher: Teacher;

    @OneToMany(() => Attendance, (subjects_classrooms) => subjects_classrooms.subject_classroom, { eager: false })
    attendances: Attendance[];

}