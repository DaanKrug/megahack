import { NgModule } from '@angular/core';
import { Routes, RouterModule } from '@angular/router';

import { PageMenuItemComponent } from './pagemenuitem.component';

const routes: Routes = [{path: '',component: PageMenuItemComponent}];

@NgModule({
  imports: [RouterModule.forChild(routes)],
  exports: [RouterModule]
})
export class PageMenuItemRoutingModule { }