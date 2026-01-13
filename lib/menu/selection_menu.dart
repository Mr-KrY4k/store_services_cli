import 'dart:io';

class SelectionMenu {
  static Future<int> show() async {
    print('\n🚀 Store Services CLI');
    print('---------------------');
    print('1. GMS (Google Play Services)');
    print('2. HMS (Huawei Mobile Services)');
    print('3. Hybrid (GMS + HMS)');
    print('4. Clean (Удалить конфигурации)');
    print('---------------------');
    stdout.write('Выберите действие [1-4]: ');

    final input = stdin.readLineSync();
    final choice = int.tryParse(input ?? '') ?? 0;

    if (choice < 1 || choice > 4) {
      print('❌ Неверный выбор. Попробуйте снова.');
      return show();
    }

    return choice;
  }
}
