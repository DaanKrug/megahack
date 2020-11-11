import { NgModule } 
       from '@angular/core';
import { Routes, RouterModule } 
       from '@angular/router';
import { SolicitationComponent } 
       from './solicitation.component';

const routes: Routes = [{path: '',component: SolicitationComponent}];

@NgModule({
	imports: [RouterModule.forChild(routes)],
	exports: [RouterModule]
})
export class SolicitationRoutingModule { }