import { Column, Entity, JoinColumn, ManyToOne, PrimaryColumn } from "typeorm";
import Attendance from "./attendance.entity";
import Student from "./student.entity";

export interface IAttendanceStudent {
    attendances_id?: number;
    present?: boolean;
    attendance?: Attendance;
    student?: Student;
}

@Entity('attendances_students')
export default class AttendanceStudent {

    @PrimaryColumn()
    attendances_id: number;

    @PrimaryColumn()
    students_id: number;

    @Column()
    present: boolean;

    @ManyToOne(() => Attendance, attendance => attendance.attendanceStudents, { onDelete: 'CASCADE' })
    @JoinColumn({ name: 'attendances_id' })
    attendance: Attendance;

    @ManyToOne(() => Student, student => student.attendanceStudents, { eager: true, onDelete: 'CASCADE' })
    @JoinColumn({ name: 'students_id' })
    student: Student;
}