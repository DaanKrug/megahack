import { MailerConfig } from './mailerconfig';
import { BaseCrudService } from '../../../app_base/basecrud.service';
 
export class MailerConfigService extends BaseCrudService {
	
  getUrl(){
	  return this.getBase() + '/mailerconfigs';
  }
  
  getEmptyObject(conditions) :Object{
	  var ownerId: number = parseInt('0' + this.storageService.localStorageGetItem('_ownerId_' + this.getAppId()));
	  return new MailerConfig(0,conditions,null,null,null,null,1,0,0,1,1,1,null,null,null,0,
				              ownerId,
				              this.storageService.localStorageGetItem('_token_' + this.getAppId()),null);
  }
  
  getAll(page,rows,conditions): Promise<MailerConfig[]> {
	  return new Promise<MailerConfig[]>(r => r(super.getAll(page,rows,this.getEmptyObject(conditions))));
  }
  
  load(id): Promise<MailerConfig> {
	  return new Promise<MailerConfig>(r => r(super.load(id)));
  }
  
  mergeAnotherInObject(object,anotherObject){
	  object.name = super.getChangedValue(anotherObject.name,object.name);
	  object.provider = super.getChangedValue(anotherObject.provider,object.provider);
	  object.username = super.getChangedValue(anotherObject.username,object.username);
	  object.password = super.getChangedValue(anotherObject.password,object.password);
	  object.position = super.getChangedValue(anotherObject.position,object.position);
	  object.perMonth = super.getChangedValue(anotherObject.perMonth,object.perMonth);
	  object.perDay = super.getChangedValue(anotherObject.perDay,object.perDay);
	  object.perHour = super.getChangedValue(anotherObject.perHour,object.perHour);
	  object.perMinute = super.getChangedValue(anotherObject.perMinute,object.perMinute);
	  object.perSecond = super.getChangedValue(anotherObject.perSecond,object.perSecond);
	  object.awsUsername = super.getChangedValue(anotherObject.awsUsername,object.awsUsername);
	  object.awsHost = super.getChangedValue(anotherObject.awsHost,object.awsHost);
	  object.replayTo = super.getChangedValue(anotherObject.replayTo,object.replayTo);
	  object.userId = super.getChangedValue(anotherObject.userId,object.userId);
	  object.ownerId = super.getChangedValue(anotherObject.ownerId,object.ownerId);
  	  return object;
  }
  
}