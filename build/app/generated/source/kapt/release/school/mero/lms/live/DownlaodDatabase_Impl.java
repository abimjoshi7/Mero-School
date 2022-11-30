package school.mero.lms.live;

import androidx.room.DatabaseConfiguration;
import androidx.room.InvalidationTracker;
import androidx.room.RoomOpenHelper;
import androidx.room.RoomOpenHelper.Delegate;
import androidx.room.RoomOpenHelper.ValidationResult;
import androidx.room.util.DBUtil;
import androidx.room.util.TableInfo;
import androidx.room.util.TableInfo.Column;
import androidx.room.util.TableInfo.ForeignKey;
import androidx.room.util.TableInfo.Index;
import androidx.sqlite.db.SupportSQLiteDatabase;
import androidx.sqlite.db.SupportSQLiteOpenHelper;
import androidx.sqlite.db.SupportSQLiteOpenHelper.Callback;
import androidx.sqlite.db.SupportSQLiteOpenHelper.Configuration;
import java.lang.Class;
import java.lang.Override;
import java.lang.String;
import java.lang.SuppressWarnings;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;
import school.mero.lms.courseCache.VideoCacheDao;
import school.mero.lms.courseCache.VideoCacheDao_Impl;

@SuppressWarnings({"unchecked", "deprecation"})
public final class DownlaodDatabase_Impl extends DownlaodDatabase {
  private volatile VideoCacheDao _videoCacheDao;

  @Override
  protected SupportSQLiteOpenHelper createOpenHelper(DatabaseConfiguration configuration) {
    final SupportSQLiteOpenHelper.Callback _openCallback = new RoomOpenHelper(configuration, new RoomOpenHelper.Delegate(15) {
      @Override
      public void createAllTables(SupportSQLiteDatabase _db) {
        _db.execSQL("CREATE TABLE IF NOT EXISTS `VideoCache` (`url` TEXT NOT NULL, `title` TEXT, `state` INTEGER, `proxy` TEXT, `duration` TEXT, `thumbnail` TEXT, `json` TEXT, `courseId` INTEGER, `percent` REAL, `expiry` INTEGER, PRIMARY KEY(`url`))");
        _db.execSQL("CREATE TABLE IF NOT EXISTS room_master_table (id INTEGER PRIMARY KEY,identity_hash TEXT)");
        _db.execSQL("INSERT OR REPLACE INTO room_master_table (id,identity_hash) VALUES(42, 'fd2777b538c47813db91c246d124eda1')");
      }

      @Override
      public void dropAllTables(SupportSQLiteDatabase _db) {
        _db.execSQL("DROP TABLE IF EXISTS `VideoCache`");
        if (mCallbacks != null) {
          for (int _i = 0, _size = mCallbacks.size(); _i < _size; _i++) {
            mCallbacks.get(_i).onDestructiveMigration(_db);
          }
        }
      }

      @Override
      protected void onCreate(SupportSQLiteDatabase _db) {
        if (mCallbacks != null) {
          for (int _i = 0, _size = mCallbacks.size(); _i < _size; _i++) {
            mCallbacks.get(_i).onCreate(_db);
          }
        }
      }

      @Override
      public void onOpen(SupportSQLiteDatabase _db) {
        mDatabase = _db;
        internalInitInvalidationTracker(_db);
        if (mCallbacks != null) {
          for (int _i = 0, _size = mCallbacks.size(); _i < _size; _i++) {
            mCallbacks.get(_i).onOpen(_db);
          }
        }
      }

      @Override
      public void onPreMigrate(SupportSQLiteDatabase _db) {
        DBUtil.dropFtsSyncTriggers(_db);
      }

      @Override
      public void onPostMigrate(SupportSQLiteDatabase _db) {
      }

      @Override
      protected RoomOpenHelper.ValidationResult onValidateSchema(SupportSQLiteDatabase _db) {
        final HashMap<String, TableInfo.Column> _columnsVideoCache = new HashMap<String, TableInfo.Column>(10);
        _columnsVideoCache.put("url", new TableInfo.Column("url", "TEXT", true, 1, null, TableInfo.CREATED_FROM_ENTITY));
        _columnsVideoCache.put("title", new TableInfo.Column("title", "TEXT", false, 0, null, TableInfo.CREATED_FROM_ENTITY));
        _columnsVideoCache.put("state", new TableInfo.Column("state", "INTEGER", false, 0, null, TableInfo.CREATED_FROM_ENTITY));
        _columnsVideoCache.put("proxy", new TableInfo.Column("proxy", "TEXT", false, 0, null, TableInfo.CREATED_FROM_ENTITY));
        _columnsVideoCache.put("duration", new TableInfo.Column("duration", "TEXT", false, 0, null, TableInfo.CREATED_FROM_ENTITY));
        _columnsVideoCache.put("thumbnail", new TableInfo.Column("thumbnail", "TEXT", false, 0, null, TableInfo.CREATED_FROM_ENTITY));
        _columnsVideoCache.put("json", new TableInfo.Column("json", "TEXT", false, 0, null, TableInfo.CREATED_FROM_ENTITY));
        _columnsVideoCache.put("courseId", new TableInfo.Column("courseId", "INTEGER", false, 0, null, TableInfo.CREATED_FROM_ENTITY));
        _columnsVideoCache.put("percent", new TableInfo.Column("percent", "REAL", false, 0, null, TableInfo.CREATED_FROM_ENTITY));
        _columnsVideoCache.put("expiry", new TableInfo.Column("expiry", "INTEGER", false, 0, null, TableInfo.CREATED_FROM_ENTITY));
        final HashSet<TableInfo.ForeignKey> _foreignKeysVideoCache = new HashSet<TableInfo.ForeignKey>(0);
        final HashSet<TableInfo.Index> _indicesVideoCache = new HashSet<TableInfo.Index>(0);
        final TableInfo _infoVideoCache = new TableInfo("VideoCache", _columnsVideoCache, _foreignKeysVideoCache, _indicesVideoCache);
        final TableInfo _existingVideoCache = TableInfo.read(_db, "VideoCache");
        if (! _infoVideoCache.equals(_existingVideoCache)) {
          return new RoomOpenHelper.ValidationResult(false, "VideoCache(school.mero.lms.courseCache.VideoCache).\n"
                  + " Expected:\n" + _infoVideoCache + "\n"
                  + " Found:\n" + _existingVideoCache);
        }
        return new RoomOpenHelper.ValidationResult(true, null);
      }
    }, "fd2777b538c47813db91c246d124eda1", "7c6dc2ab94e3791702f295a056bdabaf");
    final SupportSQLiteOpenHelper.Configuration _sqliteConfig = SupportSQLiteOpenHelper.Configuration.builder(configuration.context)
        .name(configuration.name)
        .callback(_openCallback)
        .build();
    final SupportSQLiteOpenHelper _helper = configuration.sqliteOpenHelperFactory.create(_sqliteConfig);
    return _helper;
  }

  @Override
  protected InvalidationTracker createInvalidationTracker() {
    final HashMap<String, String> _shadowTablesMap = new HashMap<String, String>(0);
    HashMap<String, Set<String>> _viewTables = new HashMap<String, Set<String>>(0);
    return new InvalidationTracker(this, _shadowTablesMap, _viewTables, "VideoCache");
  }

  @Override
  public void clearAllTables() {
    super.assertNotMainThread();
    final SupportSQLiteDatabase _db = super.getOpenHelper().getWritableDatabase();
    try {
      super.beginTransaction();
      _db.execSQL("DELETE FROM `VideoCache`");
      super.setTransactionSuccessful();
    } finally {
      super.endTransaction();
      _db.query("PRAGMA wal_checkpoint(FULL)").close();
      if (!_db.inTransaction()) {
        _db.execSQL("VACUUM");
      }
    }
  }

  @Override
  protected Map<Class<?>, List<Class<?>>> getRequiredTypeConverters() {
    final HashMap<Class<?>, List<Class<?>>> _typeConvertersMap = new HashMap<Class<?>, List<Class<?>>>();
    _typeConvertersMap.put(VideoCacheDao.class, VideoCacheDao_Impl.getRequiredConverters());
    return _typeConvertersMap;
  }

  @Override
  public VideoCacheDao videoCacheDao() {
    if (_videoCacheDao != null) {
      return _videoCacheDao;
    } else {
      synchronized(this) {
        if(_videoCacheDao == null) {
          _videoCacheDao = new VideoCacheDao_Impl(this);
        }
        return _videoCacheDao;
      }
    }
  }
}
