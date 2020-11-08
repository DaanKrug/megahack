import { CommonModule }                            from '@angular/common';
import { NgModule }                                from '@angular/core';
import { FormsModule, ReactiveFormsModule }        from '@angular/forms';
import { NgbModule }                               from '@ng-bootstrap/ng-bootstrap';
import { S3ConfigRoutingModule }                   from './s3config-routing.module';
import { S3ConfigComponent }                       from './s3config.component';
import { CustomComponentsModule }                  from '../../../app_component/customcomponents.module';

@NgModule({
  imports: [
    CommonModule,
    FormsModule, 
    ReactiveFormsModule,
    NgbModule,
    S3ConfigRoutingModule,
    CustomComponentsModule
  ],
  declarations: [S3ConfigComponent]
})
export class S3ConfigModule { }
