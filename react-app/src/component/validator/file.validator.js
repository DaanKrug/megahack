const fileTypes = [
	'image/png',
	'image/jpeg',
	'image/jpeg',
	'image/gif',
	'image/bmp',
    'application/pdf',
    'application/msword',
    'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
    'application/vnd.ms-excel',
    'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
    'application/vnd.ms-powerpoint',
    'application/vnd.openxmlformats-officedocument.presentationml.presentation'
];
const FileValidator = {
	validateFile(fileData,size){
		if(undefined === size || null === size || size < 0){
			size = 1;
		}
		if(size > 10){
			size = 10;
		}
		if(undefined === fileData || null === fileData){
			return '';
		}
		if(fileData.size > ((size * 1048576) + 50)){
			return 'Arquivo maior que ' + size + ' MB!';
		}
		if(!(fileTypes.includes(fileData.type))){
			return 'Tipo do Arquivo não aceito.';
		}
		return null;
	},
	getMimeByHexHeader(mimetype,hexHeader){
		if(['89504e47'].includes(hexHeader)){
			return 'image/png';
		}
		if(['ffd8ffe0','ffd8ffe1','ffd8ffe2','ffd8ffe3','ffd8ffe8'].includes(hexHeader)){
			return 'image/jpeg';
		}
		if(['47494638'].includes(hexHeader)){
			return 'image/gif';
		}
		if(hexHeader.indexOf('424d') === 0){
			return 'image/bmp';
		}
		if(['25504446'].includes(hexHeader)){
			return 'application/pdf';
		}
		if(['d0cf11e0'].includes(hexHeader) && mimetype === fileTypes[6]){
			return mimetype;
		}
		if(['d0cf11e0'].includes(hexHeader) && mimetype === fileTypes[8]){
			return mimetype;
		}
		if(['d0cf11e0'].includes(hexHeader) && mimetype === fileTypes[10]){
			return mimetype;
		}
		if(['504b0304','504b0506','504b0708'].includes(hexHeader) && mimetype === fileTypes[7]){
			return mimetype;
		}
		if(['504b0304','504b0506','504b0708'].includes(hexHeader) && mimetype === fileTypes[9]){
			return mimetype;
		}
		if(['504b0304','504b0506','504b0708'].includes(hexHeader) && mimetype === fileTypes[11]){
			return mimetype;
		}
		return null;
	},
	validateFileContentBase64(mimetype,arrayBuffer){
        let arrayData = (new Uint8Array(arrayBuffer)).subarray(0,4);
        let size = arrayData.length;
	    let hexHeader = '';
	    for(let i = 0; i < size; i++) {
	    	hexHeader += arrayData[i].toString(16);
	    }
	    return (mimetype === FileValidator.getMimeByHexHeader(mimetype,hexHeader.toLowerCase()));
    }
};
export default FileValidator;