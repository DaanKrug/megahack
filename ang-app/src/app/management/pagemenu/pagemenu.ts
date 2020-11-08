export class PageMenu {
   constructor(
		       public id: number, 
		       public conditions: string, 
   			   public name: string,
   			   public position: number,
			   public active: boolean,
   			   public ownerId: number,
   			   public _token: string,
   			   public objectClass: string,
   			   public menuitems: any[]
   			   ) { 
   }
}