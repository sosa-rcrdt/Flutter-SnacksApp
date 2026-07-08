// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $SalesTable extends Sales with TableInfo<$SalesTable, SaleEntity> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SalesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _fechaHoraMeta = const VerificationMeta(
    'fechaHora',
  );
  @override
  late final GeneratedColumn<DateTime> fechaHora = GeneratedColumn<DateTime>(
    'fecha_hora',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _totalCentavosMeta = const VerificationMeta(
    'totalCentavos',
  );
  @override
  late final GeneratedColumn<int> totalCentavos = GeneratedColumn<int>(
    'total_centavos',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dineroRecibidoCentavosMeta =
      const VerificationMeta('dineroRecibidoCentavos');
  @override
  late final GeneratedColumn<int> dineroRecibidoCentavos = GeneratedColumn<int>(
    'dinero_recibido_centavos',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _cambioCentavosMeta = const VerificationMeta(
    'cambioCentavos',
  );
  @override
  late final GeneratedColumn<int> cambioCentavos = GeneratedColumn<int>(
    'cambio_centavos',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<SaleStatus, String> estado =
      GeneratedColumn<String>(
        'estado',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<SaleStatus>($SalesTable.$converterestado);
  @override
  List<GeneratedColumn> get $columns => [
    id,
    fechaHora,
    totalCentavos,
    dineroRecibidoCentavos,
    cambioCentavos,
    estado,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sales';
  @override
  VerificationContext validateIntegrity(
    Insertable<SaleEntity> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('fecha_hora')) {
      context.handle(
        _fechaHoraMeta,
        fechaHora.isAcceptableOrUnknown(data['fecha_hora']!, _fechaHoraMeta),
      );
    } else if (isInserting) {
      context.missing(_fechaHoraMeta);
    }
    if (data.containsKey('total_centavos')) {
      context.handle(
        _totalCentavosMeta,
        totalCentavos.isAcceptableOrUnknown(
          data['total_centavos']!,
          _totalCentavosMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_totalCentavosMeta);
    }
    if (data.containsKey('dinero_recibido_centavos')) {
      context.handle(
        _dineroRecibidoCentavosMeta,
        dineroRecibidoCentavos.isAcceptableOrUnknown(
          data['dinero_recibido_centavos']!,
          _dineroRecibidoCentavosMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_dineroRecibidoCentavosMeta);
    }
    if (data.containsKey('cambio_centavos')) {
      context.handle(
        _cambioCentavosMeta,
        cambioCentavos.isAcceptableOrUnknown(
          data['cambio_centavos']!,
          _cambioCentavosMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_cambioCentavosMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SaleEntity map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SaleEntity(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      fechaHora: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}fecha_hora'],
      )!,
      totalCentavos: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}total_centavos'],
      )!,
      dineroRecibidoCentavos: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}dinero_recibido_centavos'],
      )!,
      cambioCentavos: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}cambio_centavos'],
      )!,
      estado: $SalesTable.$converterestado.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}estado'],
        )!,
      ),
    );
  }

  @override
  $SalesTable createAlias(String alias) {
    return $SalesTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<SaleStatus, String, String> $converterestado =
      const EnumNameConverter<SaleStatus>(SaleStatus.values);
}

class SaleEntity extends DataClass implements Insertable<SaleEntity> {
  final int id;
  final DateTime fechaHora;
  final int totalCentavos;
  final int dineroRecibidoCentavos;
  final int cambioCentavos;
  final SaleStatus estado;
  const SaleEntity({
    required this.id,
    required this.fechaHora,
    required this.totalCentavos,
    required this.dineroRecibidoCentavos,
    required this.cambioCentavos,
    required this.estado,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['fecha_hora'] = Variable<DateTime>(fechaHora);
    map['total_centavos'] = Variable<int>(totalCentavos);
    map['dinero_recibido_centavos'] = Variable<int>(dineroRecibidoCentavos);
    map['cambio_centavos'] = Variable<int>(cambioCentavos);
    {
      map['estado'] = Variable<String>(
        $SalesTable.$converterestado.toSql(estado),
      );
    }
    return map;
  }

  SalesCompanion toCompanion(bool nullToAbsent) {
    return SalesCompanion(
      id: Value(id),
      fechaHora: Value(fechaHora),
      totalCentavos: Value(totalCentavos),
      dineroRecibidoCentavos: Value(dineroRecibidoCentavos),
      cambioCentavos: Value(cambioCentavos),
      estado: Value(estado),
    );
  }

  factory SaleEntity.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SaleEntity(
      id: serializer.fromJson<int>(json['id']),
      fechaHora: serializer.fromJson<DateTime>(json['fechaHora']),
      totalCentavos: serializer.fromJson<int>(json['totalCentavos']),
      dineroRecibidoCentavos: serializer.fromJson<int>(
        json['dineroRecibidoCentavos'],
      ),
      cambioCentavos: serializer.fromJson<int>(json['cambioCentavos']),
      estado: $SalesTable.$converterestado.fromJson(
        serializer.fromJson<String>(json['estado']),
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'fechaHora': serializer.toJson<DateTime>(fechaHora),
      'totalCentavos': serializer.toJson<int>(totalCentavos),
      'dineroRecibidoCentavos': serializer.toJson<int>(dineroRecibidoCentavos),
      'cambioCentavos': serializer.toJson<int>(cambioCentavos),
      'estado': serializer.toJson<String>(
        $SalesTable.$converterestado.toJson(estado),
      ),
    };
  }

  SaleEntity copyWith({
    int? id,
    DateTime? fechaHora,
    int? totalCentavos,
    int? dineroRecibidoCentavos,
    int? cambioCentavos,
    SaleStatus? estado,
  }) => SaleEntity(
    id: id ?? this.id,
    fechaHora: fechaHora ?? this.fechaHora,
    totalCentavos: totalCentavos ?? this.totalCentavos,
    dineroRecibidoCentavos:
        dineroRecibidoCentavos ?? this.dineroRecibidoCentavos,
    cambioCentavos: cambioCentavos ?? this.cambioCentavos,
    estado: estado ?? this.estado,
  );
  SaleEntity copyWithCompanion(SalesCompanion data) {
    return SaleEntity(
      id: data.id.present ? data.id.value : this.id,
      fechaHora: data.fechaHora.present ? data.fechaHora.value : this.fechaHora,
      totalCentavos: data.totalCentavos.present
          ? data.totalCentavos.value
          : this.totalCentavos,
      dineroRecibidoCentavos: data.dineroRecibidoCentavos.present
          ? data.dineroRecibidoCentavos.value
          : this.dineroRecibidoCentavos,
      cambioCentavos: data.cambioCentavos.present
          ? data.cambioCentavos.value
          : this.cambioCentavos,
      estado: data.estado.present ? data.estado.value : this.estado,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SaleEntity(')
          ..write('id: $id, ')
          ..write('fechaHora: $fechaHora, ')
          ..write('totalCentavos: $totalCentavos, ')
          ..write('dineroRecibidoCentavos: $dineroRecibidoCentavos, ')
          ..write('cambioCentavos: $cambioCentavos, ')
          ..write('estado: $estado')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    fechaHora,
    totalCentavos,
    dineroRecibidoCentavos,
    cambioCentavos,
    estado,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SaleEntity &&
          other.id == this.id &&
          other.fechaHora == this.fechaHora &&
          other.totalCentavos == this.totalCentavos &&
          other.dineroRecibidoCentavos == this.dineroRecibidoCentavos &&
          other.cambioCentavos == this.cambioCentavos &&
          other.estado == this.estado);
}

class SalesCompanion extends UpdateCompanion<SaleEntity> {
  final Value<int> id;
  final Value<DateTime> fechaHora;
  final Value<int> totalCentavos;
  final Value<int> dineroRecibidoCentavos;
  final Value<int> cambioCentavos;
  final Value<SaleStatus> estado;
  const SalesCompanion({
    this.id = const Value.absent(),
    this.fechaHora = const Value.absent(),
    this.totalCentavos = const Value.absent(),
    this.dineroRecibidoCentavos = const Value.absent(),
    this.cambioCentavos = const Value.absent(),
    this.estado = const Value.absent(),
  });
  SalesCompanion.insert({
    this.id = const Value.absent(),
    required DateTime fechaHora,
    required int totalCentavos,
    required int dineroRecibidoCentavos,
    required int cambioCentavos,
    required SaleStatus estado,
  }) : fechaHora = Value(fechaHora),
       totalCentavos = Value(totalCentavos),
       dineroRecibidoCentavos = Value(dineroRecibidoCentavos),
       cambioCentavos = Value(cambioCentavos),
       estado = Value(estado);
  static Insertable<SaleEntity> custom({
    Expression<int>? id,
    Expression<DateTime>? fechaHora,
    Expression<int>? totalCentavos,
    Expression<int>? dineroRecibidoCentavos,
    Expression<int>? cambioCentavos,
    Expression<String>? estado,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (fechaHora != null) 'fecha_hora': fechaHora,
      if (totalCentavos != null) 'total_centavos': totalCentavos,
      if (dineroRecibidoCentavos != null)
        'dinero_recibido_centavos': dineroRecibidoCentavos,
      if (cambioCentavos != null) 'cambio_centavos': cambioCentavos,
      if (estado != null) 'estado': estado,
    });
  }

  SalesCompanion copyWith({
    Value<int>? id,
    Value<DateTime>? fechaHora,
    Value<int>? totalCentavos,
    Value<int>? dineroRecibidoCentavos,
    Value<int>? cambioCentavos,
    Value<SaleStatus>? estado,
  }) {
    return SalesCompanion(
      id: id ?? this.id,
      fechaHora: fechaHora ?? this.fechaHora,
      totalCentavos: totalCentavos ?? this.totalCentavos,
      dineroRecibidoCentavos:
          dineroRecibidoCentavos ?? this.dineroRecibidoCentavos,
      cambioCentavos: cambioCentavos ?? this.cambioCentavos,
      estado: estado ?? this.estado,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (fechaHora.present) {
      map['fecha_hora'] = Variable<DateTime>(fechaHora.value);
    }
    if (totalCentavos.present) {
      map['total_centavos'] = Variable<int>(totalCentavos.value);
    }
    if (dineroRecibidoCentavos.present) {
      map['dinero_recibido_centavos'] = Variable<int>(
        dineroRecibidoCentavos.value,
      );
    }
    if (cambioCentavos.present) {
      map['cambio_centavos'] = Variable<int>(cambioCentavos.value);
    }
    if (estado.present) {
      map['estado'] = Variable<String>(
        $SalesTable.$converterestado.toSql(estado.value),
      );
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SalesCompanion(')
          ..write('id: $id, ')
          ..write('fechaHora: $fechaHora, ')
          ..write('totalCentavos: $totalCentavos, ')
          ..write('dineroRecibidoCentavos: $dineroRecibidoCentavos, ')
          ..write('cambioCentavos: $cambioCentavos, ')
          ..write('estado: $estado')
          ..write(')'))
        .toString();
  }
}

class $SaleDetailsTable extends SaleDetails
    with TableInfo<$SaleDetailsTable, SaleDetailEntity> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SaleDetailsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _ventaIdMeta = const VerificationMeta(
    'ventaId',
  );
  @override
  late final GeneratedColumn<int> ventaId = GeneratedColumn<int>(
    'venta_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES sales (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _productoIdMeta = const VerificationMeta(
    'productoId',
  );
  @override
  late final GeneratedColumn<int> productoId = GeneratedColumn<int>(
    'producto_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nombreProductoSnapshotMeta =
      const VerificationMeta('nombreProductoSnapshot');
  @override
  late final GeneratedColumn<String> nombreProductoSnapshot =
      GeneratedColumn<String>(
        'nombre_producto_snapshot',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _precioUnitarioCentavosSnapshotMeta =
      const VerificationMeta('precioUnitarioCentavosSnapshot');
  @override
  late final GeneratedColumn<int> precioUnitarioCentavosSnapshot =
      GeneratedColumn<int>(
        'precio_unitario_centavos_snapshot',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _cantidadMeta = const VerificationMeta(
    'cantidad',
  );
  @override
  late final GeneratedColumn<int> cantidad = GeneratedColumn<int>(
    'cantidad',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _subtotalCentavosMeta = const VerificationMeta(
    'subtotalCentavos',
  );
  @override
  late final GeneratedColumn<int> subtotalCentavos = GeneratedColumn<int>(
    'subtotal_centavos',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    ventaId,
    productoId,
    nombreProductoSnapshot,
    precioUnitarioCentavosSnapshot,
    cantidad,
    subtotalCentavos,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sale_details';
  @override
  VerificationContext validateIntegrity(
    Insertable<SaleDetailEntity> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('venta_id')) {
      context.handle(
        _ventaIdMeta,
        ventaId.isAcceptableOrUnknown(data['venta_id']!, _ventaIdMeta),
      );
    } else if (isInserting) {
      context.missing(_ventaIdMeta);
    }
    if (data.containsKey('producto_id')) {
      context.handle(
        _productoIdMeta,
        productoId.isAcceptableOrUnknown(data['producto_id']!, _productoIdMeta),
      );
    } else if (isInserting) {
      context.missing(_productoIdMeta);
    }
    if (data.containsKey('nombre_producto_snapshot')) {
      context.handle(
        _nombreProductoSnapshotMeta,
        nombreProductoSnapshot.isAcceptableOrUnknown(
          data['nombre_producto_snapshot']!,
          _nombreProductoSnapshotMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_nombreProductoSnapshotMeta);
    }
    if (data.containsKey('precio_unitario_centavos_snapshot')) {
      context.handle(
        _precioUnitarioCentavosSnapshotMeta,
        precioUnitarioCentavosSnapshot.isAcceptableOrUnknown(
          data['precio_unitario_centavos_snapshot']!,
          _precioUnitarioCentavosSnapshotMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_precioUnitarioCentavosSnapshotMeta);
    }
    if (data.containsKey('cantidad')) {
      context.handle(
        _cantidadMeta,
        cantidad.isAcceptableOrUnknown(data['cantidad']!, _cantidadMeta),
      );
    } else if (isInserting) {
      context.missing(_cantidadMeta);
    }
    if (data.containsKey('subtotal_centavos')) {
      context.handle(
        _subtotalCentavosMeta,
        subtotalCentavos.isAcceptableOrUnknown(
          data['subtotal_centavos']!,
          _subtotalCentavosMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_subtotalCentavosMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SaleDetailEntity map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SaleDetailEntity(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      ventaId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}venta_id'],
      )!,
      productoId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}producto_id'],
      )!,
      nombreProductoSnapshot: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nombre_producto_snapshot'],
      )!,
      precioUnitarioCentavosSnapshot: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}precio_unitario_centavos_snapshot'],
      )!,
      cantidad: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}cantidad'],
      )!,
      subtotalCentavos: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}subtotal_centavos'],
      )!,
    );
  }

  @override
  $SaleDetailsTable createAlias(String alias) {
    return $SaleDetailsTable(attachedDatabase, alias);
  }
}

class SaleDetailEntity extends DataClass
    implements Insertable<SaleDetailEntity> {
  final int id;
  final int ventaId;
  final int productoId;
  final String nombreProductoSnapshot;
  final int precioUnitarioCentavosSnapshot;
  final int cantidad;
  final int subtotalCentavos;
  const SaleDetailEntity({
    required this.id,
    required this.ventaId,
    required this.productoId,
    required this.nombreProductoSnapshot,
    required this.precioUnitarioCentavosSnapshot,
    required this.cantidad,
    required this.subtotalCentavos,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['venta_id'] = Variable<int>(ventaId);
    map['producto_id'] = Variable<int>(productoId);
    map['nombre_producto_snapshot'] = Variable<String>(nombreProductoSnapshot);
    map['precio_unitario_centavos_snapshot'] = Variable<int>(
      precioUnitarioCentavosSnapshot,
    );
    map['cantidad'] = Variable<int>(cantidad);
    map['subtotal_centavos'] = Variable<int>(subtotalCentavos);
    return map;
  }

  SaleDetailsCompanion toCompanion(bool nullToAbsent) {
    return SaleDetailsCompanion(
      id: Value(id),
      ventaId: Value(ventaId),
      productoId: Value(productoId),
      nombreProductoSnapshot: Value(nombreProductoSnapshot),
      precioUnitarioCentavosSnapshot: Value(precioUnitarioCentavosSnapshot),
      cantidad: Value(cantidad),
      subtotalCentavos: Value(subtotalCentavos),
    );
  }

  factory SaleDetailEntity.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SaleDetailEntity(
      id: serializer.fromJson<int>(json['id']),
      ventaId: serializer.fromJson<int>(json['ventaId']),
      productoId: serializer.fromJson<int>(json['productoId']),
      nombreProductoSnapshot: serializer.fromJson<String>(
        json['nombreProductoSnapshot'],
      ),
      precioUnitarioCentavosSnapshot: serializer.fromJson<int>(
        json['precioUnitarioCentavosSnapshot'],
      ),
      cantidad: serializer.fromJson<int>(json['cantidad']),
      subtotalCentavos: serializer.fromJson<int>(json['subtotalCentavos']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'ventaId': serializer.toJson<int>(ventaId),
      'productoId': serializer.toJson<int>(productoId),
      'nombreProductoSnapshot': serializer.toJson<String>(
        nombreProductoSnapshot,
      ),
      'precioUnitarioCentavosSnapshot': serializer.toJson<int>(
        precioUnitarioCentavosSnapshot,
      ),
      'cantidad': serializer.toJson<int>(cantidad),
      'subtotalCentavos': serializer.toJson<int>(subtotalCentavos),
    };
  }

  SaleDetailEntity copyWith({
    int? id,
    int? ventaId,
    int? productoId,
    String? nombreProductoSnapshot,
    int? precioUnitarioCentavosSnapshot,
    int? cantidad,
    int? subtotalCentavos,
  }) => SaleDetailEntity(
    id: id ?? this.id,
    ventaId: ventaId ?? this.ventaId,
    productoId: productoId ?? this.productoId,
    nombreProductoSnapshot:
        nombreProductoSnapshot ?? this.nombreProductoSnapshot,
    precioUnitarioCentavosSnapshot:
        precioUnitarioCentavosSnapshot ?? this.precioUnitarioCentavosSnapshot,
    cantidad: cantidad ?? this.cantidad,
    subtotalCentavos: subtotalCentavos ?? this.subtotalCentavos,
  );
  SaleDetailEntity copyWithCompanion(SaleDetailsCompanion data) {
    return SaleDetailEntity(
      id: data.id.present ? data.id.value : this.id,
      ventaId: data.ventaId.present ? data.ventaId.value : this.ventaId,
      productoId: data.productoId.present
          ? data.productoId.value
          : this.productoId,
      nombreProductoSnapshot: data.nombreProductoSnapshot.present
          ? data.nombreProductoSnapshot.value
          : this.nombreProductoSnapshot,
      precioUnitarioCentavosSnapshot:
          data.precioUnitarioCentavosSnapshot.present
          ? data.precioUnitarioCentavosSnapshot.value
          : this.precioUnitarioCentavosSnapshot,
      cantidad: data.cantidad.present ? data.cantidad.value : this.cantidad,
      subtotalCentavos: data.subtotalCentavos.present
          ? data.subtotalCentavos.value
          : this.subtotalCentavos,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SaleDetailEntity(')
          ..write('id: $id, ')
          ..write('ventaId: $ventaId, ')
          ..write('productoId: $productoId, ')
          ..write('nombreProductoSnapshot: $nombreProductoSnapshot, ')
          ..write(
            'precioUnitarioCentavosSnapshot: $precioUnitarioCentavosSnapshot, ',
          )
          ..write('cantidad: $cantidad, ')
          ..write('subtotalCentavos: $subtotalCentavos')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    ventaId,
    productoId,
    nombreProductoSnapshot,
    precioUnitarioCentavosSnapshot,
    cantidad,
    subtotalCentavos,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SaleDetailEntity &&
          other.id == this.id &&
          other.ventaId == this.ventaId &&
          other.productoId == this.productoId &&
          other.nombreProductoSnapshot == this.nombreProductoSnapshot &&
          other.precioUnitarioCentavosSnapshot ==
              this.precioUnitarioCentavosSnapshot &&
          other.cantidad == this.cantidad &&
          other.subtotalCentavos == this.subtotalCentavos);
}

class SaleDetailsCompanion extends UpdateCompanion<SaleDetailEntity> {
  final Value<int> id;
  final Value<int> ventaId;
  final Value<int> productoId;
  final Value<String> nombreProductoSnapshot;
  final Value<int> precioUnitarioCentavosSnapshot;
  final Value<int> cantidad;
  final Value<int> subtotalCentavos;
  const SaleDetailsCompanion({
    this.id = const Value.absent(),
    this.ventaId = const Value.absent(),
    this.productoId = const Value.absent(),
    this.nombreProductoSnapshot = const Value.absent(),
    this.precioUnitarioCentavosSnapshot = const Value.absent(),
    this.cantidad = const Value.absent(),
    this.subtotalCentavos = const Value.absent(),
  });
  SaleDetailsCompanion.insert({
    this.id = const Value.absent(),
    required int ventaId,
    required int productoId,
    required String nombreProductoSnapshot,
    required int precioUnitarioCentavosSnapshot,
    required int cantidad,
    required int subtotalCentavos,
  }) : ventaId = Value(ventaId),
       productoId = Value(productoId),
       nombreProductoSnapshot = Value(nombreProductoSnapshot),
       precioUnitarioCentavosSnapshot = Value(precioUnitarioCentavosSnapshot),
       cantidad = Value(cantidad),
       subtotalCentavos = Value(subtotalCentavos);
  static Insertable<SaleDetailEntity> custom({
    Expression<int>? id,
    Expression<int>? ventaId,
    Expression<int>? productoId,
    Expression<String>? nombreProductoSnapshot,
    Expression<int>? precioUnitarioCentavosSnapshot,
    Expression<int>? cantidad,
    Expression<int>? subtotalCentavos,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (ventaId != null) 'venta_id': ventaId,
      if (productoId != null) 'producto_id': productoId,
      if (nombreProductoSnapshot != null)
        'nombre_producto_snapshot': nombreProductoSnapshot,
      if (precioUnitarioCentavosSnapshot != null)
        'precio_unitario_centavos_snapshot': precioUnitarioCentavosSnapshot,
      if (cantidad != null) 'cantidad': cantidad,
      if (subtotalCentavos != null) 'subtotal_centavos': subtotalCentavos,
    });
  }

  SaleDetailsCompanion copyWith({
    Value<int>? id,
    Value<int>? ventaId,
    Value<int>? productoId,
    Value<String>? nombreProductoSnapshot,
    Value<int>? precioUnitarioCentavosSnapshot,
    Value<int>? cantidad,
    Value<int>? subtotalCentavos,
  }) {
    return SaleDetailsCompanion(
      id: id ?? this.id,
      ventaId: ventaId ?? this.ventaId,
      productoId: productoId ?? this.productoId,
      nombreProductoSnapshot:
          nombreProductoSnapshot ?? this.nombreProductoSnapshot,
      precioUnitarioCentavosSnapshot:
          precioUnitarioCentavosSnapshot ?? this.precioUnitarioCentavosSnapshot,
      cantidad: cantidad ?? this.cantidad,
      subtotalCentavos: subtotalCentavos ?? this.subtotalCentavos,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (ventaId.present) {
      map['venta_id'] = Variable<int>(ventaId.value);
    }
    if (productoId.present) {
      map['producto_id'] = Variable<int>(productoId.value);
    }
    if (nombreProductoSnapshot.present) {
      map['nombre_producto_snapshot'] = Variable<String>(
        nombreProductoSnapshot.value,
      );
    }
    if (precioUnitarioCentavosSnapshot.present) {
      map['precio_unitario_centavos_snapshot'] = Variable<int>(
        precioUnitarioCentavosSnapshot.value,
      );
    }
    if (cantidad.present) {
      map['cantidad'] = Variable<int>(cantidad.value);
    }
    if (subtotalCentavos.present) {
      map['subtotal_centavos'] = Variable<int>(subtotalCentavos.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SaleDetailsCompanion(')
          ..write('id: $id, ')
          ..write('ventaId: $ventaId, ')
          ..write('productoId: $productoId, ')
          ..write('nombreProductoSnapshot: $nombreProductoSnapshot, ')
          ..write(
            'precioUnitarioCentavosSnapshot: $precioUnitarioCentavosSnapshot, ',
          )
          ..write('cantidad: $cantidad, ')
          ..write('subtotalCentavos: $subtotalCentavos')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $SalesTable sales = $SalesTable(this);
  late final $SaleDetailsTable saleDetails = $SaleDetailsTable(this);
  late final SalesDao salesDao = SalesDao(this as AppDatabase);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [sales, saleDetails];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'sales',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('sale_details', kind: UpdateKind.delete)],
    ),
  ]);
}

typedef $$SalesTableCreateCompanionBuilder =
    SalesCompanion Function({
      Value<int> id,
      required DateTime fechaHora,
      required int totalCentavos,
      required int dineroRecibidoCentavos,
      required int cambioCentavos,
      required SaleStatus estado,
    });
typedef $$SalesTableUpdateCompanionBuilder =
    SalesCompanion Function({
      Value<int> id,
      Value<DateTime> fechaHora,
      Value<int> totalCentavos,
      Value<int> dineroRecibidoCentavos,
      Value<int> cambioCentavos,
      Value<SaleStatus> estado,
    });

final class $$SalesTableReferences
    extends BaseReferences<_$AppDatabase, $SalesTable, SaleEntity> {
  $$SalesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$SaleDetailsTable, List<SaleDetailEntity>>
  _saleDetailsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.saleDetails,
    aliasName: 'sales__id__sale_details__venta_id',
  );

  $$SaleDetailsTableProcessedTableManager get saleDetailsRefs {
    final manager = $$SaleDetailsTableTableManager(
      $_db,
      $_db.saleDetails,
    ).filter((f) => f.ventaId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_saleDetailsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$SalesTableFilterComposer extends Composer<_$AppDatabase, $SalesTable> {
  $$SalesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get fechaHora => $composableBuilder(
    column: $table.fechaHora,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get totalCentavos => $composableBuilder(
    column: $table.totalCentavos,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get dineroRecibidoCentavos => $composableBuilder(
    column: $table.dineroRecibidoCentavos,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get cambioCentavos => $composableBuilder(
    column: $table.cambioCentavos,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<SaleStatus, SaleStatus, String> get estado =>
      $composableBuilder(
        column: $table.estado,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  Expression<bool> saleDetailsRefs(
    Expression<bool> Function($$SaleDetailsTableFilterComposer f) f,
  ) {
    final $$SaleDetailsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.saleDetails,
      getReferencedColumn: (t) => t.ventaId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SaleDetailsTableFilterComposer(
            $db: $db,
            $table: $db.saleDetails,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$SalesTableOrderingComposer
    extends Composer<_$AppDatabase, $SalesTable> {
  $$SalesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get fechaHora => $composableBuilder(
    column: $table.fechaHora,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get totalCentavos => $composableBuilder(
    column: $table.totalCentavos,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get dineroRecibidoCentavos => $composableBuilder(
    column: $table.dineroRecibidoCentavos,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get cambioCentavos => $composableBuilder(
    column: $table.cambioCentavos,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get estado => $composableBuilder(
    column: $table.estado,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SalesTableAnnotationComposer
    extends Composer<_$AppDatabase, $SalesTable> {
  $$SalesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get fechaHora =>
      $composableBuilder(column: $table.fechaHora, builder: (column) => column);

  GeneratedColumn<int> get totalCentavos => $composableBuilder(
    column: $table.totalCentavos,
    builder: (column) => column,
  );

  GeneratedColumn<int> get dineroRecibidoCentavos => $composableBuilder(
    column: $table.dineroRecibidoCentavos,
    builder: (column) => column,
  );

  GeneratedColumn<int> get cambioCentavos => $composableBuilder(
    column: $table.cambioCentavos,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<SaleStatus, String> get estado =>
      $composableBuilder(column: $table.estado, builder: (column) => column);

  Expression<T> saleDetailsRefs<T extends Object>(
    Expression<T> Function($$SaleDetailsTableAnnotationComposer a) f,
  ) {
    final $$SaleDetailsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.saleDetails,
      getReferencedColumn: (t) => t.ventaId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SaleDetailsTableAnnotationComposer(
            $db: $db,
            $table: $db.saleDetails,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$SalesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SalesTable,
          SaleEntity,
          $$SalesTableFilterComposer,
          $$SalesTableOrderingComposer,
          $$SalesTableAnnotationComposer,
          $$SalesTableCreateCompanionBuilder,
          $$SalesTableUpdateCompanionBuilder,
          (SaleEntity, $$SalesTableReferences),
          SaleEntity,
          PrefetchHooks Function({bool saleDetailsRefs})
        > {
  $$SalesTableTableManager(_$AppDatabase db, $SalesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SalesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SalesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SalesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<DateTime> fechaHora = const Value.absent(),
                Value<int> totalCentavos = const Value.absent(),
                Value<int> dineroRecibidoCentavos = const Value.absent(),
                Value<int> cambioCentavos = const Value.absent(),
                Value<SaleStatus> estado = const Value.absent(),
              }) => SalesCompanion(
                id: id,
                fechaHora: fechaHora,
                totalCentavos: totalCentavos,
                dineroRecibidoCentavos: dineroRecibidoCentavos,
                cambioCentavos: cambioCentavos,
                estado: estado,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required DateTime fechaHora,
                required int totalCentavos,
                required int dineroRecibidoCentavos,
                required int cambioCentavos,
                required SaleStatus estado,
              }) => SalesCompanion.insert(
                id: id,
                fechaHora: fechaHora,
                totalCentavos: totalCentavos,
                dineroRecibidoCentavos: dineroRecibidoCentavos,
                cambioCentavos: cambioCentavos,
                estado: estado,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$SalesTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback: ({saleDetailsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (saleDetailsRefs) db.saleDetails],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (saleDetailsRefs)
                    await $_getPrefetchedData<
                      SaleEntity,
                      $SalesTable,
                      SaleDetailEntity
                    >(
                      currentTable: table,
                      referencedTable: $$SalesTableReferences
                          ._saleDetailsRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$SalesTableReferences(db, table, p0).saleDetailsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.ventaId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$SalesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SalesTable,
      SaleEntity,
      $$SalesTableFilterComposer,
      $$SalesTableOrderingComposer,
      $$SalesTableAnnotationComposer,
      $$SalesTableCreateCompanionBuilder,
      $$SalesTableUpdateCompanionBuilder,
      (SaleEntity, $$SalesTableReferences),
      SaleEntity,
      PrefetchHooks Function({bool saleDetailsRefs})
    >;
typedef $$SaleDetailsTableCreateCompanionBuilder =
    SaleDetailsCompanion Function({
      Value<int> id,
      required int ventaId,
      required int productoId,
      required String nombreProductoSnapshot,
      required int precioUnitarioCentavosSnapshot,
      required int cantidad,
      required int subtotalCentavos,
    });
typedef $$SaleDetailsTableUpdateCompanionBuilder =
    SaleDetailsCompanion Function({
      Value<int> id,
      Value<int> ventaId,
      Value<int> productoId,
      Value<String> nombreProductoSnapshot,
      Value<int> precioUnitarioCentavosSnapshot,
      Value<int> cantidad,
      Value<int> subtotalCentavos,
    });

final class $$SaleDetailsTableReferences
    extends BaseReferences<_$AppDatabase, $SaleDetailsTable, SaleDetailEntity> {
  $$SaleDetailsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $SalesTable _ventaIdTable(_$AppDatabase db) =>
      db.sales.createAlias('sale_details__venta_id__sales__id');

  $$SalesTableProcessedTableManager get ventaId {
    final $_column = $_itemColumn<int>('venta_id')!;

    final manager = $$SalesTableTableManager(
      $_db,
      $_db.sales,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_ventaIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$SaleDetailsTableFilterComposer
    extends Composer<_$AppDatabase, $SaleDetailsTable> {
  $$SaleDetailsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get productoId => $composableBuilder(
    column: $table.productoId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nombreProductoSnapshot => $composableBuilder(
    column: $table.nombreProductoSnapshot,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get precioUnitarioCentavosSnapshot => $composableBuilder(
    column: $table.precioUnitarioCentavosSnapshot,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get cantidad => $composableBuilder(
    column: $table.cantidad,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get subtotalCentavos => $composableBuilder(
    column: $table.subtotalCentavos,
    builder: (column) => ColumnFilters(column),
  );

  $$SalesTableFilterComposer get ventaId {
    final $$SalesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.ventaId,
      referencedTable: $db.sales,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SalesTableFilterComposer(
            $db: $db,
            $table: $db.sales,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SaleDetailsTableOrderingComposer
    extends Composer<_$AppDatabase, $SaleDetailsTable> {
  $$SaleDetailsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get productoId => $composableBuilder(
    column: $table.productoId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nombreProductoSnapshot => $composableBuilder(
    column: $table.nombreProductoSnapshot,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get precioUnitarioCentavosSnapshot => $composableBuilder(
    column: $table.precioUnitarioCentavosSnapshot,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get cantidad => $composableBuilder(
    column: $table.cantidad,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get subtotalCentavos => $composableBuilder(
    column: $table.subtotalCentavos,
    builder: (column) => ColumnOrderings(column),
  );

  $$SalesTableOrderingComposer get ventaId {
    final $$SalesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.ventaId,
      referencedTable: $db.sales,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SalesTableOrderingComposer(
            $db: $db,
            $table: $db.sales,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SaleDetailsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SaleDetailsTable> {
  $$SaleDetailsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get productoId => $composableBuilder(
    column: $table.productoId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get nombreProductoSnapshot => $composableBuilder(
    column: $table.nombreProductoSnapshot,
    builder: (column) => column,
  );

  GeneratedColumn<int> get precioUnitarioCentavosSnapshot => $composableBuilder(
    column: $table.precioUnitarioCentavosSnapshot,
    builder: (column) => column,
  );

  GeneratedColumn<int> get cantidad =>
      $composableBuilder(column: $table.cantidad, builder: (column) => column);

  GeneratedColumn<int> get subtotalCentavos => $composableBuilder(
    column: $table.subtotalCentavos,
    builder: (column) => column,
  );

  $$SalesTableAnnotationComposer get ventaId {
    final $$SalesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.ventaId,
      referencedTable: $db.sales,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SalesTableAnnotationComposer(
            $db: $db,
            $table: $db.sales,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SaleDetailsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SaleDetailsTable,
          SaleDetailEntity,
          $$SaleDetailsTableFilterComposer,
          $$SaleDetailsTableOrderingComposer,
          $$SaleDetailsTableAnnotationComposer,
          $$SaleDetailsTableCreateCompanionBuilder,
          $$SaleDetailsTableUpdateCompanionBuilder,
          (SaleDetailEntity, $$SaleDetailsTableReferences),
          SaleDetailEntity,
          PrefetchHooks Function({bool ventaId})
        > {
  $$SaleDetailsTableTableManager(_$AppDatabase db, $SaleDetailsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SaleDetailsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SaleDetailsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SaleDetailsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> ventaId = const Value.absent(),
                Value<int> productoId = const Value.absent(),
                Value<String> nombreProductoSnapshot = const Value.absent(),
                Value<int> precioUnitarioCentavosSnapshot =
                    const Value.absent(),
                Value<int> cantidad = const Value.absent(),
                Value<int> subtotalCentavos = const Value.absent(),
              }) => SaleDetailsCompanion(
                id: id,
                ventaId: ventaId,
                productoId: productoId,
                nombreProductoSnapshot: nombreProductoSnapshot,
                precioUnitarioCentavosSnapshot: precioUnitarioCentavosSnapshot,
                cantidad: cantidad,
                subtotalCentavos: subtotalCentavos,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int ventaId,
                required int productoId,
                required String nombreProductoSnapshot,
                required int precioUnitarioCentavosSnapshot,
                required int cantidad,
                required int subtotalCentavos,
              }) => SaleDetailsCompanion.insert(
                id: id,
                ventaId: ventaId,
                productoId: productoId,
                nombreProductoSnapshot: nombreProductoSnapshot,
                precioUnitarioCentavosSnapshot: precioUnitarioCentavosSnapshot,
                cantidad: cantidad,
                subtotalCentavos: subtotalCentavos,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$SaleDetailsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({ventaId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (ventaId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.ventaId,
                                referencedTable: $$SaleDetailsTableReferences
                                    ._ventaIdTable(db),
                                referencedColumn: $$SaleDetailsTableReferences
                                    ._ventaIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$SaleDetailsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SaleDetailsTable,
      SaleDetailEntity,
      $$SaleDetailsTableFilterComposer,
      $$SaleDetailsTableOrderingComposer,
      $$SaleDetailsTableAnnotationComposer,
      $$SaleDetailsTableCreateCompanionBuilder,
      $$SaleDetailsTableUpdateCompanionBuilder,
      (SaleDetailEntity, $$SaleDetailsTableReferences),
      SaleDetailEntity,
      PrefetchHooks Function({bool ventaId})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$SalesTableTableManager get sales =>
      $$SalesTableTableManager(_db, _db.sales);
  $$SaleDetailsTableTableManager get saleDetails =>
      $$SaleDetailsTableTableManager(_db, _db.saleDetails);
}
