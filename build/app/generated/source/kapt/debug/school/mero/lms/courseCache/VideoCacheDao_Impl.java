package school.mero.lms.courseCache;

import android.database.Cursor;
import androidx.lifecycle.LiveData;
import androidx.room.CoroutinesRoom;
import androidx.room.EntityDeletionOrUpdateAdapter;
import androidx.room.EntityInsertionAdapter;
import androidx.room.RoomDatabase;
import androidx.room.RoomSQLiteQuery;
import androidx.room.SharedSQLiteStatement;
import androidx.room.util.CursorUtil;
import androidx.room.util.DBUtil;
import androidx.sqlite.db.SupportSQLiteStatement;
import java.lang.Class;
import java.lang.Double;
import java.lang.Exception;
import java.lang.Integer;
import java.lang.Long;
import java.lang.Object;
import java.lang.Override;
import java.lang.String;
import java.lang.SuppressWarnings;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.concurrent.Callable;
import kotlin.Unit;
import kotlin.coroutines.Continuation;
import kotlinx.coroutines.flow.Flow;

@SuppressWarnings({"unchecked", "deprecation"})
public final class VideoCacheDao_Impl implements VideoCacheDao {
  private final RoomDatabase __db;

  private final EntityInsertionAdapter<VideoCache> __insertionAdapterOfVideoCache;

  private final EntityDeletionOrUpdateAdapter<VideoCache> __deletionAdapterOfVideoCache;

  private final SharedSQLiteStatement __preparedStmtOfDeleteAll;

  private final SharedSQLiteStatement __preparedStmtOfDeleteAllWithCourse;

  private final SharedSQLiteStatement __preparedStmtOfDeleteDownloads;

  private final SharedSQLiteStatement __preparedStmtOfUpdateState;

  private final SharedSQLiteStatement __preparedStmtOfUpdateWithCourse;

  public VideoCacheDao_Impl(RoomDatabase __db) {
    this.__db = __db;
    this.__insertionAdapterOfVideoCache = new EntityInsertionAdapter<VideoCache>(__db) {
      @Override
      public String createQuery() {
        return "INSERT OR REPLACE INTO `VideoCache` (`url`,`title`,`state`,`proxy`,`duration`,`thumbnail`,`json`,`courseId`,`percent`,`expiry`) VALUES (?,?,?,?,?,?,?,?,?,?)";
      }

      @Override
      public void bind(SupportSQLiteStatement stmt, VideoCache value) {
        if (value.getUrl() == null) {
          stmt.bindNull(1);
        } else {
          stmt.bindString(1, value.getUrl());
        }
        if (value.getTitle() == null) {
          stmt.bindNull(2);
        } else {
          stmt.bindString(2, value.getTitle());
        }
        if (value.getState() == null) {
          stmt.bindNull(3);
        } else {
          stmt.bindLong(3, value.getState());
        }
        if (value.getProxy() == null) {
          stmt.bindNull(4);
        } else {
          stmt.bindString(4, value.getProxy());
        }
        if (value.getDuration() == null) {
          stmt.bindNull(5);
        } else {
          stmt.bindString(5, value.getDuration());
        }
        if (value.getThumbnail() == null) {
          stmt.bindNull(6);
        } else {
          stmt.bindString(6, value.getThumbnail());
        }
        if (value.getJson() == null) {
          stmt.bindNull(7);
        } else {
          stmt.bindString(7, value.getJson());
        }
        if (value.getCourseId() == null) {
          stmt.bindNull(8);
        } else {
          stmt.bindLong(8, value.getCourseId());
        }
        if (value.getPercent() == null) {
          stmt.bindNull(9);
        } else {
          stmt.bindDouble(9, value.getPercent());
        }
        if (value.getExpiry() == null) {
          stmt.bindNull(10);
        } else {
          stmt.bindLong(10, value.getExpiry());
        }
      }
    };
    this.__deletionAdapterOfVideoCache = new EntityDeletionOrUpdateAdapter<VideoCache>(__db) {
      @Override
      public String createQuery() {
        return "DELETE FROM `VideoCache` WHERE `url` = ?";
      }

      @Override
      public void bind(SupportSQLiteStatement stmt, VideoCache value) {
        if (value.getUrl() == null) {
          stmt.bindNull(1);
        } else {
          stmt.bindString(1, value.getUrl());
        }
      }
    };
    this.__preparedStmtOfDeleteAll = new SharedSQLiteStatement(__db) {
      @Override
      public String createQuery() {
        final String _query = "DELETE FROM VideoCache";
        return _query;
      }
    };
    this.__preparedStmtOfDeleteAllWithCourse = new SharedSQLiteStatement(__db) {
      @Override
      public String createQuery() {
        final String _query = "DELETE from VideoCache WHERE courseId =?";
        return _query;
      }
    };
    this.__preparedStmtOfDeleteDownloads = new SharedSQLiteStatement(__db) {
      @Override
      public String createQuery() {
        final String _query = "DELETE from VideoCache WHERE url =?";
        return _query;
      }
    };
    this.__preparedStmtOfUpdateState = new SharedSQLiteStatement(__db) {
      @Override
      public String createQuery() {
        final String _query = "UPDATE VideoCache SET state=? , percent=? WHERE url = ?";
        return _query;
      }
    };
    this.__preparedStmtOfUpdateWithCourse = new SharedSQLiteStatement(__db) {
      @Override
      public String createQuery() {
        final String _query = "UPDATE VideoCache SET expiry=? WHERE courseId =?";
        return _query;
      }
    };
  }

  @Override
  public Object insert(final VideoCache notification,
      final Continuation<? super Unit> continuation) {
    return CoroutinesRoom.execute(__db, true, new Callable<Unit>() {
      @Override
      public Unit call() throws Exception {
        __db.beginTransaction();
        try {
          __insertionAdapterOfVideoCache.insert(notification);
          __db.setTransactionSuccessful();
          return Unit.INSTANCE;
        } finally {
          __db.endTransaction();
        }
      }
    }, continuation);
  }

  @Override
  public void insertSingle(final VideoCache notification) {
    __db.assertNotSuspendingTransaction();
    __db.beginTransaction();
    try {
      __insertionAdapterOfVideoCache.insert(notification);
      __db.setTransactionSuccessful();
    } finally {
      __db.endTransaction();
    }
  }

  @Override
  public void insertAll(final List<VideoCache> ads) {
    __db.assertNotSuspendingTransaction();
    __db.beginTransaction();
    try {
      __insertionAdapterOfVideoCache.insert(ads);
      __db.setTransactionSuccessful();
    } finally {
      __db.endTransaction();
    }
  }

  @Override
  public Object delete(final VideoCache downloads, final Continuation<? super Unit> continuation) {
    return CoroutinesRoom.execute(__db, true, new Callable<Unit>() {
      @Override
      public Unit call() throws Exception {
        __db.beginTransaction();
        try {
          __deletionAdapterOfVideoCache.handle(downloads);
          __db.setTransactionSuccessful();
          return Unit.INSTANCE;
        } finally {
          __db.endTransaction();
        }
      }
    }, continuation);
  }

  @Override
  public Object deleteAll(final Continuation<? super Unit> continuation) {
    return CoroutinesRoom.execute(__db, true, new Callable<Unit>() {
      @Override
      public Unit call() throws Exception {
        final SupportSQLiteStatement _stmt = __preparedStmtOfDeleteAll.acquire();
        __db.beginTransaction();
        try {
          _stmt.executeUpdateDelete();
          __db.setTransactionSuccessful();
          return Unit.INSTANCE;
        } finally {
          __db.endTransaction();
          __preparedStmtOfDeleteAll.release(_stmt);
        }
      }
    }, continuation);
  }

  @Override
  public void deleteAllWithCourse(final int cid) {
    __db.assertNotSuspendingTransaction();
    final SupportSQLiteStatement _stmt = __preparedStmtOfDeleteAllWithCourse.acquire();
    int _argIndex = 1;
    _stmt.bindLong(_argIndex, cid);
    __db.beginTransaction();
    try {
      _stmt.executeUpdateDelete();
      __db.setTransactionSuccessful();
    } finally {
      __db.endTransaction();
      __preparedStmtOfDeleteAllWithCourse.release(_stmt);
    }
  }

  @Override
  public void deleteDownloads(final String dId) {
    __db.assertNotSuspendingTransaction();
    final SupportSQLiteStatement _stmt = __preparedStmtOfDeleteDownloads.acquire();
    int _argIndex = 1;
    if (dId == null) {
      _stmt.bindNull(_argIndex);
    } else {
      _stmt.bindString(_argIndex, dId);
    }
    __db.beginTransaction();
    try {
      _stmt.executeUpdateDelete();
      __db.setTransactionSuccessful();
    } finally {
      __db.endTransaction();
      __preparedStmtOfDeleteDownloads.release(_stmt);
    }
  }

  @Override
  public Object updateState(final int state, final String url, final double percent,
      final Continuation<? super Unit> continuation) {
    return CoroutinesRoom.execute(__db, true, new Callable<Unit>() {
      @Override
      public Unit call() throws Exception {
        final SupportSQLiteStatement _stmt = __preparedStmtOfUpdateState.acquire();
        int _argIndex = 1;
        _stmt.bindLong(_argIndex, state);
        _argIndex = 2;
        _stmt.bindDouble(_argIndex, percent);
        _argIndex = 3;
        if (url == null) {
          _stmt.bindNull(_argIndex);
        } else {
          _stmt.bindString(_argIndex, url);
        }
        __db.beginTransaction();
        try {
          _stmt.executeUpdateDelete();
          __db.setTransactionSuccessful();
          return Unit.INSTANCE;
        } finally {
          __db.endTransaction();
          __preparedStmtOfUpdateState.release(_stmt);
        }
      }
    }, continuation);
  }

  @Override
  public void updateWithCourse(final int cid, final long exp_date) {
    __db.assertNotSuspendingTransaction();
    final SupportSQLiteStatement _stmt = __preparedStmtOfUpdateWithCourse.acquire();
    int _argIndex = 1;
    _stmt.bindLong(_argIndex, exp_date);
    _argIndex = 2;
    _stmt.bindLong(_argIndex, cid);
    __db.beginTransaction();
    try {
      _stmt.executeUpdateDelete();
      __db.setTransactionSuccessful();
    } finally {
      __db.endTransaction();
      __preparedStmtOfUpdateWithCourse.release(_stmt);
    }
  }

  @Override
  public Flow<List<VideoCache>> getAllDownloads() {
    final String _sql = "SELECT * from VideoCache";
    final RoomSQLiteQuery _statement = RoomSQLiteQuery.acquire(_sql, 0);
    return CoroutinesRoom.createFlow(__db, false, new String[]{"VideoCache"}, new Callable<List<VideoCache>>() {
      @Override
      public List<VideoCache> call() throws Exception {
        final Cursor _cursor = DBUtil.query(__db, _statement, false, null);
        try {
          final int _cursorIndexOfUrl = CursorUtil.getColumnIndexOrThrow(_cursor, "url");
          final int _cursorIndexOfTitle = CursorUtil.getColumnIndexOrThrow(_cursor, "title");
          final int _cursorIndexOfState = CursorUtil.getColumnIndexOrThrow(_cursor, "state");
          final int _cursorIndexOfProxy = CursorUtil.getColumnIndexOrThrow(_cursor, "proxy");
          final int _cursorIndexOfDuration = CursorUtil.getColumnIndexOrThrow(_cursor, "duration");
          final int _cursorIndexOfThumbnail = CursorUtil.getColumnIndexOrThrow(_cursor, "thumbnail");
          final int _cursorIndexOfJson = CursorUtil.getColumnIndexOrThrow(_cursor, "json");
          final int _cursorIndexOfCourseId = CursorUtil.getColumnIndexOrThrow(_cursor, "courseId");
          final int _cursorIndexOfPercent = CursorUtil.getColumnIndexOrThrow(_cursor, "percent");
          final int _cursorIndexOfExpiry = CursorUtil.getColumnIndexOrThrow(_cursor, "expiry");
          final List<VideoCache> _result = new ArrayList<VideoCache>(_cursor.getCount());
          while(_cursor.moveToNext()) {
            final VideoCache _item;
            final String _tmpUrl;
            if (_cursor.isNull(_cursorIndexOfUrl)) {
              _tmpUrl = null;
            } else {
              _tmpUrl = _cursor.getString(_cursorIndexOfUrl);
            }
            _item = new VideoCache(_tmpUrl);
            final String _tmpTitle;
            if (_cursor.isNull(_cursorIndexOfTitle)) {
              _tmpTitle = null;
            } else {
              _tmpTitle = _cursor.getString(_cursorIndexOfTitle);
            }
            _item.setTitle(_tmpTitle);
            final Integer _tmpState;
            if (_cursor.isNull(_cursorIndexOfState)) {
              _tmpState = null;
            } else {
              _tmpState = _cursor.getInt(_cursorIndexOfState);
            }
            _item.setState(_tmpState);
            final String _tmpProxy;
            if (_cursor.isNull(_cursorIndexOfProxy)) {
              _tmpProxy = null;
            } else {
              _tmpProxy = _cursor.getString(_cursorIndexOfProxy);
            }
            _item.setProxy(_tmpProxy);
            final String _tmpDuration;
            if (_cursor.isNull(_cursorIndexOfDuration)) {
              _tmpDuration = null;
            } else {
              _tmpDuration = _cursor.getString(_cursorIndexOfDuration);
            }
            _item.setDuration(_tmpDuration);
            final String _tmpThumbnail;
            if (_cursor.isNull(_cursorIndexOfThumbnail)) {
              _tmpThumbnail = null;
            } else {
              _tmpThumbnail = _cursor.getString(_cursorIndexOfThumbnail);
            }
            _item.setThumbnail(_tmpThumbnail);
            final String _tmpJson;
            if (_cursor.isNull(_cursorIndexOfJson)) {
              _tmpJson = null;
            } else {
              _tmpJson = _cursor.getString(_cursorIndexOfJson);
            }
            _item.setJson(_tmpJson);
            final Integer _tmpCourseId;
            if (_cursor.isNull(_cursorIndexOfCourseId)) {
              _tmpCourseId = null;
            } else {
              _tmpCourseId = _cursor.getInt(_cursorIndexOfCourseId);
            }
            _item.setCourseId(_tmpCourseId);
            final Double _tmpPercent;
            if (_cursor.isNull(_cursorIndexOfPercent)) {
              _tmpPercent = null;
            } else {
              _tmpPercent = _cursor.getDouble(_cursorIndexOfPercent);
            }
            _item.setPercent(_tmpPercent);
            final Long _tmpExpiry;
            if (_cursor.isNull(_cursorIndexOfExpiry)) {
              _tmpExpiry = null;
            } else {
              _tmpExpiry = _cursor.getLong(_cursorIndexOfExpiry);
            }
            _item.setExpiry(_tmpExpiry);
            _result.add(_item);
          }
          return _result;
        } finally {
          _cursor.close();
        }
      }

      @Override
      protected void finalize() {
        _statement.release();
      }
    });
  }

  @Override
  public List<VideoCache> getCurrentList() {
    final String _sql = "SELECT * from VideoCache";
    final RoomSQLiteQuery _statement = RoomSQLiteQuery.acquire(_sql, 0);
    __db.assertNotSuspendingTransaction();
    final Cursor _cursor = DBUtil.query(__db, _statement, false, null);
    try {
      final int _cursorIndexOfUrl = CursorUtil.getColumnIndexOrThrow(_cursor, "url");
      final int _cursorIndexOfTitle = CursorUtil.getColumnIndexOrThrow(_cursor, "title");
      final int _cursorIndexOfState = CursorUtil.getColumnIndexOrThrow(_cursor, "state");
      final int _cursorIndexOfProxy = CursorUtil.getColumnIndexOrThrow(_cursor, "proxy");
      final int _cursorIndexOfDuration = CursorUtil.getColumnIndexOrThrow(_cursor, "duration");
      final int _cursorIndexOfThumbnail = CursorUtil.getColumnIndexOrThrow(_cursor, "thumbnail");
      final int _cursorIndexOfJson = CursorUtil.getColumnIndexOrThrow(_cursor, "json");
      final int _cursorIndexOfCourseId = CursorUtil.getColumnIndexOrThrow(_cursor, "courseId");
      final int _cursorIndexOfPercent = CursorUtil.getColumnIndexOrThrow(_cursor, "percent");
      final int _cursorIndexOfExpiry = CursorUtil.getColumnIndexOrThrow(_cursor, "expiry");
      final List<VideoCache> _result = new ArrayList<VideoCache>(_cursor.getCount());
      while(_cursor.moveToNext()) {
        final VideoCache _item;
        final String _tmpUrl;
        if (_cursor.isNull(_cursorIndexOfUrl)) {
          _tmpUrl = null;
        } else {
          _tmpUrl = _cursor.getString(_cursorIndexOfUrl);
        }
        _item = new VideoCache(_tmpUrl);
        final String _tmpTitle;
        if (_cursor.isNull(_cursorIndexOfTitle)) {
          _tmpTitle = null;
        } else {
          _tmpTitle = _cursor.getString(_cursorIndexOfTitle);
        }
        _item.setTitle(_tmpTitle);
        final Integer _tmpState;
        if (_cursor.isNull(_cursorIndexOfState)) {
          _tmpState = null;
        } else {
          _tmpState = _cursor.getInt(_cursorIndexOfState);
        }
        _item.setState(_tmpState);
        final String _tmpProxy;
        if (_cursor.isNull(_cursorIndexOfProxy)) {
          _tmpProxy = null;
        } else {
          _tmpProxy = _cursor.getString(_cursorIndexOfProxy);
        }
        _item.setProxy(_tmpProxy);
        final String _tmpDuration;
        if (_cursor.isNull(_cursorIndexOfDuration)) {
          _tmpDuration = null;
        } else {
          _tmpDuration = _cursor.getString(_cursorIndexOfDuration);
        }
        _item.setDuration(_tmpDuration);
        final String _tmpThumbnail;
        if (_cursor.isNull(_cursorIndexOfThumbnail)) {
          _tmpThumbnail = null;
        } else {
          _tmpThumbnail = _cursor.getString(_cursorIndexOfThumbnail);
        }
        _item.setThumbnail(_tmpThumbnail);
        final String _tmpJson;
        if (_cursor.isNull(_cursorIndexOfJson)) {
          _tmpJson = null;
        } else {
          _tmpJson = _cursor.getString(_cursorIndexOfJson);
        }
        _item.setJson(_tmpJson);
        final Integer _tmpCourseId;
        if (_cursor.isNull(_cursorIndexOfCourseId)) {
          _tmpCourseId = null;
        } else {
          _tmpCourseId = _cursor.getInt(_cursorIndexOfCourseId);
        }
        _item.setCourseId(_tmpCourseId);
        final Double _tmpPercent;
        if (_cursor.isNull(_cursorIndexOfPercent)) {
          _tmpPercent = null;
        } else {
          _tmpPercent = _cursor.getDouble(_cursorIndexOfPercent);
        }
        _item.setPercent(_tmpPercent);
        final Long _tmpExpiry;
        if (_cursor.isNull(_cursorIndexOfExpiry)) {
          _tmpExpiry = null;
        } else {
          _tmpExpiry = _cursor.getLong(_cursorIndexOfExpiry);
        }
        _item.setExpiry(_tmpExpiry);
        _result.add(_item);
      }
      return _result;
    } finally {
      _cursor.close();
      _statement.release();
    }
  }

  @Override
  public Flow<VideoCache> getSingleDownloads(final String url) {
    final String _sql = "SELECT * from VideoCache WHERE url =? limit 1";
    final RoomSQLiteQuery _statement = RoomSQLiteQuery.acquire(_sql, 1);
    int _argIndex = 1;
    if (url == null) {
      _statement.bindNull(_argIndex);
    } else {
      _statement.bindString(_argIndex, url);
    }
    return CoroutinesRoom.createFlow(__db, false, new String[]{"VideoCache"}, new Callable<VideoCache>() {
      @Override
      public VideoCache call() throws Exception {
        final Cursor _cursor = DBUtil.query(__db, _statement, false, null);
        try {
          final int _cursorIndexOfUrl = CursorUtil.getColumnIndexOrThrow(_cursor, "url");
          final int _cursorIndexOfTitle = CursorUtil.getColumnIndexOrThrow(_cursor, "title");
          final int _cursorIndexOfState = CursorUtil.getColumnIndexOrThrow(_cursor, "state");
          final int _cursorIndexOfProxy = CursorUtil.getColumnIndexOrThrow(_cursor, "proxy");
          final int _cursorIndexOfDuration = CursorUtil.getColumnIndexOrThrow(_cursor, "duration");
          final int _cursorIndexOfThumbnail = CursorUtil.getColumnIndexOrThrow(_cursor, "thumbnail");
          final int _cursorIndexOfJson = CursorUtil.getColumnIndexOrThrow(_cursor, "json");
          final int _cursorIndexOfCourseId = CursorUtil.getColumnIndexOrThrow(_cursor, "courseId");
          final int _cursorIndexOfPercent = CursorUtil.getColumnIndexOrThrow(_cursor, "percent");
          final int _cursorIndexOfExpiry = CursorUtil.getColumnIndexOrThrow(_cursor, "expiry");
          final VideoCache _result;
          if(_cursor.moveToFirst()) {
            final String _tmpUrl;
            if (_cursor.isNull(_cursorIndexOfUrl)) {
              _tmpUrl = null;
            } else {
              _tmpUrl = _cursor.getString(_cursorIndexOfUrl);
            }
            _result = new VideoCache(_tmpUrl);
            final String _tmpTitle;
            if (_cursor.isNull(_cursorIndexOfTitle)) {
              _tmpTitle = null;
            } else {
              _tmpTitle = _cursor.getString(_cursorIndexOfTitle);
            }
            _result.setTitle(_tmpTitle);
            final Integer _tmpState;
            if (_cursor.isNull(_cursorIndexOfState)) {
              _tmpState = null;
            } else {
              _tmpState = _cursor.getInt(_cursorIndexOfState);
            }
            _result.setState(_tmpState);
            final String _tmpProxy;
            if (_cursor.isNull(_cursorIndexOfProxy)) {
              _tmpProxy = null;
            } else {
              _tmpProxy = _cursor.getString(_cursorIndexOfProxy);
            }
            _result.setProxy(_tmpProxy);
            final String _tmpDuration;
            if (_cursor.isNull(_cursorIndexOfDuration)) {
              _tmpDuration = null;
            } else {
              _tmpDuration = _cursor.getString(_cursorIndexOfDuration);
            }
            _result.setDuration(_tmpDuration);
            final String _tmpThumbnail;
            if (_cursor.isNull(_cursorIndexOfThumbnail)) {
              _tmpThumbnail = null;
            } else {
              _tmpThumbnail = _cursor.getString(_cursorIndexOfThumbnail);
            }
            _result.setThumbnail(_tmpThumbnail);
            final String _tmpJson;
            if (_cursor.isNull(_cursorIndexOfJson)) {
              _tmpJson = null;
            } else {
              _tmpJson = _cursor.getString(_cursorIndexOfJson);
            }
            _result.setJson(_tmpJson);
            final Integer _tmpCourseId;
            if (_cursor.isNull(_cursorIndexOfCourseId)) {
              _tmpCourseId = null;
            } else {
              _tmpCourseId = _cursor.getInt(_cursorIndexOfCourseId);
            }
            _result.setCourseId(_tmpCourseId);
            final Double _tmpPercent;
            if (_cursor.isNull(_cursorIndexOfPercent)) {
              _tmpPercent = null;
            } else {
              _tmpPercent = _cursor.getDouble(_cursorIndexOfPercent);
            }
            _result.setPercent(_tmpPercent);
            final Long _tmpExpiry;
            if (_cursor.isNull(_cursorIndexOfExpiry)) {
              _tmpExpiry = null;
            } else {
              _tmpExpiry = _cursor.getLong(_cursorIndexOfExpiry);
            }
            _result.setExpiry(_tmpExpiry);
          } else {
            _result = null;
          }
          return _result;
        } finally {
          _cursor.close();
        }
      }

      @Override
      protected void finalize() {
        _statement.release();
      }
    });
  }

  @Override
  public VideoCache checkIfAlreadyDownloaded(final String proxy) {
    final String _sql = "SELECT * from VideoCache WHERE proxy =? limit 1";
    final RoomSQLiteQuery _statement = RoomSQLiteQuery.acquire(_sql, 1);
    int _argIndex = 1;
    if (proxy == null) {
      _statement.bindNull(_argIndex);
    } else {
      _statement.bindString(_argIndex, proxy);
    }
    __db.assertNotSuspendingTransaction();
    final Cursor _cursor = DBUtil.query(__db, _statement, false, null);
    try {
      final int _cursorIndexOfUrl = CursorUtil.getColumnIndexOrThrow(_cursor, "url");
      final int _cursorIndexOfTitle = CursorUtil.getColumnIndexOrThrow(_cursor, "title");
      final int _cursorIndexOfState = CursorUtil.getColumnIndexOrThrow(_cursor, "state");
      final int _cursorIndexOfProxy = CursorUtil.getColumnIndexOrThrow(_cursor, "proxy");
      final int _cursorIndexOfDuration = CursorUtil.getColumnIndexOrThrow(_cursor, "duration");
      final int _cursorIndexOfThumbnail = CursorUtil.getColumnIndexOrThrow(_cursor, "thumbnail");
      final int _cursorIndexOfJson = CursorUtil.getColumnIndexOrThrow(_cursor, "json");
      final int _cursorIndexOfCourseId = CursorUtil.getColumnIndexOrThrow(_cursor, "courseId");
      final int _cursorIndexOfPercent = CursorUtil.getColumnIndexOrThrow(_cursor, "percent");
      final int _cursorIndexOfExpiry = CursorUtil.getColumnIndexOrThrow(_cursor, "expiry");
      final VideoCache _result;
      if(_cursor.moveToFirst()) {
        final String _tmpUrl;
        if (_cursor.isNull(_cursorIndexOfUrl)) {
          _tmpUrl = null;
        } else {
          _tmpUrl = _cursor.getString(_cursorIndexOfUrl);
        }
        _result = new VideoCache(_tmpUrl);
        final String _tmpTitle;
        if (_cursor.isNull(_cursorIndexOfTitle)) {
          _tmpTitle = null;
        } else {
          _tmpTitle = _cursor.getString(_cursorIndexOfTitle);
        }
        _result.setTitle(_tmpTitle);
        final Integer _tmpState;
        if (_cursor.isNull(_cursorIndexOfState)) {
          _tmpState = null;
        } else {
          _tmpState = _cursor.getInt(_cursorIndexOfState);
        }
        _result.setState(_tmpState);
        final String _tmpProxy;
        if (_cursor.isNull(_cursorIndexOfProxy)) {
          _tmpProxy = null;
        } else {
          _tmpProxy = _cursor.getString(_cursorIndexOfProxy);
        }
        _result.setProxy(_tmpProxy);
        final String _tmpDuration;
        if (_cursor.isNull(_cursorIndexOfDuration)) {
          _tmpDuration = null;
        } else {
          _tmpDuration = _cursor.getString(_cursorIndexOfDuration);
        }
        _result.setDuration(_tmpDuration);
        final String _tmpThumbnail;
        if (_cursor.isNull(_cursorIndexOfThumbnail)) {
          _tmpThumbnail = null;
        } else {
          _tmpThumbnail = _cursor.getString(_cursorIndexOfThumbnail);
        }
        _result.setThumbnail(_tmpThumbnail);
        final String _tmpJson;
        if (_cursor.isNull(_cursorIndexOfJson)) {
          _tmpJson = null;
        } else {
          _tmpJson = _cursor.getString(_cursorIndexOfJson);
        }
        _result.setJson(_tmpJson);
        final Integer _tmpCourseId;
        if (_cursor.isNull(_cursorIndexOfCourseId)) {
          _tmpCourseId = null;
        } else {
          _tmpCourseId = _cursor.getInt(_cursorIndexOfCourseId);
        }
        _result.setCourseId(_tmpCourseId);
        final Double _tmpPercent;
        if (_cursor.isNull(_cursorIndexOfPercent)) {
          _tmpPercent = null;
        } else {
          _tmpPercent = _cursor.getDouble(_cursorIndexOfPercent);
        }
        _result.setPercent(_tmpPercent);
        final Long _tmpExpiry;
        if (_cursor.isNull(_cursorIndexOfExpiry)) {
          _tmpExpiry = null;
        } else {
          _tmpExpiry = _cursor.getLong(_cursorIndexOfExpiry);
        }
        _result.setExpiry(_tmpExpiry);
      } else {
        _result = null;
      }
      return _result;
    } finally {
      _cursor.close();
      _statement.release();
    }
  }

  @Override
  public VideoCache checkIfAlreadyFromUrl(final String proxy) {
    final String _sql = "SELECT * from VideoCache WHERE url =? limit 1";
    final RoomSQLiteQuery _statement = RoomSQLiteQuery.acquire(_sql, 1);
    int _argIndex = 1;
    if (proxy == null) {
      _statement.bindNull(_argIndex);
    } else {
      _statement.bindString(_argIndex, proxy);
    }
    __db.assertNotSuspendingTransaction();
    final Cursor _cursor = DBUtil.query(__db, _statement, false, null);
    try {
      final int _cursorIndexOfUrl = CursorUtil.getColumnIndexOrThrow(_cursor, "url");
      final int _cursorIndexOfTitle = CursorUtil.getColumnIndexOrThrow(_cursor, "title");
      final int _cursorIndexOfState = CursorUtil.getColumnIndexOrThrow(_cursor, "state");
      final int _cursorIndexOfProxy = CursorUtil.getColumnIndexOrThrow(_cursor, "proxy");
      final int _cursorIndexOfDuration = CursorUtil.getColumnIndexOrThrow(_cursor, "duration");
      final int _cursorIndexOfThumbnail = CursorUtil.getColumnIndexOrThrow(_cursor, "thumbnail");
      final int _cursorIndexOfJson = CursorUtil.getColumnIndexOrThrow(_cursor, "json");
      final int _cursorIndexOfCourseId = CursorUtil.getColumnIndexOrThrow(_cursor, "courseId");
      final int _cursorIndexOfPercent = CursorUtil.getColumnIndexOrThrow(_cursor, "percent");
      final int _cursorIndexOfExpiry = CursorUtil.getColumnIndexOrThrow(_cursor, "expiry");
      final VideoCache _result;
      if(_cursor.moveToFirst()) {
        final String _tmpUrl;
        if (_cursor.isNull(_cursorIndexOfUrl)) {
          _tmpUrl = null;
        } else {
          _tmpUrl = _cursor.getString(_cursorIndexOfUrl);
        }
        _result = new VideoCache(_tmpUrl);
        final String _tmpTitle;
        if (_cursor.isNull(_cursorIndexOfTitle)) {
          _tmpTitle = null;
        } else {
          _tmpTitle = _cursor.getString(_cursorIndexOfTitle);
        }
        _result.setTitle(_tmpTitle);
        final Integer _tmpState;
        if (_cursor.isNull(_cursorIndexOfState)) {
          _tmpState = null;
        } else {
          _tmpState = _cursor.getInt(_cursorIndexOfState);
        }
        _result.setState(_tmpState);
        final String _tmpProxy;
        if (_cursor.isNull(_cursorIndexOfProxy)) {
          _tmpProxy = null;
        } else {
          _tmpProxy = _cursor.getString(_cursorIndexOfProxy);
        }
        _result.setProxy(_tmpProxy);
        final String _tmpDuration;
        if (_cursor.isNull(_cursorIndexOfDuration)) {
          _tmpDuration = null;
        } else {
          _tmpDuration = _cursor.getString(_cursorIndexOfDuration);
        }
        _result.setDuration(_tmpDuration);
        final String _tmpThumbnail;
        if (_cursor.isNull(_cursorIndexOfThumbnail)) {
          _tmpThumbnail = null;
        } else {
          _tmpThumbnail = _cursor.getString(_cursorIndexOfThumbnail);
        }
        _result.setThumbnail(_tmpThumbnail);
        final String _tmpJson;
        if (_cursor.isNull(_cursorIndexOfJson)) {
          _tmpJson = null;
        } else {
          _tmpJson = _cursor.getString(_cursorIndexOfJson);
        }
        _result.setJson(_tmpJson);
        final Integer _tmpCourseId;
        if (_cursor.isNull(_cursorIndexOfCourseId)) {
          _tmpCourseId = null;
        } else {
          _tmpCourseId = _cursor.getInt(_cursorIndexOfCourseId);
        }
        _result.setCourseId(_tmpCourseId);
        final Double _tmpPercent;
        if (_cursor.isNull(_cursorIndexOfPercent)) {
          _tmpPercent = null;
        } else {
          _tmpPercent = _cursor.getDouble(_cursorIndexOfPercent);
        }
        _result.setPercent(_tmpPercent);
        final Long _tmpExpiry;
        if (_cursor.isNull(_cursorIndexOfExpiry)) {
          _tmpExpiry = null;
        } else {
          _tmpExpiry = _cursor.getLong(_cursorIndexOfExpiry);
        }
        _result.setExpiry(_tmpExpiry);
      } else {
        _result = null;
      }
      return _result;
    } finally {
      _cursor.close();
      _statement.release();
    }
  }

  @Override
  public LiveData<VideoCache> getSingleDownloadsLiveData(final String url) {
    final String _sql = "SELECT * from VideoCache WHERE url =? limit 1";
    final RoomSQLiteQuery _statement = RoomSQLiteQuery.acquire(_sql, 1);
    int _argIndex = 1;
    if (url == null) {
      _statement.bindNull(_argIndex);
    } else {
      _statement.bindString(_argIndex, url);
    }
    return __db.getInvalidationTracker().createLiveData(new String[]{"VideoCache"}, false, new Callable<VideoCache>() {
      @Override
      public VideoCache call() throws Exception {
        final Cursor _cursor = DBUtil.query(__db, _statement, false, null);
        try {
          final int _cursorIndexOfUrl = CursorUtil.getColumnIndexOrThrow(_cursor, "url");
          final int _cursorIndexOfTitle = CursorUtil.getColumnIndexOrThrow(_cursor, "title");
          final int _cursorIndexOfState = CursorUtil.getColumnIndexOrThrow(_cursor, "state");
          final int _cursorIndexOfProxy = CursorUtil.getColumnIndexOrThrow(_cursor, "proxy");
          final int _cursorIndexOfDuration = CursorUtil.getColumnIndexOrThrow(_cursor, "duration");
          final int _cursorIndexOfThumbnail = CursorUtil.getColumnIndexOrThrow(_cursor, "thumbnail");
          final int _cursorIndexOfJson = CursorUtil.getColumnIndexOrThrow(_cursor, "json");
          final int _cursorIndexOfCourseId = CursorUtil.getColumnIndexOrThrow(_cursor, "courseId");
          final int _cursorIndexOfPercent = CursorUtil.getColumnIndexOrThrow(_cursor, "percent");
          final int _cursorIndexOfExpiry = CursorUtil.getColumnIndexOrThrow(_cursor, "expiry");
          final VideoCache _result;
          if(_cursor.moveToFirst()) {
            final String _tmpUrl;
            if (_cursor.isNull(_cursorIndexOfUrl)) {
              _tmpUrl = null;
            } else {
              _tmpUrl = _cursor.getString(_cursorIndexOfUrl);
            }
            _result = new VideoCache(_tmpUrl);
            final String _tmpTitle;
            if (_cursor.isNull(_cursorIndexOfTitle)) {
              _tmpTitle = null;
            } else {
              _tmpTitle = _cursor.getString(_cursorIndexOfTitle);
            }
            _result.setTitle(_tmpTitle);
            final Integer _tmpState;
            if (_cursor.isNull(_cursorIndexOfState)) {
              _tmpState = null;
            } else {
              _tmpState = _cursor.getInt(_cursorIndexOfState);
            }
            _result.setState(_tmpState);
            final String _tmpProxy;
            if (_cursor.isNull(_cursorIndexOfProxy)) {
              _tmpProxy = null;
            } else {
              _tmpProxy = _cursor.getString(_cursorIndexOfProxy);
            }
            _result.setProxy(_tmpProxy);
            final String _tmpDuration;
            if (_cursor.isNull(_cursorIndexOfDuration)) {
              _tmpDuration = null;
            } else {
              _tmpDuration = _cursor.getString(_cursorIndexOfDuration);
            }
            _result.setDuration(_tmpDuration);
            final String _tmpThumbnail;
            if (_cursor.isNull(_cursorIndexOfThumbnail)) {
              _tmpThumbnail = null;
            } else {
              _tmpThumbnail = _cursor.getString(_cursorIndexOfThumbnail);
            }
            _result.setThumbnail(_tmpThumbnail);
            final String _tmpJson;
            if (_cursor.isNull(_cursorIndexOfJson)) {
              _tmpJson = null;
            } else {
              _tmpJson = _cursor.getString(_cursorIndexOfJson);
            }
            _result.setJson(_tmpJson);
            final Integer _tmpCourseId;
            if (_cursor.isNull(_cursorIndexOfCourseId)) {
              _tmpCourseId = null;
            } else {
              _tmpCourseId = _cursor.getInt(_cursorIndexOfCourseId);
            }
            _result.setCourseId(_tmpCourseId);
            final Double _tmpPercent;
            if (_cursor.isNull(_cursorIndexOfPercent)) {
              _tmpPercent = null;
            } else {
              _tmpPercent = _cursor.getDouble(_cursorIndexOfPercent);
            }
            _result.setPercent(_tmpPercent);
            final Long _tmpExpiry;
            if (_cursor.isNull(_cursorIndexOfExpiry)) {
              _tmpExpiry = null;
            } else {
              _tmpExpiry = _cursor.getLong(_cursorIndexOfExpiry);
            }
            _result.setExpiry(_tmpExpiry);
          } else {
            _result = null;
          }
          return _result;
        } finally {
          _cursor.close();
        }
      }

      @Override
      protected void finalize() {
        _statement.release();
      }
    });
  }

  @Override
  public LiveData<Integer> countDownloads() {
    final String _sql = "SELECT count(*) FROM VideoCache";
    final RoomSQLiteQuery _statement = RoomSQLiteQuery.acquire(_sql, 0);
    return __db.getInvalidationTracker().createLiveData(new String[]{"VideoCache"}, false, new Callable<Integer>() {
      @Override
      public Integer call() throws Exception {
        final Cursor _cursor = DBUtil.query(__db, _statement, false, null);
        try {
          final Integer _result;
          if(_cursor.moveToFirst()) {
            final Integer _tmp;
            if (_cursor.isNull(0)) {
              _tmp = null;
            } else {
              _tmp = _cursor.getInt(0);
            }
            _result = _tmp;
          } else {
            _result = null;
          }
          return _result;
        } finally {
          _cursor.close();
        }
      }

      @Override
      protected void finalize() {
        _statement.release();
      }
    });
  }

  public static List<Class<?>> getRequiredConverters() {
    return Collections.emptyList();
  }
}
