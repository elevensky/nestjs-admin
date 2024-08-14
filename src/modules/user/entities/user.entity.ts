import { Entity, PrimaryGeneratedColumn, Column } from 'typeorm';

@Entity()
export class User {
  @PrimaryGeneratedColumn()
  id: number;

  @Column({ type: 'varchar', length: 20, default: '', comment: '名称' })
  name: string;

  @Column({ type: 'int', default: 0, comment: '年龄' })
  age: number;

  @Column()
  email: string;
}
