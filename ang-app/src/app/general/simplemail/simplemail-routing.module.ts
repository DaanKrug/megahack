import { NgModule } from '@angular/core';
import { Routes, RouterModule } from '@angular/router';

import { SimpleMailComponent } from './simplemail.component';

const routes: Routes = [{path: '',component: SimpleMailComponent}];

@NgModule({
  imports: [RouterModule.forChild(routes)],
  exports: [RouterModule]
})
export class SimpleMailRoutingModule { }