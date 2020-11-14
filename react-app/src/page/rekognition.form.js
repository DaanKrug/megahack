import React from 'react';
import InputUpload from '../component/inputupload.js';
import AwsRekognitionService from '../api_com/awsrekognition.service.js';


export default class RekognitionForm extends React.Component{
	
	constructor(props){
		super(props);
		this.state = {
			fileData: null,	
		};
	}
	
	valueChanged(id,value){
		if(id === 'upRekognition'){
			this.setState({fileData: value});
		}
	}
	
	makeRekognition(){
		if(undefined === this.state.fileData || null === this.state.fileData){
			return;
		}
		let image = {file: this.state.fileData.base64, filename: this.state.fileData.fileName};
		console.log('makeRekognition()',this.state.fileData);
		AwsRekognitionService.rekognize(image).then(result => {
			console.log('result:',result);
		});
	}
	
	render(){
		return(
				<div>
					<div>
						<InputUpload id="upRekognition" 
							         label="Selecione uma Imagem"
							         handler={this}>
						</InputUpload>
					</div>
					<div className="buttons clear"> 
						<button className="btn btn-primary clickable"
							    onClick={() => {this.makeRekognition();}}>
							<span style={{'marginLeft':'1em;'}}>
								Avaliar Imagem
							</span>
						</button>  
					</div>
				</div>
		);
	}
	
}