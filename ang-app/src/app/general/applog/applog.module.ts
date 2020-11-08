import { CommonModule }                            from '@angular/common';
import { NgModule }                                from '@angular/core';
import { FormsModule, ReactiveFormsModule }        from '@angular/forms';
import { NgbModule }                               from '@ng-bootstrap/ng-bootstrap';
import { AppLogRoutingModule }                     from './applog-routing.module';
import { AppLogComponent }                         from './applog.component';
import { CustomComponentsModule }                  from '../../../app_component/customcomponents.module';

@NgModule({
  imports: [
    CommonModule,
    FormsModule, 
    ReactiveFormsModule,
    NgbModule,
    AppLogRoutingModule,
    CustomComponentsModule
  ],
  declarations: [AppLogComponent]
})
export class AppLogModule { }
