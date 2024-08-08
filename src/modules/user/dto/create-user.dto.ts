import { IsString, IsNumber } from 'class-validator';

export class CreateUserDto {
  id: number;
  @IsString()
  name: string;
  @IsNumber()
  age: number;
  @IsString()
  password: string;
  @IsString()
  email: string;
}
