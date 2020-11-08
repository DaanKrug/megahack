#!/usr/bin/env php
<?php

    $staticFilesDir = "./static_files";
    $mockDir = "/var/www/html/megahack2020_mock";
    
    shell_exec('sudo rm -rf ' . $mockDir);
    
    shell_exec('sudo cp -r ' . $staticFilesDir . '/webfonts ' . $mockDir);
    shell_exec('sudo cp -r ' . $staticFilesDir . '/angular ' . $mockDir);
	shell_exec('sudo cp -r ' . $staticFilesDir . '/bootstrap ' . $mockDir);
	shell_exec('sudo cp -r ' . $staticFilesDir . '/fontawesome-5.11 ' . $mockDir);
	shell_exec('sudo cp -r ' . $staticFilesDir . '/tinymce-5.3.0 ' . $mockDir);
	shell_exec('sudo cp -r ' . $staticFilesDir . '/themes ' . $mockDir);
	shell_exec('sudo cp -r ' . $staticFilesDir . '/webfonts ' . $mockDir);
	shell_exec('sudo cp ' . $staticFilesDir . '/404_dev.html ' . $mockDir . '/404.html');
	shell_exec('sudo cp ' . $staticFilesDir . '/index_dev_mock.html ' . $mockDir . '/index.html');
	shell_exec('sudo cp ' . $staticFilesDir . '/custom.min.css ' . $mockDir . '/custom.min.css');
	shell_exec('sudo cp ' . $staticFilesDir . '/favicon.ico ' . $mockDir . '/favicon.ico');
	shell_exec('sudo cp ' . $staticFilesDir . '/pwa-192x192.png ' . $mockDir . '/pwa-192x192.png');
	shell_exec('sudo cp ' . $staticFilesDir . '/pwa-512x512.png ' . $mockDir . '/pwa-512x512.png');
    
    echo("\nMockado. Acesse o endereço: 'http://localhost/megahack2020_mock' em seu navegador\n\n");
   
	
?>
