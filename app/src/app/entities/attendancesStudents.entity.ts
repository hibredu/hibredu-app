import { Column, CreateDateColumn, Entity, JoinColumn, ManyToOne, PrimaryColumn, PrimaryGeneratedColumn } from "typeorm";
import Attendance from "./attendance.entity";
import File from "./file.entity";
import Student from "./student.entity";
import SubjectClassroom from "./subjects_classrooms.entity";

export interface IAttendanceStudent {
    id?: number;
    content: string;
    type?: string;
}

@Entity('attendances_students')
export default class AttendanceStudent {

    @PrimaryColumn()
    attendances_id: number;

    @Column()
    present: boolean;

    @ManyToOne(() => Attendance, attendance => attendance.attendanceStudents, { eager: true, onDelete: 'CASCADE' })
    @JoinColumn({ name: 'attendances_id' })
    attendance: Attendance;

    @ManyToOne(() => Student, student => student.attendanceStudents, { eager: true, onDelete: 'CASCADE' })
    @JoinColumn({ name: 'students_id' })
    student: Student;
}