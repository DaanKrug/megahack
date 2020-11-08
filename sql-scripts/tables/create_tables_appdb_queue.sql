
CREATE TABLE  `simplemail` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `subject` varchar(200) COLLATE utf8mb4_general_ci NOT NULL,
  `content` text COLLATE utf8mb4_general_ci NOT NULL,
  `tosAddress` text COLLATE utf8mb4_general_ci NOT NULL,
  `successAddress` text COLLATE utf8mb4_general_ci DEFAULT NULL,
  `failAddress` text COLLATE utf8mb4_general_ci DEFAULT NULL,
  `failMessages` text COLLATE utf8mb4_general_ci DEFAULT NULL,
  `tosTotal` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `successTotal` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `failTotal` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `status` varchar(20) COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'awaiting',
  `randomKey` varchar(50) COLLATE utf8mb4_general_ci NOT NULL,
  `ownerId` bigint(20) UNSIGNED NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

ALTER TABLE `simplemail`
  ADD PRIMARY KEY (`id`);

ALTER TABLE `simplemail`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;




CREATE TABLE  `queuedmail` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `priority` decimal(2,0) UNSIGNED NOT NULL DEFAULT 0,
  `messageTitle` varchar(250) COLLATE utf8mb4_general_ci NOT NULL,
  `messageBody` text COLLATE utf8mb4_general_ci NOT NULL,
  `tto` varchar(250) COLLATE utf8mb4_general_ci NOT NULL,
  `times` decimal(2,0) UNSIGNED NOT NULL DEFAULT 0,
  `maxtimes` decimal(2,0) UNSIGNED NOT NULL DEFAULT 3,
  `lastTimeTried` bigint(20) UNSIGNED NOT NULL DEFAULT 0,
  `simpleMailId` bigint(20) UNSIGNED NOT NULL DEFAULT 0,
  `ownerId` bigint(20) UNSIGNED NOT NULL,
  `createdAt` bigint(20) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

ALTER TABLE `queuedmail`
  ADD PRIMARY KEY (`id`);

ALTER TABLE `queuedmail`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;



