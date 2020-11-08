import { NgModule }                               from '@angular/core';
import { CommonModule }                           from '@angular/common';
import { ContinueConfirmationComponent }          from './continueconfirmation.component';

@NgModule({
  imports: [
    CommonModule
  ],
  declarations: [ContinueConfirmationComponent],
  exports: [ContinueConfirmationComponent]
})
export class ContinueConfirmationModule { }
