export class Image {
   constructor(
		       public id: number, 
		       public conditions: string,
		       public link: string,
   			   public name: string,
   			   public ownerId: number,
   			   public _token: string,
   			   public objectClass: string,
   			   public secureLink: any
   			   ) { 
   }
}