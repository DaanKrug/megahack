import React from 'react';
import BotIcon from './bot.icon.js';
import SingleMessage from './single.message.js';
import InputMessage from './input.message.js';
import GaugeGraph from './gauge.graph.js';

export default class BotMessage extends React.Component {
	
	getOptionMessage(option,index,lastItem){
		const thisThis = this;
		if(undefined !== option.graph && null !== option.graph 
				&& option.graph === 'gauge'){
			return (
					<GaugeGraph key={index}
					            value={option.value}
					            label={option.label} />
			);
		}
		if(!([true,1,'true'].includes(lastItem))){
			return(<div key={index}></div>);
		}
		if(undefined !== option.input && null !== option.input 
				&& [true,1,'true'].includes(option.input)){
			return (
					<InputMessage key={index}
					               id={option.id}
					               msg={option.label} 
								   msgid={thisThis.props.msgid} 
					               handler={thisThis.props.handler}
					               type="bot" />
			);
		}
		return (
				<SingleMessage key={index}
				               id={option.id}
				               msg={option.label} 
							   msgid={thisThis.props.msgid} 
				               handler={thisThis.props.handler}
				               type="bot" />
		);
	}
	
	render() {
		const thisThis = this;
		const clazzOptions = undefined !== this.props.options 
		                     	&& null !== this.props.options
		                     	&& this.props.options.length === 1
		                     	&& [true,1,'true'].includes(this.props.options[0].input)
		                     	? 'chatMsgContainerOptionsFullWidth' : 'chatMsgContainerOptions';
	    return (
	    		<div className="chatMsgContainer rsc-ts rsc-ts-bot">
		    		<BotIcon />
					<SingleMessage msg={this.props.msg} 
					               type="bot" />
					<div className={clazzOptions}>
					{
						this.props.options.map(function(option,index){
							return thisThis.getOptionMessage(option,index,thisThis.props.lastItem);
	                    })
					}
					</div>
				</div>
	    );
    }
	
}