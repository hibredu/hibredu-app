import { Column, CreateDateColumn, Entity, JoinColumn, ManyToOne, OneToMany, PrimaryGeneratedColumn, UpdateDateColumn } from "typeorm";
import ActivityStudent from "./activity_student.entity";
import Alert from "./alerts.entity";
import AttendanceStudent from "./attendances_student.entity";
import { Classroom } from "./classroom.entity";

export interface IStudent {
    id: number;
    name: string;
    lastName: string;
    email?: string;
    password: string;
    created_at: Date;
    updated_at: Date;
    activitiesToStudents: ActivityStudent[];
}

@Entity('students')
export default class Student {
    @PrimaryGeneratedColumn('increment')
    id: number;

    @Column()
    name: string;

    @Column({default: null})
    email?: string;

    @Column()
    classrooms_id: number;

    @ManyToOne(() => Classroom, (classroom) => classroom.students)
    @JoinColumn({ name: 'classrooms_id' })
    classroom: Classroom;

    @CreateDateColumn({ type: "timestamp", default: () => "CURRENT_TIMESTAMP(6)" })
    created_at: Date;

    @UpdateDateColumn({ type: "timestamp", default: () => "CURRENT_TIMESTAMP(6)", onUpdate: "CURRENT_TIMESTAMP(6)" })
    updated_at: Date;

    @OneToMany(() => ActivityStudent, (activityToStudent) => activityToStudent.student, { eager: false })
    activitiesToStudents: ActivityStudent[];

    @OneToMany(() => AttendanceStudent, (attendance_student) => attendance_student.student)
    attendanceStudents: AttendanceStudent[];

    @OneToMany(() => Alert, (alert) => alert.student, { eager: false })
    alerts: Alert[];
}