import 'package:stash/src/api/entry.dart';

import 'cache_info.dart';

/// The wrapper around the object that is added to the cache
class CacheEntry extends Entry<CacheInfo> {
  /// The expiry time getter
  DateTime get expiryTime => info.expiryTime;

  /// The hit count getter
  int get hitCount => info.hitCount;

  /// Creates a [CacheEntry]
  ///
  /// * [info]: The cache info
  /// * [value]: The cache value
  /// * [state]: The entry state
  CacheEntry._(CacheInfo info, dynamic value, EntryState state)
      : super(info, value, state);

  /// Builds a new [CacheEntry]
  ///
  /// * [builder]: The [CacheEntry] builder
  CacheEntry._builder(CacheEntryBuilder builder)
      : this._(
            CacheInfo(builder.key, builder.creationTime,
                builder.creationTime.add(builder.expiryDuration),
                hitCount: builder.hitCount,
                accessTime: builder.accessTime,
                updateTime: builder.updateTime),
            builder.value,
            builder.state);

  /// Creates a new [CacheEntry]
  ///
  /// * [key]: The cache key
  /// * [creationTime]: The cache creation time
  /// * [expiryTime]: The cache expiry time
  /// * [value]: The cache value
  /// * [accessTime]: The cache access time
  /// * [updateTime]: The cache update time
  /// * [hitCount]: The cache hit count
  CacheEntry.loadEntry(
      String key, DateTime creationTime, DateTime expiryTime, dynamic value,
      {DateTime? accessTime, DateTime? updateTime, int? hitCount})
      : this._(
            CacheInfo(key, creationTime, expiryTime,
                hitCount: hitCount,
                accessTime: accessTime,
                updateTime: updateTime),
            value,
            EntryState.loaded);

  /// Copy the current [CacheEntry] and updates it
  ///
  /// * [value]: The cache value
  /// * [updateTime]: The cache update time
  /// * [hitCount]: The cache hit count
  /// * [expiryTime]: The cache expiry time
  CacheEntry updateValue(dynamic value, DateTime updateTime, int hitCount,
      {DateTime? expiryTime}) {
    return CacheEntry._(
        CacheInfo(key, creationTime, expiryTime ?? this.expiryTime,
            hitCount: hitCount, accessTime: accessTime, updateTime: updateTime),
        value,
        EntryState.updatedValue);
  }

  /// Updates the [Info] fields
  ///
  /// * [expiryTime]: The cache expiry time
  /// * [hitCount]: The cache hit count
  /// * [accessTime]: The cache access time
  /// * [updateTime]: The cache update time
  @override
  void updateInfoFields({
    DateTime? expiryTime,
    int? hitCount,
    DateTime? accessTime,
    DateTime? updateTime,
  }) {
    super.updateInfoFields(accessTime: accessTime, updateTime: updateTime);
    info.expiryTime = expiryTime ?? info.expiryTime;
    info.hitCount = hitCount ?? info.hitCount;
  }

  /// Updates a [CacheEntry] info
  ///
  /// * [info]: The updated info
  @override
  void updateInfo(CacheInfo info) {
    updateInfoFields(
      hitCount: info.hitCount,
      expiryTime: info.expiryTime,
      accessTime: info.accessTime,
      updateTime: info.updateTime,
    );
  }

  /// Checks if the cache entry is expired
  ///
  /// * [now]: An optional value for the current time
  ///
  /// Return true if expired, false if not
  bool isExpired([DateTime? now]) {
    return info.isExpired(now);
  }
}

/// The [CacheEntry] builder
class CacheEntryBuilder<T> extends EntryBuilder<T, CacheInfo, CacheEntry> {
  /// The expiry duration
  Duration expiryDuration;

  // The hit count
  int? hitCount;

  /// Builds a [CacheEntryBuilder]
  ///
  /// * [key]: The entry key
  /// * [value]: The entry value
  /// * [creationTime]: The entry creation time
  /// * [expiryDuration]: The entry expiry duration
  /// * [hitCount]: The entry hit count
  /// * [accessTime]: The access time
  /// * [updateTime]: The update time
  CacheEntryBuilder(
      String key, T value, DateTime creationTime, this.expiryDuration,
      {this.hitCount, DateTime? accessTime, DateTime? updateTime})
      : super(key, value, creationTime,
            accessTime: accessTime, updateTime: updateTime);

  @override
  CacheEntry build() {
    return CacheEntry._builder(this);
  }
}
