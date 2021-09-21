import { Column, CreateDateColumn, Entity, JoinColumn, ManyToOne, PrimaryGeneratedColumn, UpdateDateColumn } from "typeorm";
import Activity from "./activity.entity";
import Student from "./student.entity";

@Entity('activities_students')
export default class ActivityToStudent {
    [x: string]: any;
    @PrimaryGeneratedColumn('increment')
    id: number;

    @Column()
    delivered: boolean;

    @Column()
    status: string;

    @Column()
    grade: number;

    @CreateDateColumn({ type: "timestamp", default: () => "CURRENT_TIMESTAMP(6)" })
    created_at: Date;

    @UpdateDateColumn({ type: "timestamp", default: () => "CURRENT_TIMESTAMP(6)", onUpdate: "CURRENT_TIMESTAMP(6)" })
    updated_at: Date;

    @Column()
    activities_id: number;

    @ManyToOne(() => Activity, (activity) => activity.activitiesToStudents, { eager: true })
    @JoinColumn({ name: 'activities_id' })
    activity: Activity;

    @ManyToOne(() => Student, (student) => student.activitiesToStudents)
    @JoinColumn({ name: 'students_id' })
    student: Student;
}