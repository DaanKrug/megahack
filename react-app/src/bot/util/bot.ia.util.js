import AgeRangeService from '../../api_com/agerange.service.js';
import CancerTypeService from '../../api_com/cancertype.service.js';
import CancerTypeAgeRangeService from '../../api_com/cancertypeagerange.service.js';
import CancerTypeRiskFactorService from '../../api_com/cancertyperiskfactor.service.js';
import CancerTypeSymptonService from '../../api_com/cancertypesympton.service.js';


export default class BotIAUtil {
	
	ageranges: any[];
	cancertypes: any[];
	cancertypeageranges: any[];
    cancertyperiskfactors: any[];
    cancertypesymptons: any[];
    counter: number;
	symptonCounter: number;
    selectedSymptons: any[];
	riskFactorCounter: number;
	selectedRiskFactors: any[];

    constructor(){
    	this.counter = 0;
    	AgeRangeService.getAll(-1,-1,null).then(ageranges => {
			this.ageranges = ageranges;
			this.counter ++;
		});
    	CancerTypeService.getAll(-1,-1,null).then(cancertypes => {
			this.cancertypes = cancertypes;
			this.counter ++;
		});
    	CancerTypeAgeRangeService.getAll(-1,-1,null).then(cancertypeageranges => {
			this.cancertypeageranges = cancertypeageranges;
			this.counter ++;
		});
    	CancerTypeRiskFactorService.getAll(-1,-1,null).then(cancertyperiskfactors => {
			this.cancertyperiskfactors = cancertyperiskfactors;
			this.counter ++;
		});
    	CancerTypeSymptonService.getAll(-1,-1,null).then(cancertypesymptons => {
			this.cancertypesymptons = cancertypesymptons;
			this.counter ++;
		});
    }
    
    wasLoaded(){
    	return this.counter === 5;
    }
    
    getPreviousSymptonForMessage(){
    	if(this.symptonCounter === 0){
    		return null;
    	}
    	return this.selectedSymptons[this.symptonCounter - 1];
    }
    
    getNextSymptonForMessage(){
    	if(this.symptonCounter >= this.selectedSymptons.length){
    		return null;
    	}
    	const sympton = this.selectedSymptons[this.symptonCounter];
    	this.symptonCounter ++;
    	return sympton;
    }
    
    filterSymptonsRiskFactor(age,gender){
		let cancerTypeIds = this.filterCancerTypeIds(age,gender);
		this.filterCancerTypeRiskFactors(cancerTypeIds);
		this.filterCancerTypeSymptons(cancerTypeIds);
    }
    
    filterCancerTypeRiskFactors(cancerTypeIds){
    	this.riskFactorCounter = 0;
		this.selectedRiskFactors = [];
		let riskIds = [];
        const size = this.cancertyperiskfactors.length;
    	for(let i = 0; i < size; i++){
    		if(!(cancerTypeIds.includes(this.cancertyperiskfactors[i].a3_cancertypeid))){
    			continue;
    		}
    		const riskId = this.cancertyperiskfactors[i].a4_cancerriskfactorid;
    		if(riskIds.includes(riskId)){
    			continue;
    		}
    		riskIds.unshift(riskId);
    		this.selectedRiskFactors = [...this.selectedRiskFactors,this.cancertyperiskfactors[i]];
    	}
    }
    
    filterCancerTypeSymptons(cancerTypeIds){
    	this.symptonCounter = 0;
        this.selectedSymptons = [];
        let symptonIds = [];
        const size = this.cancertypesymptons.length;
    	for(let i = 0; i < size; i++){
    		if(!(cancerTypeIds.includes(this.cancertypesymptons[i].a3_cancertypeid))){
    			continue;
    		}
    		const symptonId = this.cancertypesymptons[i].a4_cancersymptonid;
    		if(symptonIds.includes(symptonId)){
    			continue;
    		}
    		symptonIds.unshift(symptonId);
    		this.selectedSymptons = [...this.selectedSymptons,this.cancertypesymptons[i]];
    	}
    }
    
    filterCancerTypeIds(age,gender){
    	let ids = [];
    	const size = this.cancertypeageranges.length;
    	for(let i = 0; i < size; i++){
    		let ageRange = this.getAgeRange(this.cancertypeageranges[i].a4_canceragerangeid);
    		if(!(age >= ageRange.a3_min && age < ageRange.a4_max)){
    			continue;
    		}
    		if(!(ids.includes(this.cancertypeageranges[i].a3_cancertypeid))){
    			ids = [...ids,this.cancertypeageranges[i].a3_cancertypeid];
    		}
    	}
    	return this.getCancerTypeIdsByGender(ids,gender);
    }
    
    getAgeRange(id){
    	const size = this.ageranges.length;
    	for(let i = 0; i < size; i++){
    		if(this.ageranges[i].id === id){
    			return this.ageranges[i];
    		}
    	}
    	return null;
    }
    
    getCancerTypeIdsByGender(ids,gender){
    	let ids2 = [];
    	const size = this.cancertypes.length;
    	for(let i = 0; i < size; i++){
    		if(!(ids.includes(this.cancertypes[i].id))){
    			continue;
    		}
    		if(gender === 'M' && !this.cancertypes[i].a4_male){
    			continue;
    		}
    		if(gender === 'F' && !this.cancertypes[i].a5_female){
    			continue;
    		}
    		ids2 = [...ids2,this.cancertypes[i].id];
    	}
    	return ids2;
    }
    
    getCancerTypeName(id){
    	const size = this.cancertypes.length;
    	for(let i = 0; i < size; i++){
    		if(this.cancertypes[i].id === id){
    			return this.cancertypes[i].a1_name;
    		}
    	}
    	return null;
    }
    
    getMaxWeight(cancertypeid,type){
    	let max = 0;
    	if(type === 'agerange'){
    		max = 10;
    	}
    	if(type === 'sympton'){
    		let size = this.cancertypesymptons.length;
    		for(let i = 0; i < size; i++){
    			if(this.cancertypesymptons[i].a3_cancertypeid !== cancertypeid){
    				continue;
    			}
    			max += this.cancertypesymptons[i].a5_weight;
    		}
    	}
    	return max;
    }
       
    putResponse(cancertypeid,responsesGroup,response){
    	const size = responsesGroup.length;
    	let found = false;
    	for(let i = 0; i < size; i++){
    		if(responsesGroup[i].cancertypeid === cancertypeid
    			&& responsesGroup[i].type === response.type){
    			responsesGroup[i].totalWeight += response.weight;
    			responsesGroup[i].responses.unshift(response);
    			responsesGroup[i].avgWeight = (responsesGroup[i].totalWeight / responsesGroup[i].maxWeight);
    			found = true;
    			break;
    		}
    	}
    	if(!found){
    		let responseGroup = {
    			cancertypeid: cancertypeid,
    			cancertypeName: this.getCancerTypeName(cancertypeid),
    			type: response.type,
    			totalWeight: response.weight,
    			maxWeight: this.getMaxWeight(cancertypeid,response.type),
    			responses: [response]
    		}
    		responseGroup.avgWeight = (responseGroup.totalWeight / responseGroup.maxWeight);
    		responsesGroup.unshift(responseGroup);
    	}
    	return responsesGroup;
    }
    
    filterResponses(steps){
    	let responsesGroup = [];
    	const size = steps.length;
    	for(let i = 0; i < size; i++){
    		if([true,1,'true'].includes(steps[i].fromBot) || steps[i].value === 0
    			|| undefined === steps[i].qid || null === steps[i].qid
    			|| undefined === steps[i].flag || null === steps[i].flag){
    			continue;
    		}
    		let type = steps[i].flag.label;
    		let symptonid = type === 'sympton' ? steps[i].flag.object.a4_cancersymptonid : null;
    		let weight = steps[i].flag.object.a5_weight;
    		let cancertypeid = steps[i].flag.object.a3_cancertypeid;
    		let response = {
    			qid: steps[i].qid,
    			type: type,
    			label: steps[i].flag.object.a1_name,
    			symptonid: symptonid,
    			weight: weight
    		};
    		responsesGroup = this.putResponse(cancertypeid,responsesGroup,response);
    	}
    	return responsesGroup;
    }
    
    calculateResults(steps){
    	return this.filterResponses(steps);
	}
    
}















