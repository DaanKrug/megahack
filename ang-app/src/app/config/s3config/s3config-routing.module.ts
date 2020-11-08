import { NgModule } from '@angular/core';
import { Routes, RouterModule } from '@angular/router';

import { S3ConfigComponent } from './s3config.component';

const routes: Routes = [{path: '',component: S3ConfigComponent}];

@NgModule({
  imports: [RouterModule.forChild(routes)],
  exports: [RouterModule]
})
export class S3ConfigRoutingModule { }