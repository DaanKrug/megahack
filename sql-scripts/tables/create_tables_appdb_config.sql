CREATE TABLE  `module` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(100) COLLATE utf8mb4_general_ci NOT NULL,
  `active` tinyint(1) NOT NULL DEFAULT 1,
  `ownerId` bigint(20) UNSIGNED DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

ALTER TABLE `module`
  ADD PRIMARY KEY (`id`),
  ADD KEY `module_ownerid_index` (`ownerId`);

ALTER TABLE `module`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;
  
  
  
  
CREATE TABLE  `appconfig` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(50) COLLATE utf8mb4_general_ci NOT NULL,
  `description` varchar(250) COLLATE utf8mb4_general_ci NOT NULL,
  `site` varchar(250) COLLATE utf8mb4_general_ci NOT NULL,
  `usePricingPolicy` tinyint(1) NOT NULL DEFAULT 0,
  `pricingPolicy` text COLLATE utf8mb4_general_ci DEFAULT NULL,
  `usePrivacityPolicy` tinyint(1) NOT NULL DEFAULT 0,
  `privacityPolicy` text COLLATE utf8mb4_general_ci DEFAULT NULL,
  `useUsetermsPolicy` tinyint(1) NOT NULL DEFAULT 0,
  `usetermsPolicy` text COLLATE utf8mb4_general_ci DEFAULT NULL,
  `useUsecontractPolicy` tinyint(1) NOT NULL DEFAULT 0,
  `usecontractPolicy` text COLLATE utf8mb4_general_ci DEFAULT NULL,
  `useAuthorInfo` tinyint(1) NOT NULL DEFAULT 0,
  `authorInfo` text COLLATE utf8mb4_general_ci DEFAULT NULL,
  `active` tinyint(1) NOT NULL DEFAULT 0,
  `ownerId` bigint(20) UNSIGNED DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

ALTER TABLE `appconfig`
  ADD PRIMARY KEY (`id`),
  ADD KEY `appconfig_ownerid_index` (`ownerId`);

ALTER TABLE `appconfig`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

  
  

CREATE TABLE  `s3config` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `bucketName` varchar(250) COLLATE utf8mb4_general_ci NOT NULL,
  `bucketUrl` varchar(250) COLLATE utf8mb4_general_ci NOT NULL,
  `region` varchar(30) COLLATE utf8mb4_general_ci NOT NULL,
  `version` varchar(30) COLLATE utf8mb4_general_ci NOT NULL,
  `keyy` varchar(50) COLLATE utf8mb4_general_ci NOT NULL,
  `secret` varchar(100) COLLATE utf8mb4_general_ci NOT NULL,
  `active` tinyint(1) NOT NULL DEFAULT 0,
  `ownerId` bigint(20) UNSIGNED DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

ALTER TABLE `s3config`
  ADD PRIMARY KEY (`id`),
  ADD KEY `s3config_ownerid_index` (`ownerId`);

ALTER TABLE `s3config`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;
  
  


CREATE TABLE  `timesync` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `language` varchar(10) COLLATE utf8mb4_general_ci NOT NULL,
  `systemdiff` bigint(20) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

ALTER TABLE `timesync`
  ADD PRIMARY KEY (`id`);

ALTER TABLE `timesync`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;



