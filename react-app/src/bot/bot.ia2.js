import BaseBrowserStorageService from '../api_com/base/basebrowserstorage.service.js';
import BotIAUtil from './util/bot.ia.util.js';
import StepUtil from './util/step.util.js';
import CpfValidator from './validator/cpf.validator.js';

const botiaUtil = new BotIAUtil();
const stepUtil = new StepUtil();

export default class BotIA2 {
	
	cpf: string;
    needResume: boolean;
    waiting: boolean;
    blockWalking: boolean;
    backendResponse: string;
    serviceCode: number;
    selectedConsumerUnitNumber: string;
    needRepeatBack: boolean;

	constructor(){
		this.reset();
	}
	
	reset(){
		this.cpf = BaseBrowserStorageService.getLocalItem('cpf');
		this.backendResponse = null;
		this.needResume = false;
		this.waiting = false;
		this.blockWalking = false;
		this.serviceCode = 0;
		this.selectedConsumerUnitNumber = null;
		this.needRepeatBack = false;
	}
	
    getInitialSteps(){
		return [stepUtil.getBotQuestion(0,'Olá, eu sou Joana! Seja bem vindo ao Light App!',[],null)];
	}
    
    getNextSteps(stepId,msgResponse,valueResponse){
    	//console.log([stepId,this.blockWalking,this.serviceCode,msgResponse,valueResponse]);
    	let oldNeedResume = this.needResume ? true : false;
    	this.needResume = false;
    	this.needRepeatBack = false;
    	if(stepId === 1 && null !== this.cpf){
    		this.needResume = true;
    		return [];
    	}
    	if(stepId === 1){
    		return this.getPutCPFSteps(stepId);
    	}
    	if(stepId === 2 && !oldNeedResume){
    		let msg = CpfValidator(msgResponse);
    		if(null !== msg){
    			this.needRepeatBack = true;
    			return this.getErrorMsgSteps(stepId,msg);
    		}
    		this.cpf = msgResponse.trim();
    		this.cpf = this.cpf.replace(/\./gi,'');
    		this.cpf = this.cpf.replace(/-/gi,'');
    		BaseBrowserStorageService.setLocalItem('cpf',this.cpf);
    	}
    	if(stepId === 2){
    		return this.getOperationSteps(stepId,msgResponse,valueResponse);
    	}
    	this.needResume = [3,4,5].includes(stepId);
    	if(stepId === 3 && valueResponse === 1){
    		this.serviceCode = 1;
    		return this.getLightFaultSteps();
    	}
    	if(stepId === 3 && valueResponse === 2){
    		this.serviceCode = 2;
    		return this.getLightReBindingSteps();
    	}
    	if(stepId === 4 && this.blockWalking && this.serviceCode === 1){
    		this.blockWalking = false;
    		this.selectedConsumerUnitNumber = valueResponse;
    		return this.getLightFaultSteps();
    	}
        if(stepId === 4 && this.blockWalking && this.serviceCode === 2){
        	this.blockWalking = false;
        	this.selectedConsumerUnitNumber = valueResponse;
    		return this.getLightReBindingSteps();
    	}
    	if([4,5].includes(stepId)){
    		return this.getBackendResponseSteps(stepId,msgResponse,valueResponse);
    	}
    	return this.goToBeginStep();
    }
    
    getPutCPFSteps(stepId){
		return [stepUtil.getBotQuestion(stepId,'Por favor informe o CPF do responsável:',
				                        stepUtil.getInputTextOption(),null)];
	}
    
    getErrorMsgSteps(stepId,msg){
		return [stepUtil.getBotQuestion(stepId,msg,stepUtil.getInputTextOption(),null)];
	}
    
    getOperationSteps(stepId,msgResponse,valueResponse){
		let options = stepUtil.appendOption([],1,'Relatar Falta de Luz',false);
		options = stepUtil.appendOption(options,2,'Solicitar Re-ligamento',false);
		let steps = [];
    	if(null != msgResponse && null != valueResponse){
    		steps = [...steps,stepUtil.getUserAnswer(stepId,stepId - 1,msgResponse,valueResponse,null)];
    	}
		return [...steps,stepUtil.getBotQuestion(stepId,'Em que posso lhe ajudar?',options,null)];
	}
    
    getLightFaultSteps(){
    	this.waiting = true;
    	if(null != this.selectedConsumerUnitNumber){
    		botiaUtil.registerFaultByConsumerUnitId(this.selectedConsumerUnitNumber).then(response => {
        		this.backendResponse = response;
        		this.waiting = false;
        		this.selectedConsumerUnitNumber = null;
        	});
        	return [];
    	}
    	botiaUtil.registerFault(this.cpf).then(response => {
    		this.backendResponse = response;
    		this.waiting = false;
    	});
    	return [];
	}
    
    getLightReBindingSteps(){
    	this.waiting = true;
    	if(null != this.selectedConsumerUnitNumber){
    		botiaUtil.registerReBindingByConsumerUnitId(this.selectedConsumerUnitNumber).then(response => {
        		this.backendResponse = response;
        		this.waiting = false;
        		this.selectedConsumerUnitNumber = null;
        	});
        	return [];
    	}
    	botiaUtil.registerReBinding(this.cpf).then(response => {
    		this.backendResponse = response;
    		this.waiting = false;
    	});
    	return [];
	}
    
    getBackendResponseSteps(stepId,msgResponse,valueResponse){
    	var steps = [];
    	if(null != msgResponse && null != valueResponse){
    		steps = [...steps,stepUtil.getUserAnswer(stepId,stepId - 1,msgResponse,valueResponse,null)];
    	}
    	if(null != this.backendResponse && Array.isArray(this.backendResponse) 
    			&& this.backendResponse.length > 1){
    		this.blockWalking = true;
    		return this.getConsumerUnitSelectionOptionsMessage(stepId,steps);
    	}
    	let msg = Array.isArray(this.backendResponse) ? this.backendResponse[0].msg : this.backendResponse.msg;
    	return this.splitBotMessage(stepId,steps,msg);
    }
    
    goToBeginStep(){
    	let options = stepUtil.appendOption([],-1,'Sim, realizar nova solicitação',null);
    	return [stepUtil.getBotQuestion(-1,'Deseja realizar uma nova solicitação?',options,null)];
    }
    
    getConsumerUnitSelectionOptionsMessage(stepId,steps){
    	let size = this.backendResponse.length;
		let options = [];
		for(let i = 0; i < size; i++){
			let label = this.getConsumerUnitLabel(this.backendResponse[i]);
			options = stepUtil.appendOption(options,this.backendResponse[i].id,label,null);
		}
		let compl = this.serviceCode === 1 ? 'informando falta de energia' : 'solicitando re-ligamento';
		let msg = 'Olá ' + this.backendResponse[0].a1_name + '! Para qual unidade de ';
		msg += 'consumo você está ' + compl + '?';
		return [...steps,stepUtil.getBotQuestion(stepId,msg,options,null)];
    }
    
    splitBotMessage(stepId,steps,msg){
    	let msgs = msg.split('|');
    	let size = msgs.length;
    	for(let i = 0; i < size; i++){
    		let msg2 = msgs[i].trim();
    		if(msg2 === ''){
    			continue;
    		}
    		steps = [...steps,stepUtil.getBotQuestion(stepId,msg2,[],null)];
    	}
    	return steps;
    }
    
    getConsumerUnitLabel(consumerUnit){
    	let label = consumerUnit.a8_street + ', ';
    	label += (null !== consumerUnit.a9_number && consumerUnit.a9_number.trim() !== '') 
    	       ? 'Nº ' + consumerUnit.a9_number : 's/n';
    	label += ', ' + consumerUnit.a7_city + '/' + consumerUnit.a6_uf;
    	label += ' CEP: ' + consumerUnit.a5_cep;
        return label;
    }

};