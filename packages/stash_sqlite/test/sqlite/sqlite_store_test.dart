import 'package:drift/drift.dart';
import 'package:stash_sqlite/stash_sqlite.dart';
import 'package:stash_test/stash_test.dart';

class VaultStoreContext extends VaultTestContext<SqliteVaultStore> {
  VaultStoreContext(ValueGenerator generator,
      {dynamic Function(Map<String, dynamic>)? fromEncodable})
      : super(generator, fromEncodable: generator.fromEncodable);

  @override
  Future<SqliteVaultStore> newStore() {
    return newSqliteMemoryVaultStore(fromEncodable: fromEncodable);
  }
}

class CacheStoreContext extends CacheTestContext<SqliteCacheStore> {
  CacheStoreContext(ValueGenerator generator,
      {dynamic Function(Map<String, dynamic>)? fromEncodable})
      : super(generator, fromEncodable: generator.fromEncodable);

  @override
  Future<SqliteCacheStore> newStore() {
    return newSqliteMemoryCacheStore(fromEncodable: fromEncodable);
  }
}

void main() async {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;

  testStore((generator) => VaultStoreContext(generator));
  testStore((generator) => CacheStoreContext(generator));
  testVault((generator) => VaultStoreContext(generator));
  testCache((generator) => CacheStoreContext(generator));
}
