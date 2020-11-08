import { CommonModule }                            from '@angular/common';
import { NgModule }                                from '@angular/core';
import { FormsModule, ReactiveFormsModule }        from '@angular/forms';
import { NgbModule }                               from '@ng-bootstrap/ng-bootstrap';
import { ImageRoutingModule }                      from './image-routing.module';
import { ImageComponent }                          from './image.component';
import { CustomComponentsModule }                  from '../../../app_component/customcomponents.module';

@NgModule({
  imports: [
    CommonModule,
    FormsModule, 
    ReactiveFormsModule,
    NgbModule,
    ImageRoutingModule,
    CustomComponentsModule
  ],
  declarations: [ImageComponent]
})
export class ImageModule { }
