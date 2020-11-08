import { NgModule }                                   from '@angular/core';
import { CommonModule }                               from '@angular/common';
import { FormsModule, ReactiveFormsModule }           from '@angular/forms';
import { NgbModule }                                  from '@ng-bootstrap/ng-bootstrap';
import { RichCheckboxMultiComponent }                 from './richcheckboxmulti.component';

@NgModule({
  imports: [
    CommonModule, FormsModule, ReactiveFormsModule, NgbModule
  ],
  declarations: [RichCheckboxMultiComponent],
  exports: [RichCheckboxMultiComponent]
})
export class RichCheckboxMultiModule { }
