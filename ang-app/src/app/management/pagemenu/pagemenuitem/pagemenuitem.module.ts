import { CommonModule }                            from '@angular/common';
import { NgModule }                                from '@angular/core';
import { FormsModule, ReactiveFormsModule }        from '@angular/forms';
import { NgbModule }                               from '@ng-bootstrap/ng-bootstrap';
import { PageMenuItemRoutingModule }               from './pagemenuitem-routing.module';
import { PageMenuItemComponent }                   from './pagemenuitem.component';
import { CustomComponentsModule }                  from '../../../../app_component/customcomponents.module';

@NgModule({
  imports: [
    CommonModule,
    FormsModule, 
    ReactiveFormsModule,
    NgbModule,
    PageMenuItemRoutingModule,
    CustomComponentsModule
  ],
  declarations: [PageMenuItemComponent]
})
export class PageMenuItemModule { }
