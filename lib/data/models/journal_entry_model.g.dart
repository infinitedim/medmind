// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'journal_entry_model.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetJournalEntryModelCollection on Isar {
  IsarCollection<JournalEntryModel> get journalEntryModels => this.collection();
}

const JournalEntryModelSchema = CollectionSchema(
  name: r'JournalEntryModel',
  id: 3211955384174486103,
  properties: {
    r'activityLevel': PropertySchema(
      id: 0,
      name: r'activityLevel',
      type: IsarType.string,
      enumMap: _JournalEntryModelactivityLevelEnumValueMap,
    ),
    r'createdAt': PropertySchema(
      id: 1,
      name: r'createdAt',
      type: IsarType.dateTime,
    ),
    r'date': PropertySchema(
      id: 2,
      name: r'date',
      type: IsarType.dateTime,
    ),
    r'extractedSymptoms': PropertySchema(
      id: 3,
      name: r'extractedSymptoms',
      type: IsarType.objectList,
      target: r'ExtractedSymptomEmbed',
    ),
    r'freeText': PropertySchema(
      id: 4,
      name: r'freeText',
      type: IsarType.string,
    ),
    r'lifestyleFactors': PropertySchema(
      id: 5,
      name: r'lifestyleFactors',
      type: IsarType.objectList,
      target: r'LifestyleFactorLogEmbed',
    ),
    r'medications': PropertySchema(
      id: 6,
      name: r'medications',
      type: IsarType.objectList,
      target: r'MedicationLogEmbed',
    ),
    r'mood': PropertySchema(
      id: 7,
      name: r'mood',
      type: IsarType.string,
      enumMap: _JournalEntryModelmoodEnumValueMap,
    ),
    r'moodIntensity': PropertySchema(
      id: 8,
      name: r'moodIntensity',
      type: IsarType.long,
    ),
    r'sleepRecord': PropertySchema(
      id: 9,
      name: r'sleepRecord',
      type: IsarType.object,
      target: r'SleepRecordEmbed',
    ),
    r'symptoms': PropertySchema(
      id: 10,
      name: r'symptoms',
      type: IsarType.objectList,
      target: r'SymptomLogEmbed',
    ),
    r'uid': PropertySchema(
      id: 11,
      name: r'uid',
      type: IsarType.string,
    ),
    r'updatedAt': PropertySchema(
      id: 12,
      name: r'updatedAt',
      type: IsarType.dateTime,
    )
  },
  estimateSize: _journalEntryModelEstimateSize,
  serialize: _journalEntryModelSerialize,
  deserialize: _journalEntryModelDeserialize,
  deserializeProp: _journalEntryModelDeserializeProp,
  idName: r'id',
  indexes: {
    r'uid': IndexSchema(
      id: 8193695471701937315,
      name: r'uid',
      unique: true,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'uid',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    ),
    r'date': IndexSchema(
      id: -7552997827385218417,
      name: r'date',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'date',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {
    r'SymptomLogEmbed': SymptomLogEmbedSchema,
    r'MedicationLogEmbed': MedicationLogEmbedSchema,
    r'SleepRecordEmbed': SleepRecordEmbedSchema,
    r'LifestyleFactorLogEmbed': LifestyleFactorLogEmbedSchema,
    r'ExtractedSymptomEmbed': ExtractedSymptomEmbedSchema
  },
  getId: _journalEntryModelGetId,
  getLinks: _journalEntryModelGetLinks,
  attach: _journalEntryModelAttach,
  version: '3.1.0+1',
);

int _journalEntryModelEstimateSize(
  JournalEntryModel object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.activityLevel;
    if (value != null) {
      bytesCount += 3 + value.name.length * 3;
    }
  }
  {
    final list = object.extractedSymptoms;
    if (list != null) {
      bytesCount += 3 + list.length * 3;
      {
        final offsets = allOffsets[ExtractedSymptomEmbed]!;
        for (var i = 0; i < list.length; i++) {
          final value = list[i];
          bytesCount += ExtractedSymptomEmbedSchema.estimateSize(
              value, offsets, allOffsets);
        }
      }
    }
  }
  {
    final value = object.freeText;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.lifestyleFactors.length * 3;
  {
    final offsets = allOffsets[LifestyleFactorLogEmbed]!;
    for (var i = 0; i < object.lifestyleFactors.length; i++) {
      final value = object.lifestyleFactors[i];
      bytesCount += LifestyleFactorLogEmbedSchema.estimateSize(
          value, offsets, allOffsets);
    }
  }
  bytesCount += 3 + object.medications.length * 3;
  {
    final offsets = allOffsets[MedicationLogEmbed]!;
    for (var i = 0; i < object.medications.length; i++) {
      final value = object.medications[i];
      bytesCount +=
          MedicationLogEmbedSchema.estimateSize(value, offsets, allOffsets);
    }
  }
  {
    final value = object.mood;
    if (value != null) {
      bytesCount += 3 + value.name.length * 3;
    }
  }
  {
    final value = object.sleepRecord;
    if (value != null) {
      bytesCount += 3 +
          SleepRecordEmbedSchema.estimateSize(
              value, allOffsets[SleepRecordEmbed]!, allOffsets);
    }
  }
  bytesCount += 3 + object.symptoms.length * 3;
  {
    final offsets = allOffsets[SymptomLogEmbed]!;
    for (var i = 0; i < object.symptoms.length; i++) {
      final value = object.symptoms[i];
      bytesCount +=
          SymptomLogEmbedSchema.estimateSize(value, offsets, allOffsets);
    }
  }
  bytesCount += 3 + object.uid.length * 3;
  return bytesCount;
}

void _journalEntryModelSerialize(
  JournalEntryModel object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.activityLevel?.name);
  writer.writeDateTime(offsets[1], object.createdAt);
  writer.writeDateTime(offsets[2], object.date);
  writer.writeObjectList<ExtractedSymptomEmbed>(
    offsets[3],
    allOffsets,
    ExtractedSymptomEmbedSchema.serialize,
    object.extractedSymptoms,
  );
  writer.writeString(offsets[4], object.freeText);
  writer.writeObjectList<LifestyleFactorLogEmbed>(
    offsets[5],
    allOffsets,
    LifestyleFactorLogEmbedSchema.serialize,
    object.lifestyleFactors,
  );
  writer.writeObjectList<MedicationLogEmbed>(
    offsets[6],
    allOffsets,
    MedicationLogEmbedSchema.serialize,
    object.medications,
  );
  writer.writeString(offsets[7], object.mood?.name);
  writer.writeLong(offsets[8], object.moodIntensity);
  writer.writeObject<SleepRecordEmbed>(
    offsets[9],
    allOffsets,
    SleepRecordEmbedSchema.serialize,
    object.sleepRecord,
  );
  writer.writeObjectList<SymptomLogEmbed>(
    offsets[10],
    allOffsets,
    SymptomLogEmbedSchema.serialize,
    object.symptoms,
  );
  writer.writeString(offsets[11], object.uid);
  writer.writeDateTime(offsets[12], object.updatedAt);
}

JournalEntryModel _journalEntryModelDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = JournalEntryModel();
  object.activityLevel = _JournalEntryModelactivityLevelValueEnumMap[
      reader.readStringOrNull(offsets[0])];
  object.createdAt = reader.readDateTime(offsets[1]);
  object.date = reader.readDateTime(offsets[2]);
  object.extractedSymptoms = reader.readObjectList<ExtractedSymptomEmbed>(
    offsets[3],
    ExtractedSymptomEmbedSchema.deserialize,
    allOffsets,
    ExtractedSymptomEmbed(),
  );
  object.freeText = reader.readStringOrNull(offsets[4]);
  object.id = id;
  object.lifestyleFactors = reader.readObjectList<LifestyleFactorLogEmbed>(
        offsets[5],
        LifestyleFactorLogEmbedSchema.deserialize,
        allOffsets,
        LifestyleFactorLogEmbed(),
      ) ??
      [];
  object.medications = reader.readObjectList<MedicationLogEmbed>(
        offsets[6],
        MedicationLogEmbedSchema.deserialize,
        allOffsets,
        MedicationLogEmbed(),
      ) ??
      [];
  object.mood =
      _JournalEntryModelmoodValueEnumMap[reader.readStringOrNull(offsets[7])];
  object.moodIntensity = reader.readLongOrNull(offsets[8]);
  object.sleepRecord = reader.readObjectOrNull<SleepRecordEmbed>(
    offsets[9],
    SleepRecordEmbedSchema.deserialize,
    allOffsets,
  );
  object.symptoms = reader.readObjectList<SymptomLogEmbed>(
        offsets[10],
        SymptomLogEmbedSchema.deserialize,
        allOffsets,
        SymptomLogEmbed(),
      ) ??
      [];
  object.uid = reader.readString(offsets[11]);
  object.updatedAt = reader.readDateTime(offsets[12]);
  return object;
}

P _journalEntryModelDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (_JournalEntryModelactivityLevelValueEnumMap[
          reader.readStringOrNull(offset)]) as P;
    case 1:
      return (reader.readDateTime(offset)) as P;
    case 2:
      return (reader.readDateTime(offset)) as P;
    case 3:
      return (reader.readObjectList<ExtractedSymptomEmbed>(
        offset,
        ExtractedSymptomEmbedSchema.deserialize,
        allOffsets,
        ExtractedSymptomEmbed(),
      )) as P;
    case 4:
      return (reader.readStringOrNull(offset)) as P;
    case 5:
      return (reader.readObjectList<LifestyleFactorLogEmbed>(
            offset,
            LifestyleFactorLogEmbedSchema.deserialize,
            allOffsets,
            LifestyleFactorLogEmbed(),
          ) ??
          []) as P;
    case 6:
      return (reader.readObjectList<MedicationLogEmbed>(
            offset,
            MedicationLogEmbedSchema.deserialize,
            allOffsets,
            MedicationLogEmbed(),
          ) ??
          []) as P;
    case 7:
      return (_JournalEntryModelmoodValueEnumMap[
          reader.readStringOrNull(offset)]) as P;
    case 8:
      return (reader.readLongOrNull(offset)) as P;
    case 9:
      return (reader.readObjectOrNull<SleepRecordEmbed>(
        offset,
        SleepRecordEmbedSchema.deserialize,
        allOffsets,
      )) as P;
    case 10:
      return (reader.readObjectList<SymptomLogEmbed>(
            offset,
            SymptomLogEmbedSchema.deserialize,
            allOffsets,
            SymptomLogEmbed(),
          ) ??
          []) as P;
    case 11:
      return (reader.readString(offset)) as P;
    case 12:
      return (reader.readDateTime(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _JournalEntryModelactivityLevelEnumValueMap = {
  r'sedentary': r'sedentary',
  r'light': r'light',
  r'moderate': r'moderate',
  r'active': r'active',
};
const _JournalEntryModelactivityLevelValueEnumMap = {
  r'sedentary': ActivityLevel.sedentary,
  r'light': ActivityLevel.light,
  r'moderate': ActivityLevel.moderate,
  r'active': ActivityLevel.active,
};
const _JournalEntryModelmoodEnumValueMap = {
  r'great': r'great',
  r'good': r'good',
  r'okay': r'okay',
  r'bad': r'bad',
  r'terrible': r'terrible',
};
const _JournalEntryModelmoodValueEnumMap = {
  r'great': Mood.great,
  r'good': Mood.good,
  r'okay': Mood.okay,
  r'bad': Mood.bad,
  r'terrible': Mood.terrible,
};

Id _journalEntryModelGetId(JournalEntryModel object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _journalEntryModelGetLinks(
    JournalEntryModel object) {
  return [];
}

void _journalEntryModelAttach(
    IsarCollection<dynamic> col, Id id, JournalEntryModel object) {
  object.id = id;
}

extension JournalEntryModelByIndex on IsarCollection<JournalEntryModel> {
  Future<JournalEntryModel?> getByUid(String uid) {
    return getByIndex(r'uid', [uid]);
  }

  JournalEntryModel? getByUidSync(String uid) {
    return getByIndexSync(r'uid', [uid]);
  }

  Future<bool> deleteByUid(String uid) {
    return deleteByIndex(r'uid', [uid]);
  }

  bool deleteByUidSync(String uid) {
    return deleteByIndexSync(r'uid', [uid]);
  }

  Future<List<JournalEntryModel?>> getAllByUid(List<String> uidValues) {
    final values = uidValues.map((e) => [e]).toList();
    return getAllByIndex(r'uid', values);
  }

  List<JournalEntryModel?> getAllByUidSync(List<String> uidValues) {
    final values = uidValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'uid', values);
  }

  Future<int> deleteAllByUid(List<String> uidValues) {
    final values = uidValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'uid', values);
  }

  int deleteAllByUidSync(List<String> uidValues) {
    final values = uidValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'uid', values);
  }

  Future<Id> putByUid(JournalEntryModel object) {
    return putByIndex(r'uid', object);
  }

  Id putByUidSync(JournalEntryModel object, {bool saveLinks = true}) {
    return putByIndexSync(r'uid', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByUid(List<JournalEntryModel> objects) {
    return putAllByIndex(r'uid', objects);
  }

  List<Id> putAllByUidSync(List<JournalEntryModel> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'uid', objects, saveLinks: saveLinks);
  }
}

extension JournalEntryModelQueryWhereSort
    on QueryBuilder<JournalEntryModel, JournalEntryModel, QWhere> {
  QueryBuilder<JournalEntryModel, JournalEntryModel, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<JournalEntryModel, JournalEntryModel, QAfterWhere> anyDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'date'),
      );
    });
  }
}

extension JournalEntryModelQueryWhere
    on QueryBuilder<JournalEntryModel, JournalEntryModel, QWhereClause> {
  QueryBuilder<JournalEntryModel, JournalEntryModel, QAfterWhereClause>
      idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<JournalEntryModel, JournalEntryModel, QAfterWhereClause>
      idNotEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<JournalEntryModel, JournalEntryModel, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<JournalEntryModel, JournalEntryModel, QAfterWhereClause>
      idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<JournalEntryModel, JournalEntryModel, QAfterWhereClause>
      idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<JournalEntryModel, JournalEntryModel, QAfterWhereClause>
      uidEqualTo(String uid) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'uid',
        value: [uid],
      ));
    });
  }

  QueryBuilder<JournalEntryModel, JournalEntryModel, QAfterWhereClause>
      uidNotEqualTo(String uid) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'uid',
              lower: [],
              upper: [uid],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'uid',
              lower: [uid],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'uid',
              lower: [uid],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'uid',
              lower: [],
              upper: [uid],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<JournalEntryModel, JournalEntryModel, QAfterWhereClause>
      dateEqualTo(DateTime date) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'date',
        value: [date],
      ));
    });
  }

  QueryBuilder<JournalEntryModel, JournalEntryModel, QAfterWhereClause>
      dateNotEqualTo(DateTime date) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'date',
              lower: [],
              upper: [date],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'date',
              lower: [date],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'date',
              lower: [date],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'date',
              lower: [],
              upper: [date],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<JournalEntryModel, JournalEntryModel, QAfterWhereClause>
      dateGreaterThan(
    DateTime date, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'date',
        lower: [date],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<JournalEntryModel, JournalEntryModel, QAfterWhereClause>
      dateLessThan(
    DateTime date, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'date',
        lower: [],
        upper: [date],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<JournalEntryModel, JournalEntryModel, QAfterWhereClause>
      dateBetween(
    DateTime lowerDate,
    DateTime upperDate, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'date',
        lower: [lowerDate],
        includeLower: includeLower,
        upper: [upperDate],
        includeUpper: includeUpper,
      ));
    });
  }
}

extension JournalEntryModelQueryFilter
    on QueryBuilder<JournalEntryModel, JournalEntryModel, QFilterCondition> {
  QueryBuilder<JournalEntryModel, JournalEntryModel, QAfterFilterCondition>
      activityLevelIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'activityLevel',
      ));
    });
  }

  QueryBuilder<JournalEntryModel, JournalEntryModel, QAfterFilterCondition>
      activityLevelIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'activityLevel',
      ));
    });
  }

  QueryBuilder<JournalEntryModel, JournalEntryModel, QAfterFilterCondition>
      activityLevelEqualTo(
    ActivityLevel? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'activityLevel',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<JournalEntryModel, JournalEntryModel, QAfterFilterCondition>
      activityLevelGreaterThan(
    ActivityLevel? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'activityLevel',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<JournalEntryModel, JournalEntryModel, QAfterFilterCondition>
      activityLevelLessThan(
    ActivityLevel? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'activityLevel',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<JournalEntryModel, JournalEntryModel, QAfterFilterCondition>
      activityLevelBetween(
    ActivityLevel? lower,
    ActivityLevel? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'activityLevel',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<JournalEntryModel, JournalEntryModel, QAfterFilterCondition>
      activityLevelStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'activityLevel',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<JournalEntryModel, JournalEntryModel, QAfterFilterCondition>
      activityLevelEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'activityLevel',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<JournalEntryModel, JournalEntryModel, QAfterFilterCondition>
      activityLevelContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'activityLevel',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<JournalEntryModel, JournalEntryModel, QAfterFilterCondition>
      activityLevelMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'activityLevel',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<JournalEntryModel, JournalEntryModel, QAfterFilterCondition>
      activityLevelIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'activityLevel',
        value: '',
      ));
    });
  }

  QueryBuilder<JournalEntryModel, JournalEntryModel, QAfterFilterCondition>
      activityLevelIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'activityLevel',
        value: '',
      ));
    });
  }

  QueryBuilder<JournalEntryModel, JournalEntryModel, QAfterFilterCondition>
      createdAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<JournalEntryModel, JournalEntryModel, QAfterFilterCondition>
      createdAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<JournalEntryModel, JournalEntryModel, QAfterFilterCondition>
      createdAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<JournalEntryModel, JournalEntryModel, QAfterFilterCondition>
      createdAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'createdAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<JournalEntryModel, JournalEntryModel, QAfterFilterCondition>
      dateEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'date',
        value: value,
      ));
    });
  }

  QueryBuilder<JournalEntryModel, JournalEntryModel, QAfterFilterCondition>
      dateGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'date',
        value: value,
      ));
    });
  }

  QueryBuilder<JournalEntryModel, JournalEntryModel, QAfterFilterCondition>
      dateLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'date',
        value: value,
      ));
    });
  }

  QueryBuilder<JournalEntryModel, JournalEntryModel, QAfterFilterCondition>
      dateBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'date',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<JournalEntryModel, JournalEntryModel, QAfterFilterCondition>
      extractedSymptomsIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'extractedSymptoms',
      ));
    });
  }

  QueryBuilder<JournalEntryModel, JournalEntryModel, QAfterFilterCondition>
      extractedSymptomsIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'extractedSymptoms',
      ));
    });
  }

  QueryBuilder<JournalEntryModel, JournalEntryModel, QAfterFilterCondition>
      extractedSymptomsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'extractedSymptoms',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<JournalEntryModel, JournalEntryModel, QAfterFilterCondition>
      extractedSymptomsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'extractedSymptoms',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<JournalEntryModel, JournalEntryModel, QAfterFilterCondition>
      extractedSymptomsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'extractedSymptoms',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<JournalEntryModel, JournalEntryModel, QAfterFilterCondition>
      extractedSymptomsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'extractedSymptoms',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<JournalEntryModel, JournalEntryModel, QAfterFilterCondition>
      extractedSymptomsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'extractedSymptoms',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<JournalEntryModel, JournalEntryModel, QAfterFilterCondition>
      extractedSymptomsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'extractedSymptoms',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<JournalEntryModel, JournalEntryModel, QAfterFilterCondition>
      freeTextIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'freeText',
      ));
    });
  }

  QueryBuilder<JournalEntryModel, JournalEntryModel, QAfterFilterCondition>
      freeTextIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'freeText',
      ));
    });
  }

  QueryBuilder<JournalEntryModel, JournalEntryModel, QAfterFilterCondition>
      freeTextEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'freeText',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<JournalEntryModel, JournalEntryModel, QAfterFilterCondition>
      freeTextGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'freeText',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<JournalEntryModel, JournalEntryModel, QAfterFilterCondition>
      freeTextLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'freeText',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<JournalEntryModel, JournalEntryModel, QAfterFilterCondition>
      freeTextBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'freeText',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<JournalEntryModel, JournalEntryModel, QAfterFilterCondition>
      freeTextStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'freeText',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<JournalEntryModel, JournalEntryModel, QAfterFilterCondition>
      freeTextEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'freeText',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<JournalEntryModel, JournalEntryModel, QAfterFilterCondition>
      freeTextContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'freeText',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<JournalEntryModel, JournalEntryModel, QAfterFilterCondition>
      freeTextMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'freeText',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<JournalEntryModel, JournalEntryModel, QAfterFilterCondition>
      freeTextIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'freeText',
        value: '',
      ));
    });
  }

  QueryBuilder<JournalEntryModel, JournalEntryModel, QAfterFilterCondition>
      freeTextIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'freeText',
        value: '',
      ));
    });
  }

  QueryBuilder<JournalEntryModel, JournalEntryModel, QAfterFilterCondition>
      idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<JournalEntryModel, JournalEntryModel, QAfterFilterCondition>
      idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<JournalEntryModel, JournalEntryModel, QAfterFilterCondition>
      idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<JournalEntryModel, JournalEntryModel, QAfterFilterCondition>
      idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<JournalEntryModel, JournalEntryModel, QAfterFilterCondition>
      lifestyleFactorsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'lifestyleFactors',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<JournalEntryModel, JournalEntryModel, QAfterFilterCondition>
      lifestyleFactorsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'lifestyleFactors',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<JournalEntryModel, JournalEntryModel, QAfterFilterCondition>
      lifestyleFactorsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'lifestyleFactors',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<JournalEntryModel, JournalEntryModel, QAfterFilterCondition>
      lifestyleFactorsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'lifestyleFactors',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<JournalEntryModel, JournalEntryModel, QAfterFilterCondition>
      lifestyleFactorsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'lifestyleFactors',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<JournalEntryModel, JournalEntryModel, QAfterFilterCondition>
      lifestyleFactorsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'lifestyleFactors',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<JournalEntryModel, JournalEntryModel, QAfterFilterCondition>
      medicationsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'medications',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<JournalEntryModel, JournalEntryModel, QAfterFilterCondition>
      medicationsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'medications',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<JournalEntryModel, JournalEntryModel, QAfterFilterCondition>
      medicationsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'medications',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<JournalEntryModel, JournalEntryModel, QAfterFilterCondition>
      medicationsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'medications',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<JournalEntryModel, JournalEntryModel, QAfterFilterCondition>
      medicationsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'medications',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<JournalEntryModel, JournalEntryModel, QAfterFilterCondition>
      medicationsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'medications',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<JournalEntryModel, JournalEntryModel, QAfterFilterCondition>
      moodIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'mood',
      ));
    });
  }

  QueryBuilder<JournalEntryModel, JournalEntryModel, QAfterFilterCondition>
      moodIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'mood',
      ));
    });
  }

  QueryBuilder<JournalEntryModel, JournalEntryModel, QAfterFilterCondition>
      moodEqualTo(
    Mood? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'mood',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<JournalEntryModel, JournalEntryModel, QAfterFilterCondition>
      moodGreaterThan(
    Mood? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'mood',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<JournalEntryModel, JournalEntryModel, QAfterFilterCondition>
      moodLessThan(
    Mood? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'mood',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<JournalEntryModel, JournalEntryModel, QAfterFilterCondition>
      moodBetween(
    Mood? lower,
    Mood? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'mood',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<JournalEntryModel, JournalEntryModel, QAfterFilterCondition>
      moodStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'mood',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<JournalEntryModel, JournalEntryModel, QAfterFilterCondition>
      moodEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'mood',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<JournalEntryModel, JournalEntryModel, QAfterFilterCondition>
      moodContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'mood',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<JournalEntryModel, JournalEntryModel, QAfterFilterCondition>
      moodMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'mood',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<JournalEntryModel, JournalEntryModel, QAfterFilterCondition>
      moodIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'mood',
        value: '',
      ));
    });
  }

  QueryBuilder<JournalEntryModel, JournalEntryModel, QAfterFilterCondition>
      moodIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'mood',
        value: '',
      ));
    });
  }

  QueryBuilder<JournalEntryModel, JournalEntryModel, QAfterFilterCondition>
      moodIntensityIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'moodIntensity',
      ));
    });
  }

  QueryBuilder<JournalEntryModel, JournalEntryModel, QAfterFilterCondition>
      moodIntensityIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'moodIntensity',
      ));
    });
  }

  QueryBuilder<JournalEntryModel, JournalEntryModel, QAfterFilterCondition>
      moodIntensityEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'moodIntensity',
        value: value,
      ));
    });
  }

  QueryBuilder<JournalEntryModel, JournalEntryModel, QAfterFilterCondition>
      moodIntensityGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'moodIntensity',
        value: value,
      ));
    });
  }

  QueryBuilder<JournalEntryModel, JournalEntryModel, QAfterFilterCondition>
      moodIntensityLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'moodIntensity',
        value: value,
      ));
    });
  }

  QueryBuilder<JournalEntryModel, JournalEntryModel, QAfterFilterCondition>
      moodIntensityBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'moodIntensity',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<JournalEntryModel, JournalEntryModel, QAfterFilterCondition>
      sleepRecordIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'sleepRecord',
      ));
    });
  }

  QueryBuilder<JournalEntryModel, JournalEntryModel, QAfterFilterCondition>
      sleepRecordIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'sleepRecord',
      ));
    });
  }

  QueryBuilder<JournalEntryModel, JournalEntryModel, QAfterFilterCondition>
      symptomsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'symptoms',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<JournalEntryModel, JournalEntryModel, QAfterFilterCondition>
      symptomsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'symptoms',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<JournalEntryModel, JournalEntryModel, QAfterFilterCondition>
      symptomsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'symptoms',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<JournalEntryModel, JournalEntryModel, QAfterFilterCondition>
      symptomsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'symptoms',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<JournalEntryModel, JournalEntryModel, QAfterFilterCondition>
      symptomsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'symptoms',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<JournalEntryModel, JournalEntryModel, QAfterFilterCondition>
      symptomsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'symptoms',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<JournalEntryModel, JournalEntryModel, QAfterFilterCondition>
      uidEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'uid',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<JournalEntryModel, JournalEntryModel, QAfterFilterCondition>
      uidGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'uid',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<JournalEntryModel, JournalEntryModel, QAfterFilterCondition>
      uidLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'uid',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<JournalEntryModel, JournalEntryModel, QAfterFilterCondition>
      uidBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'uid',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<JournalEntryModel, JournalEntryModel, QAfterFilterCondition>
      uidStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'uid',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<JournalEntryModel, JournalEntryModel, QAfterFilterCondition>
      uidEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'uid',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<JournalEntryModel, JournalEntryModel, QAfterFilterCondition>
      uidContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'uid',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<JournalEntryModel, JournalEntryModel, QAfterFilterCondition>
      uidMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'uid',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<JournalEntryModel, JournalEntryModel, QAfterFilterCondition>
      uidIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'uid',
        value: '',
      ));
    });
  }

  QueryBuilder<JournalEntryModel, JournalEntryModel, QAfterFilterCondition>
      uidIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'uid',
        value: '',
      ));
    });
  }

  QueryBuilder<JournalEntryModel, JournalEntryModel, QAfterFilterCondition>
      updatedAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<JournalEntryModel, JournalEntryModel, QAfterFilterCondition>
      updatedAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<JournalEntryModel, JournalEntryModel, QAfterFilterCondition>
      updatedAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<JournalEntryModel, JournalEntryModel, QAfterFilterCondition>
      updatedAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'updatedAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension JournalEntryModelQueryObject
    on QueryBuilder<JournalEntryModel, JournalEntryModel, QFilterCondition> {
  QueryBuilder<JournalEntryModel, JournalEntryModel, QAfterFilterCondition>
      extractedSymptomsElement(FilterQuery<ExtractedSymptomEmbed> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'extractedSymptoms');
    });
  }

  QueryBuilder<JournalEntryModel, JournalEntryModel, QAfterFilterCondition>
      lifestyleFactorsElement(FilterQuery<LifestyleFactorLogEmbed> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'lifestyleFactors');
    });
  }

  QueryBuilder<JournalEntryModel, JournalEntryModel, QAfterFilterCondition>
      medicationsElement(FilterQuery<MedicationLogEmbed> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'medications');
    });
  }

  QueryBuilder<JournalEntryModel, JournalEntryModel, QAfterFilterCondition>
      sleepRecord(FilterQuery<SleepRecordEmbed> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'sleepRecord');
    });
  }

  QueryBuilder<JournalEntryModel, JournalEntryModel, QAfterFilterCondition>
      symptomsElement(FilterQuery<SymptomLogEmbed> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'symptoms');
    });
  }
}

extension JournalEntryModelQueryLinks
    on QueryBuilder<JournalEntryModel, JournalEntryModel, QFilterCondition> {}

extension JournalEntryModelQuerySortBy
    on QueryBuilder<JournalEntryModel, JournalEntryModel, QSortBy> {
  QueryBuilder<JournalEntryModel, JournalEntryModel, QAfterSortBy>
      sortByActivityLevel() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'activityLevel', Sort.asc);
    });
  }

  QueryBuilder<JournalEntryModel, JournalEntryModel, QAfterSortBy>
      sortByActivityLevelDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'activityLevel', Sort.desc);
    });
  }

  QueryBuilder<JournalEntryModel, JournalEntryModel, QAfterSortBy>
      sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<JournalEntryModel, JournalEntryModel, QAfterSortBy>
      sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<JournalEntryModel, JournalEntryModel, QAfterSortBy>
      sortByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.asc);
    });
  }

  QueryBuilder<JournalEntryModel, JournalEntryModel, QAfterSortBy>
      sortByDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.desc);
    });
  }

  QueryBuilder<JournalEntryModel, JournalEntryModel, QAfterSortBy>
      sortByFreeText() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'freeText', Sort.asc);
    });
  }

  QueryBuilder<JournalEntryModel, JournalEntryModel, QAfterSortBy>
      sortByFreeTextDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'freeText', Sort.desc);
    });
  }

  QueryBuilder<JournalEntryModel, JournalEntryModel, QAfterSortBy>
      sortByMood() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mood', Sort.asc);
    });
  }

  QueryBuilder<JournalEntryModel, JournalEntryModel, QAfterSortBy>
      sortByMoodDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mood', Sort.desc);
    });
  }

  QueryBuilder<JournalEntryModel, JournalEntryModel, QAfterSortBy>
      sortByMoodIntensity() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'moodIntensity', Sort.asc);
    });
  }

  QueryBuilder<JournalEntryModel, JournalEntryModel, QAfterSortBy>
      sortByMoodIntensityDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'moodIntensity', Sort.desc);
    });
  }

  QueryBuilder<JournalEntryModel, JournalEntryModel, QAfterSortBy> sortByUid() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uid', Sort.asc);
    });
  }

  QueryBuilder<JournalEntryModel, JournalEntryModel, QAfterSortBy>
      sortByUidDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uid', Sort.desc);
    });
  }

  QueryBuilder<JournalEntryModel, JournalEntryModel, QAfterSortBy>
      sortByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<JournalEntryModel, JournalEntryModel, QAfterSortBy>
      sortByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }
}

extension JournalEntryModelQuerySortThenBy
    on QueryBuilder<JournalEntryModel, JournalEntryModel, QSortThenBy> {
  QueryBuilder<JournalEntryModel, JournalEntryModel, QAfterSortBy>
      thenByActivityLevel() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'activityLevel', Sort.asc);
    });
  }

  QueryBuilder<JournalEntryModel, JournalEntryModel, QAfterSortBy>
      thenByActivityLevelDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'activityLevel', Sort.desc);
    });
  }

  QueryBuilder<JournalEntryModel, JournalEntryModel, QAfterSortBy>
      thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<JournalEntryModel, JournalEntryModel, QAfterSortBy>
      thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<JournalEntryModel, JournalEntryModel, QAfterSortBy>
      thenByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.asc);
    });
  }

  QueryBuilder<JournalEntryModel, JournalEntryModel, QAfterSortBy>
      thenByDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.desc);
    });
  }

  QueryBuilder<JournalEntryModel, JournalEntryModel, QAfterSortBy>
      thenByFreeText() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'freeText', Sort.asc);
    });
  }

  QueryBuilder<JournalEntryModel, JournalEntryModel, QAfterSortBy>
      thenByFreeTextDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'freeText', Sort.desc);
    });
  }

  QueryBuilder<JournalEntryModel, JournalEntryModel, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<JournalEntryModel, JournalEntryModel, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<JournalEntryModel, JournalEntryModel, QAfterSortBy>
      thenByMood() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mood', Sort.asc);
    });
  }

  QueryBuilder<JournalEntryModel, JournalEntryModel, QAfterSortBy>
      thenByMoodDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mood', Sort.desc);
    });
  }

  QueryBuilder<JournalEntryModel, JournalEntryModel, QAfterSortBy>
      thenByMoodIntensity() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'moodIntensity', Sort.asc);
    });
  }

  QueryBuilder<JournalEntryModel, JournalEntryModel, QAfterSortBy>
      thenByMoodIntensityDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'moodIntensity', Sort.desc);
    });
  }

  QueryBuilder<JournalEntryModel, JournalEntryModel, QAfterSortBy> thenByUid() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uid', Sort.asc);
    });
  }

  QueryBuilder<JournalEntryModel, JournalEntryModel, QAfterSortBy>
      thenByUidDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uid', Sort.desc);
    });
  }

  QueryBuilder<JournalEntryModel, JournalEntryModel, QAfterSortBy>
      thenByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<JournalEntryModel, JournalEntryModel, QAfterSortBy>
      thenByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }
}

extension JournalEntryModelQueryWhereDistinct
    on QueryBuilder<JournalEntryModel, JournalEntryModel, QDistinct> {
  QueryBuilder<JournalEntryModel, JournalEntryModel, QDistinct>
      distinctByActivityLevel({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'activityLevel',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<JournalEntryModel, JournalEntryModel, QDistinct>
      distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<JournalEntryModel, JournalEntryModel, QDistinct>
      distinctByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'date');
    });
  }

  QueryBuilder<JournalEntryModel, JournalEntryModel, QDistinct>
      distinctByFreeText({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'freeText', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<JournalEntryModel, JournalEntryModel, QDistinct> distinctByMood(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'mood', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<JournalEntryModel, JournalEntryModel, QDistinct>
      distinctByMoodIntensity() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'moodIntensity');
    });
  }

  QueryBuilder<JournalEntryModel, JournalEntryModel, QDistinct> distinctByUid(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'uid', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<JournalEntryModel, JournalEntryModel, QDistinct>
      distinctByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'updatedAt');
    });
  }
}

extension JournalEntryModelQueryProperty
    on QueryBuilder<JournalEntryModel, JournalEntryModel, QQueryProperty> {
  QueryBuilder<JournalEntryModel, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<JournalEntryModel, ActivityLevel?, QQueryOperations>
      activityLevelProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'activityLevel');
    });
  }

  QueryBuilder<JournalEntryModel, DateTime, QQueryOperations>
      createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<JournalEntryModel, DateTime, QQueryOperations> dateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'date');
    });
  }

  QueryBuilder<JournalEntryModel, List<ExtractedSymptomEmbed>?,
      QQueryOperations> extractedSymptomsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'extractedSymptoms');
    });
  }

  QueryBuilder<JournalEntryModel, String?, QQueryOperations>
      freeTextProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'freeText');
    });
  }

  QueryBuilder<JournalEntryModel, List<LifestyleFactorLogEmbed>,
      QQueryOperations> lifestyleFactorsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lifestyleFactors');
    });
  }

  QueryBuilder<JournalEntryModel, List<MedicationLogEmbed>, QQueryOperations>
      medicationsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'medications');
    });
  }

  QueryBuilder<JournalEntryModel, Mood?, QQueryOperations> moodProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'mood');
    });
  }

  QueryBuilder<JournalEntryModel, int?, QQueryOperations>
      moodIntensityProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'moodIntensity');
    });
  }

  QueryBuilder<JournalEntryModel, SleepRecordEmbed?, QQueryOperations>
      sleepRecordProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'sleepRecord');
    });
  }

  QueryBuilder<JournalEntryModel, List<SymptomLogEmbed>, QQueryOperations>
      symptomsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'symptoms');
    });
  }

  QueryBuilder<JournalEntryModel, String, QQueryOperations> uidProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'uid');
    });
  }

  QueryBuilder<JournalEntryModel, DateTime, QQueryOperations>
      updatedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'updatedAt');
    });
  }
}

// **************************************************************************
// IsarEmbeddedGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

const SymptomLogEmbedSchema = Schema(
  name: r'SymptomLogEmbed',
  id: -6859505031989153351,
  properties: {
    r'durationMinutes': PropertySchema(
      id: 0,
      name: r'durationMinutes',
      type: IsarType.long,
    ),
    r'notes': PropertySchema(
      id: 1,
      name: r'notes',
      type: IsarType.string,
    ),
    r'onsetHour': PropertySchema(
      id: 2,
      name: r'onsetHour',
      type: IsarType.long,
    ),
    r'onsetMinute': PropertySchema(
      id: 3,
      name: r'onsetMinute',
      type: IsarType.long,
    ),
    r'severity': PropertySchema(
      id: 4,
      name: r'severity',
      type: IsarType.long,
    ),
    r'symptomId': PropertySchema(
      id: 5,
      name: r'symptomId',
      type: IsarType.string,
    )
  },
  estimateSize: _symptomLogEmbedEstimateSize,
  serialize: _symptomLogEmbedSerialize,
  deserialize: _symptomLogEmbedDeserialize,
  deserializeProp: _symptomLogEmbedDeserializeProp,
);

int _symptomLogEmbedEstimateSize(
  SymptomLogEmbed object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.notes;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.symptomId.length * 3;
  return bytesCount;
}

void _symptomLogEmbedSerialize(
  SymptomLogEmbed object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.durationMinutes);
  writer.writeString(offsets[1], object.notes);
  writer.writeLong(offsets[2], object.onsetHour);
  writer.writeLong(offsets[3], object.onsetMinute);
  writer.writeLong(offsets[4], object.severity);
  writer.writeString(offsets[5], object.symptomId);
}

SymptomLogEmbed _symptomLogEmbedDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = SymptomLogEmbed();
  object.durationMinutes = reader.readLongOrNull(offsets[0]);
  object.notes = reader.readStringOrNull(offsets[1]);
  object.onsetHour = reader.readLongOrNull(offsets[2]);
  object.onsetMinute = reader.readLongOrNull(offsets[3]);
  object.severity = reader.readLong(offsets[4]);
  object.symptomId = reader.readString(offsets[5]);
  return object;
}

P _symptomLogEmbedDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLongOrNull(offset)) as P;
    case 1:
      return (reader.readStringOrNull(offset)) as P;
    case 2:
      return (reader.readLongOrNull(offset)) as P;
    case 3:
      return (reader.readLongOrNull(offset)) as P;
    case 4:
      return (reader.readLong(offset)) as P;
    case 5:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

extension SymptomLogEmbedQueryFilter
    on QueryBuilder<SymptomLogEmbed, SymptomLogEmbed, QFilterCondition> {
  QueryBuilder<SymptomLogEmbed, SymptomLogEmbed, QAfterFilterCondition>
      durationMinutesIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'durationMinutes',
      ));
    });
  }

  QueryBuilder<SymptomLogEmbed, SymptomLogEmbed, QAfterFilterCondition>
      durationMinutesIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'durationMinutes',
      ));
    });
  }

  QueryBuilder<SymptomLogEmbed, SymptomLogEmbed, QAfterFilterCondition>
      durationMinutesEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'durationMinutes',
        value: value,
      ));
    });
  }

  QueryBuilder<SymptomLogEmbed, SymptomLogEmbed, QAfterFilterCondition>
      durationMinutesGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'durationMinutes',
        value: value,
      ));
    });
  }

  QueryBuilder<SymptomLogEmbed, SymptomLogEmbed, QAfterFilterCondition>
      durationMinutesLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'durationMinutes',
        value: value,
      ));
    });
  }

  QueryBuilder<SymptomLogEmbed, SymptomLogEmbed, QAfterFilterCondition>
      durationMinutesBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'durationMinutes',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<SymptomLogEmbed, SymptomLogEmbed, QAfterFilterCondition>
      notesIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'notes',
      ));
    });
  }

  QueryBuilder<SymptomLogEmbed, SymptomLogEmbed, QAfterFilterCondition>
      notesIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'notes',
      ));
    });
  }

  QueryBuilder<SymptomLogEmbed, SymptomLogEmbed, QAfterFilterCondition>
      notesEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'notes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SymptomLogEmbed, SymptomLogEmbed, QAfterFilterCondition>
      notesGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'notes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SymptomLogEmbed, SymptomLogEmbed, QAfterFilterCondition>
      notesLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'notes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SymptomLogEmbed, SymptomLogEmbed, QAfterFilterCondition>
      notesBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'notes',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SymptomLogEmbed, SymptomLogEmbed, QAfterFilterCondition>
      notesStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'notes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SymptomLogEmbed, SymptomLogEmbed, QAfterFilterCondition>
      notesEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'notes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SymptomLogEmbed, SymptomLogEmbed, QAfterFilterCondition>
      notesContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'notes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SymptomLogEmbed, SymptomLogEmbed, QAfterFilterCondition>
      notesMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'notes',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SymptomLogEmbed, SymptomLogEmbed, QAfterFilterCondition>
      notesIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'notes',
        value: '',
      ));
    });
  }

  QueryBuilder<SymptomLogEmbed, SymptomLogEmbed, QAfterFilterCondition>
      notesIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'notes',
        value: '',
      ));
    });
  }

  QueryBuilder<SymptomLogEmbed, SymptomLogEmbed, QAfterFilterCondition>
      onsetHourIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'onsetHour',
      ));
    });
  }

  QueryBuilder<SymptomLogEmbed, SymptomLogEmbed, QAfterFilterCondition>
      onsetHourIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'onsetHour',
      ));
    });
  }

  QueryBuilder<SymptomLogEmbed, SymptomLogEmbed, QAfterFilterCondition>
      onsetHourEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'onsetHour',
        value: value,
      ));
    });
  }

  QueryBuilder<SymptomLogEmbed, SymptomLogEmbed, QAfterFilterCondition>
      onsetHourGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'onsetHour',
        value: value,
      ));
    });
  }

  QueryBuilder<SymptomLogEmbed, SymptomLogEmbed, QAfterFilterCondition>
      onsetHourLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'onsetHour',
        value: value,
      ));
    });
  }

  QueryBuilder<SymptomLogEmbed, SymptomLogEmbed, QAfterFilterCondition>
      onsetHourBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'onsetHour',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<SymptomLogEmbed, SymptomLogEmbed, QAfterFilterCondition>
      onsetMinuteIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'onsetMinute',
      ));
    });
  }

  QueryBuilder<SymptomLogEmbed, SymptomLogEmbed, QAfterFilterCondition>
      onsetMinuteIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'onsetMinute',
      ));
    });
  }

  QueryBuilder<SymptomLogEmbed, SymptomLogEmbed, QAfterFilterCondition>
      onsetMinuteEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'onsetMinute',
        value: value,
      ));
    });
  }

  QueryBuilder<SymptomLogEmbed, SymptomLogEmbed, QAfterFilterCondition>
      onsetMinuteGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'onsetMinute',
        value: value,
      ));
    });
  }

  QueryBuilder<SymptomLogEmbed, SymptomLogEmbed, QAfterFilterCondition>
      onsetMinuteLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'onsetMinute',
        value: value,
      ));
    });
  }

  QueryBuilder<SymptomLogEmbed, SymptomLogEmbed, QAfterFilterCondition>
      onsetMinuteBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'onsetMinute',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<SymptomLogEmbed, SymptomLogEmbed, QAfterFilterCondition>
      severityEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'severity',
        value: value,
      ));
    });
  }

  QueryBuilder<SymptomLogEmbed, SymptomLogEmbed, QAfterFilterCondition>
      severityGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'severity',
        value: value,
      ));
    });
  }

  QueryBuilder<SymptomLogEmbed, SymptomLogEmbed, QAfterFilterCondition>
      severityLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'severity',
        value: value,
      ));
    });
  }

  QueryBuilder<SymptomLogEmbed, SymptomLogEmbed, QAfterFilterCondition>
      severityBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'severity',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<SymptomLogEmbed, SymptomLogEmbed, QAfterFilterCondition>
      symptomIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'symptomId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SymptomLogEmbed, SymptomLogEmbed, QAfterFilterCondition>
      symptomIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'symptomId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SymptomLogEmbed, SymptomLogEmbed, QAfterFilterCondition>
      symptomIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'symptomId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SymptomLogEmbed, SymptomLogEmbed, QAfterFilterCondition>
      symptomIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'symptomId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SymptomLogEmbed, SymptomLogEmbed, QAfterFilterCondition>
      symptomIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'symptomId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SymptomLogEmbed, SymptomLogEmbed, QAfterFilterCondition>
      symptomIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'symptomId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SymptomLogEmbed, SymptomLogEmbed, QAfterFilterCondition>
      symptomIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'symptomId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SymptomLogEmbed, SymptomLogEmbed, QAfterFilterCondition>
      symptomIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'symptomId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SymptomLogEmbed, SymptomLogEmbed, QAfterFilterCondition>
      symptomIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'symptomId',
        value: '',
      ));
    });
  }

  QueryBuilder<SymptomLogEmbed, SymptomLogEmbed, QAfterFilterCondition>
      symptomIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'symptomId',
        value: '',
      ));
    });
  }
}

extension SymptomLogEmbedQueryObject
    on QueryBuilder<SymptomLogEmbed, SymptomLogEmbed, QFilterCondition> {}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

const MedicationLogEmbedSchema = Schema(
  name: r'MedicationLogEmbed',
  id: 8512038188275427756,
  properties: {
    r'dosage': PropertySchema(
      id: 0,
      name: r'dosage',
      type: IsarType.string,
    ),
    r'medicationId': PropertySchema(
      id: 1,
      name: r'medicationId',
      type: IsarType.string,
    ),
    r'taken': PropertySchema(
      id: 2,
      name: r'taken',
      type: IsarType.bool,
    ),
    r'timeHour': PropertySchema(
      id: 3,
      name: r'timeHour',
      type: IsarType.long,
    ),
    r'timeMinute': PropertySchema(
      id: 4,
      name: r'timeMinute',
      type: IsarType.long,
    )
  },
  estimateSize: _medicationLogEmbedEstimateSize,
  serialize: _medicationLogEmbedSerialize,
  deserialize: _medicationLogEmbedDeserialize,
  deserializeProp: _medicationLogEmbedDeserializeProp,
);

int _medicationLogEmbedEstimateSize(
  MedicationLogEmbed object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.dosage;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.medicationId.length * 3;
  return bytesCount;
}

void _medicationLogEmbedSerialize(
  MedicationLogEmbed object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.dosage);
  writer.writeString(offsets[1], object.medicationId);
  writer.writeBool(offsets[2], object.taken);
  writer.writeLong(offsets[3], object.timeHour);
  writer.writeLong(offsets[4], object.timeMinute);
}

MedicationLogEmbed _medicationLogEmbedDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = MedicationLogEmbed();
  object.dosage = reader.readStringOrNull(offsets[0]);
  object.medicationId = reader.readString(offsets[1]);
  object.taken = reader.readBool(offsets[2]);
  object.timeHour = reader.readLongOrNull(offsets[3]);
  object.timeMinute = reader.readLongOrNull(offsets[4]);
  return object;
}

P _medicationLogEmbedDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readStringOrNull(offset)) as P;
    case 1:
      return (reader.readString(offset)) as P;
    case 2:
      return (reader.readBool(offset)) as P;
    case 3:
      return (reader.readLongOrNull(offset)) as P;
    case 4:
      return (reader.readLongOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

extension MedicationLogEmbedQueryFilter
    on QueryBuilder<MedicationLogEmbed, MedicationLogEmbed, QFilterCondition> {
  QueryBuilder<MedicationLogEmbed, MedicationLogEmbed, QAfterFilterCondition>
      dosageIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'dosage',
      ));
    });
  }

  QueryBuilder<MedicationLogEmbed, MedicationLogEmbed, QAfterFilterCondition>
      dosageIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'dosage',
      ));
    });
  }

  QueryBuilder<MedicationLogEmbed, MedicationLogEmbed, QAfterFilterCondition>
      dosageEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'dosage',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MedicationLogEmbed, MedicationLogEmbed, QAfterFilterCondition>
      dosageGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'dosage',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MedicationLogEmbed, MedicationLogEmbed, QAfterFilterCondition>
      dosageLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'dosage',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MedicationLogEmbed, MedicationLogEmbed, QAfterFilterCondition>
      dosageBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'dosage',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MedicationLogEmbed, MedicationLogEmbed, QAfterFilterCondition>
      dosageStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'dosage',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MedicationLogEmbed, MedicationLogEmbed, QAfterFilterCondition>
      dosageEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'dosage',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MedicationLogEmbed, MedicationLogEmbed, QAfterFilterCondition>
      dosageContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'dosage',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MedicationLogEmbed, MedicationLogEmbed, QAfterFilterCondition>
      dosageMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'dosage',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MedicationLogEmbed, MedicationLogEmbed, QAfterFilterCondition>
      dosageIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'dosage',
        value: '',
      ));
    });
  }

  QueryBuilder<MedicationLogEmbed, MedicationLogEmbed, QAfterFilterCondition>
      dosageIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'dosage',
        value: '',
      ));
    });
  }

  QueryBuilder<MedicationLogEmbed, MedicationLogEmbed, QAfterFilterCondition>
      medicationIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'medicationId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MedicationLogEmbed, MedicationLogEmbed, QAfterFilterCondition>
      medicationIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'medicationId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MedicationLogEmbed, MedicationLogEmbed, QAfterFilterCondition>
      medicationIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'medicationId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MedicationLogEmbed, MedicationLogEmbed, QAfterFilterCondition>
      medicationIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'medicationId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MedicationLogEmbed, MedicationLogEmbed, QAfterFilterCondition>
      medicationIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'medicationId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MedicationLogEmbed, MedicationLogEmbed, QAfterFilterCondition>
      medicationIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'medicationId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MedicationLogEmbed, MedicationLogEmbed, QAfterFilterCondition>
      medicationIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'medicationId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MedicationLogEmbed, MedicationLogEmbed, QAfterFilterCondition>
      medicationIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'medicationId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MedicationLogEmbed, MedicationLogEmbed, QAfterFilterCondition>
      medicationIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'medicationId',
        value: '',
      ));
    });
  }

  QueryBuilder<MedicationLogEmbed, MedicationLogEmbed, QAfterFilterCondition>
      medicationIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'medicationId',
        value: '',
      ));
    });
  }

  QueryBuilder<MedicationLogEmbed, MedicationLogEmbed, QAfterFilterCondition>
      takenEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'taken',
        value: value,
      ));
    });
  }

  QueryBuilder<MedicationLogEmbed, MedicationLogEmbed, QAfterFilterCondition>
      timeHourIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'timeHour',
      ));
    });
  }

  QueryBuilder<MedicationLogEmbed, MedicationLogEmbed, QAfterFilterCondition>
      timeHourIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'timeHour',
      ));
    });
  }

  QueryBuilder<MedicationLogEmbed, MedicationLogEmbed, QAfterFilterCondition>
      timeHourEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'timeHour',
        value: value,
      ));
    });
  }

  QueryBuilder<MedicationLogEmbed, MedicationLogEmbed, QAfterFilterCondition>
      timeHourGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'timeHour',
        value: value,
      ));
    });
  }

  QueryBuilder<MedicationLogEmbed, MedicationLogEmbed, QAfterFilterCondition>
      timeHourLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'timeHour',
        value: value,
      ));
    });
  }

  QueryBuilder<MedicationLogEmbed, MedicationLogEmbed, QAfterFilterCondition>
      timeHourBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'timeHour',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<MedicationLogEmbed, MedicationLogEmbed, QAfterFilterCondition>
      timeMinuteIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'timeMinute',
      ));
    });
  }

  QueryBuilder<MedicationLogEmbed, MedicationLogEmbed, QAfterFilterCondition>
      timeMinuteIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'timeMinute',
      ));
    });
  }

  QueryBuilder<MedicationLogEmbed, MedicationLogEmbed, QAfterFilterCondition>
      timeMinuteEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'timeMinute',
        value: value,
      ));
    });
  }

  QueryBuilder<MedicationLogEmbed, MedicationLogEmbed, QAfterFilterCondition>
      timeMinuteGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'timeMinute',
        value: value,
      ));
    });
  }

  QueryBuilder<MedicationLogEmbed, MedicationLogEmbed, QAfterFilterCondition>
      timeMinuteLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'timeMinute',
        value: value,
      ));
    });
  }

  QueryBuilder<MedicationLogEmbed, MedicationLogEmbed, QAfterFilterCondition>
      timeMinuteBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'timeMinute',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension MedicationLogEmbedQueryObject
    on QueryBuilder<MedicationLogEmbed, MedicationLogEmbed, QFilterCondition> {}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

const SleepRecordEmbedSchema = Schema(
  name: r'SleepRecordEmbed',
  id: 6012856812929781201,
  properties: {
    r'bedTimeMs': PropertySchema(
      id: 0,
      name: r'bedTimeMs',
      type: IsarType.long,
    ),
    r'disturbances': PropertySchema(
      id: 1,
      name: r'disturbances',
      type: IsarType.long,
    ),
    r'quality': PropertySchema(
      id: 2,
      name: r'quality',
      type: IsarType.long,
    ),
    r'wakeTimeMs': PropertySchema(
      id: 3,
      name: r'wakeTimeMs',
      type: IsarType.long,
    )
  },
  estimateSize: _sleepRecordEmbedEstimateSize,
  serialize: _sleepRecordEmbedSerialize,
  deserialize: _sleepRecordEmbedDeserialize,
  deserializeProp: _sleepRecordEmbedDeserializeProp,
);

int _sleepRecordEmbedEstimateSize(
  SleepRecordEmbed object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  return bytesCount;
}

void _sleepRecordEmbedSerialize(
  SleepRecordEmbed object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.bedTimeMs);
  writer.writeLong(offsets[1], object.disturbances);
  writer.writeLong(offsets[2], object.quality);
  writer.writeLong(offsets[3], object.wakeTimeMs);
}

SleepRecordEmbed _sleepRecordEmbedDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = SleepRecordEmbed();
  object.bedTimeMs = reader.readLong(offsets[0]);
  object.disturbances = reader.readLongOrNull(offsets[1]);
  object.quality = reader.readLong(offsets[2]);
  object.wakeTimeMs = reader.readLong(offsets[3]);
  return object;
}

P _sleepRecordEmbedDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLong(offset)) as P;
    case 1:
      return (reader.readLongOrNull(offset)) as P;
    case 2:
      return (reader.readLong(offset)) as P;
    case 3:
      return (reader.readLong(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

extension SleepRecordEmbedQueryFilter
    on QueryBuilder<SleepRecordEmbed, SleepRecordEmbed, QFilterCondition> {
  QueryBuilder<SleepRecordEmbed, SleepRecordEmbed, QAfterFilterCondition>
      bedTimeMsEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'bedTimeMs',
        value: value,
      ));
    });
  }

  QueryBuilder<SleepRecordEmbed, SleepRecordEmbed, QAfterFilterCondition>
      bedTimeMsGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'bedTimeMs',
        value: value,
      ));
    });
  }

  QueryBuilder<SleepRecordEmbed, SleepRecordEmbed, QAfterFilterCondition>
      bedTimeMsLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'bedTimeMs',
        value: value,
      ));
    });
  }

  QueryBuilder<SleepRecordEmbed, SleepRecordEmbed, QAfterFilterCondition>
      bedTimeMsBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'bedTimeMs',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<SleepRecordEmbed, SleepRecordEmbed, QAfterFilterCondition>
      disturbancesIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'disturbances',
      ));
    });
  }

  QueryBuilder<SleepRecordEmbed, SleepRecordEmbed, QAfterFilterCondition>
      disturbancesIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'disturbances',
      ));
    });
  }

  QueryBuilder<SleepRecordEmbed, SleepRecordEmbed, QAfterFilterCondition>
      disturbancesEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'disturbances',
        value: value,
      ));
    });
  }

  QueryBuilder<SleepRecordEmbed, SleepRecordEmbed, QAfterFilterCondition>
      disturbancesGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'disturbances',
        value: value,
      ));
    });
  }

  QueryBuilder<SleepRecordEmbed, SleepRecordEmbed, QAfterFilterCondition>
      disturbancesLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'disturbances',
        value: value,
      ));
    });
  }

  QueryBuilder<SleepRecordEmbed, SleepRecordEmbed, QAfterFilterCondition>
      disturbancesBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'disturbances',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<SleepRecordEmbed, SleepRecordEmbed, QAfterFilterCondition>
      qualityEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'quality',
        value: value,
      ));
    });
  }

  QueryBuilder<SleepRecordEmbed, SleepRecordEmbed, QAfterFilterCondition>
      qualityGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'quality',
        value: value,
      ));
    });
  }

  QueryBuilder<SleepRecordEmbed, SleepRecordEmbed, QAfterFilterCondition>
      qualityLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'quality',
        value: value,
      ));
    });
  }

  QueryBuilder<SleepRecordEmbed, SleepRecordEmbed, QAfterFilterCondition>
      qualityBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'quality',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<SleepRecordEmbed, SleepRecordEmbed, QAfterFilterCondition>
      wakeTimeMsEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'wakeTimeMs',
        value: value,
      ));
    });
  }

  QueryBuilder<SleepRecordEmbed, SleepRecordEmbed, QAfterFilterCondition>
      wakeTimeMsGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'wakeTimeMs',
        value: value,
      ));
    });
  }

  QueryBuilder<SleepRecordEmbed, SleepRecordEmbed, QAfterFilterCondition>
      wakeTimeMsLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'wakeTimeMs',
        value: value,
      ));
    });
  }

  QueryBuilder<SleepRecordEmbed, SleepRecordEmbed, QAfterFilterCondition>
      wakeTimeMsBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'wakeTimeMs',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension SleepRecordEmbedQueryObject
    on QueryBuilder<SleepRecordEmbed, SleepRecordEmbed, QFilterCondition> {}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

const LifestyleFactorLogEmbedSchema = Schema(
  name: r'LifestyleFactorLogEmbed',
  id: -1958366069818457162,
  properties: {
    r'boolValue': PropertySchema(
      id: 0,
      name: r'boolValue',
      type: IsarType.bool,
    ),
    r'factorId': PropertySchema(
      id: 1,
      name: r'factorId',
      type: IsarType.string,
    ),
    r'numericValue': PropertySchema(
      id: 2,
      name: r'numericValue',
      type: IsarType.double,
    ),
    r'scaleValue': PropertySchema(
      id: 3,
      name: r'scaleValue',
      type: IsarType.long,
    )
  },
  estimateSize: _lifestyleFactorLogEmbedEstimateSize,
  serialize: _lifestyleFactorLogEmbedSerialize,
  deserialize: _lifestyleFactorLogEmbedDeserialize,
  deserializeProp: _lifestyleFactorLogEmbedDeserializeProp,
);

int _lifestyleFactorLogEmbedEstimateSize(
  LifestyleFactorLogEmbed object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.factorId.length * 3;
  return bytesCount;
}

void _lifestyleFactorLogEmbedSerialize(
  LifestyleFactorLogEmbed object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeBool(offsets[0], object.boolValue);
  writer.writeString(offsets[1], object.factorId);
  writer.writeDouble(offsets[2], object.numericValue);
  writer.writeLong(offsets[3], object.scaleValue);
}

LifestyleFactorLogEmbed _lifestyleFactorLogEmbedDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = LifestyleFactorLogEmbed();
  object.boolValue = reader.readBoolOrNull(offsets[0]);
  object.factorId = reader.readString(offsets[1]);
  object.numericValue = reader.readDoubleOrNull(offsets[2]);
  object.scaleValue = reader.readLongOrNull(offsets[3]);
  return object;
}

P _lifestyleFactorLogEmbedDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readBoolOrNull(offset)) as P;
    case 1:
      return (reader.readString(offset)) as P;
    case 2:
      return (reader.readDoubleOrNull(offset)) as P;
    case 3:
      return (reader.readLongOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

extension LifestyleFactorLogEmbedQueryFilter on QueryBuilder<
    LifestyleFactorLogEmbed, LifestyleFactorLogEmbed, QFilterCondition> {
  QueryBuilder<LifestyleFactorLogEmbed, LifestyleFactorLogEmbed,
      QAfterFilterCondition> boolValueIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'boolValue',
      ));
    });
  }

  QueryBuilder<LifestyleFactorLogEmbed, LifestyleFactorLogEmbed,
      QAfterFilterCondition> boolValueIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'boolValue',
      ));
    });
  }

  QueryBuilder<LifestyleFactorLogEmbed, LifestyleFactorLogEmbed,
      QAfterFilterCondition> boolValueEqualTo(bool? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'boolValue',
        value: value,
      ));
    });
  }

  QueryBuilder<LifestyleFactorLogEmbed, LifestyleFactorLogEmbed,
      QAfterFilterCondition> factorIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'factorId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LifestyleFactorLogEmbed, LifestyleFactorLogEmbed,
      QAfterFilterCondition> factorIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'factorId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LifestyleFactorLogEmbed, LifestyleFactorLogEmbed,
      QAfterFilterCondition> factorIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'factorId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LifestyleFactorLogEmbed, LifestyleFactorLogEmbed,
      QAfterFilterCondition> factorIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'factorId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LifestyleFactorLogEmbed, LifestyleFactorLogEmbed,
      QAfterFilterCondition> factorIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'factorId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LifestyleFactorLogEmbed, LifestyleFactorLogEmbed,
      QAfterFilterCondition> factorIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'factorId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LifestyleFactorLogEmbed, LifestyleFactorLogEmbed,
          QAfterFilterCondition>
      factorIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'factorId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LifestyleFactorLogEmbed, LifestyleFactorLogEmbed,
          QAfterFilterCondition>
      factorIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'factorId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LifestyleFactorLogEmbed, LifestyleFactorLogEmbed,
      QAfterFilterCondition> factorIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'factorId',
        value: '',
      ));
    });
  }

  QueryBuilder<LifestyleFactorLogEmbed, LifestyleFactorLogEmbed,
      QAfterFilterCondition> factorIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'factorId',
        value: '',
      ));
    });
  }

  QueryBuilder<LifestyleFactorLogEmbed, LifestyleFactorLogEmbed,
      QAfterFilterCondition> numericValueIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'numericValue',
      ));
    });
  }

  QueryBuilder<LifestyleFactorLogEmbed, LifestyleFactorLogEmbed,
      QAfterFilterCondition> numericValueIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'numericValue',
      ));
    });
  }

  QueryBuilder<LifestyleFactorLogEmbed, LifestyleFactorLogEmbed,
      QAfterFilterCondition> numericValueEqualTo(
    double? value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'numericValue',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<LifestyleFactorLogEmbed, LifestyleFactorLogEmbed,
      QAfterFilterCondition> numericValueGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'numericValue',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<LifestyleFactorLogEmbed, LifestyleFactorLogEmbed,
      QAfterFilterCondition> numericValueLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'numericValue',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<LifestyleFactorLogEmbed, LifestyleFactorLogEmbed,
      QAfterFilterCondition> numericValueBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'numericValue',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<LifestyleFactorLogEmbed, LifestyleFactorLogEmbed,
      QAfterFilterCondition> scaleValueIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'scaleValue',
      ));
    });
  }

  QueryBuilder<LifestyleFactorLogEmbed, LifestyleFactorLogEmbed,
      QAfterFilterCondition> scaleValueIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'scaleValue',
      ));
    });
  }

  QueryBuilder<LifestyleFactorLogEmbed, LifestyleFactorLogEmbed,
      QAfterFilterCondition> scaleValueEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'scaleValue',
        value: value,
      ));
    });
  }

  QueryBuilder<LifestyleFactorLogEmbed, LifestyleFactorLogEmbed,
      QAfterFilterCondition> scaleValueGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'scaleValue',
        value: value,
      ));
    });
  }

  QueryBuilder<LifestyleFactorLogEmbed, LifestyleFactorLogEmbed,
      QAfterFilterCondition> scaleValueLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'scaleValue',
        value: value,
      ));
    });
  }

  QueryBuilder<LifestyleFactorLogEmbed, LifestyleFactorLogEmbed,
      QAfterFilterCondition> scaleValueBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'scaleValue',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension LifestyleFactorLogEmbedQueryObject on QueryBuilder<
    LifestyleFactorLogEmbed, LifestyleFactorLogEmbed, QFilterCondition> {}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

const ExtractedSymptomEmbedSchema = Schema(
  name: r'ExtractedSymptomEmbed',
  id: 1311666130010288397,
  properties: {
    r'confidence': PropertySchema(
      id: 0,
      name: r'confidence',
      type: IsarType.double,
    ),
    r'isConfirmedByUser': PropertySchema(
      id: 1,
      name: r'isConfirmedByUser',
      type: IsarType.bool,
    ),
    r'severity': PropertySchema(
      id: 2,
      name: r'severity',
      type: IsarType.string,
    ),
    r'sourceText': PropertySchema(
      id: 3,
      name: r'sourceText',
      type: IsarType.string,
    ),
    r'symptomName': PropertySchema(
      id: 4,
      name: r'symptomName',
      type: IsarType.string,
    )
  },
  estimateSize: _extractedSymptomEmbedEstimateSize,
  serialize: _extractedSymptomEmbedSerialize,
  deserialize: _extractedSymptomEmbedDeserialize,
  deserializeProp: _extractedSymptomEmbedDeserializeProp,
);

int _extractedSymptomEmbedEstimateSize(
  ExtractedSymptomEmbed object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.severity;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.sourceText.length * 3;
  bytesCount += 3 + object.symptomName.length * 3;
  return bytesCount;
}

void _extractedSymptomEmbedSerialize(
  ExtractedSymptomEmbed object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDouble(offsets[0], object.confidence);
  writer.writeBool(offsets[1], object.isConfirmedByUser);
  writer.writeString(offsets[2], object.severity);
  writer.writeString(offsets[3], object.sourceText);
  writer.writeString(offsets[4], object.symptomName);
}

ExtractedSymptomEmbed _extractedSymptomEmbedDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = ExtractedSymptomEmbed();
  object.confidence = reader.readDouble(offsets[0]);
  object.isConfirmedByUser = reader.readBoolOrNull(offsets[1]);
  object.severity = reader.readStringOrNull(offsets[2]);
  object.sourceText = reader.readString(offsets[3]);
  object.symptomName = reader.readString(offsets[4]);
  return object;
}

P _extractedSymptomEmbedDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDouble(offset)) as P;
    case 1:
      return (reader.readBoolOrNull(offset)) as P;
    case 2:
      return (reader.readStringOrNull(offset)) as P;
    case 3:
      return (reader.readString(offset)) as P;
    case 4:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

extension ExtractedSymptomEmbedQueryFilter on QueryBuilder<
    ExtractedSymptomEmbed, ExtractedSymptomEmbed, QFilterCondition> {
  QueryBuilder<ExtractedSymptomEmbed, ExtractedSymptomEmbed,
      QAfterFilterCondition> confidenceEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'confidence',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ExtractedSymptomEmbed, ExtractedSymptomEmbed,
      QAfterFilterCondition> confidenceGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'confidence',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ExtractedSymptomEmbed, ExtractedSymptomEmbed,
      QAfterFilterCondition> confidenceLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'confidence',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ExtractedSymptomEmbed, ExtractedSymptomEmbed,
      QAfterFilterCondition> confidenceBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'confidence',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ExtractedSymptomEmbed, ExtractedSymptomEmbed,
      QAfterFilterCondition> isConfirmedByUserIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'isConfirmedByUser',
      ));
    });
  }

  QueryBuilder<ExtractedSymptomEmbed, ExtractedSymptomEmbed,
      QAfterFilterCondition> isConfirmedByUserIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'isConfirmedByUser',
      ));
    });
  }

  QueryBuilder<ExtractedSymptomEmbed, ExtractedSymptomEmbed,
      QAfterFilterCondition> isConfirmedByUserEqualTo(bool? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isConfirmedByUser',
        value: value,
      ));
    });
  }

  QueryBuilder<ExtractedSymptomEmbed, ExtractedSymptomEmbed,
      QAfterFilterCondition> severityIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'severity',
      ));
    });
  }

  QueryBuilder<ExtractedSymptomEmbed, ExtractedSymptomEmbed,
      QAfterFilterCondition> severityIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'severity',
      ));
    });
  }

  QueryBuilder<ExtractedSymptomEmbed, ExtractedSymptomEmbed,
      QAfterFilterCondition> severityEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'severity',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExtractedSymptomEmbed, ExtractedSymptomEmbed,
      QAfterFilterCondition> severityGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'severity',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExtractedSymptomEmbed, ExtractedSymptomEmbed,
      QAfterFilterCondition> severityLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'severity',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExtractedSymptomEmbed, ExtractedSymptomEmbed,
      QAfterFilterCondition> severityBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'severity',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExtractedSymptomEmbed, ExtractedSymptomEmbed,
      QAfterFilterCondition> severityStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'severity',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExtractedSymptomEmbed, ExtractedSymptomEmbed,
      QAfterFilterCondition> severityEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'severity',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExtractedSymptomEmbed, ExtractedSymptomEmbed,
          QAfterFilterCondition>
      severityContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'severity',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExtractedSymptomEmbed, ExtractedSymptomEmbed,
          QAfterFilterCondition>
      severityMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'severity',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExtractedSymptomEmbed, ExtractedSymptomEmbed,
      QAfterFilterCondition> severityIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'severity',
        value: '',
      ));
    });
  }

  QueryBuilder<ExtractedSymptomEmbed, ExtractedSymptomEmbed,
      QAfterFilterCondition> severityIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'severity',
        value: '',
      ));
    });
  }

  QueryBuilder<ExtractedSymptomEmbed, ExtractedSymptomEmbed,
      QAfterFilterCondition> sourceTextEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'sourceText',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExtractedSymptomEmbed, ExtractedSymptomEmbed,
      QAfterFilterCondition> sourceTextGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'sourceText',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExtractedSymptomEmbed, ExtractedSymptomEmbed,
      QAfterFilterCondition> sourceTextLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'sourceText',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExtractedSymptomEmbed, ExtractedSymptomEmbed,
      QAfterFilterCondition> sourceTextBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'sourceText',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExtractedSymptomEmbed, ExtractedSymptomEmbed,
      QAfterFilterCondition> sourceTextStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'sourceText',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExtractedSymptomEmbed, ExtractedSymptomEmbed,
      QAfterFilterCondition> sourceTextEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'sourceText',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExtractedSymptomEmbed, ExtractedSymptomEmbed,
          QAfterFilterCondition>
      sourceTextContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'sourceText',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExtractedSymptomEmbed, ExtractedSymptomEmbed,
          QAfterFilterCondition>
      sourceTextMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'sourceText',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExtractedSymptomEmbed, ExtractedSymptomEmbed,
      QAfterFilterCondition> sourceTextIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'sourceText',
        value: '',
      ));
    });
  }

  QueryBuilder<ExtractedSymptomEmbed, ExtractedSymptomEmbed,
      QAfterFilterCondition> sourceTextIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'sourceText',
        value: '',
      ));
    });
  }

  QueryBuilder<ExtractedSymptomEmbed, ExtractedSymptomEmbed,
      QAfterFilterCondition> symptomNameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'symptomName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExtractedSymptomEmbed, ExtractedSymptomEmbed,
      QAfterFilterCondition> symptomNameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'symptomName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExtractedSymptomEmbed, ExtractedSymptomEmbed,
      QAfterFilterCondition> symptomNameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'symptomName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExtractedSymptomEmbed, ExtractedSymptomEmbed,
      QAfterFilterCondition> symptomNameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'symptomName',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExtractedSymptomEmbed, ExtractedSymptomEmbed,
      QAfterFilterCondition> symptomNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'symptomName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExtractedSymptomEmbed, ExtractedSymptomEmbed,
      QAfterFilterCondition> symptomNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'symptomName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExtractedSymptomEmbed, ExtractedSymptomEmbed,
          QAfterFilterCondition>
      symptomNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'symptomName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExtractedSymptomEmbed, ExtractedSymptomEmbed,
          QAfterFilterCondition>
      symptomNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'symptomName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExtractedSymptomEmbed, ExtractedSymptomEmbed,
      QAfterFilterCondition> symptomNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'symptomName',
        value: '',
      ));
    });
  }

  QueryBuilder<ExtractedSymptomEmbed, ExtractedSymptomEmbed,
      QAfterFilterCondition> symptomNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'symptomName',
        value: '',
      ));
    });
  }
}

extension ExtractedSymptomEmbedQueryObject on QueryBuilder<
    ExtractedSymptomEmbed, ExtractedSymptomEmbed, QFilterCondition> {}
