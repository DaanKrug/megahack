
CREATE TABLE  `mailerconfig` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `provider` varchar(30) COLLATE utf8mb4_general_ci NOT NULL,
  `name` varchar(30) COLLATE utf8mb4_general_ci NOT NULL,
  `username` varchar(100) COLLATE utf8mb4_general_ci NOT NULL,
  `password` varchar(250) COLLATE utf8mb4_general_ci NOT NULL,
  `position` int(3) UNSIGNED NOT NULL DEFAULt 0,
  `perMonth` int(10) UNSIGNED NOT NULL,
  `perDay` int(10) UNSIGNED NOT NULL,
  `perHour` int(10) UNSIGNED NOT NULL,
  `perMinute` int(10) UNSIGNED NOT NULL,
  `perSecond` int(10) UNSIGNED NOT NULL,
  `replayTo` varchar(100) COLLATE utf8mb4_general_ci NOT NULL,
  `lastTimeUsed` bigint(20) UNSIGNED NOT NULL DEFAULT 0,
  `userId` bigint(20) UNSIGNED NOT NULL,
  `ownerId` bigint(20) UNSIGNED NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

ALTER TABLE `mailerconfig`
  ADD PRIMARY KEY (`id`);
  
ALTER TABLE `mailerconfig`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;
  



CREATE TABLE  `mailerconfigusedquota` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `mailerConfigId` bigint(20) UNSIGNED NOT NULL,
  `day` decimal(2,0) UNSIGNED NOT NULL,
  `month` decimal(2,0) UNSIGNED NOT NULL,
  `year` decimal(4,0) UNSIGNED NOT NULL,
  `hour` decimal(2,0) UNSIGNED NOT NULL,
  `minute` decimal(2,0) UNSIGNED NOT NULL,
  `second` decimal(2,0) UNSIGNED NOT NULL,
  `amount` int(10) UNSIGNED NOT NULL,
  `ownerId` bigint(20) UNSIGNED NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

ALTER TABLE `mailerconfigusedquota`
  ADD PRIMARY KEY (`id`);
  
ALTER TABLE `mailerconfigusedquota`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;
  
  


CREATE TABLE  `mailerusage` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `mailerConfigId` bigint(20) UNSIGNED NOT NULL,
  `userId` bigint(20) UNSIGNED NOT NULL,
  `day` decimal(2,0) UNSIGNED NOT NULL,
  `month` decimal(2,0) UNSIGNED NOT NULL,
  `year` decimal(4,0) UNSIGNED NOT NULL,
  `amount` int(10) UNSIGNED NOT NULL,
  `date` datetime NOT NULL,
  `provisioned` tinyint(1) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

ALTER TABLE `mailerusage`
  ADD PRIMARY KEY (`id`);

ALTER TABLE `mailerusage`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

