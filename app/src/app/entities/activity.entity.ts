import { Column, CreateDateColumn, Entity, JoinColumn, ManyToOne, OneToMany, PrimaryGeneratedColumn, UpdateDateColumn } from "typeorm";
import ActivityToStudent from "./activityToStudent.entity";
import File from "./file.entity";
import SubjectClassroom from "./subjects_classrooms.entity";

@Entity('activities')
export default class Activity {
    @PrimaryGeneratedColumn('increment')
    id: number;

    @Column()
    name: string;

    @Column()
    subject: string;

    @Column()
    description: string;

    @Column()
    max_note: number;

    @Column()
    owner_id?: number;

    @ManyToOne(() => SubjectClassroom, subject_classroom => subject_classroom.activities, { onDelete: 'CASCADE' })
    @JoinColumn({ name: 'owner_id' })
    subject_classroom: SubjectClassroom;

    @ManyToOne(() => File, (file) => file.activities, { onDelete: 'CASCADE' })
    @JoinColumn({ name: 'files_id' })
    file: File

    @CreateDateColumn({ type: "timestamp", default: () => "CURRENT_TIMESTAMP(6)" })
    created_at: Date;

    @UpdateDateColumn({ type: "timestamp", default: () => "CURRENT_TIMESTAMP(6)", onUpdate: "CURRENT_TIMESTAMP(6)" })
    updated_at: Date;

    @OneToMany(() => ActivityToStudent, (activityToStudent) => activityToStudent.activity)
    activitiesToStudents: ActivityToStudent[];
}