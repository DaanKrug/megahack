export class PageMenuItemFile {
   constructor(
		       public id: number, 
		       public conditions: string, 
   			   public name: string,
   			   public position: number,
   			   public fileId: number,
   			   public pageMenuItemId: number,
   			   public ownerId: number,
   			   public _token: string,
   			   public objectClass: string
   			   ) { 
   }
}