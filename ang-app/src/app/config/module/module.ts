export class Module {
   constructor(
		       public id: number, 
		       public conditions: string, 
		       public name: string,
   			   public active: boolean,
   			   public ownerId: number,
   			   public _token: string,
   			   public objectClass: string
   			   ) { 
   }
}