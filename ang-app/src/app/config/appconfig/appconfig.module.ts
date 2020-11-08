import { CommonModule }                       from '@angular/common';
import { NgModule }                           from '@angular/core';
import { FormsModule, ReactiveFormsModule }   from '@angular/forms';
import { NgbModule }                          from '@ng-bootstrap/ng-bootstrap';
import { AppConfigRoutingModule }             from './appconfig-routing.module';
import { AppConfigComponent }                 from './appconfig.component';
import { CustomComponentsModule }             from '../../../app_component/customcomponents.module';

@NgModule({
  imports: [
    CommonModule,
    FormsModule, 
    ReactiveFormsModule,
    NgbModule,
    AppConfigRoutingModule,
    CustomComponentsModule
  ],
  declarations: [AppConfigComponent]
})
export class AppConfigModule { }
