import { NgModule }                           from '@angular/core';
import { TableNavigatorModule }               from './tablenavigator/tablenavigator.module';
import { EditDeleteActionModule }             from './editdeleteaction/editdeleteaction.module';
import { FormActionModule }                   from './formaction/formaction.module';
import { FormToolbarModule }                  from './formtoolbar/formtoolbar.module';
import { ContinueConfirmationModule }         from './continueconfirmation/continueconfirmation.module';
import { DeleteConfirmationModule }           from './deleteconfirmation/deleteconfirmation.module';
import { CaptchaModule }                      from './captcha/captcha.module';
import { RichFilterSelectorModule }           from './rich/richfilterselector/richfilterselector.module';
import { RichImageSelectorModule }            from './rich/richimageselector/richimageselector.module';
import { RichEditorModule }                   from './rich/richeditor/richeditor.module';
import { RichCheckboxModule }                 from './rich/richcheckbox/richcheckbox.module';
import { RichDatePickerModule }               from './rich/richdatepicker/richdatepicker.module';
import { RichInputTextModule }                from './rich/richinputtext/richinputtext.module';
import { RichInputSelectModule }              from './rich/richinputselect/richinputselect.module';
import { RichTabBarModule }                   from './rich/richtabbar/richtabbar.module';
import { RichDropDownButtonModule }           from './rich/richdropdownbutton/richdropdownbutton.module';
import { RichMenuButtonModule }               from './rich/richmenubutton/richmenubutton.module';
import { RichCheckboxMultiModule }            from './rich/richcheckboxmulti/richcheckboxmulti.module';


@NgModule({
  imports: [
    TableNavigatorModule, EditDeleteActionModule, FormActionModule, FormToolbarModule, 
    ContinueConfirmationModule, DeleteConfirmationModule,
    CaptchaModule,
    RichFilterSelectorModule, RichImageSelectorModule, 
    RichEditorModule, RichCheckboxModule, RichDatePickerModule,
    RichInputTextModule, RichInputSelectModule, RichTabBarModule, 
    RichDropDownButtonModule, RichMenuButtonModule, RichCheckboxMultiModule
  ],
  declarations: [],
  exports: [
    TableNavigatorModule, EditDeleteActionModule, FormActionModule, FormToolbarModule, 
    ContinueConfirmationModule, DeleteConfirmationModule,
    CaptchaModule,
    RichFilterSelectorModule, RichImageSelectorModule, 
    RichEditorModule, RichCheckboxModule, RichDatePickerModule,
    RichInputTextModule, RichInputSelectModule, RichTabBarModule, 
    RichDropDownButtonModule, RichMenuButtonModule, RichCheckboxMultiModule
  ]
})
export class CustomComponentsModule { }
