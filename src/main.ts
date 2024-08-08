import { NestFactory } from '@nestjs/core';
import { ValidationPipe } from '@nestjs/common';
import { AppModule } from './app.module';

async function bootstrap() {
  const app = await NestFactory.create(AppModule);
  app.setGlobalPrefix('api'); // 设置全局前缀
  app.useGlobalPipes(new ValidationPipe()); // 新增校验 pipe
  await app.listen(3000);
}
bootstrap();
