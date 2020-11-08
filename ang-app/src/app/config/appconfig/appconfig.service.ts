import { AppConfig } from './appconfig';
import { BaseCrudService } from '../../../app_base/basecrud.service';
 
export class AppConfigService extends BaseCrudService {
	
  getUrl(){
	  return this.getBase() + '/appconfigs';
  }
  
  getEmptyObject(conditions) :Object{
	  var ownerId: number = parseInt('0' + this.storageService.localStorageGetItem('_ownerId_' + this.getAppId()));
	  return new AppConfig(0,conditions,null,null,null,false,null,false,null,false,null,false,null,
			               false,null,false,
			               ownerId,
			               this.storageService.localStorageGetItem('_token_' + this.getAppId()),null);
  }
  
  getAll(page,rows,conditions): Promise<AppConfig[]> {
	  return new Promise<AppConfig[]>(r => r(super.getAll(page,rows,this.getEmptyObject(conditions))));
  }
  
  load(id): Promise<AppConfig> {
	  return new Promise<AppConfig>(r => r(super.load(id)));
  }
  
  mergeAnotherInObject(object,anotherObject){
	  object.name = super.getChangedValue(anotherObject.name,object.name);
	  object.description = super.getChangedValue(anotherObject.description,object.description);
	  object.site = super.getChangedValue(anotherObject.site,object.site);
	  object.usePricingPolicy = super.getChangedValue(anotherObject.usePricingPolicy,object.usePricingPolicy);
	  object.pricingPolicy = super.getChangedValue(anotherObject.pricingPolicy,object.pricingPolicy);
	  object.usePrivacityPolicy = super.getChangedValue(anotherObject.usePrivacityPolicy,object.usePrivacityPolicy);
	  object.privacityPolicy = super.getChangedValue(anotherObject.privacityPolicy,object.privacityPolicy);
	  object.useUsetermsPolicy = super.getChangedValue(anotherObject.useUsetermsPolicy,object.useUsetermsPolicy);
	  object.usetermsPolicy = super.getChangedValue(anotherObject.usetermsPolicy,object.usetermsPolicy);
	  object.useUsecontractPolicy = super.getChangedValue(anotherObject.useUsecontractPolicy,object.useUsecontractPolicy);
	  object.usecontractPolicy = super.getChangedValue(anotherObject.usecontractPolicy,object.usecontractPolicy);
      object.useAuthorInfo = super.getChangedValue(anotherObject.useAuthorInfo,object.useAuthorInfo);
	  object.authorInfo = super.getChangedValue(anotherObject.authorInfo,object.authorInfo);
	  object.active = super.getChangedValue(anotherObject.active,object.active);
	  object.ownerId = super.getChangedValue(anotherObject.ownerId,object.ownerId);
  	  return object;
  }
  
}