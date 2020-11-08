#!/usr/bin/env php
<?php

	$arr = explode('/',__DIR__);
	array_pop($arr);
    $baseDir = implode('/',$arr);
    $staticFilesDir = $baseDir . "/static_files";
    $reactAppDir = $baseDir . "/react-app";
    $reactFilesDir = $staticFilesDir . "/react";
    $reactBuildDir = $reactAppDir . "/build";
    
    $output = shell_exec('npm run build');
    echo $output;
    
    $output = shell_exec('sudo rm -rf ' . $reactFilesDir);
    echo $output;
    $output = shell_exec('sudo mkdir ' . $reactFilesDir);
    echo $output;
    
    $output = shell_exec('sudo cp -r ' . $reactBuildDir . '/static ' . $reactFilesDir);
    echo $output;
    $output = shell_exec('sudo cp ' . $reactBuildDir . '/*.* ' . $reactFilesDir);
    echo $output;
    
?>