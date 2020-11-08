import { CommonModule }                            from '@angular/common';
import { NgModule }                                from '@angular/core';
import { FormsModule, ReactiveFormsModule }        from '@angular/forms';
import { NgbModule }                               from '@ng-bootstrap/ng-bootstrap';
import { LoginRoutingModule }                      from './login-routing.module';
import { LoginComponent }                          from './login.component';
import { CustomComponentsModule }                  from '../../../app_component/customcomponents.module';

@NgModule({
  imports: [
    CommonModule,
    FormsModule, 
    ReactiveFormsModule,
    NgbModule,
    LoginRoutingModule,
    CustomComponentsModule
  ],
  declarations: [LoginComponent]
})
export class LoginModule {}
