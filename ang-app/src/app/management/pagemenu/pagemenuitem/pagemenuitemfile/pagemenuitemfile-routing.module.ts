import { NgModule } from '@angular/core';
import { Routes, RouterModule } from '@angular/router';

import { PageMenuItemFileComponent } from './pagemenuitemfile.component';

const routes: Routes = [{path: '',component: PageMenuItemFileComponent}];

@NgModule({
  imports: [RouterModule.forChild(routes)],
  exports: [RouterModule]
})
export class PageMenuItemFileRoutingModule { }