import { BeforeInsert, BeforeUpdate, Column, Entity, PrimaryGeneratedColumn } from "typeorm"
import bcryptjs from 'bcryptjs'

@Entity('teachers')
export class Teacher {
    @PrimaryGeneratedColumn('increment')
    id: number;

    @Column()
    name: string;

    @Column()
    email: string;

    @Column()
    password?: string;

    @BeforeInsert()
    @BeforeUpdate()
    hashPassword() {
        this.password = bcryptjs.hashSync(this.password ? this.password : '', 8);
    }
}