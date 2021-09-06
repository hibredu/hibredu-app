import { Column, Entity, PrimaryGeneratedColumn } from "typeorm";

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
}