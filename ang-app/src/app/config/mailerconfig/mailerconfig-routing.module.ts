import { NgModule } from '@angular/core';
import { Routes, RouterModule } from '@angular/router';

import { MailerConfigComponent } from './mailerconfig.component';

const routes: Routes = [{path: '',component: MailerConfigComponent}];

@NgModule({
  imports: [RouterModule.forChild(routes)],
  exports: [RouterModule]
})
export class MailerConfigRoutingModule { }