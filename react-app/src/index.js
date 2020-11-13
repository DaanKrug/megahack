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

import MainPage from './page/main.page.js';

// For mock remote server uncomment following lines then execute [npm start] in terminal
//BaseBrowserStorageService.setSessionItem('_remote_server_','true');

// change to 'true' to show API connection errors
BaseBrowserStorageService.setSessionItem('_debugg_mode_on_','true');


ReactDOM.render(
	<MainPage />,
    document.getElementById('root')
);














