import { NgModule }                                   from '@angular/core';
import { CommonModule }                               from '@angular/common';
import { FormsModule, ReactiveFormsModule }           from '@angular/forms';
import { NgbModule }                                  from '@ng-bootstrap/ng-bootstrap';
import { RichEditorComponent }                        from './richeditor.component';

@NgModule({
  imports: [
    CommonModule, FormsModule, ReactiveFormsModule, NgbModule
  ],
  declarations: [RichEditorComponent],
  exports: [RichEditorComponent]
})
export class RichEditorModule { }
