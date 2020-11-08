import { CommonModule }                            from '@angular/common';
import { NgModule }                                from '@angular/core';
import { FormsModule, ReactiveFormsModule }        from '@angular/forms';
import { NgbModule }                               from '@ng-bootstrap/ng-bootstrap';
import { SimpleMailRoutingModule }                 from './simplemail-routing.module';
import { SimpleMailComponent }                     from './simplemail.component';
import { CustomComponentsModule }                  from '../../../app_component/customcomponents.module';

@NgModule({
  imports: [
    CommonModule,
    FormsModule, 
    ReactiveFormsModule,
    NgbModule,
    SimpleMailRoutingModule,
    CustomComponentsModule
  ],
  declarations: [SimpleMailComponent]
})
export class SimpleMailModule { }
