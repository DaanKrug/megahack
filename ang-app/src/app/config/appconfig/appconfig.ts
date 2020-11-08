export class AppConfig {
   constructor(
		       public id: number, 
		       public conditions: string, 
		       public name: string,
		       public description: string,
		       public site: string,
		       public usePricingPolicy: boolean,
		       public pricingPolicy: string,
		       public usePrivacityPolicy: boolean,
		       public privacityPolicy: string,
		       public useUsetermsPolicy: boolean,
		       public usetermsPolicy: string,
		       public useUsecontractPolicy: boolean,
		       public usecontractPolicy: string,
		       public useAuthorInfo: boolean,
		       public authorInfo: string,
   			   public active: boolean,
   			   public ownerId: number,
   			   public _token: string,
   			   public objectClass: string
   			   ) { 
   }
}