import { PageMenu } from './pagemenu';
import { BaseCrudService } from '../../../app_base/basecrud.service';
 
export class PageMenuService extends BaseCrudService {
	
  getUrl(){
	  return this.getBase() + '/pagemenus';
  }
   
  getEmptyObject(conditions) :Object{
	  var ownerId: number = parseInt('0' + this.storageService.localStorageGetItem('_ownerId_' + this.getAppId()));
	  return new PageMenu(0,conditions,null,1,false,
			              ownerId,
			              this.storageService.localStorageGetItem('_token_' + this.getAppId()),null,null);
  }
  
  getAll(page,rows,conditions): Promise<PageMenu[]> {
	  return new Promise<PageMenu[]>(r => r(super.getAll(page,rows,this.getEmptyObject(conditions))));
  }
  
  load(id): Promise<PageMenu> {
	  return new Promise<PageMenu>(r => r(super.load(id)));
  }
  
  mergeAnotherInObject(object,anotherObject){
	  object.name = super.getChangedValue(anotherObject.name,object.name);
	  object.position = super.getChangedValue(anotherObject.position,object.position);
	  object.active = super.getChangedValue(anotherObject.active,object.active);
	  object.ownerId = super.getChangedValue(anotherObject.ownerId,object.ownerId);
  	  return object;
  }	  
  
}