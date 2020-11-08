import { PageMenuItemFile } from './pagemenuitemfile';
import { BaseCrudService } from '../../../../../app_base/basecrud.service';
 
export class PageMenuItemFileService extends BaseCrudService {
	
  getUrl(){
	  return this.getBase() + '/pagemenuitemfiles';
  }
  
  getUrlForCache(){
	  var pageMenuItemId: number = parseInt('0' + this.storageService.localStorageGetItem('_pageMenuItemId_' + this.getAppId()));
	  return this.getUrl() + '/' + pageMenuItemId;
  }
   
  getEmptyObject(conditions) :Object{
	  var ownerId: number = parseInt('0' + this.storageService.localStorageGetItem('_ownerId_' + this.getAppId()));
      var pageMenuItemId: number = parseInt('0' + this.storageService.localStorageGetItem('_pageMenuItemId_' + this.getAppId()));
	  return new PageMenuItemFile(0,conditions,null,1,0,
				                  pageMenuItemId,
				                  ownerId,
				                  this.storageService.localStorageGetItem('_token_' + this.getAppId()),null);
  }
  
  setAutoValues(object){
	  object.pageMenuItemId = parseInt('0' + this.storageService.localStorageGetItem('_pageMenuItemId_' + this.getAppId()));
	  return object;
  }
 
  getAll(page,rows,conditions): Promise<PageMenuItemFile[]> {
	  return new Promise<PageMenuItemFile[]>(r => r(super.getAll(page,rows,this.getEmptyObject(conditions))));
  }
  
  load(id): Promise<PageMenuItemFile> {
	  return new Promise<PageMenuItemFile>(r => r(super.load(id)));
  }
  
  mergeAnotherInObject(object,anotherObject){
	  object.name = super.getChangedValue(anotherObject.name,object.name);
	  object.position = super.getChangedValue(anotherObject.position,object.position);
	  object.fileId = super.getChangedValue(anotherObject.fileId,object.fileId);
	  object.pageMenuItemId = super.getChangedValue(anotherObject.pageMenuItemId,object.pageMenuItemId);
	  object.ownerId = super.getChangedValue(anotherObject.ownerId,object.ownerId);
  	  return object;
  }
  
}