import { BeforeInsert, BeforeUpdate, Column, CreateDateColumn, Entity, getConnection, JoinColumn, ManyToOne, OneToMany, PrimaryGeneratedColumn, UpdateDateColumn } from "typeorm"
import bcryptjs from 'bcryptjs'
import School from "./school.entity";
import SubjectsClassrooms from "./subjects_classrooms.entity";

export interface ITeacher {
    id?: number;
    name: string;
    email: string;
    password?: string;
    phone?: string;
    school_id?: number;
    school?: School;
    created_at?: Date;
    updated_at?: Date;
}

@Entity('teachers')
export default class Teacher {
    @PrimaryGeneratedColumn('increment')
    id: number;

    @Column()
    name: string;

    @Column()
    email: string;

    @Column()
    password?: string;

    @Column()
    phone: string;

    @ManyToOne(() => School, school => school.teachers)
    @JoinColumn({ name: 'schools_id' })
    school: School;

    @OneToMany(() => SubjectsClassrooms, (subjects_classrooms) => subjects_classrooms.teacher, { eager: true })
    subjects_classrooms: SubjectsClassrooms[];

    @CreateDateColumn({ type: "timestamp", default: () => "CURRENT_TIMESTAMP(6)" })
    created_at: Date;

    @UpdateDateColumn({ type: "timestamp", default: () => "CURRENT_TIMESTAMP(6)", onUpdate: "CURRENT_TIMESTAMP(6)" })
    updated_at: Date;

    @BeforeInsert()
    @BeforeUpdate()
    hashPassword() {
        this.password = bcryptjs.hashSync(this.password ? this.password : '', 8);
    }
}