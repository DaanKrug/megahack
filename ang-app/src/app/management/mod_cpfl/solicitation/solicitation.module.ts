import { CommonModule }                       
       from '@angular/common';
import { NgModule }                           
       from '@angular/core';
import { FormsModule, ReactiveFormsModule }   
       from '@angular/forms';
import { NgbModule }                          
       from '@ng-bootstrap/ng-bootstrap';
import { NgxMaskModule }                      
       from 'ngx-mask';
import { SolicitationRoutingModule }                
       from './solicitation-routing.module';
import { SolicitationComponent }                    
       from './solicitation.component';
import { CustomComponentsModule }             
       from '../../../../app_component/customcomponents.module';

@NgModule({
	imports: [
		CommonModule,
		FormsModule, 
		ReactiveFormsModule,
		NgbModule,
		NgxMaskModule.forRoot(),
		SolicitationRoutingModule,
		CustomComponentsModule
	],
	declarations: [SolicitationComponent]
})
export class SolicitationModule { }