import React from 'react';
import Gauge from 'svg-gauge';

export default class GaugeGraph extends React.Component {

	constructor(props){
		super(props);
		this.state = {
			id: 'gaugeGraph_' + new Date().getTime()
		};
	}
	
	componentDidMount(){
		setTimeout(() => {
			this.draw(this.state.id,this.props.value,this.props.label);
		},100);
	}

	draw(elemId,value0to1,label){
		let graphContainer = document.getElementById(elemId);
		graphContainer.innerHTML = '';
		let id = elemId + '_graph_' + new Date().getTime(); 
		let graph = document.createElement('div');
		graph.id = id;
		graph.className = 'gauge-container';
		graphContainer.appendChild(graph);
		let value = parseInt('' + (value0to1 * 100));
		if(value > 100){
			value = 100;
		}
		let graphLabel = document.createElement('div');
		graphLabel.innerHTML = label + value + '/100';
		graphContainer.appendChild(graphLabel);
		let graphElem = document.getElementById(id);
		Gauge(graphElem,{
		    max: 100,
		    label: function(value){return value + "/" + this.max;},
		    value: value,
		    color: function(value){
				if(value <= 25) {
		    		return "#5ee432"; // green
		    	}
		    	if(value <= 50) {
		    		return "#fffa50"; // yellow
		    	}
		    	if(value <= 75) {
		    		return "#f7aa38"; // orange
		    	}
		    	return "#ef4655"; // red
			}
		});
	}
	
	render() {
	    return (
	    		<div id={this.state.id}></div>
	    );
    }
	
}