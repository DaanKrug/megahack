import { NgModule }                                   from '@angular/core';
import { CommonModule }                               from '@angular/common';
import { FormsModule, ReactiveFormsModule }           from '@angular/forms';
import { NgbModule }                                  from '@ng-bootstrap/ng-bootstrap';
import { RichMenuButtonComponent }                    from './richmenubutton.component';

@NgModule({
  imports: [
    CommonModule, FormsModule, ReactiveFormsModule, NgbModule
  ],
  declarations: [RichMenuButtonComponent],
  exports: [RichMenuButtonComponent]
})
export class RichMenuButtonModule { }
