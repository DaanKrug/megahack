import BotIAUtil from './util/bot.ia.util.js';
import StepUtil from './util/step.util.js';
import AgeValidator from './validator/age.validator.js';

const botiaUtil = new BotIAUtil();
const stepUtil = new StepUtil();

export default class BotIA2 {
	
	age: number;
	gender: string;
    finished: boolean;

	reset(){
		this.age = null;
		this.gender = null;
		this.finished = false;
	}
	
    wasLoaded(){
    	return botiaUtil.wasLoaded();
    }
    
    getInitialSteps(){
		return [stepUtil.getBotQuestion(0,'Olá. sou doutor butiá!',[],null)];
	}
    
    getNextSteps(actualStep,stepId,msgResponse,valueResponse){
    	if(actualStep === 0){
    		return this.getAgeRangeSteps([]);
    	}
    	if(actualStep === 1){
    		return this.getSteps2(stepId,msgResponse,valueResponse);
    	}
    	if(actualStep === 2){
    		this.gender = valueResponse;
    		botiaUtil.filterSymptonsRiskFactor(this.age,this.gender);
    		return this.getSteps3(stepId,msgResponse,valueResponse);
    	}
    	let idx1 = (3 + botiaUtil.symptonCounter);
    	let size1 = botiaUtil.selectedSymptons.length - 1;
    	if(actualStep === idx1 && botiaUtil.symptonCounter <= size1){
    		return this.getNextStepsCancerSympton(stepId,msgResponse,valueResponse);
    	}
    	if(actualStep === idx1 && botiaUtil.symptonCounter > size1){
    		this.finished = true;
    		return this.getNextStepsCancerSympton(stepId,msgResponse,valueResponse);
    	}
    	/*if(actualStep === (3 + botiaUtil.symptonCounter + botiaUtil.riskFactorCounter)
    			&& botiaUtil.riskFactorCounter < botiaUtil.cancertyperiskfactors.length){
    		return this.getNextStepsCancerRiskFactor(stepId,msgResponse,valueResponse);
    	}*/
    	return [];
    }

	getAgeRangeSteps(preMsgs){
		const label = 'Qual a idade da pessoa?';
		const msgs = [stepUtil.getBotQuestion(1,label,stepUtil.getInputTextOption(),null)];
		return preMsgs.concat(msgs);
	}
	
	getSteps2(stepId,msgResponse,valueResponse){
		let validationMsg = AgeValidator(msgResponse);
		if(null != validationMsg){
			return this.getAgeRangeSteps([stepUtil.getBotQuestion(1,validationMsg,[],null)]);
		}
		this.age = parseInt(valueResponse);
		let options = stepUtil.appendOption([],'M','Masculino',false);
		options = stepUtil.appendOption(options,'F','Feminino',false);
		return [
			stepUtil.getUserAnswer(2,stepId,msgResponse,valueResponse,null),
			stepUtil.getBotQuestion(2,'Qual o sexo de nascimento da pessoa?',options,null)
		];
	}
	
	getSteps3(stepId,msgResponse,valueResponse){
		let steps = [
			stepUtil.getUserAnswer(3,stepId,msgResponse,valueResponse,null),
			stepUtil.getBotQuestion(3,'Quais dos sintomas abaixo a pessoa apresenta:',[],null)
		];
		return steps.concat(this.getNextStepsCancerSympton(stepId,msgResponse,valueResponse));
	}
	
	getNextStepsCancerSympton(stepId,msgResponse,valueResponse){
		let sympton0 = botiaUtil.getPreviousSymptonForMessage();
		let sympton = botiaUtil.getNextSymptonForMessage();
		let id = 3 + botiaUtil.symptonCounter;
		let flag0 = null != sympton0 ? {label: 'sympton', object: sympton0} : null;
		let steps = null != flag0 ? [stepUtil.getUserAnswer(id,stepId,msgResponse,valueResponse,flag0)] : [];
		if(null != sympton){
			let flag1 = {label: 'sympton', object: sympton};
			steps = [...steps,stepUtil.getBotQuestion(id,sympton.a1_name,stepUtil.getYesNoOptions(),flag1)];
		}
		return steps;
	}
	
	/*
	getNextStepsCancerRiskFactor(stepId,msgResponse,valueResponse){
		return [
			stepUtil.getUserAnswer(3,stepId,msgResponse,valueResponse,null),
			stepUtil.getBotQuestion(3,'Quais dos sintomas abaixo a pessoa apresenta:',[])
		];
	}*/
	
	diagnoseResults(steps){
		let responses = botiaUtil.calculateResults(steps);
		let options = [];
    	const size = responses.length;
    	for(let i = 0; i < size; i++){
    		let label = 'Probabilidade ' + responses[i].cancertypeName + ': ';
    		let id = 'opt_' + i + '_' + new Date().getTime();
    		options = stepUtil.appendOptionGaugeGraph(options,id,label,responses[i].avgWeight);
    	}
    	let infoLabel = '* Para valores maiores que 25% (ou 25/100) de probabilidade, procurar um especialista.';
    	if(options.length === 0){
    		infoLabel = '* Nenhum indício significativo de preocupação encontrado.';
    	}
    	let options2 = stepUtil.appendOption([],-1,'Nova Consulta',null);
    	return [
    		stepUtil.getBotQuestion(3 + botiaUtil.symptonCounter + 1,'Diagnóstico (*):',options,null),
    		stepUtil.getBotQuestion(3 + botiaUtil.symptonCounter + 2,infoLabel,[],null),
    		stepUtil.getBotQuestion(3 + botiaUtil.symptonCounter + 3,'Nova Consulta?',options2,null),
    	];
	}
	
	
	
};
