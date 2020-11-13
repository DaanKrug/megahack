import React from 'react';

import BigButton from '../component/bigbutton.js';
import SolicitationForm from './solicitation.form.js';
import SicinBot from '../bot/sicinbot.js';


export default class MainPage extends React.Component {
	
	constructor(props) {    
		super(props);    
		this.state = {      
			view: 'initial'
		};  
	}
	
	setView(name){
		this.setState({view: name});
	}
	
	newBinding(){
		this.setView('newBinding');
	}
	
	alterClientData(){
		this.setView('alterClientData');
		console.log('make alterClientData screen');
	}
	
	otherServices(){
		this.setView('otherServices');
		console.log('make otherServices screen');
	}
	
	renderSolicitationForm(){
		return(
			   <SolicitationForm />
		);
	}
	
    renderinitialView() {
	    return (
	    		<div>
		    		<div className="field" 
		    			 style={{'width':'calc(100% - 23em)'}}>
			    		<div>
				    		<img src={require('../img/logo.png')} 
							     style={{'width':'30em','height':'10em','margin':'1em 0 0 1.4em'}}
							     alt="" />
			    		</div>
			    		<div className="container">
				    		<div className="row justify-content-center" 
				    			 style={{'paddingTop': '3em'}}>
				    			<BigButton label="Solicitar Nova Ligação" 
				    				       className="fab fa-houzz" 
				    				       onClick={() => this.newBinding()} />
				    			<BigButton label="Alterar Dados Cadastrais" 
				    				       className="fas fa-user-edit" 
				    				       onClick={() => this.alterClientData()} />
						    	<BigButton label="Outros Serviços" 
				    				       className="fas fa-network-wired" 
				    				       onClick={() => this.otherServices()} />
							</div>
						</div>
					</div>
					<div className="field" 
						 style={{'float':'right !important','width':'22em'}}>
						<SicinBot />
					</div>
				</div>
	    );
    }
    
    render(){
    	if('newBinding' === this.state.view){
    		return this.renderSolicitationForm();
    	}
    	/*
    	if('alterClientData' === this.state.view){
    		return this.renderinitialView();
    	}
    	if('otherServices' === this.state.view){
    		return this.renderinitialView();
    	}
    	if('initial' === this.state.view){
    		return this.renderinitialView();
    	}
    	*/
    	return this.renderinitialView();
    }
    
}