import { Column, CreateDateColumn, Entity, JoinColumn, ManyToOne, PrimaryGeneratedColumn, UpdateDateColumn } from "typeorm";
import Student from "./student.entity";
import Teacher from "./teacher.entity";

export interface IAlert {
    id?: number;
    value: string;
    created_at?: Date;
    updated_at?: Date;
    teacher?: Teacher;
    student?: Student;
}

@Entity('alerts')
export default class Alert {
    @PrimaryGeneratedColumn('increment')
    id: number;

    @Column()
    value: string;
    
    @Column()
    level: string;

    @CreateDateColumn({ type: "timestamp", default: () => "CURRENT_TIMESTAMP(6)" })
    created_at: Date;

    @UpdateDateColumn({ type: "timestamp", default: () => "CURRENT_TIMESTAMP(6)", onUpdate: "CURRENT_TIMESTAMP(6)" })
    updated_at: Date;

    @Column()
    teachers_id: number;

    @ManyToOne(() => Teacher, teacher => teacher.alerts)
    @JoinColumn({ name: 'teachers_id' })
    teacher: Teacher;

    @ManyToOne(() => Student, (student) => student.alerts, { eager: true })
    @JoinColumn({ name: 'students_id' })
    student: Student
}
