import { CommonModule }                            from '@angular/common';
import { NgModule }                                from '@angular/core';
import { FormsModule, ReactiveFormsModule }        from '@angular/forms';
import { NgbModule }                               from '@ng-bootstrap/ng-bootstrap';
import { PageMenuRoutingModule }                   from './pagemenu-routing.module';
import { PageMenuComponent }                       from './pagemenu.component';
import { CustomComponentsModule }                  from '../../../app_component/customcomponents.module';

@NgModule({
  imports: [
    CommonModule,
    FormsModule, 
    ReactiveFormsModule,
    NgbModule,
    PageMenuRoutingModule,
    CustomComponentsModule
  ],
  declarations: [PageMenuComponent]
})
export class PageMenuModule { }
