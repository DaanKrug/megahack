import { CommonModule }                            from '@angular/common';
import { NgModule }                                from '@angular/core';
import { FormsModule, ReactiveFormsModule }        from '@angular/forms';
import { NgbModule }                               from '@ng-bootstrap/ng-bootstrap';
import { PageMenuItemFileRoutingModule }           from './pagemenuitemfile-routing.module';
import { PageMenuItemFileComponent }               from './pagemenuitemfile.component';
import { CustomComponentsModule }                  from '../../../../../app_component/customcomponents.module';

@NgModule({
  imports: [
    CommonModule,
    FormsModule, 
    ReactiveFormsModule,
    NgbModule,
    PageMenuItemFileRoutingModule,
    CustomComponentsModule
  ],
  declarations: [PageMenuItemFileComponent]
})
export class PageMenuItemFileModule { }
