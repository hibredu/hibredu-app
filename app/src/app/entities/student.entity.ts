import { Column, Entity, PrimaryGeneratedColumn } from "typeorm";

@Entity()
export default class Student {
    @PrimaryGeneratedColumn()
    id: number;

    @Column('name')
    name: string;

    @Column('email')
    email: string;
}