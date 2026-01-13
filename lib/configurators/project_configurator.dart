import 'package:store_services_cli/configurators/gms_configurator.dart';
import 'package:store_services_cli/configurators/hms_configurator.dart';

class ProjectConfigurator {
  final _gms = GmsConfigurator();
  final _hms = HmsConfigurator();

  Future<void> applyGms() async {
    await clean(); // Clean everything first to avoid duplicates or conflicts
    await _gms.apply();
  }

  Future<void> applyHms() async {
    await clean();
    await _hms.apply();
  }

  Future<void> applyHybrid() async {
    print('🔧 Applying Hybrid configuration...');
    await clean(); // Reset state
    await _gms.apply();
    await _hms.apply();
  }

  Future<void> clean() async {
    print('🧹 Cleaning configurations...');
    await _gms.remove();
    await _hms.remove();
    print('✨ Clean complete.');
  }
}
