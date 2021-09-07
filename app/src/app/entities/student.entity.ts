import { Column, CreateDateColumn, Entity, JoinColumn, ManyToOne, OneToMany, PrimaryGeneratedColumn, UpdateDateColumn } from "typeorm";
import ActivityToStudent from "./activityToStudent.entity";
import AttendanceStudent from "./attendancesStudents.entity";
import { Classroom } from "./classroom.entity";

export interface IStudent {
    id: number;
    name: string;
    lastName: string;
    email: string;
    password: string;
    created_at: Date;
    updated_at: Date;
    activitiesToStudents: ActivityToStudent[];
}

@Entity('students')
export default class Student {
    @PrimaryGeneratedColumn('increment')
    id: number;

    @Column()
    name: string;

    @Column()
    email: string;

    @ManyToOne(() => Classroom, (classroom) => classroom.students)
    @JoinColumn({ name: 'classrooms_id' })
    classroom: Classroom;

    @CreateDateColumn({ type: "timestamp", default: () => "CURRENT_TIMESTAMP(6)" })
    created_at: Date;

    @UpdateDateColumn({ type: "timestamp", default: () => "CURRENT_TIMESTAMP(6)", onUpdate: "CURRENT_TIMESTAMP(6)" })
    updated_at: Date;

    @OneToMany(() => ActivityToStudent, (activityToStudent) => activityToStudent.student, { eager: false })
    activitiesToStudents: ActivityToStudent[];

    @OneToMany(() => AttendanceStudent, (attendance_student) => attendance_student.student)
    attendanceStudents: AttendanceStudent[];
}