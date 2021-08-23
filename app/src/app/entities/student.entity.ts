import { Column, Entity, PrimaryGeneratedColumn } from "typeorm";

@Entity('students')
export class Student {
    @PrimaryGeneratedColumn('increment')
    id: number;

    @Column()
    name: string;

    @Column()
    email: string;
}