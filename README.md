

# Hackathon 5º Mega Hack | Shawee | Time XX | Desafio XX | Equipe Kentaurus

APP é um aplicativo que ajudará ....

## Tecnologias

Para a construção do protótipo estamos utilizando... 

 - Banco de Dados: Maria DB
 - Backend Desenvolvido em:  Elixir 
 - Front-End: 
   - Angular 9+ para parte administrativa e comunicação REST.
   - React JS para página pública e chat bot.

## Participantes

 - Daniel Krug (Full Stack Developer / Software Engineer)
   - https://www.linkedin.com/in/daniel-krug-427646b9/
   - https://github.com/DaanKrug
 - Deivid Gabriel (Full Stack Developer)
   - https://github.com/Fukubi
 - Henrique Nitatori (Backend Developer) 
   - https://github.com/henrique-nitatori
 - Katia Rocha (Marketing/UX)
   - https://www.linkedin.com/in/katia-rocha/
 


# Tips and Tricks

  - Rename file "/ex_app/lib/aapp_config/enviroment/enviroment.env.ex2" to "/ex_app/lib/aapp_config/enviroment/enviroment.env.ex" to run elixir backend app.
  - Create a folder "ex_app/priv/static" to store static files.
  - Adjust some .sh files to correct reference in your local enviroment.
  - Compilation/Execution:
    - 1 - cd /var/www/html/megahack2020/react-app
      - Install basic node_modules (copy for another React app for example)
      - npm install svg-gauge --save
      - npm install react-simple-chatbot --save
      - sudo ./react.sh dev
    - 2 - cd /var/www/html/megahack2020/ang-app
      - Install basic node_modules (copy for another Angular app for example)
      - npm install --save @ng-bootstrap/ng-bootstrap
      - npm install --save ngx-spinner
      - npm install --save ngx-mask
      - sudo ./ng.sh dev
    - 3 - cd /var/www/html/megahack2020/ex_app
      - sudo ./make_files.sh dev
      - sudo ./make_release.sh
      - sudo mix run --no-halt
  - Backup:
    - Repeat steps 1 and 2 of "Compilation/Execution"
    - Repeat steps 3 of "Compilation/Execution", except "sudo mix run --no-halt"
    - cd /var/www/html/megahack2020
      - sudo ./backup.sh dev
  - Mock React - to use remote server (if deployed already):
    - Uncoment some lines as described in "index.js" file on react-app dir.
  - Mock Angular - to use remote server (if deployed already):
    - cd /var/www/html/megahack2020/ang-app
      - sudo ./ng.sh mock
    - cd /var/www/html/megahack2020
      - sudo ./mock.sh
  - Initial database users (t3st3*externO123456):
    - INSERT INTO `user` (`id`, `name`, `email`, `password`, `category`, `permissions`, `active`, `confirmation_code`, `ownerId`, `created_at`, `updated_at`, `deleted_at`) VALUES (1, 'Your Name 1', '<email1_adminmaster>', '$2b$15$lGFA.1VmjptK5FhPqO0Aa.y/zEcUpoUfPNOhZeyo2HA7XWZ.S9cdm', 'admin_master', '', 1, '', 0, '2020-01-22 10:29:45', '2020-10-08 09:42:50', NULL),(2, 'Your Name 2', '<email2_admin>', '$2b$15$6fhKSVugjzAlLAVKQ50Fk.RmU99bgQrhU.mqqztgSCNb4sGIZ9HTC', 'admin', 'cancerdiagnostic_write,cancerdiagnostic,user_write,user', 1, '', 1, '2020-10-08 09:59:15', '2020-10-28 15:53:37', NULL);
      
      