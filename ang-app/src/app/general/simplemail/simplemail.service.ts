import { SimpleMail } from './simplemail';
import { BaseCrudService } from '../../../app_base/basecrud.service';
 
export class SimpleMailService extends BaseCrudService {
	
  getUrl(){
	  return this.getBase() + '/simplemails';
  }
  
  getEmptyObject(conditions) :Object{
	  var ownerId: number = parseInt('0' + this.storageService.localStorageGetItem('_ownerId_' + this.getAppId()));
	  return new SimpleMail(0,conditions,null,null,null,null,null,0,0,0,null,null,
			                ownerId,
			                this.storageService.localStorageGetItem('_token_' + this.getAppId()),null,null);
  }
 
  getAll(page,rows,conditions): Promise<SimpleMail[]> {
	  return new Promise<SimpleMail[]>(r => r(super.getAll(page,rows,this.getEmptyObject(conditions))));
  }
  
  load(id): Promise<SimpleMail> {
	  return new Promise<SimpleMail>(r => r(super.load(id)));
  }
  
  mergeAnotherInObject(object,anotherObject){
	  object.subject = super.getChangedValue(anotherObject.subject,object.subject);
	  object.content = super.getChangedValue(anotherObject.content,object.content);
	  object.tosAddress = super.getChangedValue(anotherObject.tosAddress,object.tosAddress);
	  object.successAddress = super.getChangedValue(anotherObject.successAddress,object.successAddress);
	  object.failAddress = super.getChangedValue(anotherObject.failAddress,object.failAddress);
	  object.successTotal = super.getChangedValue(anotherObject.successTotal,object.successTotal);
	  object.tosTotal = super.getChangedValue(anotherObject.tosTotal,object.tosTotal);
	  object.failTotal = super.getChangedValue(anotherObject.failTotal,object.failTotal);
	  object.status = super.getChangedValue(anotherObject.status,object.status);
	  object.failMessages = super.getChangedValue(anotherObject.failMessages,object.failMessages);
	  object.ownerId = super.getChangedValue(anotherObject.ownerId,object.ownerId);
  	  return object;
  }
  
}