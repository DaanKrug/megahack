export class PageMenuItem {
   constructor(
		       public id: number, 
		       public conditions: string, 
   			   public name: string,
   			   public content: string,
   			   public position: number,
			   public active: boolean,
   			   public pageMenuId: number,
   			   public ownerId: number,
   			   public _token: string,
   			   public objectClass: string
   			   ) { 
   }
}