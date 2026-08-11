
// class AppVersionResponse {
//   final int count;
//   final List<AppVersion> results;

//   AppVersionResponse({
//     required this.count,
//     required this.results,
//   });

//   factory AppVersionResponse.fromJson(Map<String, dynamic> json) {
//     return AppVersionResponse(
//       count: json['count'],
//       results: (json['results'] as List)
//           .map((e) => AppVersion.fromJson(e))
//           .toList(),
//     );
//   }
// }

// class AppVersion {
//   final String id;
//   final int installedCount;
//   final String approvalStatus;
//   final String appFile;
//   final String appIcon;
//   final String versionCode;
//   final String buildNumber;
//   final double sizeInMb;
//   final String hashString;
//   final String releaseName;
//   final String? releaseComments;
//   final String? releaseTrack;
//   final DateTime createdOn;
//   final DateTime updatedOn;
//   final String minSdkVersion;
//   final String targetSdkVersion;
//   final bool isDefault;
//   final bool isEnabled;
//   final String application;

//   AppVersion({
//     required this.id,
//     required this.installedCount,
//     required this.approvalStatus,
//     required this.appFile,
//     required this.appIcon,
//     required this.versionCode,
//     required this.buildNumber,
//     required this.sizeInMb,
//     required this.hashString,
//     required this.releaseName,
//     this.releaseComments,
//     this.releaseTrack,
//     required this.createdOn,
//     required this.updatedOn,
//     required this.minSdkVersion,
//     required this.targetSdkVersion,
//     required this.isDefault,
//     required this.isEnabled,
//     required this.application,
//   });

//   factory AppVersion.fromJson(Map<String, dynamic> json) {
//     return AppVersion(
//       id: json['id'],
//       installedCount: json['installed_count'],
//       approvalStatus: json['approval_status'],
//       appFile: json['app_file'],
//       appIcon: json['app_icon'],
//       versionCode: json['version_code'],
//       buildNumber: json['build_number'],
//       sizeInMb: (json['size_in_mb'] as num).toDouble(),
//       hashString: json['hash_string'],
//       releaseName: json['release_name'],
//       releaseComments: json['release_comments'],
//       releaseTrack: json['release_track'],
//       createdOn: DateTime.parse(json['created_on']),
//       updatedOn: DateTime.parse(json['updated_on']),
//       minSdkVersion: json['min_sdk_version'],
//       targetSdkVersion: json['target_sdk_version'],
//       isDefault: json['is_default'],
//       isEnabled: json['is_enabled'],
//       application: json['application'],
//     );
//   }
// }