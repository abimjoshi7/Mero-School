// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// **************************************************************************
// DriftDatabaseGenerator
// **************************************************************************

// ignore_for_file: type=lint
class MyCartModelData extends DataClass implements Insertable<MyCartModelData> {
  final String cartId;
  final String title;
  final String shortDescription;
  final String level;
  final String price;
  final String appleProductId;
  final String tagsmeta;
  const MyCartModelData(
      {required this.cartId,
      required this.title,
      required this.shortDescription,
      required this.level,
      required this.price,
      required this.appleProductId,
      required this.tagsmeta});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['cart_id'] = Variable<String>(cartId);
    map['title'] = Variable<String>(title);
    map['short_description'] = Variable<String>(shortDescription);
    map['level'] = Variable<String>(level);
    map['price'] = Variable<String>(price);
    map['apple_product_id'] = Variable<String>(appleProductId);
    map['tagsmeta'] = Variable<String>(tagsmeta);
    return map;
  }

  MyCartModelCompanion toCompanion(bool nullToAbsent) {
    return MyCartModelCompanion(
      cartId: Value(cartId),
      title: Value(title),
      shortDescription: Value(shortDescription),
      level: Value(level),
      price: Value(price),
      appleProductId: Value(appleProductId),
      tagsmeta: Value(tagsmeta),
    );
  }

  factory MyCartModelData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MyCartModelData(
      cartId: serializer.fromJson<String>(json['cartId']),
      title: serializer.fromJson<String>(json['title']),
      shortDescription: serializer.fromJson<String>(json['shortDescription']),
      level: serializer.fromJson<String>(json['level']),
      price: serializer.fromJson<String>(json['price']),
      appleProductId: serializer.fromJson<String>(json['appleProductId']),
      tagsmeta: serializer.fromJson<String>(json['tagsmeta']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'cartId': serializer.toJson<String>(cartId),
      'title': serializer.toJson<String>(title),
      'shortDescription': serializer.toJson<String>(shortDescription),
      'level': serializer.toJson<String>(level),
      'price': serializer.toJson<String>(price),
      'appleProductId': serializer.toJson<String>(appleProductId),
      'tagsmeta': serializer.toJson<String>(tagsmeta),
    };
  }

  MyCartModelData copyWith(
          {String? cartId,
          String? title,
          String? shortDescription,
          String? level,
          String? price,
          String? appleProductId,
          String? tagsmeta}) =>
      MyCartModelData(
        cartId: cartId ?? this.cartId,
        title: title ?? this.title,
        shortDescription: shortDescription ?? this.shortDescription,
        level: level ?? this.level,
        price: price ?? this.price,
        appleProductId: appleProductId ?? this.appleProductId,
        tagsmeta: tagsmeta ?? this.tagsmeta,
      );
  @override
  String toString() {
    return (StringBuffer('MyCartModelData(')
          ..write('cartId: $cartId, ')
          ..write('title: $title, ')
          ..write('shortDescription: $shortDescription, ')
          ..write('level: $level, ')
          ..write('price: $price, ')
          ..write('appleProductId: $appleProductId, ')
          ..write('tagsmeta: $tagsmeta')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      cartId, title, shortDescription, level, price, appleProductId, tagsmeta);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MyCartModelData &&
          other.cartId == this.cartId &&
          other.title == this.title &&
          other.shortDescription == this.shortDescription &&
          other.level == this.level &&
          other.price == this.price &&
          other.appleProductId == this.appleProductId &&
          other.tagsmeta == this.tagsmeta);
}

class MyCartModelCompanion extends UpdateCompanion<MyCartModelData> {
  final Value<String> cartId;
  final Value<String> title;
  final Value<String> shortDescription;
  final Value<String> level;
  final Value<String> price;
  final Value<String> appleProductId;
  final Value<String> tagsmeta;
  const MyCartModelCompanion({
    this.cartId = const Value.absent(),
    this.title = const Value.absent(),
    this.shortDescription = const Value.absent(),
    this.level = const Value.absent(),
    this.price = const Value.absent(),
    this.appleProductId = const Value.absent(),
    this.tagsmeta = const Value.absent(),
  });
  MyCartModelCompanion.insert({
    required String cartId,
    required String title,
    required String shortDescription,
    required String level,
    required String price,
    required String appleProductId,
    required String tagsmeta,
  })  : cartId = Value(cartId),
        title = Value(title),
        shortDescription = Value(shortDescription),
        level = Value(level),
        price = Value(price),
        appleProductId = Value(appleProductId),
        tagsmeta = Value(tagsmeta);
  static Insertable<MyCartModelData> custom({
    Expression<String>? cartId,
    Expression<String>? title,
    Expression<String>? shortDescription,
    Expression<String>? level,
    Expression<String>? price,
    Expression<String>? appleProductId,
    Expression<String>? tagsmeta,
  }) {
    return RawValuesInsertable({
      if (cartId != null) 'cart_id': cartId,
      if (title != null) 'title': title,
      if (shortDescription != null) 'short_description': shortDescription,
      if (level != null) 'level': level,
      if (price != null) 'price': price,
      if (appleProductId != null) 'apple_product_id': appleProductId,
      if (tagsmeta != null) 'tagsmeta': tagsmeta,
    });
  }

  MyCartModelCompanion copyWith(
      {Value<String>? cartId,
      Value<String>? title,
      Value<String>? shortDescription,
      Value<String>? level,
      Value<String>? price,
      Value<String>? appleProductId,
      Value<String>? tagsmeta}) {
    return MyCartModelCompanion(
      cartId: cartId ?? this.cartId,
      title: title ?? this.title,
      shortDescription: shortDescription ?? this.shortDescription,
      level: level ?? this.level,
      price: price ?? this.price,
      appleProductId: appleProductId ?? this.appleProductId,
      tagsmeta: tagsmeta ?? this.tagsmeta,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (cartId.present) {
      map['cart_id'] = Variable<String>(cartId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (shortDescription.present) {
      map['short_description'] = Variable<String>(shortDescription.value);
    }
    if (level.present) {
      map['level'] = Variable<String>(level.value);
    }
    if (price.present) {
      map['price'] = Variable<String>(price.value);
    }
    if (appleProductId.present) {
      map['apple_product_id'] = Variable<String>(appleProductId.value);
    }
    if (tagsmeta.present) {
      map['tagsmeta'] = Variable<String>(tagsmeta.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MyCartModelCompanion(')
          ..write('cartId: $cartId, ')
          ..write('title: $title, ')
          ..write('shortDescription: $shortDescription, ')
          ..write('level: $level, ')
          ..write('price: $price, ')
          ..write('appleProductId: $appleProductId, ')
          ..write('tagsmeta: $tagsmeta')
          ..write(')'))
        .toString();
  }
}

class $MyCartModelTable extends MyCartModel
    with TableInfo<$MyCartModelTable, MyCartModelData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MyCartModelTable(this.attachedDatabase, [this._alias]);
  final VerificationMeta _cartIdMeta = const VerificationMeta('cartId');
  @override
  late final GeneratedColumn<String> cartId = GeneratedColumn<String>(
      'cart_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  final VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  final VerificationMeta _shortDescriptionMeta =
      const VerificationMeta('shortDescription');
  @override
  late final GeneratedColumn<String> shortDescription = GeneratedColumn<String>(
      'short_description', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  final VerificationMeta _levelMeta = const VerificationMeta('level');
  @override
  late final GeneratedColumn<String> level = GeneratedColumn<String>(
      'level', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  final VerificationMeta _priceMeta = const VerificationMeta('price');
  @override
  late final GeneratedColumn<String> price = GeneratedColumn<String>(
      'price', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  final VerificationMeta _appleProductIdMeta =
      const VerificationMeta('appleProductId');
  @override
  late final GeneratedColumn<String> appleProductId = GeneratedColumn<String>(
      'apple_product_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  final VerificationMeta _tagsmetaMeta = const VerificationMeta('tagsmeta');
  @override
  late final GeneratedColumn<String> tagsmeta = GeneratedColumn<String>(
      'tagsmeta', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [cartId, title, shortDescription, level, price, appleProductId, tagsmeta];
  @override
  String get aliasedName => _alias ?? 'my_cart_model';
  @override
  String get actualTableName => 'my_cart_model';
  @override
  VerificationContext validateIntegrity(Insertable<MyCartModelData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('cart_id')) {
      context.handle(_cartIdMeta,
          cartId.isAcceptableOrUnknown(data['cart_id']!, _cartIdMeta));
    } else if (isInserting) {
      context.missing(_cartIdMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('short_description')) {
      context.handle(
          _shortDescriptionMeta,
          shortDescription.isAcceptableOrUnknown(
              data['short_description']!, _shortDescriptionMeta));
    } else if (isInserting) {
      context.missing(_shortDescriptionMeta);
    }
    if (data.containsKey('level')) {
      context.handle(
          _levelMeta, level.isAcceptableOrUnknown(data['level']!, _levelMeta));
    } else if (isInserting) {
      context.missing(_levelMeta);
    }
    if (data.containsKey('price')) {
      context.handle(
          _priceMeta, price.isAcceptableOrUnknown(data['price']!, _priceMeta));
    } else if (isInserting) {
      context.missing(_priceMeta);
    }
    if (data.containsKey('apple_product_id')) {
      context.handle(
          _appleProductIdMeta,
          appleProductId.isAcceptableOrUnknown(
              data['apple_product_id']!, _appleProductIdMeta));
    } else if (isInserting) {
      context.missing(_appleProductIdMeta);
    }
    if (data.containsKey('tagsmeta')) {
      context.handle(_tagsmetaMeta,
          tagsmeta.isAcceptableOrUnknown(data['tagsmeta']!, _tagsmetaMeta));
    } else if (isInserting) {
      context.missing(_tagsmetaMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {cartId};
  @override
  MyCartModelData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MyCartModelData(
      cartId: attachedDatabase.options.types
          .read(DriftSqlType.string, data['${effectivePrefix}cart_id'])!,
      title: attachedDatabase.options.types
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      shortDescription: attachedDatabase.options.types.read(
          DriftSqlType.string, data['${effectivePrefix}short_description'])!,
      level: attachedDatabase.options.types
          .read(DriftSqlType.string, data['${effectivePrefix}level'])!,
      price: attachedDatabase.options.types
          .read(DriftSqlType.string, data['${effectivePrefix}price'])!,
      appleProductId: attachedDatabase.options.types.read(
          DriftSqlType.string, data['${effectivePrefix}apple_product_id'])!,
      tagsmeta: attachedDatabase.options.types
          .read(DriftSqlType.string, data['${effectivePrefix}tagsmeta'])!,
    );
  }

  @override
  $MyCartModelTable createAlias(String alias) {
    return $MyCartModelTable(attachedDatabase, alias);
  }
}

class NotificationModelData extends DataClass
    implements Insertable<NotificationModelData> {
  final String id;
  final String courseId;
  final String icon;
  final String title;
  final String description;
  final String type;
  final String notifyTime;
  final bool isRead;
  const NotificationModelData(
      {required this.id,
      required this.courseId,
      required this.icon,
      required this.title,
      required this.description,
      required this.type,
      required this.notifyTime,
      required this.isRead});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['course_id'] = Variable<String>(courseId);
    map['icon'] = Variable<String>(icon);
    map['title'] = Variable<String>(title);
    map['description'] = Variable<String>(description);
    map['type'] = Variable<String>(type);
    map['notify_time'] = Variable<String>(notifyTime);
    map['is_read'] = Variable<bool>(isRead);
    return map;
  }

  NotificationModelCompanion toCompanion(bool nullToAbsent) {
    return NotificationModelCompanion(
      id: Value(id),
      courseId: Value(courseId),
      icon: Value(icon),
      title: Value(title),
      description: Value(description),
      type: Value(type),
      notifyTime: Value(notifyTime),
      isRead: Value(isRead),
    );
  }

  factory NotificationModelData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return NotificationModelData(
      id: serializer.fromJson<String>(json['id']),
      courseId: serializer.fromJson<String>(json['courseId']),
      icon: serializer.fromJson<String>(json['icon']),
      title: serializer.fromJson<String>(json['title']),
      description: serializer.fromJson<String>(json['description']),
      type: serializer.fromJson<String>(json['type']),
      notifyTime: serializer.fromJson<String>(json['notifyTime']),
      isRead: serializer.fromJson<bool>(json['isRead']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'courseId': serializer.toJson<String>(courseId),
      'icon': serializer.toJson<String>(icon),
      'title': serializer.toJson<String>(title),
      'description': serializer.toJson<String>(description),
      'type': serializer.toJson<String>(type),
      'notifyTime': serializer.toJson<String>(notifyTime),
      'isRead': serializer.toJson<bool>(isRead),
    };
  }

  NotificationModelData copyWith(
          {String? id,
          String? courseId,
          String? icon,
          String? title,
          String? description,
          String? type,
          String? notifyTime,
          bool? isRead}) =>
      NotificationModelData(
        id: id ?? this.id,
        courseId: courseId ?? this.courseId,
        icon: icon ?? this.icon,
        title: title ?? this.title,
        description: description ?? this.description,
        type: type ?? this.type,
        notifyTime: notifyTime ?? this.notifyTime,
        isRead: isRead ?? this.isRead,
      );
  @override
  String toString() {
    return (StringBuffer('NotificationModelData(')
          ..write('id: $id, ')
          ..write('courseId: $courseId, ')
          ..write('icon: $icon, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('type: $type, ')
          ..write('notifyTime: $notifyTime, ')
          ..write('isRead: $isRead')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, courseId, icon, title, description, type, notifyTime, isRead);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is NotificationModelData &&
          other.id == this.id &&
          other.courseId == this.courseId &&
          other.icon == this.icon &&
          other.title == this.title &&
          other.description == this.description &&
          other.type == this.type &&
          other.notifyTime == this.notifyTime &&
          other.isRead == this.isRead);
}

class NotificationModelCompanion
    extends UpdateCompanion<NotificationModelData> {
  final Value<String> id;
  final Value<String> courseId;
  final Value<String> icon;
  final Value<String> title;
  final Value<String> description;
  final Value<String> type;
  final Value<String> notifyTime;
  final Value<bool> isRead;
  const NotificationModelCompanion({
    this.id = const Value.absent(),
    this.courseId = const Value.absent(),
    this.icon = const Value.absent(),
    this.title = const Value.absent(),
    this.description = const Value.absent(),
    this.type = const Value.absent(),
    this.notifyTime = const Value.absent(),
    this.isRead = const Value.absent(),
  });
  NotificationModelCompanion.insert({
    required String id,
    required String courseId,
    required String icon,
    required String title,
    required String description,
    required String type,
    required String notifyTime,
    required bool isRead,
  })  : id = Value(id),
        courseId = Value(courseId),
        icon = Value(icon),
        title = Value(title),
        description = Value(description),
        type = Value(type),
        notifyTime = Value(notifyTime),
        isRead = Value(isRead);
  static Insertable<NotificationModelData> custom({
    Expression<String>? id,
    Expression<String>? courseId,
    Expression<String>? icon,
    Expression<String>? title,
    Expression<String>? description,
    Expression<String>? type,
    Expression<String>? notifyTime,
    Expression<bool>? isRead,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (courseId != null) 'course_id': courseId,
      if (icon != null) 'icon': icon,
      if (title != null) 'title': title,
      if (description != null) 'description': description,
      if (type != null) 'type': type,
      if (notifyTime != null) 'notify_time': notifyTime,
      if (isRead != null) 'is_read': isRead,
    });
  }

  NotificationModelCompanion copyWith(
      {Value<String>? id,
      Value<String>? courseId,
      Value<String>? icon,
      Value<String>? title,
      Value<String>? description,
      Value<String>? type,
      Value<String>? notifyTime,
      Value<bool>? isRead}) {
    return NotificationModelCompanion(
      id: id ?? this.id,
      courseId: courseId ?? this.courseId,
      icon: icon ?? this.icon,
      title: title ?? this.title,
      description: description ?? this.description,
      type: type ?? this.type,
      notifyTime: notifyTime ?? this.notifyTime,
      isRead: isRead ?? this.isRead,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (courseId.present) {
      map['course_id'] = Variable<String>(courseId.value);
    }
    if (icon.present) {
      map['icon'] = Variable<String>(icon.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (notifyTime.present) {
      map['notify_time'] = Variable<String>(notifyTime.value);
    }
    if (isRead.present) {
      map['is_read'] = Variable<bool>(isRead.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('NotificationModelCompanion(')
          ..write('id: $id, ')
          ..write('courseId: $courseId, ')
          ..write('icon: $icon, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('type: $type, ')
          ..write('notifyTime: $notifyTime, ')
          ..write('isRead: $isRead')
          ..write(')'))
        .toString();
  }
}

class $NotificationModelTable extends NotificationModel
    with TableInfo<$NotificationModelTable, NotificationModelData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $NotificationModelTable(this.attachedDatabase, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  final VerificationMeta _courseIdMeta = const VerificationMeta('courseId');
  @override
  late final GeneratedColumn<String> courseId = GeneratedColumn<String>(
      'course_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  final VerificationMeta _iconMeta = const VerificationMeta('icon');
  @override
  late final GeneratedColumn<String> icon = GeneratedColumn<String>(
      'icon', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  final VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  final VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  final VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
      'type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  final VerificationMeta _notifyTimeMeta = const VerificationMeta('notifyTime');
  @override
  late final GeneratedColumn<String> notifyTime = GeneratedColumn<String>(
      'notify_time', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  final VerificationMeta _isReadMeta = const VerificationMeta('isRead');
  @override
  late final GeneratedColumn<bool> isRead = GeneratedColumn<bool>(
      'is_read', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: true,
      defaultConstraints: 'CHECK (is_read IN (0, 1))');
  @override
  List<GeneratedColumn> get $columns =>
      [id, courseId, icon, title, description, type, notifyTime, isRead];
  @override
  String get aliasedName => _alias ?? 'notification_model';
  @override
  String get actualTableName => 'notification_model';
  @override
  VerificationContext validateIntegrity(
      Insertable<NotificationModelData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('course_id')) {
      context.handle(_courseIdMeta,
          courseId.isAcceptableOrUnknown(data['course_id']!, _courseIdMeta));
    } else if (isInserting) {
      context.missing(_courseIdMeta);
    }
    if (data.containsKey('icon')) {
      context.handle(
          _iconMeta, icon.isAcceptableOrUnknown(data['icon']!, _iconMeta));
    } else if (isInserting) {
      context.missing(_iconMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    } else if (isInserting) {
      context.missing(_descriptionMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
          _typeMeta, type.isAcceptableOrUnknown(data['type']!, _typeMeta));
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('notify_time')) {
      context.handle(
          _notifyTimeMeta,
          notifyTime.isAcceptableOrUnknown(
              data['notify_time']!, _notifyTimeMeta));
    } else if (isInserting) {
      context.missing(_notifyTimeMeta);
    }
    if (data.containsKey('is_read')) {
      context.handle(_isReadMeta,
          isRead.isAcceptableOrUnknown(data['is_read']!, _isReadMeta));
    } else if (isInserting) {
      context.missing(_isReadMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {title, description};
  @override
  NotificationModelData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return NotificationModelData(
      id: attachedDatabase.options.types
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      courseId: attachedDatabase.options.types
          .read(DriftSqlType.string, data['${effectivePrefix}course_id'])!,
      icon: attachedDatabase.options.types
          .read(DriftSqlType.string, data['${effectivePrefix}icon'])!,
      title: attachedDatabase.options.types
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      description: attachedDatabase.options.types
          .read(DriftSqlType.string, data['${effectivePrefix}description'])!,
      type: attachedDatabase.options.types
          .read(DriftSqlType.string, data['${effectivePrefix}type'])!,
      notifyTime: attachedDatabase.options.types
          .read(DriftSqlType.string, data['${effectivePrefix}notify_time'])!,
      isRead: attachedDatabase.options.types
          .read(DriftSqlType.bool, data['${effectivePrefix}is_read'])!,
    );
  }

  @override
  $NotificationModelTable createAlias(String alias) {
    return $NotificationModelTable(attachedDatabase, alias);
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  late final $MyCartModelTable myCartModel = $MyCartModelTable(this);
  late final $NotificationModelTable notificationModel =
      $NotificationModelTable(this);
  @override
  Iterable<TableInfo<Table, dynamic>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [myCartModel, notificationModel];
}
