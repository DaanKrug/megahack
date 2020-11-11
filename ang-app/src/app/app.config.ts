export class AppConfig {
	
	static authViews = [
		'home','mailerconfigs','modules','appconfigs','s3configs',
		'simplemails','users','applogs','images','files',
		'pagemenus','pagemenuitems','pagemenuitemfiles',
		'clients','solicitations',
	];
	
	static categories = [
		['modules',                                ['admin_master']],
	    ['appconfigs',                             ['admin_master']],
	    ['s3configs',                              ['admin_master']],
	    ['clients',                                ['admin_master','admin','system_auditor']],
	    ['solicitations',                          ['admin_master','admin','system_auditor']],
		['mailerconfigs',                          ['admin_master','admin','system_auditor']],
		['simplemails',                            ['admin_master','admin','system_auditor']],
		['users',                                  ['admin_master','admin','system_auditor']],
		['applogs',                                ['admin_master','admin','system_auditor']],
		['files',                                  ['admin_master','admin','system_auditor']],
		['pagemenus',                              ['admin_master','admin','system_auditor']],
		['pagemenuitems',                          ['admin_master','admin','system_auditor']],
		['pagemenuitemfiles',                      ['admin_master','admin','system_auditor']],
		['cancerdiagnostics',                      ['admin_master','admin','system_auditor']],
		['images',                                 ['admin_master','admin','system_auditor','enroll']],
    ];
	
}