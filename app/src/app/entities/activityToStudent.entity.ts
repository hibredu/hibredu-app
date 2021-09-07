import { Column, CreateDateColumn, Entity, JoinColumn, ManyToOne, PrimaryGeneratedColumn, UpdateDateColumn } from "typeorm";
import Activity from "./activity.entity";
import Student from "./student.entity";

@Entity('activities_students')
export default class ActivityToStudent {
    @PrimaryGeneratedColumn('increment')
    id: number;

    @Column()
    delivered: number;

    @Column()
    status: string;

    @Column()
    grade: number;

    @CreateDateColumn({ type: "timestamp", default: () => "CURRENT_TIMESTAMP(6)" })
    created_at: Date;

    @UpdateDateColumn({ type: "timestamp", default: () => "CURRENT_TIMESTAMP(6)", onUpdate: "CURRENT_TIMESTAMP(6)" })
    updated_at: Date;

    @ManyToOne(() => Activity, (activity) => activity.activitiesToStudents)
    @JoinColumn({ name: 'activities_id' })
    activity: Activity;

    @ManyToOne(() => Student, (student) => student.activitiesToStudents)
    @JoinColumn({ name: 'students_id' })
    student: Student;
}