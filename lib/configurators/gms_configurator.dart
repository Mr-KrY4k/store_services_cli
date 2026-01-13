import 'package:store_services_cli/configurators/base_configurator.dart';

class GmsConfigurator extends BaseConfigurator {
  // --- Constants for GMS ---
  static const _gmsPluginId = 'com.google.gms.google-services';
  static const _gmsPluginVersion = '4.4.2';
  static const _crashlyticsPluginId = 'com.google.firebase.crashlytics';
  static const _crashlyticsPluginVersion = '3.0.2';

  static const _playServicesLocation =
      'com.google.android.gms:play-services-location:21.3.0';
  static const _installReferrer =
      'com.android.installreferrer:installreferrer:2.2';

  Future<void> apply() async {
    print('🔧 [GMS] Applying configuration...');

    await _modifySettingsGradle(); // NEW: Check settings for plugins
    await _modifyRootBuildGradle();
    await _modifyAppBuildGradle();
    await _modifyManifest();
    await _modifyPubspec();
    print('⚠️  Не забудьте добавить android/app/google-services.json');
    print(
      '⚠️  Не забудьте добавить иконку: android/app/src/main/res/drawable/firebase_icon_push.png',
    );
  }

  Future<void> remove() async {
    print('🧹 [GMS] Removing configuration...');
    await _removeSettingsGradle(); // NEW
    await _removeRootBuildGradle();
    await _removeAppBuildGradle();
    await _removeManifest();
    await _removePubspec();
  }

  Future<void> _modifySettingsGradle() async {
    await modifyFile(settingsGradle, 'Settings Gradle', (content) async {
      // Check for plugins block to add GMS if using modern Flutter structure
      if (!content.contains(_gmsPluginId)) {
        if (content.contains('plugins {')) {
          final replacement =
              'plugins {\n    id("$_gmsPluginId") version "$_gmsPluginVersion" apply false\n    id("$_crashlyticsPluginId") version "$_crashlyticsPluginVersion" apply false';
          return content.replaceFirst('plugins {', replacement);
        }
      }
      return null;
    });
  }

  Future<void> _removeSettingsGradle() async {
    await modifyFile(settingsGradle, 'Settings Gradle', (content) async {
      if (content.contains(_gmsPluginId)) {
        return content
            .replaceFirst(
              '\n    id("$_gmsPluginId") version "$_gmsPluginVersion" apply false',
              '',
            )
            .replaceFirst(
              '\n    id("$_crashlyticsPluginId") version "$_crashlyticsPluginVersion" apply false',
              '',
            );
      }
      return null;
    });
  }

  Future<void> _modifyRootBuildGradle() async {
    await modifyFile(rootBuildGradle, 'Root Gradle', (content) async {
      if (!content.contains(_gmsPluginId)) {
        if (content.contains('plugins {')) {
          final replacement =
              'plugins {\n    id("$_gmsPluginId") version "$_gmsPluginVersion" apply false\n    id("$_crashlyticsPluginId") version "$_crashlyticsPluginVersion" apply false';
          return content.replaceFirst('plugins {', replacement);
        }
      }
      return null;
    });
  }

  Future<void> _removeRootBuildGradle() async {
    await modifyFile(rootBuildGradle, 'Root Gradle', (content) async {
      if (content.contains(_gmsPluginId)) {
        return content
            .replaceFirst(
              '\n    id("$_gmsPluginId") version "$_gmsPluginVersion" apply false',
              '',
            )
            .replaceFirst(
              '\n    id("$_crashlyticsPluginId") version "$_crashlyticsPluginVersion" apply false',
              '',
            );
      }
      return null;
    });
  }

  Future<void> _modifyAppBuildGradle() async {
    await modifyFile(appBuildGradle, 'App Gradle', (content) async {
      var newContent = content;
      bool changed = false;

      // 1. Apply Plugins
      if (!newContent.contains('id("$_gmsPluginId")')) {
        // Try to add after com.android.application to ensure correct order
        if (newContent.contains('id("com.android.application")')) {
          newContent = newContent.replaceFirst(
            'id("com.android.application")',
            'id("com.android.application")\n    id("$_gmsPluginId")\n    id("$_crashlyticsPluginId")',
          );
          changed = true;
        } else if (newContent.contains('plugins {')) {
          // Fallback
          newContent = newContent.replaceFirst(
            'plugins {',
            'plugins {\n    id("$_gmsPluginId")\n    id("$_crashlyticsPluginId")',
          );
          changed = true;
        }
      }

      // 2. Add Dependencies
      if (!newContent.contains(_playServicesLocation)) {
        if (newContent.contains('dependencies {')) {
          newContent = newContent.replaceFirst(
            'dependencies {',
            'dependencies {\n    implementation("$_playServicesLocation")\n    implementation("$_installReferrer")',
          );
          changed = true;
        } else {
          // If dependencies block missing, add it at the end
          newContent +=
              '\n\ndependencies {\n    implementation("$_playServicesLocation")\n    implementation("$_installReferrer")\n}';
          changed = true;
        }
      }

      // 3. Replace buildTypes
      const userRequestedBuildTypes = '''
    buildTypes {
        getByName("release") {
            signingConfig = signingConfigs.getByName("release")
        }
        getByName("debug") {
            isDebuggable = true
        }
    }''';

      final replaced = replaceBlock(
        newContent,
        'buildTypes',
        userRequestedBuildTypes,
      );
      if (replaced != null && replaced != newContent) {
        newContent = replaced;
        changed = true;
      }

      return changed ? newContent : null;
    });
  }

  Future<void> _removeAppBuildGradle() async {
    await modifyFile(appBuildGradle, 'App Gradle', (content) async {
      var newContent = content;
      bool changed = false;

      if (newContent.contains(_gmsPluginId)) {
        newContent = newContent.replaceFirst('\n    id("$_gmsPluginId")', '');
        changed = true;
      }
      if (newContent.contains(_crashlyticsPluginId)) {
        newContent = newContent.replaceFirst(
          '\n    id("$_crashlyticsPluginId")',
          '',
        );
        changed = true;
      }
      if (newContent.contains(_playServicesLocation)) {
        newContent = newContent.replaceFirst(
          '\n    implementation("$_playServicesLocation")',
          '',
        );
        changed = true;
      }
      if (newContent.contains(_installReferrer)) {
        newContent = newContent.replaceFirst(
          '\n    implementation("$_installReferrer")',
          '',
        );
        changed = true;
      }

      // Restore clean buildTypes
      const cleanBuildTypes = '''
    buildTypes {
        release {
            // TODO: Add your own signing config for the release build.
            // Signing with the debug keys for now, so `flutter run --release` works.
            signingConfig = signingConfigs.getByName("debug")
        }
    }''';

      final replaced = replaceBlock(newContent, 'buildTypes', cleanBuildTypes);
      if (replaced != null) {
        newContent = replaced;
      }

      return changed || replaced != null ? newContent : null;
    });
  }

  Future<void> _modifyManifest() async {
    await modifyFile(manifest, 'Manifest', (content) async {
      // Variables for modification tracking
      var newContent = content;
      bool changed = false;

      // 0. Ensure xmlns:tools is present
      if (!newContent.contains('xmlns:tools')) {
        newContent = newContent.replaceFirst(
          '<manifest xmlns:android="http://schemas.android.com/apk/res/android"',
          '<manifest xmlns:android="http://schemas.android.com/apk/res/android" xmlns:tools="http://schemas.android.com/tools"',
        );
        changed = true;
      }

      // Permissions
      final permissions = [
        '<uses-permission android:name="android.permission.INTERNET"/>',
        '<uses-permission android:name="android.permission.ACCESS_NETWORK_STATE" />',
        '<uses-permission android:name="android.permission.ACCESS_WIFI_STATE" />',
        '<uses-permission android:name="com.google.android.gms.permission.AD_ID"/>',
        '<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" tools:node="remove" />',
      ];

      final appTagIndex = newContent.indexOf('<application');
      if (appTagIndex != -1) {
        for (var perm in permissions) {
          if (!newContent.contains(perm)) {
            newContent = newContent.replaceRange(
              appTagIndex,
              appTagIndex,
              '$perm\n    ',
            );
            changed = true;
          }
        }
      }

      // Meta-data
      const metaData =
          '<meta-data android:name="com.google.firebase.messaging.default_notification_icon" android:resource="@drawable/firebase_icon_push"/>';
      final appEndIndex = newContent.indexOf('</application>');
      if (appEndIndex != -1) {
        if (!newContent.contains(
          'com.google.firebase.messaging.default_notification_icon',
        )) {
          newContent = newContent.replaceRange(
            appEndIndex,
            appEndIndex,
            '    $metaData\n    ',
          );
          changed = true;
        }
      }

      return changed ? newContent : null;
    });
  }

  Future<void> _removeManifest() async {
    await modifyFile(manifest, 'Manifest', (content) async {
      var newContent = content;
      bool changed = false;
      final permissions = [
        '<uses-permission android:name="com.google.android.gms.permission.AD_ID"/>',
        '<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" tools:node="remove" />',
      ];
      for (var perm in permissions) {
        if (newContent.contains(perm)) {
          newContent = newContent
              .replaceFirst('$perm\n    ', '')
              .replaceFirst(perm, '');
          changed = true;
        }
      }

      // Remove Meta-data
      const metaData =
          '<meta-data android:name="com.google.firebase.messaging.default_notification_icon" android:resource="@drawable/firebase_icon_push"/>';
      if (newContent.contains(
        'com.google.firebase.messaging.default_notification_icon',
      )) {
        // Try exact match with indentation
        newContent = newContent
            .replaceFirst('    $metaData\n    ', '')
            .replaceFirst(metaData, '');
        changed = true;
      }
      return changed ? newContent : null;
    });
  }

  Future<void> _modifyPubspec() async {
    await modifyFile(pubspec, 'Pubspec', (content) async {
      final deps = [
        'firebase_analytics: ^12.0.0',
        'firebase_core: ^4.0.0',
        'firebase_crashlytics: ^5.0.0',
        'firebase_messaging: ^16.0.0',
        'firebase_remote_config: ^6.0.0',
        'advertising_id: ^2.7.1',
      ];

      var newContent = content;
      bool changed = false;

      if (newContent.contains('dependencies:')) {
        for (var dep in deps) {
          final depName = dep.split(':')[0];
          if (!newContent.contains(depName + ':')) {
            newContent = newContent.replaceFirst(
              'dependencies:',
              'dependencies:\n  $dep',
            );
            changed = true;
          }
        }
      }
      return changed ? newContent : null;
    });
  }

  Future<void> _removePubspec() async {
    await modifyFile(pubspec, 'Pubspec', (content) async {
      var newContent = content;
      bool changed = false;
      final deps = [
        'firebase_analytics: ^12.0.0',
        'firebase_core: ^4.0.0',
        'firebase_crashlytics: ^5.0.0',
        'firebase_messaging: ^16.0.0',
        'firebase_remote_config: ^6.0.0',
        'advertising_id: ^2.7.1',
      ];
      for (var dep in deps) {
        if (newContent.contains(dep)) {
          newContent = newContent
              .replaceFirst('\n  $dep', '')
              .replaceFirst(dep, '');
          changed = true;
        }
      }
      return changed ? newContent : null;
    });
  }
}
