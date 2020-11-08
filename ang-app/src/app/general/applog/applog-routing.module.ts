import { NgModule } from '@angular/core';
import { Routes, RouterModule } from '@angular/router';

import { AppLogComponent } from './applog.component';

const routes: Routes = [{path: '',component: AppLogComponent}];

@NgModule({
  imports: [RouterModule.forChild(routes)],
  exports: [RouterModule]
})
export class AppLogRoutingModule { }