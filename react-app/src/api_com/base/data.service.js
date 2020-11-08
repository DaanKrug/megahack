const DataService = {
	emptyObject(object){
		return (undefined === object || null === object);
	},
	emptyString(object){
		return DataService.emptyObject(object) || object.trim() === '';
	},
	emptyArray(objects){
		return DataService.emptyObject(objects) || !(objects.length > 0);
	},
	rowsFromObjects(objects){
		if(DataService.emptyArray(objects) || DataService.emptyObject(objects[0])){
			return 0;
		}
		return objects[0].totalRows;
	},
	clearRowZeroObjects(objects){
		if(DataService.rowsFromObjects(objects) === 0){
			return [];
		}
		return objects;
	},
	clearRowZeroObjectsValidated(dataObjects){
		const objects = DataService.clearRowZeroObjects(dataObjects);
		if(!(objects.length > 0)){
			return [];
		}
		if(!DataService.emptyObject(objects[0]) 
				&& !DataService.emptyString(objects[0].objectClass)){
			console.log('error: dataObjects: ',dataObjects);
			return [];
		}
		return objects;
	},
};
export default DataService;