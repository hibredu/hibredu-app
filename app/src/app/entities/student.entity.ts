import { Column, CreateDateColumn, Entity, JoinColumn, ManyToOne, OneToMany, PrimaryGeneratedColumn, UpdateDateColumn } from "typeorm";
import { ActivityToStudent } from "./activityToStudent.entity";
import { Classroom } from "./classroom.entity";

@Entity('students')
export class Student {
    @PrimaryGeneratedColumn('increment')
    id: number;

    @Column()
    name: string;

    @Column()
    email: string;

    @ManyToOne(() => Classroom, (classroom) => classroom.students)
    @JoinColumn({name: 'id_classroom'})
    classroom: Classroom;

    @CreateDateColumn({ type: "timestamp", default: () => "CURRENT_TIMESTAMP(6)" })
    created_at: Date;

    @UpdateDateColumn({ type: "timestamp", default: () => "CURRENT_TIMESTAMP(6)", onUpdate: "CURRENT_TIMESTAMP(6)" })
    updated_at: Date;

    @OneToMany(() => ActivityToStudent, (activityToStudent) => activityToStudent.student, { eager: true })
    activitiesToStudents: ActivityToStudent[];
}