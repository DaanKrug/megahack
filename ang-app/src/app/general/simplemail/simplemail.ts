export class SimpleMail {
   constructor(
		       public id: number, 
		       public conditions: string, 
		       public subject: string,
		       public content: string,
		       public tosAddress: string,
		       public successAddress: string,
		       public failAddress: string,
		       public tosTotal: number,
		       public successTotal: number,
	   		   public failTotal: number,
		       public status: string,
		       public failMessages: string,
		       public ownerId: number,
   			   public _token: string,
   			   public objectClass: string,
	   		   public updated_at: string
   			   ) { 
   }
}
