import { NgModule }                 from '@angular/core';
import { Routes, RouterModule }     from '@angular/router';

import { UserServiceRouter }        from './management/user/user.service.router';

const routes: Routes = [
  { path: 'mailerconfigs',
    loadChildren: () => import('./config/mailerconfig/mailerconfig.module').then(m => m.MailerConfigModule),     
    canActivate: [UserServiceRouter]            
  },
  { path: 'modules',        
    loadChildren: () => import('./config/module/module.module').then(m => m.ModuleModule),
    canActivate: [UserServiceRouter] 
  },
  { path: 'appconfigs',       
    loadChildren: () => import('./config/appconfig/appconfig.module').then(m => m.AppConfigModule),
    canActivate: [UserServiceRouter] 
  },
  { path: 's3configs', 
    loadChildren: () => import('./config/s3config/s3config.module').then(m => m.S3ConfigModule), 
    canActivate: [UserServiceRouter] 
  },
  { path: 'home',        
    loadChildren: () => import('./general/home/home.module').then(m => m.HomeModule), 
    canActivate: [UserServiceRouter] 
  },
  { path: 'blank',        
	loadChildren: () => import('./general/home/home.module').then(m => m.HomeModule), 
	canActivate: [UserServiceRouter] 
  },
  { path: 'pricingpolicy',        
	loadChildren: () => import('./general/home/home.module').then(m => m.HomeModule), 
	canActivate: [UserServiceRouter] 
  },
  { path: 'userterms',        
    loadChildren: () => import('./general/home/home.module').then(m => m.HomeModule), 
    canActivate: [UserServiceRouter] 
  },
  { path: 'privacitypolicy',        
	loadChildren: () => import('./general/home/home.module').then(m => m.HomeModule), 
	canActivate: [UserServiceRouter] 
  },
  { path: 'usecontract',        
	loadChildren: () => import('./general/home/home.module').then(m => m.HomeModule), 
	canActivate: [UserServiceRouter] 
  },
  { path: 'authorinfo',        
	loadChildren: () => import('./general/home/home.module').then(m => m.HomeModule), 
	canActivate: [UserServiceRouter] 
  },
  { path: 'applogs',  
    loadChildren: () => import('./general/applog/applog.module').then(m => m.AppLogModule),
    canActivate: [UserServiceRouter] 
  },
  { path: 'simplemails',               
    loadChildren: () => import('./general/simplemail/simplemail.module').then(m => m.SimpleMailModule),
    canActivate: [UserServiceRouter] 
  },
  { path: 'users',                          
    loadChildren: () => import('./management/user/user.module').then(m => m.UserModule),    
    canActivate: [UserServiceRouter] 
  },
  { path: 'images',                            
    loadChildren: () => import('./management/image/image.module').then(m => m.ImageModule), 
    canActivate: [UserServiceRouter] 
  },
  { path: 'files',                              
    loadChildren: () => import('./management/file/file.module').then(m => m.FileModule), 
    canActivate: [UserServiceRouter] 
  },
  { path: 'login',
    loadChildren: () => import('./general/login/login.module').then(m => m.LoginModule), 
    canActivate: [UserServiceRouter] 
  },
  { path: 'register',
	loadChildren: () => import('./general/login/login.module').then(m => m.LoginModule), 
	canActivate: [UserServiceRouter] 
  },
  { path: 'changePassword',
    loadChildren: () => import('./general/login/login.module').then(m => m.LoginModule), 
    canActivate: [UserServiceRouter] 
  },
  { path: 'pagemenus',               
	loadChildren: () => import('./management/pagemenu/pagemenu.module').then(m => m.PageMenuModule), 
	canActivate: [UserServiceRouter] 
  },
  { path: 'pagemenuitems',       
	loadChildren: () => import('./management/pagemenu/pagemenuitem/pagemenuitem.module')
	                         .then(m => m.PageMenuItemModule),
	canActivate: [UserServiceRouter] 
  },
  { path: 'pagemenuitemfiles',                  
	loadChildren: () => import('./management/pagemenu/pagemenuitem/pagemenuitemfile/pagemenuitemfile.module')
	                         .then(m => m.PageMenuItemFileModule), 
	canActivate: [UserServiceRouter] 
  },
  { path: 'clients',
	loadChildren: () => import('./management/mod_cpfl/client/client.module')
	  						 .then(m => m.ClientModule), 
	canActivate: [UserServiceRouter] 
  },
  { path: 'consumerunits',
	loadChildren: () => import('./management/mod_cpfl/consumerunit/consumerunit.module')
	                         .then(m => m.ConsumerunitModule), 
	canActivate: [UserServiceRouter] 
  },
  { path: 'billets',
	loadChildren: () => import('./management/mod_cpfl/billet/billet.module').then(m => m.BilletModule), 
	canActivate: [UserServiceRouter] 
  },
  { path: 'solicitations',
	loadChildren: () => import('./management/mod_cpfl/solicitation/solicitation.module')
	  					     .then(m => m.SolicitationModule), 
	canActivate: [UserServiceRouter] 
  },
  { path: '**',redirectTo: '/',pathMatch: 'full' }
];

@NgModule({
  imports: [RouterModule.forRoot(routes)],
  exports: [RouterModule]
})
export class AppRoutingModule { }
