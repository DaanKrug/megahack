import { NgModule }                                   from '@angular/core';
import { CommonModule }                               from '@angular/common';
import { FormsModule, ReactiveFormsModule }           from '@angular/forms';
import { NgbModule }                                  from '@ng-bootstrap/ng-bootstrap';
import { RichDropDownButtonComponent }                from './richdropdownbutton.component';

@NgModule({
  imports: [
    CommonModule, FormsModule, ReactiveFormsModule, NgbModule
  ],
  declarations: [RichDropDownButtonComponent],
  exports: [RichDropDownButtonComponent]
})
export class RichDropDownButtonModule { }
