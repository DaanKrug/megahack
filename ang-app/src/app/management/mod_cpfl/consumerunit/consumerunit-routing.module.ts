import { NgModule } 
       from '@angular/core';
import { Routes, RouterModule } 
       from '@angular/router';
import { ConsumerunitComponent } 
       from './consumerunit.component';

const routes: Routes = [{path: '',component: ConsumerunitComponent}];

@NgModule({
	imports: [RouterModule.forChild(routes)],
	exports: [RouterModule]
})
export class ConsumerunitRoutingModule { }