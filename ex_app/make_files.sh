#!/usr/bin/env php
<?php

	$description = "Mega Hack 2020 - in Elixir/Erlang";
	$arr = explode('/',__DIR__);
	array_pop($arr);
    $app = $arr[count($arr) - 1];
    $baseDir = implode('/',$arr);
    $compilationDir = $baseDir . "/ex_app/compiled_" . $app;
    $staticFilesDir = $baseDir . "/static_files";
    $staticDir = $baseDir . "/ex_app/priv/static";
    
    shell_exec('sudo rm -rf ' . $staticDir . '/*');
    
    $env = 'prod';
    if(null==$argv[1] || trim($argv[1]) != $env){
        $env = 'dev';
    } 
    if($env == 'dev'){
    	shell_exec('sudo cp -r ' . $staticFilesDir . '/angular ' . $staticDir);
    	shell_exec('sudo cp -r ' . $staticFilesDir . '/react ' . $staticDir);
    	shell_exec('sudo cp -r ' . $staticFilesDir . '/bootstrap ' . $staticDir);
    	shell_exec('sudo cp -r ' . $staticFilesDir . '/fontawesome-5.11 ' . $staticDir);
    	shell_exec('sudo cp -r ' . $staticFilesDir . '/tinymce-5.3.0 ' . $staticDir);
    	shell_exec('sudo cp -r ' . $staticFilesDir . '/themes ' . $staticDir);
    	shell_exec('sudo cp -r ' . $staticFilesDir . '/webfonts ' . $staticDir);
    	shell_exec('sudo cp ' . $staticFilesDir . '/404_dev.html ' . $staticDir . '/404.html');
    	shell_exec('sudo cp ' . $staticFilesDir . '/index_dev.html ' . $staticDir . '/index.html');
    	shell_exec('sudo cp ' . $staticFilesDir . '/custom.min.css ' . $staticDir . '/custom.min.css');
    	shell_exec('sudo cp ' . $staticFilesDir . '/favicon.ico ' . $staticDir . '/favicon.ico');
    	shell_exec('sudo cp ' . $staticFilesDir . '/pwa-192x192.png ' . $staticDir . '/pwa-192x192.png');
    	shell_exec('sudo cp ' . $staticFilesDir . '/pwa-512x512.png ' . $staticDir . '/pwa-512x512.png');
    }else{
    	shell_exec('sudo cp -r ' . $staticFilesDir . '/react ' . $staticDir);
    	shell_exec('sudo cp ' . $staticFilesDir . '/404_prod.html ' . $staticDir . '/404.html');
    	shell_exec('sudo cp ' . $staticFilesDir . '/index_prod.html ' . $staticDir . '/index.html');
    }
    
    shell_exec('sudo rm -rf make_release.sh');
    shell_exec('sudo rm -rf ./lib/aapp_config/enviroment/enviroment.decisor.ex');
    
    $f0 = fopen("./lib/aapp_config/enviroment/enviroment.decisor.ex", "w");
    fwrite($f0,"defmodule ExApp.Enviroment.Decisor do\n");
    fwrite($f0,"\n");
    fwrite($f0,"  def getEnvType() do\n");
    fwrite($f0,"    \"" . $env . "\"\n");
    fwrite($f0,"  end\n");
    fwrite($f0,"\n");
    fwrite($f0,"end"); 
    fclose($f0);
    
    $f1 = fopen("./" . $app . ".service", "w");
	fwrite($f1,"[Unit]\n"); 
	fwrite($f1,"Description=" . $description . "\n"); 
	fwrite($f1,"After=mysql.service\n"); 
	fwrite($f1,"\n"); 
	fwrite($f1,"[Service]\n");
	fwrite($f1,"Environment=\"MIX_ENV=prod\" \"HOME=" . $compilationDir . "/ex_app/bin\"\n");
	fwrite($f1,"ExecStart=/usr/local/bin/" . $app . "_startup.sh\n");
	fwrite($f1,"ExecStop=/usr/local/bin/" . $app . "_shutdown.sh\n");
	fwrite($f1,"RemainAfterExit=yes\n");
	fwrite($f1,"\n");
	fwrite($f1,"[Install]\n");
	fwrite($f1,"# WantedBy=default.target\n"); 
	fwrite($f1,"WantedBy=multi-user.target");
	fclose($f1);
	
	$f2 = fopen("./" . $app . "_shutdown.sh", "w");
	fwrite($f2,"#!/bin/bash\n"); 
	fwrite($f2,$compilationDir . "/ex_app/bin/ex_app stop"); 
	fclose($f2);
	
	$f3 = fopen("./" . $app . "_startup.sh", "w");
	fwrite($f3,"#!/bin/bash\n"); 
	fwrite($f3,$compilationDir . "/ex_app/bin/ex_app start"); 
	fclose($f3);
    
    $f4 = fopen("./"  . $app . "_init.sh", "w");
	fwrite($f4,"#!/bin/bash\n");
	fwrite($f4,"sudo cp " . $compilationDir . "/" . $app . "_startup.sh /usr/local/bin/" . $app . "_startup.sh\n"); 
	fwrite($f4,"sudo chmod 744 /usr/local/bin/" . $app . "_startup.sh\n"); 
	fwrite($f4,"sudo chmod +x /usr/local/bin/" . $app . "_startup.sh\n");
	fwrite($f4,"sudo cp " . $compilationDir . "/" . $app . "_shutdown.sh /usr/local/bin/" . $app . "_shutdown.sh\n"); 
	fwrite($f4,"sudo chmod 744 /usr/local/bin/" . $app . "_shutdown.sh\n"); 
	fwrite($f4,"sudo chmod +x /usr/local/bin/" . $app . "_shutdown.sh\n");
	fwrite($f4,"sudo cp " . $compilationDir . "/" . $app . ".service /etc/systemd/system\n"); 
	fwrite($f4,"sudo chmod 664 /etc/systemd/system/" . $app . ".service\n"); 
	fwrite($f4,"sudo chmod +x /etc/systemd/system/" . $app . ".service\n"); 
	fwrite($f4,"sudo systemctl daemon-reload\n"); 
	fwrite($f4,"sudo systemctl enable " . $app . ".service\n"); 
	fwrite($f4,"sudo systemctl restart " . $app . ".service"); 
	fclose($f4);
    
	$f5 = fopen("./make_release.sh", "w");
	fwrite($f5,"#!/bin/bash\n"); 
	fwrite($f5,"sudo rm -rf compiled_" . $app . "\n"); 
	fwrite($f5,"sudo mkdir compiled_" . $app . "\n"); 
	fwrite($f5,"sudo mix do deps.get, deps.compile, compile\n"); 
	fwrite($f5,"sudo MIX_ENV=prod mix release\n"); 
	fwrite($f5,"sudo cp -r _build/prod/rel/ex_app compiled_" . $app . "\n"); 
	fwrite($f5,"sudo mv " . $app . ".service ./compiled_" . $app . "\n"); 
	fwrite($f5,"sudo mv " . $app . "_startup.sh ./compiled_" . $app . "\n"); 
	fwrite($f5,"sudo mv " . $app . "_shutdown.sh ./compiled_" . $app . "\n"); 
	fwrite($f5,"sudo mv " . $app . "_init.sh ./compiled_" . $app . "\n"); 
	fwrite($f5,"sudo chmod +x ./compiled_" . $app . "/" . $app . "_init.sh\n"); 
	fclose($f5);
	
	shell_exec('sudo chmod 774 make_release.sh');
	shell_exec('sudo chmod +x make_release.sh');
?>
