import BaseBrowserStorageService from '../api_com/base/basebrowserstorage.service.js';
import BotIAUtil from './util/bot.ia.util.js';
import StepUtil from './util/step.util.js';

const botiaUtil = new BotIAUtil();
const stepUtil = new StepUtil();

export default class BotIA2 {
	
	cpf: string;
    needResume: boolean;
    waiting: boolean;
    blockWalking: boolean;
    backendResponse: string;
    serviceCode: number;
    selectedUCNumber: string;

	constructor(){
		this.reset();
	}
	
	reset(){
		this.cpf = BaseBrowserStorageService.getLocalItem('cpf');
		console.log('CPF armazenado: ', this.cpf);
		this.backendResponse = null;
		this.needResume = false;
		this.waiting = false;
		this.blockWalking = false;
		this.serviceCode = 0;
		this.selectedUCNumber = null;
	}
	
    getInitialSteps(){
		return [stepUtil.getBotQuestion(0,'Bem vindo ao Light App!',[],null)];
	}
    
    getNextSteps(stepId,msgResponse,valueResponse){
    	let oldNeedResume = this.needResume ? true : false;
    	this.needResume = false;
    	if(stepId === 1 && null !== this.cpf){
    		this.needResume = true;
    		return [];
    	}
    	if(stepId === 1){
    		return this.getPutCPFSteps(stepId);
    	}
    	if(stepId === 2 && !oldNeedResume){
    		this.cpf = msgResponse;
    		BaseBrowserStorageService.setLocalItem('cpf',this.cpf);
    	}
    	if(stepId === 2){
    		return this.getOperationSteps(stepId,msgResponse,valueResponse);
    	}
    	if(stepId === 3 && valueResponse === 1){
    		this.needResume = true;
    		return this.getLightFaultSteps();
    	}
    	if(stepId === 3 && valueResponse === 2){
    		this.needResume = true;
    		return this.getLightReBindingSteps();
    	}
    	if(stepId === 4 && this.blockWalking && this.serviceCode === 1){
    		this.needResume = true;
    		this.selectedUCNumber = valueResponse;
    		return this.getLightFaultSteps();
    	}
        if(stepId === 4 && this.blockWalking && this.serviceCode === 2){
        	this.needResume = true;
        	this.selectedUCNumber = valueResponse;
    		return this.getLightReBindingSteps();
    	}
    	if(stepId === 4){
    		this.needResume = true;
    		this.selectedUCNumber = null;
    		return this.getBackendResponseSteps(stepId,msgResponse,valueResponse);
    	}
    	return this.goToBeginStep(stepId);
    }
    
    getPutCPFSteps(stepId){
		const label = 'Informe o CPF:';
		const msgs = [stepUtil.getBotQuestion(stepId,label,stepUtil.getInputTextOption(),null)];
		return msgs;
	}
    
    getOperationSteps(stepId,msgResponse,valueResponse){
		let options = stepUtil.appendOption([],1,'Relatar Falta de Luz',false);
		options = stepUtil.appendOption(options,2,'Solicitar Re-ligamento',false);
		let steps = [];
    	if(null != msgResponse && null != valueResponse){
    		steps = [...steps,stepUtil.getUserAnswer(stepId,stepId - 1,msgResponse,valueResponse,null)];
    	}
		return [...steps,stepUtil.getBotQuestion(stepId,'Em que posso ajudar?',options,null)];
	}
    
    getLightFaultSteps(){
    	this.serviceCode = 1;
    	this.waiting = true;
    	if(null != this.selectedUCNumber){
    		botiaUtil.registerFaultByConsumerUnitId(this.selectedUCNumber).then(response => {
    			console.log('response: ', response);
        		this.backendResponse = response;
        		this.waiting = false;
        		this.blockWalking = false;
        	});
        	return [];
    	}
    	botiaUtil.registerFault(this.cpf).then(response => {
    		this.backendResponse = response;
    		this.waiting = false;
    		this.blockWalking = false;
    	});
    	return [];
	}
    
    getLightReBindingSteps(){
    	this.serviceCode = 2;
    	this.waiting = true;
    	/*botiaUtil.registerFault(this.cpf).then(response => {
    		this.backendResponse = response;
    		this.waiting = false;
    		this.blockWalking = false;
    	});*/
    	return [];
	}
    
    getBackendResponseSteps(stepId,msgResponse,valueResponse){
    	var steps = [];
    	if(null != msgResponse && null != valueResponse){
    		steps = [...steps,stepUtil.getUserAnswer(stepId,stepId - 1,msgResponse,valueResponse,null)];
    	}
    	if(null != this.backendResponse && this.backendResponse.length > 1){
    		this.blockWalking = true;
    		this.needResume = false;
    		let size = this.backendResponse.length;
    		let options = [];
    		for(let i = 0; i < size; i++){
    			let label = this.getConsumerUnitLabel(this.backendResponse[i]);
    			options = stepUtil.appendOption(options,this.backendResponse[i].id,label,null);
    		}
    		let msg = 'Olá ' + this.backendResponse[0].a1_name + '! Qual unidade de ';
    		msg += 'consumo está com falta de energia?';
    		return [...steps,stepUtil.getBotQuestion(stepId,msg,options,null)];
    	}
    	return [...steps,stepUtil.getBotQuestion(stepId,'-> ' + this.backendResponse,[],null)];
    }
    
    goToBeginStep(stepId){
    	let options = stepUtil.appendOption([],-1,'Sim, Realizar Nova Operação',null);
    	return [stepUtil.getBotQuestion(stepId,'Nova Operação?',options,null)];
    }
    
    getConsumerUnitLabel(consumerUnit){
    	let label = consumerUnit.a8_street + ', ';
    	label += (null != consumerUnit.a9_number) ? consumerUnit.a9_number : 's/n, ';
    	label += consumerUnit.a7_city + '/' + consumerUnit.a6_uf;
    	label += ' CEP: ' + consumerUnit.a5_cep;
        return label;
    }

};














