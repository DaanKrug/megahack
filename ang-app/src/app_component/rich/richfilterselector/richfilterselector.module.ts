import { NgModule }                               from '@angular/core';
import { CommonModule }                           from '@angular/common';
import { FormsModule, ReactiveFormsModule }       from '@angular/forms';
import { NgbModule }                              from '@ng-bootstrap/ng-bootstrap';
import { RichFilterSelectorComponent }            from './richfilterselector.component';

@NgModule({
  imports: [
    CommonModule, FormsModule, ReactiveFormsModule, NgbModule
  ],
  declarations: [RichFilterSelectorComponent],
  exports: [RichFilterSelectorComponent]
})
export class RichFilterSelectorModule { }
