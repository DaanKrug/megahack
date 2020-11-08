export class AppLog {
   constructor(
		       public id: number, 
		       public conditions: string, 
		       public userId: number,
   			   public userName: string,
   			   public userEmail: string,
   			   public operation: string,
   			   public objTitle: string,
   			   public ffrom: string,
   			   public tto: string,
   			   public ownerId: number,
   			   public _token: string,
   			   public objectClass: string
   			   ) { 
   }
}