import { Image } from './image';
import { BaseCrudService } from '../../../app_base/basecrud.service';
 
export class ImageService extends BaseCrudService {
	
  getUrl(){
	  return this.getBase() + '/images';
  }
  
  getEmptyObject(conditions) :Object{
	  var ownerId: number = parseInt('0' + this.storageService.localStorageGetItem('_ownerId_' + this.getAppId()));
	  return new Image(0,conditions,null,null,
			           ownerId,
			           this.storageService.localStorageGetItem('_token_' + this.getAppId()),null,null);
  }
 
  getAll(page,rows,conditions): Promise<Image[]> {
	  return new Promise<Image[]>(r => r(super.getAll(page,rows,this.getEmptyObject(conditions))));
  }
  
  load(id): Promise<Image> {
	  return new Promise<Image>(r => r(super.load(id)));
  }
  
  mergeAnotherInObject(object,anotherObject){
	  object.name = super.getChangedValue(anotherObject.name,object.name);
	  object.link = super.getChangedValue(anotherObject.link,object.link);
	  object.ownerId = super.getChangedValue(anotherObject.ownerId,object.ownerId);
  	  return object;
  }
  
}