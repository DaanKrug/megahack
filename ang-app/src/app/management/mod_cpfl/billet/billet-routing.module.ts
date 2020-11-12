import { NgModule } 
       from '@angular/core';
import { Routes, RouterModule } 
       from '@angular/router';
import { BilletComponent } 
       from './billet.component';

const routes: Routes = [{path: '',component: BilletComponent}];

@NgModule({
	imports: [RouterModule.forChild(routes)],
	exports: [RouterModule]
})
export class BilletRoutingModule { }