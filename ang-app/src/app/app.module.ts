import { BrowserModule }                    from '@angular/platform-browser';
import { NgModule }                         from '@angular/core';
import { FormsModule, ReactiveFormsModule } from '@angular/forms';
import { HttpClientModule }                 from '@angular/common/http';
import { NgbModule }                        from '@ng-bootstrap/ng-bootstrap';
import { NgxSpinnerModule }                 from 'ngx-spinner';

import { CustomComponentsModule }           from '../app_component/customcomponents.module';

import { AppRoutingModule }                 from './app-routing.module';
import { AppComponent }                     from './app.component';

import { UserServiceRouter }                from './management/user/user.service.router';
import { DateService }                      from '../app_base/date/date.service';
import { CalendarDrawer }                   from '../app_base/calendar/calendar.drawer';
import { StringService }                    from '../app_base/string/string.service';
import { MathService }                      from '../app_base/math/math.service';
import { EventEmitterService }              from '../app_base/event/event.emitter.service';
import { StorageService }                   from '../app_base/storage/storage.service';
import { CacheDataService }                 from '../app_base/cache/cache.data.service';
import { CipherService }                    from '../app_base/cipher/cipher.service';

@NgModule({
  declarations: [
    AppComponent
  ],
  imports: [
    BrowserModule,
    AppRoutingModule,
    FormsModule,
    ReactiveFormsModule,
    NgbModule,
    NgxSpinnerModule,
    HttpClientModule,
    CustomComponentsModule
  ],
  providers: [StorageService, CacheDataService, DateService, CalendarDrawer, 
              StringService, MathService, EventEmitterService, UserServiceRouter,
              CipherService
  ],
  bootstrap: [AppComponent]
})
export class AppModule{ }
