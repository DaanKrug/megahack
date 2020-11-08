import { NgModule }                               from '@angular/core';
import { CommonModule }                           from '@angular/common';
import { FormsModule, ReactiveFormsModule }       from '@angular/forms';
import { NgbModule }                              from '@ng-bootstrap/ng-bootstrap';
import { RichImageSelectorComponent }             from './richimageselector.component';

@NgModule({
  imports: [
    CommonModule, FormsModule, ReactiveFormsModule, NgbModule
  ],
  declarations: [RichImageSelectorComponent],
  exports: [RichImageSelectorComponent]
})
export class RichImageSelectorModule { }
