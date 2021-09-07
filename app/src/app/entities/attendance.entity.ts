import { Column, CreateDateColumn, Entity, JoinColumn, ManyToOne, OneToMany, PrimaryGeneratedColumn } from "typeorm";
import AttendanceStudent from "./attendancesStudents.entity";
import File from "./file.entity";
import SubjectClassroom from "./subjects_classrooms.entity";

export interface IAttendance {
    id?: number;
    content: string;
    type?: string;
}

@Entity('attendances')
export default class Attendance {
    @PrimaryGeneratedColumn('increment')
    id: number;

    @Column()
    date: Date;

    @Column()
    description: string;

    @Column()
    class_subject: string;

    @Column()
    owner_id?: number;

    @CreateDateColumn({ type: "timestamp", default: () => "CURRENT_TIMESTAMP(6)" })
    created_at: Date;

    @ManyToOne(() => SubjectClassroom, subject_classroom => subject_classroom.attendances)
    @JoinColumn({ name: 'owner_id' })
    subject_classroom: SubjectClassroom;

    @ManyToOne(() => File, (file) => file.attendances)
    @JoinColumn({ name: 'files_id' })
    file: File

    @OneToMany(() => AttendanceStudent, (attendance_student) => attendance_student.attendance)
    attendanceStudents: AttendanceStudent[];

}