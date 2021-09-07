import { Column, CreateDateColumn, Entity, ManyToOne, OneToMany, PrimaryGeneratedColumn, UpdateDateColumn } from "typeorm";
import Student from "./student.entity";
import SubjectsClassrooms from "./subjects_classrooms.entity";

@Entity('classrooms')
export class Classroom {
    @PrimaryGeneratedColumn('increment')
    id: number;

    @Column()
    name: string;

    @OneToMany(() => Student, (student) => student.classroom, { eager: false })
    students: Student[]

    @OneToMany(() => SubjectsClassrooms, (subjects_classrooms) => subjects_classrooms.classroom)
    subjects_classrooms: SubjectsClassrooms[];

    @CreateDateColumn({ type: "timestamp", default: () => "CURRENT_TIMESTAMP(6)" })
    created_at: Date;

    @UpdateDateColumn({ type: "timestamp", default: () => "CURRENT_TIMESTAMP(6)", onUpdate: "CURRENT_TIMESTAMP(6)" })
    updated_at: Date;
}