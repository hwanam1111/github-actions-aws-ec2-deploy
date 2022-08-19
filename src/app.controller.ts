import { Controller, Get } from '@nestjs/common';
import { AppService } from './app.service';

@Controller()
export class AppController {
  constructor(private readonly appService: AppService) {}

  @Get()
  getHello(): string {
    return this.appService.getHello();
  }

  @Get('/green')
  getHelloGreenDeploy(): string {
    return 'Hello green deploy';
  }

  @Get('/blue')
  getHelloBlueDeploy(): string {
    return 'Hello blue deploy';
  }
}
