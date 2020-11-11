
CREATE TABLE  `user` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(30) COLLATE utf8mb4_general_ci NOT NULL,
  `email` varchar(100) COLLATE utf8mb4_general_ci NOT NULL,
  `password` varchar(100) COLLATE utf8mb4_general_ci NOT NULL,
  `category` varchar(15) COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'admin',
  `permissions` text COLLATE utf8mb4_general_ci DEFAULT NULL,
  `active` tinyint(1) NOT NULL DEFAULT 1,
  `confirmation_code` varchar(20) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `ownerId` bigint(20) UNSIGNED DEFAULT 1,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

ALTER TABLE `user`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `user_email_unique` (`email`),
  ADD KEY `user_ownerid_index` (`ownerId`);

ALTER TABLE `user`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;
  
 

 
CREATE TABLE  `file` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(30) COLLATE utf8mb4_general_ci NOT NULL,
  `link` text COLLATE utf8mb4_general_ci NOT NULL,
  `ownerId` bigint(20) UNSIGNED NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

ALTER TABLE `file`
  ADD PRIMARY KEY (`id`),
  ADD KEY `file_name_index` (`name`),
  ADD KEY `file_ownerid_index` (`ownerId`);

ALTER TABLE `file`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;
  
  


CREATE TABLE  `image` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(100) COLLATE utf8mb4_general_ci NOT NULL,
  `link` text COLLATE utf8mb4_general_ci NOT NULL,
  `description` varchar(250) COLLATE utf8mb4_general_ci NOT NULL,
  `forPublic` tinyint(1) NOT NULL DEFAULT 0,
  `ownerId` bigint(20) UNSIGNED NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

ALTER TABLE `image`
  ADD PRIMARY KEY (`id`),
  ADD KEY `image_name_index` (`name`),
  ADD KEY `image_ownerid_index` (`ownerId`);

ALTER TABLE `image`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

  


CREATE TABLE  `pagemenu` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(250) COLLATE utf8mb4_general_ci NOT NULL,
  `position` decimal(3,0) UNSIGNED NOT NULL DEFAULT 0,
  `active` tinyint(1) NOT NULL DEFAULT 0,
  `ownerId` bigint(20) UNSIGNED NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

ALTER TABLE `pagemenu`
  ADD PRIMARY KEY (`id`);

ALTER TABLE `pagemenu`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;




CREATE TABLE  `pagemenuitem` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(250) COLLATE utf8mb4_general_ci NOT NULL,
  `content` text COLLATE utf8mb4_general_ci NOT NULL,
  `position` decimal(3,0) UNSIGNED NOT NULL DEFAULT 0,
  `active` tinyint(1) NOT NULL DEFAULT 0,
  `pageMenuId` bigint(20) UNSIGNED NOT NULL,
  `ownerId` bigint(20) UNSIGNED NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

ALTER TABLE `pagemenuitem`
  ADD PRIMARY KEY (`id`);

ALTER TABLE `pagemenuitem`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;




CREATE TABLE  `pagemenuitemfile` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(70) COLLATE utf8mb4_general_ci NOT NULL,
  `position` decimal(3,0) UNSIGNED NOT NULL DEFAULT 0,
  `fileId` bigint(20) UNSIGNED NOT NULL,
  `fileLink` text COLLATE utf8mb4_general_ci NOT NULL,
  `pageMenuItemId` bigint(20) UNSIGNED NOT NULL,
  `ownerId` bigint(20) UNSIGNED NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

ALTER TABLE `pagemenuitemfile`
  ADD PRIMARY KEY (`id`);
  
ALTER TABLE `pagemenuitemfile`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;




CREATE TABLE `additionaluserinfo` (
     `id` bigint(20) UNSIGNED NOT NULL,
     `a1_rg` varchar(20) COLLATE utf8mb4_general_ci NOT NULL,
     `a2_cpf` varchar(14) COLLATE utf8mb4_general_ci NOT NULL,
     `a3_cns` varchar(15) COLLATE utf8mb4_general_ci NOT NULL,
     `a4_phone` varchar(250) COLLATE utf8mb4_general_ci NOT NULL,
     `a5_address` varchar(500) COLLATE utf8mb4_general_ci NOT NULL,
     `a6_otherinfo` varchar(500) COLLATE utf8mb4_general_ci NOT NULL,
     `a7_userid` bigint(20) UNSIGNED NOT NULL DEFAULT 0,
     `ownerId` bigint(20) UNSIGNED NOT NULL,
     `created_at` timestamp NULL DEFAULT NULL,
     `updated_at` timestamp NULL DEFAULT NULL,
     `deleted_at` timestamp NULL DEFAULT NULL
   ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
   
ALTER TABLE `additionaluserinfo` ADD PRIMARY KEY (`id`);
   
ALTER TABLE `additionaluserinfo` MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;




CREATE TABLE `client` (
     `id` bigint(20) UNSIGNED NOT NULL,
     `a1_name` varchar(250) COLLATE utf8mb4_general_ci NOT NULL,
     `a2_type` varchar(2) COLLATE utf8mb4_general_ci NOT NULL,
     `a3_cpf` varchar(20) COLLATE utf8mb4_general_ci NOT NULL,
     `a4_cnpj` varchar(20) COLLATE utf8mb4_general_ci NOT NULL,
     `a5_birthdate` datetime DEFAULT NULL,
     `a6_doctype` varchar(30) COLLATE utf8mb4_general_ci NOT NULL,
     `a7_document` varchar(30) COLLATE utf8mb4_general_ci NOT NULL,
     `a8_gender` varchar(20) COLLATE utf8mb4_general_ci NOT NULL,
     `a9_email` varchar(100) COLLATE utf8mb4_general_ci NOT NULL,
     `a10_phone` varchar(250) COLLATE utf8mb4_general_ci NOT NULL,
     `a11_cep` varchar(10) COLLATE utf8mb4_general_ci NOT NULL,
     `a12_uf` varchar(2) COLLATE utf8mb4_general_ci NOT NULL,
     `a13_city` varchar(250) COLLATE utf8mb4_general_ci NOT NULL,
     `a14_street` varchar(250) COLLATE utf8mb4_general_ci NOT NULL,
     `a15_number` varchar(10) COLLATE utf8mb4_general_ci NOT NULL,
     `a16_compl1type` varchar(250) COLLATE utf8mb4_general_ci NOT NULL,
     `a17_compl1desc` varchar(250) COLLATE utf8mb4_general_ci NOT NULL,
     `a18_compl2type` varchar(250) COLLATE utf8mb4_general_ci NOT NULL,
     `a19_compl2desc` varchar(250) COLLATE utf8mb4_general_ci NOT NULL,
     `ownerId` bigint(20) UNSIGNED NOT NULL,
     `created_at` timestamp NULL DEFAULT NULL,
     `updated_at` timestamp NULL DEFAULT NULL,
     `deleted_at` timestamp NULL DEFAULT NULL
   ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
   
ALTER TABLE `client` ADD PRIMARY KEY (`id`);
   
ALTER TABLE `client` MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;




CREATE TABLE `solicitation` (
     `id` bigint(20) UNSIGNED NOT NULL,
     `a1_name` varchar(250) COLLATE utf8mb4_general_ci NOT NULL,
     `a3_cpf` varchar(20) COLLATE utf8mb4_general_ci NOT NULL,
     `a4_cnpj` varchar(20) COLLATE utf8mb4_general_ci NOT NULL,
     `a2_caracteristic` varchar(2) COLLATE utf8mb4_general_ci NOT NULL,
     `a5_cep` varchar(10) COLLATE utf8mb4_general_ci NOT NULL,
     `a6_uf` varchar(2) COLLATE utf8mb4_general_ci NOT NULL,
     `a7_city` varchar(250) COLLATE utf8mb4_general_ci NOT NULL,
     `a8_street` varchar(250) COLLATE utf8mb4_general_ci NOT NULL,
     `a9_number` varchar(10) COLLATE utf8mb4_general_ci NOT NULL,
     `a10_compl1type` varchar(250) COLLATE utf8mb4_general_ci NOT NULL,
     `a11_compl1desc` varchar(250) COLLATE utf8mb4_general_ci NOT NULL,
     `a12_compl2type` varchar(250) COLLATE utf8mb4_general_ci NOT NULL,
     `a13_compl2desc` varchar(250) COLLATE utf8mb4_general_ci NOT NULL,
     `a14_reference` varchar(250) COLLATE utf8mb4_general_ci NOT NULL,
     `a15_clientid` bigint(20) UNSIGNED NOT NULL DEFAULT 0,
     `active` tinyint(1) NOT NULL DEFAULT 0,
     `ownerId` bigint(20) UNSIGNED NOT NULL,
     `created_at` timestamp NULL DEFAULT NULL,
     `updated_at` timestamp NULL DEFAULT NULL,
     `deleted_at` timestamp NULL DEFAULT NULL
   ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
   
ALTER TABLE `solicitation` ADD PRIMARY KEY (`id`);
   
ALTER TABLE `solicitation` MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;




CREATE TABLE `consumerunit` (
     `id` bigint(20) UNSIGNED NOT NULL,
     `a1_name` varchar(250) COLLATE utf8mb4_general_ci NOT NULL,
     `a3_cpf` varchar(20) COLLATE utf8mb4_general_ci NOT NULL,
     `a4_cnpj` varchar(20) COLLATE utf8mb4_general_ci NOT NULL,
     `a2_caracteristic` varchar(2) COLLATE utf8mb4_general_ci NOT NULL,
     `a5_cep` varchar(10) COLLATE utf8mb4_general_ci NOT NULL,
     `a6_uf` varchar(2) COLLATE utf8mb4_general_ci NOT NULL,
     `a7_city` varchar(250) COLLATE utf8mb4_general_ci NOT NULL,
     `a8_street` varchar(250) COLLATE utf8mb4_general_ci NOT NULL,
     `a9_number` varchar(10) COLLATE utf8mb4_general_ci NOT NULL,
     `a10_compl1type` varchar(250) COLLATE utf8mb4_general_ci NOT NULL,
     `a11_compl1desc` varchar(250) COLLATE utf8mb4_general_ci NOT NULL,
     `a12_compl2type` varchar(250) COLLATE utf8mb4_general_ci NOT NULL,
     `a13_compl2desc` varchar(250) COLLATE utf8mb4_general_ci NOT NULL,
     `a14_reference` varchar(250) COLLATE utf8mb4_general_ci NOT NULL,
     `a15_clientid` bigint(20) UNSIGNED NOT NULL DEFAULT 0,
     `a16_solicitationid` bigint(20) UNSIGNED NOT NULL DEFAULT 0,
     `ownerId` bigint(20) UNSIGNED NOT NULL,
     `created_at` timestamp NULL DEFAULT NULL,
     `updated_at` timestamp NULL DEFAULT NULL,
     `deleted_at` timestamp NULL DEFAULT NULL
   ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
   
ALTER TABLE `consumerunit` ADD PRIMARY KEY (`id`);
   
ALTER TABLE `consumerunit` MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;