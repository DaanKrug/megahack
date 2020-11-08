export class S3Config {
   constructor(
		       public id: number, 
		       public conditions: string, 
		       public bucketName: string,
		       public bucketUrl: string,
		       public region: string,
		       public version: string,
		       public key: string,
		       public secret: string,
   			   public active: boolean,
   			   public ownerId: number,
   			   public _token: string,
   			   public objectClass: string
   			   ) { 
   }
}