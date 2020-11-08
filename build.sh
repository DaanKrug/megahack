#!/usr/bin/env php
<?php
    $arr = explode('/',__DIR__);
    $app = $arr[count($arr) - 1];
    $buildBase = '/home/daniel/Desktop/BUILD/';
    $buildDir = $buildBase . $app;
    $baseDir = __DIR__;
    $compilationDir = $baseDir . '/ex_app/compiled_' . $app;
    
    $env = 'prod';
    if(null==$argv[1] || trim($argv[1]) != $env){
        $env = 'dev';
    } 
    
    shell_exec('sudo rm -rf ' . $buildDir);
    shell_exec('sudo mkdir ' . $buildDir);
    shell_exec('sudo cp index_' . $env . '.html ' . $buildDir . '/index.html');
    shell_exec('sudo cp index_' . $env . '.html index.html');
    shell_exec('sudo cp manifest_' . $env . '.webmanifest ' . $buildDir . '/manifest.webmanifest');
    shell_exec('sudo cp manifest_' . $env . '.webmanifest manifest.webmanifest');
    shell_exec('sudo cp serviceworker_' . $env . '.js ' . $buildDir . '/serviceworker.js');
    shell_exec('sudo cp serviceworker_' . $env . '.js serviceworker.js');
    shell_exec('sudo mkdir ' . $buildDir . '/ex_app');
    shell_exec('sudo cp -r ' . $compilationDir . ' ' . $buildDir  . '/ex_app');
    shell_exec('sudo chmod 777 -R ' . $buildDir);

?>