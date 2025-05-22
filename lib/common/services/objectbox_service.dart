// filepath: lib/services/objectbox_service.dart

// ignore: depend_on_referenced_packages
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../../objectbox.g.dart'; // This will be generated after running build_runner, InshaaAllah

/// A service that handles ObjectBox initialization and provides access to the store.
class ObjectBoxService {
  static ObjectBoxService? _instance;
  late final Store _store;

  Store get store => _store;

  ObjectBoxService._create(this._store) {
    _instance = this;
  }

  /// Create an instance of ObjectBox to use throughout the app.
  static Future<ObjectBoxService> create() async {
    if (_instance != null) return _instance!;

    final docsDir = await getApplicationDocumentsDirectory();
    final store =
        await openStore(directory: p.join(docsDir.path, "barakah_db"));
    return ObjectBoxService._create(store);
  }

  /// Get the singleton instance of the ObjectBoxService.
  /// The service must be created with `create()` before calling this getter.
  static ObjectBoxService get instance {
    assert(_instance != null,
        'ObjectBoxService must be created with create() first');
    return _instance!;
  }

  /// Properly close the store on app shutdown
  void dispose() {
    _store.close();
  }
}
