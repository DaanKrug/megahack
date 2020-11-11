import { Meta } from '@angular/platform-browser';
import { OnInit, OnDestroy } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Router, ActivatedRoute } from '@angular/router';
import { NgbModal, NgbDateStruct, NgbDatepickerConfig } from '@ng-bootstrap/ng-bootstrap';
import { NgxSpinnerService } from 'ngx-spinner';
import { BaseCrudComponent } from '../../app_base/basecrud.component';

import { UserServiceRouter } from '../management/user/user.service.router';

import { StorageService } from '../../app_base/storage/storage.service';
import { StringService } from '../../app_base/string/string.service';
import { CacheDataService } from '../../app_base/cache/cache.data.service';
import { DateService } from '../../app_base/date/date.service';
import { MathService } from '../../app_base/math/math.service';
import { CalendarDrawer } from '../../app_base/calendar/calendar.drawer';
import { EventEmitterService } from '../../app_base/event/event.emitter.service';
import { CipherService } from '../../app_base/cipher/cipher.service';

import { MailerConfigService } from '../config/mailerconfig/mailerconfig.service';
import { ModuleService } from '../config/module/module.service';
import { AppConfigService } from '../config/appconfig/appconfig.service';
import { S3ConfigService } from '../config/s3config/s3config.service';
import { AppLogService } from '../general/applog/applog.service';
import { SimpleMailService } from '../general/simplemail/simplemail.service';

import { UserService } from '../management/user/user.service';
import { AdditionaluserinfoService } from '../management/user/additionaluserinfo/additionaluserinfo.service';
import { ImageService } from '../management/image/image.service';
import { FileService } from '../management/file/file.service';
import { PageMenuService } from '../management/pagemenu/pagemenu.service';
import { PageMenuItemService } from '../management/pagemenu/pagemenuitem/pagemenuitem.service';
import { PageMenuItemFileService } 
       from '../management/pagemenu/pagemenuitem/pagemenuitemfile/pagemenuitemfile.service';
       
import { ClientService } from '../management/mod_cpfl/client/client.service';
import { SolicitationService } from '../management/mod_cpfl/solicitation/solicitation.service';
import { ConsumerunitService } from '../management/mod_cpfl/consumerunit/consumerunit.service';


export class BaseCrudFilterComponent extends BaseCrudComponent implements OnInit, OnDestroy{

	mailerConfigService: MailerConfigService;
	moduleService: ModuleService;
	appConfigService: AppConfigService;
	s3ConfigService: S3ConfigService;
    appLogService: AppLogService;
    simpleMailService: SimpleMailService;
    userService: UserService;
    additionaluserinfoService: AdditionaluserinfoService;
    imageService: ImageService;
    fileService: FileService;
	pageMenuService: PageMenuService;
	pageMenuItemService: PageMenuItemService;
	pageMenuItemFileService: PageMenuItemFileService;
	clientService: ClientService;
	solicitationService: SolicitationService;
    consumerunitService: ConsumerunitService;

    modulesNames: string[];
    activatedServices: any[];
    signedVariables: any[];

    servicesInitialized: boolean;
    isLocalhost: boolean;

    constructor(protected modallService: NgbModal,
			    protected stringService: StringService,
			    protected spinnerr: NgxSpinnerService,
		        protected dateService: DateService, 
		        protected mathService: MathService,
		        protected dateConfig: NgbDatepickerConfig,
		        protected eventEmitterService: EventEmitterService,
		        protected http: HttpClient,
		        private storageServicee: StorageService,
		        protected cacheDataService: CacheDataService,
		        protected calendarDrawer: CalendarDrawer,
		        protected router: Router, 
		        protected route: ActivatedRoute,
		        protected userServiceRouter: UserServiceRouter,
		        protected meta: Meta,
		        protected cipherService: CipherService
    			) {
		super();
		this.servicesInitialized = false;
		this.modalService = modallService;
		this.spinner = spinnerr;
		this.stringServicee = stringService;
		this.dateServicee = dateService;
		this.storageService = this.storageServicee;
		this.setMinMaxDateConfigDefault();
		this.calendarDrawer.setDateService(this.dateService);
		this.messageEmitterService = this.eventEmitterService;
		this.modulesNames = [];
		this.verifyLocalhost();
	}
    
    helpMessage(msg){
    	this.openMessage('Informação',msg);
    }
    
    verifyLocalhost(){
    	var url = window.location.href;
    	var idx1 = url.indexOf('http://localhost');
    	var idx2 = url.indexOf('https://localhost');
    	this.isLocalhost = (idx1 == 0 || idx2 == 0);
    }
    
    loadModules(){
    	this.modulesNames = [];
    	if(this.emptyObject(this.storageService)){
    		setTimeout(() => {this.loadModules();},50);
    		return;
    	}
    	var names = this.storageService.localStorageGetItem('_modulesNames_' + this.getAppId());
    	if(undefined == names || null == names || names == 'wait_loading_modules'){
    		setTimeout(() => {this.loadModules();},50);
    		return;
    	}
    	this.modulesNames = names.split(',');
    }
    
	// Do not override!
	getAppId(){
		return this.meta.getTag('name=app-id').content;
	}
	
	// Do not override!
	getAppPrefix(){
		return this.meta.getTag('name=app-prefix').content;
	}
	
	// Do not override!
    downloadFile(link){
  	    this.eventEmitterService.get('downloadFile').emit({link: link});
    }
     
	// Do not override!
    setMinMaxDateConfigDefault(){
    	this.dateConfig.minDate = {year: (new Date().getFullYear() - 1), month: 1, day: 1};
		this.dateConfig.maxDate = {year: (new Date().getFullYear() + 1), month: 12, day: 31};
		this.dateConfig.markDisabled = (date: NgbDateStruct) => {
            return false;
        };  
    }
    
    // Do not override!
    setMinMaxDateConfig(dsStr,dfStr){
    	const separator = ((''+dsStr).indexOf('/') != -1) ? '/' : '-';
    	const ds = this.dateService.valuesDateToInt(dsStr,separator);
    	const df = this.dateService.valuesDateToInt(dfStr,separator);
    	this.dateConfig.minDate = {year: ds.year, month: ds.month, day: ds.day};
		this.dateConfig.maxDate = {year: df.year, month: df.month, day: df.day};
    }
    
    // Do not override!
    setMinMaxDateConfigByTime(ts,te){
    	var ds = new Date();
		ds.setTime(ts);
		var de = new Date();
		de.setTime(te); 
    	this.dateConfig.minDate = {year: ds.getFullYear(), month: ds.getMonth() + 1, day: ds.getDate()};
		this.dateConfig.maxDate = {year: de.getFullYear(), month: de.getMonth() + 1, day: de.getDate()};
    }
	
	ngOnInit() {
		this.ngOnInitWaiter();
	}
	
	ngOnInitWaiter(){
		if(!this.servicesInitialized){
			setTimeout(() => {this.ngOnInitWaiter();},100);
			return;
		}
		super.ngOnInit();
	}
	
	ngOnDestroy(){
        if(null!=this.activatedServices){
        	var size = this.activatedServices.length;
        	for(var i = 0; i < size; i++){
        		this.activatedServices[i].ngOnDestroy();
        	}
        }
        if(null!=this.signedVariables){
        	var size = this.signedVariables.length;
    		for(var i = 0; i < size; i++){
    			this.signedVariables[i] = null;
    		}
        }
        this.activatedServices = null;
        this.signedVariables = null;
	    this.modulesNames = null;
	    this.servicesInitialized = null;
	    this.isLocalhost = false;
		super.ngOnDestroy();
	}
	
	setInitializationServices(toAactivateServices: string[]){
		if(toAactivateServices.includes('mailer')){
			this.mailerConfigService = new MailerConfigService(this.http);
			this.injectServiceDependencies(this.mailerConfigService);
		}
		if(toAactivateServices.includes('module')){
			this.moduleService = new ModuleService(this.http);
			this.injectServiceDependencies(this.moduleService);
		}
        if(toAactivateServices.includes('appconfig')){
        	this.appConfigService = new AppConfigService(this.http);
      	    this.injectServiceDependencies(this.appConfigService);
		}
		if(toAactivateServices.includes('s3config')){
        	this.s3ConfigService = new S3ConfigService(this.http);
      	    this.injectServiceDependencies(this.s3ConfigService);
		}
		if(toAactivateServices.includes('applog')){
        	this.appLogService = new AppLogService(this.http);
      	    this.injectServiceDependencies(this.appLogService);
		}
        if(toAactivateServices.includes('simplemail')){
        	this.simpleMailService = new SimpleMailService(this.http);
      	    this.injectServiceDependencies(this.simpleMailService);
		}
        if(toAactivateServices.includes('user')){
        	this.userService = new UserService(this.http);
      	    this.injectServiceDependencies(this.userService);
		}
        if(toAactivateServices.includes('additionaluserinfo')){
        	this.additionaluserinfoService = new AdditionaluserinfoService(this.http);
      	    this.injectServiceDependencies(this.additionaluserinfoService);
		}
        if(toAactivateServices.includes('image')){
        	this.imageService = new ImageService(this.http);
      	    this.injectServiceDependencies(this.imageService);
        }
        if(toAactivateServices.includes('file')){
        	this.fileService = new FileService(this.http);
      	    this.injectServiceDependencies(this.fileService);
        }
        if(toAactivateServices.includes('pagemenu')){
			this.pageMenuService = new PageMenuService(this.http);
			this.injectServiceDependencies(this.pageMenuService);
		}
		if(toAactivateServices.includes('pagemenuitem')){
			this.pageMenuItemService = new PageMenuItemService(this.http);
			this.injectServiceDependencies(this.pageMenuItemService);
		}
		if(toAactivateServices.includes('pagemenuitemfile')){
			this.pageMenuItemFileService = new PageMenuItemFileService(this.http);
			this.injectServiceDependencies(this.pageMenuItemFileService);
		}
		if(toAactivateServices.includes('client')){
			this.clientService = new ClientService(this.http);
			this.injectServiceDependencies(this.clientService);
		}
		if(toAactivateServices.includes('solicitation')){
			this.solicitationService = new SolicitationService(this.http);
			this.injectServiceDependencies(this.solicitationService);
		}
		if(toAactivateServices.includes('consumerunit')){
			this.consumerunitService = new ConsumerunitService(this.http);
			this.injectServiceDependencies(this.consumerunitService);
		}
		this.servicesInitialized = true;
	}
	
	private injectServiceDependencies(objService){
		objService.setStorageService(this.storageService);
		objService.setCacheDataService(this.cacheDataService);
		objService.setMeta(this.meta);
		this.addInitializedService(objService);
	}
	
	private addInitializedService(objService){
		if(this.emptyArray(this.activatedServices)){
			this.activatedServices = [];
		}
		this.activatedServices = [...this.activatedServices,objService];
		this.addSignedVariables([objService]);
	}
	
	private addSignedVariables(arrVariables){
		if(this.emptyArray(this.signedVariables)){
			this.signedVariables = [];
		}
		var size = arrVariables.length;
		for(var i = 0; i < size; i++){
			this.signedVariables = [...this.signedVariables,arrVariables[i]];
		}
	}
	
    getNameToFilterCondition(nameAttr){
    	nameAttr = this.emptyObject(nameAttr) ? 'name' : nameAttr;
    	if(!this.emptyString(this.nameToFilter)){
    	    return ' xoo ' + nameAttr + ' xstrike quaspa%' + this.nameToFilter.trim() + '%quaspa ';
	    }
	    return '';
    }
	        
	infoContainGeneric(oa,ea,titles,title,label,byFieldName){
		var msg = '- S&atilde;o carregad' + oa + 's no m&aacute;ximo ' + oa + 's primeir' + oa;
		msg += 's 5 ' + titles + ' para a sele&ccedil;&atilde;o.';
		msg += '<br/>';
		msg += '- Utilize o campo <strong>' + title;
		msg += ' Cont&eacute;m</strong> para fazer com que ess' + ea + 's 5 ';
		msg += label + 's para a sele&ccedil;&atilde;o,';
		msg += ' sejam pr&eacute; filtrad' + oa + 's ' + byFieldName + '. Assim qualquer ';
		msg += label + ' existente poder&aacute; ser selecionad' + oa + '.';
		msg = msg.replace('modelo impress&atilde;os','modelos impress&atilde;o'),
		this.openMessage(title + ' Contem',msg);
	}
	      
	patchValue(target,value){
		if(target == 'name'){
			this.dataForm.patchValue({name: value});
		}
		if(target == 'label'){
			this.dataForm.patchValue({label: value});
		}
		if(target == 'username'){
			this.dataForm.patchValue({username: ('' + value).toLowerCase()});
		}
		if(target == 'replayTo'){
			this.dataForm.patchValue({replayTo: value});
		}
		if(target == 'subject'){
			this.dataForm.patchValue({subject: value});
		}
		if(target == 'content'){
			this.dataForm.patchValue({content: value});
		}
		if(target == 'email'){
			this.dataForm.patchValue({email: ('' + value).toLowerCase()});
		}
		if(target == 'orderId'){
			this.dataForm.patchValue({orderId: value});
		}
		if(target == 'title'){
			this.dataForm.patchValue({title: value});
		}
		if(target == 'position'){
			this.dataForm.patchValue({position: value});
		}
		if(target == 'size'){
			this.dataForm.patchValue({size: value});
		}
		if(target == 'template'){
			this.dataForm.patchValue({template: value});
		}
		if(target == 'to'){
			this.dataForm.patchValue({to: value});
		}
		if(target == 'imageHeight'){
			this.dataForm.patchValue({imageHeight: value});
		}
		if(target == 'backgroundWidth'){
			this.dataForm.patchValue({backgroundWidth: value});
		}
		if(target == 'backgroundHeight'){
			this.dataForm.patchValue({backgroundHeight: value});
		}
		if(target == 'perMonth'){
			this.dataForm.patchValue({perMonth: value});
		}
		if(target == 'perDay'){
			this.dataForm.patchValue({perDay: value});
		}
		if(target == 'perHour'){
			this.dataForm.patchValue({perHour: value});
		}
		if(target == 'perMinute'){
			this.dataForm.patchValue({perMinute: value});
		}
		if(target == 'perSecond'){
			this.dataForm.patchValue({perSecond: value});
		}
		if(target == 'site'){
			this.dataForm.patchValue({site: value});
		}
		if(target == 'start'){
			this.dataForm.patchValue({start: value});
		}
		if(target == 'finish'){
			this.dataForm.patchValue({finish: value});
		}
		if(target == 'description'){
			this.dataForm.patchValue({description: value});
		}
		if(target == 'bucketName'){
			this.dataForm.patchValue({bucketName: value});
		}
		if(target == 'bucketUrl'){
			this.dataForm.patchValue({bucketUrl: value});
		}
		if(target == 'region'){
			this.dataForm.patchValue({region: value});
		}
		if(target == 'version'){
			this.dataForm.patchValue({version: value});
		}
		if(target == 'key'){
			this.dataForm.patchValue({key: value});
		}
		if(target == 'secret'){
			this.dataForm.patchValue({secret: value});
		}
	}

}