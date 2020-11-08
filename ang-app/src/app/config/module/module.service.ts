import { Module } from './module';
import { BaseCrudService } from '../../../app_base/basecrud.service';
 
export class ModuleService extends BaseCrudService {
	
  getUrl(){
	  return this.getBase() + '/modules';
  }
  
  getEmptyObject(conditions) :Object{
	  var ownerId: number = parseInt('0' + this.storageService.localStorageGetItem('_ownerId_' + this.getAppId()));
	  return new Module(0,conditions,null,false,
			            ownerId,
			            this.storageService.localStorageGetItem('_token_' + this.getAppId()),null);
  }
  
  getAll(page,rows,conditions): Promise<Module[]> {
	  return new Promise<Module[]>(r => r(super.getAll(page,rows,this.getEmptyObject(conditions))));
  }
  
  load(id): Promise<Module> {
	  return new Promise<Module>(r => r(super.load(id)));
  }
  
  mergeAnotherInObject(object,anotherObject){
	  object.name = super.getChangedValue(anotherObject.name,object.name);
	  object.active = super.getChangedValue(anotherObject.active,object.active);
	  object.ownerId = super.getChangedValue(anotherObject.ownerId,object.ownerId);
  	  return object;
  }
  
}