#!/usr/bin/env php
<?php
    $arr = explode('/',__DIR__);
    $app = $arr[count($arr) - 1];
    $baseDir = __DIR__;
    $backupDir = '/home/daniel/Desktop/to_aws';
    $angCacheDir = $baseDir . '/ang-app/node_modules/.cache';
    $compilationDir = $baseDir . '/ex_app/compiled_' . $app;
    $buildDir = $baseDir . '/ex_app/_build';
    
    $angNodeModulesDelDir = $backupDir . '/' . $app . '/ang-app/node_modules';
    $reactNodeModulesDelDir = $backupDir . '/' . $app . '/react-app/node_modules';
    
    
    $suffix = date('_d_m_Y_h_i_s');
    
    $env = 'prod';
    if(null==$argv[1] || trim($argv[1]) != $env){
        $env = 'dev';
    } 
    
    shell_exec('sudo ./build.sh ' . $env);
    shell_exec('sudo rm -rf ' . $angCacheDir);
    shell_exec('sudo rm -rf ' . $compilationDir);
    shell_exec('sudo rm -rf ' . $buildDir);
    shell_exec('sudo rm -rf ' . $backupDir . '/' . $app);
    shell_exec('sudo cp -r ' . $baseDir . ' ' . $backupDir);
    
    shell_exec('sudo rm -rf ' . $angNodeModulesDelDir);
    shell_exec('sudo rm -rf ' . $reactNodeModulesDelDir);
    
    shell_exec('sudo tar -cvzf ' . $app . $suffix . '.tar.gz ' . $backupDir . '/' . $app);
    shell_exec('sudo mv ' . $app . $suffix . '.tar.gz ' . $backupDir . '/' . $app . $suffix . '.tar.gz');
    shell_exec('sudo chmod 777 -R ' . $backupDir . '/' . $app);
    shell_exec('sudo chmod 777 ' . $backupDir . '/' . $app . $suffix . '.tar.gz');
?>
