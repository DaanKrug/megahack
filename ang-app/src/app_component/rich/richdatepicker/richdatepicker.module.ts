import { NgModule }                                   from '@angular/core';
import { CommonModule }                               from '@angular/common';
import { FormsModule, ReactiveFormsModule }           from '@angular/forms';
import { NgbModule }                                  from '@ng-bootstrap/ng-bootstrap';
import { RichDatePickerComponent }                    from './richdatepicker.component';

@NgModule({
  imports: [
    CommonModule, FormsModule, ReactiveFormsModule, NgbModule
  ],
  declarations: [RichDatePickerComponent],
  exports: [RichDatePickerComponent]
})
export class RichDatePickerModule { }
