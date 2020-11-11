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
import { ConsumerunitRoutingModule }                
       from './consumerunit-routing.module';
import { ConsumerunitComponent }                    
       from './consumerunit.component';
import { CustomComponentsModule }             
       from '../../../../app_component/customcomponents.module';

@NgModule({
	imports: [
		CommonModule,
		FormsModule, 
		ReactiveFormsModule,
		NgbModule,
		NgxMaskModule.forRoot(),
		ConsumerunitRoutingModule,
		CustomComponentsModule
	],
	declarations: [ConsumerunitComponent]
})
export class ConsumerunitModule { }