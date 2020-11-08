import { NgModule }                                   from '@angular/core';
import { CommonModule }                               from '@angular/common';
import { FormsModule, ReactiveFormsModule }           from '@angular/forms';
import { NgbModule }                                  from '@ng-bootstrap/ng-bootstrap';
import { RichInputTextComponent }                     from './richinputtext.component';

@NgModule({
  imports: [
    CommonModule, FormsModule, ReactiveFormsModule, NgbModule
  ],
  declarations: [RichInputTextComponent],
  exports: [RichInputTextComponent]
})
export class RichInputTextModule { }
