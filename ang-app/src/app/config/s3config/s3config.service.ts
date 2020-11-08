import { S3Config } from './s3config';
import { BaseCrudService } from '../../../app_base/basecrud.service';
 
export class S3ConfigService extends BaseCrudService {
	
  getUrl(){
	  return this.getBase() + '/s3configs';
  }
  
  getEmptyObject(conditions) :Object{
	  var ownerId: number = parseInt('0' + this.storageService.localStorageGetItem('_ownerId_' + this.getAppId()));
	  return new S3Config(0,conditions,null,null,null,null,null,null,false,
			              ownerId,
			              this.storageService.localStorageGetItem('_token_' + this.getAppId()),null);
  }
  
  getAll(page,rows,conditions): Promise<S3Config[]> {
	  return new Promise<S3Config[]>(r => r(super.getAll(page,rows,this.getEmptyObject(conditions))));
  }
  
  load(id): Promise<S3Config> {
	  return new Promise<S3Config>(r => r(super.load(id)));
  }
  
  mergeAnotherInObject(object,anotherObject){
	  object.bucketName = super.getChangedValue(anotherObject.bucketName,object.bucketName);
	  object.bucketUrl = super.getChangedValue(anotherObject.bucketUrl,object.bucketUrl);
	  object.region = super.getChangedValue(anotherObject.region,object.region);
	  object.version = super.getChangedValue(anotherObject.version,object.version);
	  object.key = super.getChangedValue(anotherObject.key,object.key);
	  object.secret = super.getChangedValue(anotherObject.secret,object.secret);
	  object.active = super.getChangedValue(anotherObject.active,object.active);
	  object.ownerId = super.getChangedValue(anotherObject.ownerId,object.ownerId);
  	  return object;
  }
  
}