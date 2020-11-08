import { PageMenuItem } from './pagemenuitem';
import { BaseCrudService } from '../../../../app_base/basecrud.service';
 
export class PageMenuItemService extends BaseCrudService {
	
  getUrl(){
	  return this.getBase() + '/pagemenuitems';
  }
  
  getUrlForCache(){
	  var pageMenuId: number = parseInt('0' + this.storageService
			                                      .localStorageGetItem('_pageMenuId_' + this.getAppId()));
	  return this.getUrl() + '/' + pageMenuId;
  }
   
  getEmptyObject(conditions) :Object{
	  var ownerId: number = parseInt('0' + this.storageService
			                                   .localStorageGetItem('_ownerId_' + this.getAppId()));
      var pageMenuId: number = parseInt('0' + this.storageService
    		                                      .localStorageGetItem('_pageMenuId_' + this.getAppId()));
	  return new PageMenuItem(0,conditions,null,null,1,false,
			                  pageMenuId,
			                  ownerId,
			                  this.storageService.localStorageGetItem('_token_' + this.getAppId()),null);
  }
  
  setAutoValues(object){
	  object.pageMenuId = parseInt('0' + this.storageService
			                                 .localStorageGetItem('_pageMenuId_' + this.getAppId()));
	  return object;
  }
 
  getAll(page,rows,conditions): Promise<PageMenuItem[]> {
	  return new Promise<PageMenuItem[]>(r => r(super.getAll(page,rows,this.getEmptyObject(conditions))));
  }
  
  load(id): Promise<PageMenuItem> {
	  return new Promise<PageMenuItem>(r => r(super.load(id)));
  }
  
  mergeAnotherInObject(object,anotherObject){
	  object.name = super.getChangedValue(anotherObject.name,object.name);
	  object.content = super.getChangedValue(anotherObject.content,object.content);
	  object.position = super.getChangedValue(anotherObject.position,object.position);
	  object.active = super.getChangedValue(anotherObject.active,object.active);
	  object.pageMenuId = super.getChangedValue(anotherObject.pageMenuId,object.pageMenuId);
	  object.ownerId = super.getChangedValue(anotherObject.ownerId,object.ownerId);
  	  return object;
  }
  
}