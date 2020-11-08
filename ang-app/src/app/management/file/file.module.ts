import { CommonModule }                            from '@angular/common';
import { NgModule }                                from '@angular/core';
import { FormsModule, ReactiveFormsModule }        from '@angular/forms';
import { NgbModule }                               from '@ng-bootstrap/ng-bootstrap';
import { FileRoutingModule }                       from './file-routing.module';
import { FileComponent }                           from './file.component';
import { CustomComponentsModule }                  from '../../../app_component/customcomponents.module';

@NgModule({
  imports: [
    CommonModule,
    FormsModule, 
    ReactiveFormsModule,
    NgbModule,
    FileRoutingModule,
    CustomComponentsModule
  ],
  declarations: [FileComponent]
})
export class FileModule { }
