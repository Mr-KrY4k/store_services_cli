import 'dart:io';
import 'package:path/path.dart' as p;

abstract class BaseConfigurator {
  // --- Paths ---
  final String _androidPath = 'android';

  String get rootBuildGradle => p.join(_androidPath, 'build.gradle.kts');
  String get appBuildGradle => p.join(_androidPath, 'app', 'build.gradle.kts');
  String get settingsGradle => p.join(_androidPath, 'settings.gradle.kts');
  String get manifest =>
      p.join(_androidPath, 'app', 'src', 'main', 'AndroidManifest.xml');
  String get pubspec => 'pubspec.yaml';
  String get proguardRules => p.join(_androidPath, 'app', 'proguard-rules.pro');

  // --- Helpers ---

  Future<void> modifyFile(
    String path,
    String name,
    Future<String?> Function(String content) modifier,
  ) async {
    final file = File(path);
    if (!file.existsSync()) {
      print('⚠️ $path not found ($name skipped).');
      return;
    }

    String content = await file.readAsString();
    final newContent = await modifier(content);

    if (newContent != null && newContent != content) {
      await file.writeAsString(newContent);
      print('  ✅ Updated $path');
    }
  }

  /// Replaces a block named [blockName] (e.g. "buildTypes") with [replacement].
  /// Handles nested braces to find the end of the block.
  String? replaceBlock(String content, String blockName, String replacement) {
    final startIndex = content.indexOf('$blockName {');
    if (startIndex == -1) return null;

    int braceCount = 0;

    bool foundStart = false;
    int? blockEndIndex;

    // Iterate through content starting from the opening brace of the block
    for (int i = startIndex; i < content.length; i++) {
      if (content[i] == '{') {
        braceCount++;
        foundStart = true;
      } else if (content[i] == '}') {
        braceCount--;
      }

      if (foundStart && braceCount == 0) {
        blockEndIndex = i + 1; // Include the closing brace
        break;
      }
    }

    if (blockEndIndex != null) {
      return content.replaceRange(
        startIndex,
        blockEndIndex,
        replacement.trim(),
      );
    }
    return null;
  }
}
