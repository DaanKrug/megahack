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
import { ClientRoutingModule }                
       from './client-routing.module';
import { ClientComponent }                    
       from './client.component';
import { CustomComponentsModule }             
       from '../../../../app_component/customcomponents.module';

@NgModule({
	imports: [
		CommonModule,
		FormsModule, 
		ReactiveFormsModule,
		NgbModule,
		NgxMaskModule.forRoot(),
		ClientRoutingModule,
		CustomComponentsModule
	],
	declarations: [ClientComponent]
})
export class ClientModule { }