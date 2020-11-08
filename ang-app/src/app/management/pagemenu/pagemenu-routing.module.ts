import { NgModule } from '@angular/core';
import { Routes, RouterModule } from '@angular/router';

import { PageMenuComponent } from './pagemenu.component';

const routes: Routes = [{path: '',component: PageMenuComponent}];

@NgModule({
  imports: [RouterModule.forChild(routes)],
  exports: [RouterModule]
})
export class PageMenuRoutingModule { }