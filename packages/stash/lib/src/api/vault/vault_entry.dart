import 'package:stash/src/api/entry.dart';

import 'vault_info.dart';

/// The wrapper around the object that added to the vault
class VaultEntry extends Entry<VaultInfo> {
  /// Builds a [VaultEntry]
  ///
  /// * [info]: The entry info
  /// * [value]: The entry value
  /// * [state]: The entry state
  VaultEntry._(VaultInfo info, dynamic value, EntryState state)
      : super(info, value, state);

  /// Builds a new [VaultEntry]
  ///
  /// * [builder]: The [VaultEntry] builder
  VaultEntry._builder(VaultEntryBuilder builder)
      : this._(
            VaultInfo(builder.key, builder.creationTime,
                accessTime: builder.accessTime, updateTime: builder.updateTime),
            builder.value,
            builder.state);

  /// Loads a new [VaultEntry]
  ///
  /// * [key]: The vault key
  /// * [creationTime]: The vault creation time
  /// * [value]: The vault value
  /// * [accessTime]: The vault access time
  /// * [updateTime]: The vault update time
  VaultEntry.loadEntry(String key, DateTime creationTime, dynamic value,
      {DateTime? accessTime, DateTime? updateTime})
      : this._(
            VaultInfo(key, creationTime,
                accessTime: accessTime, updateTime: updateTime),
            value,
            EntryState.loaded);

  /// Updates the [VaultEntry] value
  ///
  /// * [value]: The vault value
  /// * [updateTime]: The vault update time
  VaultEntry updateValue(dynamic value, DateTime updateTime) {
    return VaultEntry._(
        VaultInfo(key, creationTime,
            accessTime: accessTime, updateTime: updateTime),
        value,
        EntryState.updatedValue);
  }
}

/// The [VaultEntry] builder
class VaultEntryBuilder<T> extends EntryBuilder<T, VaultInfo, VaultEntry> {
  /// Builds a [VaultEntryBuilder]
  ///
  /// * [key]: The entry key
  /// * [value]: The entry value
  /// * [creationTime]: The entry creation time
  /// * [accessTime]: The access time
  /// * [updateTime]: The update time
  VaultEntryBuilder(String key, T value, DateTime creationTime)
      : super(key, value, creationTime);

  @override
  VaultEntry build() {
    return VaultEntry._builder(this);
  }
}
