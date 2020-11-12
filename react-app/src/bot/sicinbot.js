import React from 'react';

import BotMessage from './component/bot.message.js';
import UserMessage from './component/user.message.js';

import BotIA2 from './bot.ia2.js';
const botia = new BotIA2();

export default class SicinBot extends React.Component {
	
	constructor(props){
		super(props);    
		this.state = {
		    key: new Date().getTime(),
			actualStep: 0,
			msgs: botia.getInitialSteps(),
			lastClickTime: null
		};
		setTimeout(() => {this.loadNextSteps(null,null,null);},10);
	}
	
	reset(){
		this.setState({
		    key: new Date().getTime(),
			actualStep: 0,
			msgs: botia.getInitialSteps()
		});
		setTimeout(() => {this.loadNextSteps(null,null,null);},100);
	}
	
	handleMsgClick(stepId,msgResponse,valueResponse){
		//console.log([stepId,msgResponse,valueResponse]);
		let now = new Date().getTime();
		if(null != this.state.lastClickTime && !((now - this.state.lastClickTime) > 1000)){
			return
		}
		this.setState({lastClickTime: now});
		if(stepId === -1){
			botia.reset();
			this.reset();
			return;
		}
		if(stepId !== this.state.actualStep){
			return;
		}
		this.loadNextSteps(stepId,msgResponse,valueResponse);
	}
	
	loadNextSteps(stepId,msgResponse,valueResponse){
		if(botia.waiting){
			setTimeout(() => {this.loadNextSteps(stepId,msgResponse,valueResponse);},100);
			return;
		}
		let discounter = botia.needRepeatBack ? -1 : 0;
		const newStep = this.state.actualStep + (botia.blockWalking ? 0 : 1) + discounter;
		const nextSteps = botia.getNextSteps(newStep,msgResponse,valueResponse);
		let msgs = this.state.msgs.slice();
		msgs = msgs.concat(nextSteps);
		this.setState({
			key: new Date().getTime(),
			actualStep: newStep,
			msgs: msgs
		});
		if(botia.needResume && !botia.blockWalking){
			setTimeout(() => {this.loadNextSteps(stepId + discounter,msgResponse,valueResponse);},100);
			return;
		}
	}
	
	getMessageElement(msg,index){
		const thisThis = this;
		if([true,1,'true'].includes(msg.fromBot)){
			return (
					<BotMessage key={index}
						        msgid={msg.id}
						        msg={msg.label} 
						        handler={thisThis}
					            lastItem={msg.lastItem}
						        options={msg.options} />		
			);
		}
		return (
				<UserMessage msgid={msg.id} 
					         key={index}
					         msg={msg.label} 
					         handler={thisThis} />	
		);
	}
	
	render(){
		const thisThis = this;
		let rMsgs = [];
		const size = this.state.msgs.length;
		for(let i = size - 1; i >= 0; i--){
			let msg = this.state.msgs[i];
			msg.lastItem = (i === (size - 1));
			rMsgs = [...rMsgs,msg];
		}
		return (
				<div key={this.state.key} className="rsc">
					<div id="chatContainer" 
						 className="chatContainer">
				    	<div className="chatContainerHeader rsc-header header">
				    		<span className="rsc-header-title">
				    		Joana Resolve
				    		</span>
				    	</div>
				    	<div id="chatContainerBody" 
				    		 className="rsc-content">
					    	{
					    		rMsgs.map(function(msg,index){
									return thisThis.getMessageElement(msg,index);
			                    })
			                }
				    	</div>
				    	<div className="rsc-footer"></div>
				    </div>
				</div>
		);
	}

}