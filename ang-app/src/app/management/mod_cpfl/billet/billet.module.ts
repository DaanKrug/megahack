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
import { BilletRoutingModule }                
       from './billet-routing.module';
import { BilletComponent }                    
       from './billet.component';
import { CustomComponentsModule }             
       from '../../../../app_component/customcomponents.module';

@NgModule({
	imports: [
		CommonModule,
		FormsModule, 
		ReactiveFormsModule,
		NgbModule,
		NgxMaskModule.forRoot(),
		BilletRoutingModule,
		CustomComponentsModule
	],
	declarations: [BilletComponent]
})
export class BilletModule { }