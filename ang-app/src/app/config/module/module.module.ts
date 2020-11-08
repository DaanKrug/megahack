import { CommonModule }                            from '@angular/common';
import { NgModule }                                from '@angular/core';
import { FormsModule, ReactiveFormsModule }        from '@angular/forms';
import { NgbModule }                               from '@ng-bootstrap/ng-bootstrap';
import { ModuleRoutingModule }                     from './module-routing.module';
import { ModuleComponent }                         from './module.component';
import { CustomComponentsModule }                  from '../../../app_component/customcomponents.module';

@NgModule({
  imports: [
    CommonModule,
    FormsModule, 
    ReactiveFormsModule,
    NgbModule,
    ModuleRoutingModule,
    CustomComponentsModule
  ],
  declarations: [ModuleComponent]
})
export class ModuleModule { }
