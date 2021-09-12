import { Column, Entity, OneToMany, PrimaryGeneratedColumn } from "typeorm";
import Activity from "./activity.entity";
import Attendance from "./attendance.entity";

export interface IFile {
    id?: number;
    content: string;
    type?: string;
}

@Entity('files')
export default class File {
    @PrimaryGeneratedColumn('increment')
    id: number;

    @Column()
    content: string;

    @Column()
    type: string;

    @OneToMany(() => Attendance, (attendance) => attendance.file)
    attendances: Attendance[];

    @OneToMany(() => Activity, (activity) => activity.file)
    activities: Activity[];
}