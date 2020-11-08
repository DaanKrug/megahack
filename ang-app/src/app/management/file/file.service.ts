import { File } from './file';
import { BaseCrudService } from '../../../app_base/basecrud.service';
 
export class FileService extends BaseCrudService {
	
  getUrl(){
	  return this.getBase() + '/files';
  }
  
  getEmptyObject(conditions) :Object{
	  var ownerId: number = parseInt('0' + this.storageService.localStorageGetItem('_ownerId_' + this.getAppId()));
	  return new File(0,conditions,null,null,
		              ownerId,
		              this.storageService.localStorageGetItem('_token_' + this.getAppId()),null);
  }
 
  getAll(page,rows,conditions): Promise<File[]> {
	  return new Promise<File[]>(r => r(super.getAll(page,rows,this.getEmptyObject(conditions))));
  }
  
  load(id): Promise<File> {
	  return new Promise<File>(r => r(super.load(id)));
  }
  
  s3upload(base64,filename,name): Promise<any>{
	  this.setInActivity();
	  var object: any = this.getEmptyObject(null);
	  object.file = base64;
	  object.filename = filename;
	  object.name = name;
	  return this.http.post(this.getUrl() + '/fileS3Upload' + this.getAntiCache(),object,this.options)
				 .toPromise()
			     .then((response: any) => {return response;})
			     .catch(this.handleError);
  }
  
  mergeAnotherInObject(object,anotherObject){
	  object.name = super.getChangedValue(anotherObject.name,object.name);
	  object.link = super.getChangedValue(anotherObject.link,object.link);
	  object.ownerId = super.getChangedValue(anotherObject.ownerId,object.ownerId);
  	  return object;
  }
  
}