import { CommonModule }                               from '@angular/common';
import { NgModule }                                   from '@angular/core';
import { FormsModule, ReactiveFormsModule }           from '@angular/forms';
import { NgbModule }                                  from '@ng-bootstrap/ng-bootstrap';
import { MailerConfigRoutingModule }                  from './mailerconfig-routing.module';
import { MailerConfigComponent }                      from './mailerconfig.component';
import { CustomComponentsModule }                     from '../../../app_component/customcomponents.module';

@NgModule({
  imports: [
    CommonModule,
    FormsModule, 
    ReactiveFormsModule,
    NgbModule,
    MailerConfigRoutingModule,
    CustomComponentsModule
  ],
  declarations: [MailerConfigComponent]
})
export class MailerConfigModule { }