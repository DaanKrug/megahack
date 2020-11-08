export class MailerConfig {
   constructor(
		       public id: number, 
		       public conditions: string, 
		       public provider: string,
		       public name: string,
		       public username: string,
   			   public password: string,
   			   public position: number,
   			   public perMonth: number,
   			   public perDay: number,
   			   public perHour: number,
   			   public perMinute: number,
   			   public perSecond: number,
   			   public awsUsername: string,
   			   public awsHost: string,
   			   public replayTo: string,
   			   public userId: number,
   			   public ownerId: number,
   			   public _token: string,
   			   public objectClass: string
   			   ) { 
   }
}