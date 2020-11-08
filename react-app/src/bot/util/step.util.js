
const trillion = 1000000000;

export default class StepUtil{
	
	getInputTextOption(){
		return this.appendOption([],1,null,true);
	}
	
	getYesNoOptions(){
		let options = this.appendOption([],1,'Sim',false);
		return this.appendOption(options,0,'Não',false);
	}
	
	appendOption(options,id,label,input){
		return [...options,{id: id, label: label, input: input}];
	}
	
	appendOptionGaugeGraph(options,id,label,value){
		return [...options,{id: id, label: label, value: value, graph: 'gauge'}];
	}
	
	getBotQuestion(id,label,options,flag){
		return {
			id: id, 
			fromBot: true,
			flag: flag,
			label: label, 
			options: options
		};
	}
	
	getUserAnswer(id,stepId,msgResponse,valueResponse,flag){
		return {
			id: id + trillion, 
			fromBot: false, 
			qid: stepId, 
			flag: flag,
			label: msgResponse, 
			value: valueResponse
		};
	}
	
};