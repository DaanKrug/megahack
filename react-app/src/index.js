import React from 'react';
import ReactDOM from 'react-dom';
import BaseBrowserStorageService from './api_com/base/basebrowserstorage.service.js';

import './css/bootstrap.min.css';
import './css/fontawesome-5.11/css/all.min.css';
import './css/custom.min.css';
import './css/megahack2020.css';
import './css/app.css';
import './css/gauge.css';
import './css/bot.css';

import SicinBot from './bot/sicinbot.js';

// For mock remote server uncomment following lines then execute [npm start] in terminal
//BaseBrowserStorageService.setSessionItem('_remote_server_','true');

// change to 'true' to show API connection errors
BaseBrowserStorageService.setSessionItem('_debugg_mode_on_','true');


ReactDOM.render(
	<div>
		<div className="field" style={{'width':'calc(100% - 23em)'}}>
			<img src={require('./img/logo.png')} 
			     style={{'width':'30em','height':'10em','margin':'1em 0 0 1.4em'}}
			     alt="" />
		</div>
		<div className="field" style={{'float':'right !important','width':'22em'}}>
			<SicinBot />
		</div>
	</div>,
    document.getElementById('root')
);














