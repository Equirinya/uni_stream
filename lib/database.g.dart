// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetVideoApiAccountCollection on Isar {
  IsarCollection<VideoApiAccount> get videoApiAccounts => this.collection();
}

const VideoApiAccountSchema = CollectionSchema(
  name: r'VideoApiAccount',
  id: 2282997127201510332,
  properties: {
    r'type': PropertySchema(
      id: 0,
      name: r'type',
      type: IsarType.string,
      enumMap: _VideoApiAccounttypeEnumValueMap,
    )
  },
  estimateSize: _videoApiAccountEstimateSize,
  serialize: _videoApiAccountSerialize,
  deserialize: _videoApiAccountDeserialize,
  deserializeProp: _videoApiAccountDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {
    r'universityAccount': LinkSchema(
      id: -9218838898084121159,
      name: r'universityAccount',
      target: r'UniversityAccount',
      single: true,
    )
  },
  embeddedSchemas: {},
  getId: _videoApiAccountGetId,
  getLinks: _videoApiAccountGetLinks,
  attach: _videoApiAccountAttach,
  version: '3.1.0+1',
);

int _videoApiAccountEstimateSize(
  VideoApiAccount object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.type.name.length * 3;
  return bytesCount;
}

void _videoApiAccountSerialize(
  VideoApiAccount object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.type.name);
}

VideoApiAccount _videoApiAccountDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = VideoApiAccount();
  object.id = id;
  object.type =
      _VideoApiAccounttypeValueEnumMap[reader.readStringOrNull(offsets[0])] ??
          VideoApiType.opencast;
  return object;
}

P _videoApiAccountDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (_VideoApiAccounttypeValueEnumMap[
              reader.readStringOrNull(offset)] ??
          VideoApiType.opencast) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _VideoApiAccounttypeEnumValueMap = {
  r'opencast': r'opencast',
};
const _VideoApiAccounttypeValueEnumMap = {
  r'opencast': VideoApiType.opencast,
};

Id _videoApiAccountGetId(VideoApiAccount object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _videoApiAccountGetLinks(VideoApiAccount object) {
  return [object.universityAccount];
}

void _videoApiAccountAttach(
    IsarCollection<dynamic> col, Id id, VideoApiAccount object) {
  object.id = id;
  object.universityAccount.attach(
      col, col.isar.collection<UniversityAccount>(), r'universityAccount', id);
}

extension VideoApiAccountQueryWhereSort
    on QueryBuilder<VideoApiAccount, VideoApiAccount, QWhere> {
  QueryBuilder<VideoApiAccount, VideoApiAccount, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension VideoApiAccountQueryWhere
    on QueryBuilder<VideoApiAccount, VideoApiAccount, QWhereClause> {
  QueryBuilder<VideoApiAccount, VideoApiAccount, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<VideoApiAccount, VideoApiAccount, QAfterWhereClause>
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

  QueryBuilder<VideoApiAccount, VideoApiAccount, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<VideoApiAccount, VideoApiAccount, QAfterWhereClause> idLessThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<VideoApiAccount, VideoApiAccount, QAfterWhereClause> idBetween(
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
}

extension VideoApiAccountQueryFilter
    on QueryBuilder<VideoApiAccount, VideoApiAccount, QFilterCondition> {
  QueryBuilder<VideoApiAccount, VideoApiAccount, QAfterFilterCondition>
      idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<VideoApiAccount, VideoApiAccount, QAfterFilterCondition>
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

  QueryBuilder<VideoApiAccount, VideoApiAccount, QAfterFilterCondition>
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

  QueryBuilder<VideoApiAccount, VideoApiAccount, QAfterFilterCondition>
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

  QueryBuilder<VideoApiAccount, VideoApiAccount, QAfterFilterCondition>
      typeEqualTo(
    VideoApiType value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'type',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VideoApiAccount, VideoApiAccount, QAfterFilterCondition>
      typeGreaterThan(
    VideoApiType value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'type',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VideoApiAccount, VideoApiAccount, QAfterFilterCondition>
      typeLessThan(
    VideoApiType value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'type',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VideoApiAccount, VideoApiAccount, QAfterFilterCondition>
      typeBetween(
    VideoApiType lower,
    VideoApiType upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'type',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VideoApiAccount, VideoApiAccount, QAfterFilterCondition>
      typeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'type',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VideoApiAccount, VideoApiAccount, QAfterFilterCondition>
      typeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'type',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VideoApiAccount, VideoApiAccount, QAfterFilterCondition>
      typeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'type',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VideoApiAccount, VideoApiAccount, QAfterFilterCondition>
      typeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'type',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VideoApiAccount, VideoApiAccount, QAfterFilterCondition>
      typeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'type',
        value: '',
      ));
    });
  }

  QueryBuilder<VideoApiAccount, VideoApiAccount, QAfterFilterCondition>
      typeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'type',
        value: '',
      ));
    });
  }
}

extension VideoApiAccountQueryObject
    on QueryBuilder<VideoApiAccount, VideoApiAccount, QFilterCondition> {}

extension VideoApiAccountQueryLinks
    on QueryBuilder<VideoApiAccount, VideoApiAccount, QFilterCondition> {
  QueryBuilder<VideoApiAccount, VideoApiAccount, QAfterFilterCondition>
      universityAccount(FilterQuery<UniversityAccount> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'universityAccount');
    });
  }

  QueryBuilder<VideoApiAccount, VideoApiAccount, QAfterFilterCondition>
      universityAccountIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'universityAccount', 0, true, 0, true);
    });
  }
}

extension VideoApiAccountQuerySortBy
    on QueryBuilder<VideoApiAccount, VideoApiAccount, QSortBy> {
  QueryBuilder<VideoApiAccount, VideoApiAccount, QAfterSortBy> sortByType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.asc);
    });
  }

  QueryBuilder<VideoApiAccount, VideoApiAccount, QAfterSortBy>
      sortByTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.desc);
    });
  }
}

extension VideoApiAccountQuerySortThenBy
    on QueryBuilder<VideoApiAccount, VideoApiAccount, QSortThenBy> {
  QueryBuilder<VideoApiAccount, VideoApiAccount, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<VideoApiAccount, VideoApiAccount, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<VideoApiAccount, VideoApiAccount, QAfterSortBy> thenByType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.asc);
    });
  }

  QueryBuilder<VideoApiAccount, VideoApiAccount, QAfterSortBy>
      thenByTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.desc);
    });
  }
}

extension VideoApiAccountQueryWhereDistinct
    on QueryBuilder<VideoApiAccount, VideoApiAccount, QDistinct> {
  QueryBuilder<VideoApiAccount, VideoApiAccount, QDistinct> distinctByType(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'type', caseSensitive: caseSensitive);
    });
  }
}

extension VideoApiAccountQueryProperty
    on QueryBuilder<VideoApiAccount, VideoApiAccount, QQueryProperty> {
  QueryBuilder<VideoApiAccount, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<VideoApiAccount, VideoApiType, QQueryOperations> typeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'type');
    });
  }
}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetUniversityAccountCollection on Isar {
  IsarCollection<UniversityAccount> get universityAccounts => this.collection();
}

const UniversityAccountSchema = CollectionSchema(
  name: r'UniversityAccount',
  id: -8132327057308943605,
  properties: {
    r'index': PropertySchema(
      id: 0,
      name: r'index',
      type: IsarType.long,
    ),
    r'lastDashboardUpdate': PropertySchema(
      id: 1,
      name: r'lastDashboardUpdate',
      type: IsarType.dateTime,
    ),
    r'university': PropertySchema(
      id: 2,
      name: r'university',
      type: IsarType.string,
      enumMap: _UniversityAccountuniversityEnumValueMap,
    ),
    r'userIdentifier': PropertySchema(
      id: 3,
      name: r'userIdentifier',
      type: IsarType.string,
    )
  },
  estimateSize: _universityAccountEstimateSize,
  serialize: _universityAccountSerialize,
  deserialize: _universityAccountDeserialize,
  deserializeProp: _universityAccountDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {
    r'courses': LinkSchema(
      id: 5294173954322175897,
      name: r'courses',
      target: r'Course',
      single: false,
      linkName: r'universityAccount',
    ),
    r'videoApis': LinkSchema(
      id: 6598274692317234400,
      name: r'videoApis',
      target: r'VideoApiAccount',
      single: false,
      linkName: r'universityAccount',
    )
  },
  embeddedSchemas: {},
  getId: _universityAccountGetId,
  getLinks: _universityAccountGetLinks,
  attach: _universityAccountAttach,
  version: '3.1.0+1',
);

int _universityAccountEstimateSize(
  UniversityAccount object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.university.name.length * 3;
  bytesCount += 3 + object.userIdentifier.length * 3;
  return bytesCount;
}

void _universityAccountSerialize(
  UniversityAccount object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.index);
  writer.writeDateTime(offsets[1], object.lastDashboardUpdate);
  writer.writeString(offsets[2], object.university.name);
  writer.writeString(offsets[3], object.userIdentifier);
}

UniversityAccount _universityAccountDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = UniversityAccount();
  object.id = id;
  object.index = reader.readLong(offsets[0]);
  object.lastDashboardUpdate = reader.readDateTime(offsets[1]);
  object.university = _UniversityAccountuniversityValueEnumMap[
          reader.readStringOrNull(offsets[2])] ??
      University.rwth;
  object.userIdentifier = reader.readString(offsets[3]);
  return object;
}

P _universityAccountDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLong(offset)) as P;
    case 1:
      return (reader.readDateTime(offset)) as P;
    case 2:
      return (_UniversityAccountuniversityValueEnumMap[
              reader.readStringOrNull(offset)] ??
          University.rwth) as P;
    case 3:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _UniversityAccountuniversityEnumValueMap = {
  r'rwth': r'rwth',
};
const _UniversityAccountuniversityValueEnumMap = {
  r'rwth': University.rwth,
};

Id _universityAccountGetId(UniversityAccount object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _universityAccountGetLinks(
    UniversityAccount object) {
  return [object.courses, object.videoApis];
}

void _universityAccountAttach(
    IsarCollection<dynamic> col, Id id, UniversityAccount object) {
  object.id = id;
  object.courses.attach(col, col.isar.collection<Course>(), r'courses', id);
  object.videoApis
      .attach(col, col.isar.collection<VideoApiAccount>(), r'videoApis', id);
}

extension UniversityAccountQueryWhereSort
    on QueryBuilder<UniversityAccount, UniversityAccount, QWhere> {
  QueryBuilder<UniversityAccount, UniversityAccount, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension UniversityAccountQueryWhere
    on QueryBuilder<UniversityAccount, UniversityAccount, QWhereClause> {
  QueryBuilder<UniversityAccount, UniversityAccount, QAfterWhereClause>
      idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<UniversityAccount, UniversityAccount, QAfterWhereClause>
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

  QueryBuilder<UniversityAccount, UniversityAccount, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<UniversityAccount, UniversityAccount, QAfterWhereClause>
      idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<UniversityAccount, UniversityAccount, QAfterWhereClause>
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
}

extension UniversityAccountQueryFilter
    on QueryBuilder<UniversityAccount, UniversityAccount, QFilterCondition> {
  QueryBuilder<UniversityAccount, UniversityAccount, QAfterFilterCondition>
      idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<UniversityAccount, UniversityAccount, QAfterFilterCondition>
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

  QueryBuilder<UniversityAccount, UniversityAccount, QAfterFilterCondition>
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

  QueryBuilder<UniversityAccount, UniversityAccount, QAfterFilterCondition>
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

  QueryBuilder<UniversityAccount, UniversityAccount, QAfterFilterCondition>
      indexEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'index',
        value: value,
      ));
    });
  }

  QueryBuilder<UniversityAccount, UniversityAccount, QAfterFilterCondition>
      indexGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'index',
        value: value,
      ));
    });
  }

  QueryBuilder<UniversityAccount, UniversityAccount, QAfterFilterCondition>
      indexLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'index',
        value: value,
      ));
    });
  }

  QueryBuilder<UniversityAccount, UniversityAccount, QAfterFilterCondition>
      indexBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'index',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<UniversityAccount, UniversityAccount, QAfterFilterCondition>
      lastDashboardUpdateEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastDashboardUpdate',
        value: value,
      ));
    });
  }

  QueryBuilder<UniversityAccount, UniversityAccount, QAfterFilterCondition>
      lastDashboardUpdateGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lastDashboardUpdate',
        value: value,
      ));
    });
  }

  QueryBuilder<UniversityAccount, UniversityAccount, QAfterFilterCondition>
      lastDashboardUpdateLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lastDashboardUpdate',
        value: value,
      ));
    });
  }

  QueryBuilder<UniversityAccount, UniversityAccount, QAfterFilterCondition>
      lastDashboardUpdateBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lastDashboardUpdate',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<UniversityAccount, UniversityAccount, QAfterFilterCondition>
      universityEqualTo(
    University value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'university',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UniversityAccount, UniversityAccount, QAfterFilterCondition>
      universityGreaterThan(
    University value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'university',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UniversityAccount, UniversityAccount, QAfterFilterCondition>
      universityLessThan(
    University value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'university',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UniversityAccount, UniversityAccount, QAfterFilterCondition>
      universityBetween(
    University lower,
    University upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'university',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UniversityAccount, UniversityAccount, QAfterFilterCondition>
      universityStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'university',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UniversityAccount, UniversityAccount, QAfterFilterCondition>
      universityEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'university',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UniversityAccount, UniversityAccount, QAfterFilterCondition>
      universityContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'university',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UniversityAccount, UniversityAccount, QAfterFilterCondition>
      universityMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'university',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UniversityAccount, UniversityAccount, QAfterFilterCondition>
      universityIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'university',
        value: '',
      ));
    });
  }

  QueryBuilder<UniversityAccount, UniversityAccount, QAfterFilterCondition>
      universityIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'university',
        value: '',
      ));
    });
  }

  QueryBuilder<UniversityAccount, UniversityAccount, QAfterFilterCondition>
      userIdentifierEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'userIdentifier',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UniversityAccount, UniversityAccount, QAfterFilterCondition>
      userIdentifierGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'userIdentifier',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UniversityAccount, UniversityAccount, QAfterFilterCondition>
      userIdentifierLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'userIdentifier',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UniversityAccount, UniversityAccount, QAfterFilterCondition>
      userIdentifierBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'userIdentifier',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UniversityAccount, UniversityAccount, QAfterFilterCondition>
      userIdentifierStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'userIdentifier',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UniversityAccount, UniversityAccount, QAfterFilterCondition>
      userIdentifierEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'userIdentifier',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UniversityAccount, UniversityAccount, QAfterFilterCondition>
      userIdentifierContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'userIdentifier',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UniversityAccount, UniversityAccount, QAfterFilterCondition>
      userIdentifierMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'userIdentifier',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UniversityAccount, UniversityAccount, QAfterFilterCondition>
      userIdentifierIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'userIdentifier',
        value: '',
      ));
    });
  }

  QueryBuilder<UniversityAccount, UniversityAccount, QAfterFilterCondition>
      userIdentifierIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'userIdentifier',
        value: '',
      ));
    });
  }
}

extension UniversityAccountQueryObject
    on QueryBuilder<UniversityAccount, UniversityAccount, QFilterCondition> {}

extension UniversityAccountQueryLinks
    on QueryBuilder<UniversityAccount, UniversityAccount, QFilterCondition> {
  QueryBuilder<UniversityAccount, UniversityAccount, QAfterFilterCondition>
      courses(FilterQuery<Course> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'courses');
    });
  }

  QueryBuilder<UniversityAccount, UniversityAccount, QAfterFilterCondition>
      coursesLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'courses', length, true, length, true);
    });
  }

  QueryBuilder<UniversityAccount, UniversityAccount, QAfterFilterCondition>
      coursesIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'courses', 0, true, 0, true);
    });
  }

  QueryBuilder<UniversityAccount, UniversityAccount, QAfterFilterCondition>
      coursesIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'courses', 0, false, 999999, true);
    });
  }

  QueryBuilder<UniversityAccount, UniversityAccount, QAfterFilterCondition>
      coursesLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'courses', 0, true, length, include);
    });
  }

  QueryBuilder<UniversityAccount, UniversityAccount, QAfterFilterCondition>
      coursesLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'courses', length, include, 999999, true);
    });
  }

  QueryBuilder<UniversityAccount, UniversityAccount, QAfterFilterCondition>
      coursesLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(
          r'courses', lower, includeLower, upper, includeUpper);
    });
  }

  QueryBuilder<UniversityAccount, UniversityAccount, QAfterFilterCondition>
      videoApis(FilterQuery<VideoApiAccount> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'videoApis');
    });
  }

  QueryBuilder<UniversityAccount, UniversityAccount, QAfterFilterCondition>
      videoApisLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'videoApis', length, true, length, true);
    });
  }

  QueryBuilder<UniversityAccount, UniversityAccount, QAfterFilterCondition>
      videoApisIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'videoApis', 0, true, 0, true);
    });
  }

  QueryBuilder<UniversityAccount, UniversityAccount, QAfterFilterCondition>
      videoApisIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'videoApis', 0, false, 999999, true);
    });
  }

  QueryBuilder<UniversityAccount, UniversityAccount, QAfterFilterCondition>
      videoApisLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'videoApis', 0, true, length, include);
    });
  }

  QueryBuilder<UniversityAccount, UniversityAccount, QAfterFilterCondition>
      videoApisLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'videoApis', length, include, 999999, true);
    });
  }

  QueryBuilder<UniversityAccount, UniversityAccount, QAfterFilterCondition>
      videoApisLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(
          r'videoApis', lower, includeLower, upper, includeUpper);
    });
  }
}

extension UniversityAccountQuerySortBy
    on QueryBuilder<UniversityAccount, UniversityAccount, QSortBy> {
  QueryBuilder<UniversityAccount, UniversityAccount, QAfterSortBy>
      sortByIndex() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'index', Sort.asc);
    });
  }

  QueryBuilder<UniversityAccount, UniversityAccount, QAfterSortBy>
      sortByIndexDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'index', Sort.desc);
    });
  }

  QueryBuilder<UniversityAccount, UniversityAccount, QAfterSortBy>
      sortByLastDashboardUpdate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastDashboardUpdate', Sort.asc);
    });
  }

  QueryBuilder<UniversityAccount, UniversityAccount, QAfterSortBy>
      sortByLastDashboardUpdateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastDashboardUpdate', Sort.desc);
    });
  }

  QueryBuilder<UniversityAccount, UniversityAccount, QAfterSortBy>
      sortByUniversity() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'university', Sort.asc);
    });
  }

  QueryBuilder<UniversityAccount, UniversityAccount, QAfterSortBy>
      sortByUniversityDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'university', Sort.desc);
    });
  }

  QueryBuilder<UniversityAccount, UniversityAccount, QAfterSortBy>
      sortByUserIdentifier() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userIdentifier', Sort.asc);
    });
  }

  QueryBuilder<UniversityAccount, UniversityAccount, QAfterSortBy>
      sortByUserIdentifierDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userIdentifier', Sort.desc);
    });
  }
}

extension UniversityAccountQuerySortThenBy
    on QueryBuilder<UniversityAccount, UniversityAccount, QSortThenBy> {
  QueryBuilder<UniversityAccount, UniversityAccount, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<UniversityAccount, UniversityAccount, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<UniversityAccount, UniversityAccount, QAfterSortBy>
      thenByIndex() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'index', Sort.asc);
    });
  }

  QueryBuilder<UniversityAccount, UniversityAccount, QAfterSortBy>
      thenByIndexDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'index', Sort.desc);
    });
  }

  QueryBuilder<UniversityAccount, UniversityAccount, QAfterSortBy>
      thenByLastDashboardUpdate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastDashboardUpdate', Sort.asc);
    });
  }

  QueryBuilder<UniversityAccount, UniversityAccount, QAfterSortBy>
      thenByLastDashboardUpdateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastDashboardUpdate', Sort.desc);
    });
  }

  QueryBuilder<UniversityAccount, UniversityAccount, QAfterSortBy>
      thenByUniversity() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'university', Sort.asc);
    });
  }

  QueryBuilder<UniversityAccount, UniversityAccount, QAfterSortBy>
      thenByUniversityDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'university', Sort.desc);
    });
  }

  QueryBuilder<UniversityAccount, UniversityAccount, QAfterSortBy>
      thenByUserIdentifier() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userIdentifier', Sort.asc);
    });
  }

  QueryBuilder<UniversityAccount, UniversityAccount, QAfterSortBy>
      thenByUserIdentifierDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userIdentifier', Sort.desc);
    });
  }
}

extension UniversityAccountQueryWhereDistinct
    on QueryBuilder<UniversityAccount, UniversityAccount, QDistinct> {
  QueryBuilder<UniversityAccount, UniversityAccount, QDistinct>
      distinctByIndex() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'index');
    });
  }

  QueryBuilder<UniversityAccount, UniversityAccount, QDistinct>
      distinctByLastDashboardUpdate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastDashboardUpdate');
    });
  }

  QueryBuilder<UniversityAccount, UniversityAccount, QDistinct>
      distinctByUniversity({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'university', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<UniversityAccount, UniversityAccount, QDistinct>
      distinctByUserIdentifier({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'userIdentifier',
          caseSensitive: caseSensitive);
    });
  }
}

extension UniversityAccountQueryProperty
    on QueryBuilder<UniversityAccount, UniversityAccount, QQueryProperty> {
  QueryBuilder<UniversityAccount, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<UniversityAccount, int, QQueryOperations> indexProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'index');
    });
  }

  QueryBuilder<UniversityAccount, DateTime, QQueryOperations>
      lastDashboardUpdateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastDashboardUpdate');
    });
  }

  QueryBuilder<UniversityAccount, University, QQueryOperations>
      universityProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'university');
    });
  }

  QueryBuilder<UniversityAccount, String, QQueryOperations>
      userIdentifierProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'userIdentifier');
    });
  }
}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetCourseCollection on Isar {
  IsarCollection<Course> get courses => this.collection();
}

const CourseSchema = CollectionSchema(
  name: r'Course',
  id: -5832084671214696602,
  properties: {
    r'hidden': PropertySchema(
      id: 0,
      name: r'hidden',
      type: IsarType.bool,
    ),
    r'lastAccess': PropertySchema(
      id: 1,
      name: r'lastAccess',
      type: IsarType.dateTime,
    ),
    r'lastOpenedSection': PropertySchema(
      id: 2,
      name: r'lastOpenedSection',
      type: IsarType.long,
    ),
    r'lastUpdate': PropertySchema(
      id: 3,
      name: r'lastUpdate',
      type: IsarType.dateTime,
    ),
    r'name': PropertySchema(
      id: 4,
      name: r'name',
      type: IsarType.string,
    ),
    r'nameVariations': PropertySchema(
      id: 5,
      name: r'nameVariations',
      type: IsarType.stringList,
    ),
    r'sections': PropertySchema(
      id: 6,
      name: r'sections',
      type: IsarType.stringList,
    ),
    r'universityId': PropertySchema(
      id: 7,
      name: r'universityId',
      type: IsarType.long,
    )
  },
  estimateSize: _courseEstimateSize,
  serialize: _courseSerialize,
  deserialize: _courseDeserialize,
  deserializeProp: _courseDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {
    r'universityAccount': LinkSchema(
      id: 1179712375614888903,
      name: r'universityAccount',
      target: r'UniversityAccount',
      single: true,
    )
  },
  embeddedSchemas: {},
  getId: _courseGetId,
  getLinks: _courseGetLinks,
  attach: _courseAttach,
  version: '3.1.0+1',
);

int _courseEstimateSize(
  Course object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.name;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.nameVariations.length * 3;
  {
    for (var i = 0; i < object.nameVariations.length; i++) {
      final value = object.nameVariations[i];
      bytesCount += value.length * 3;
    }
  }
  bytesCount += 3 + object.sections.length * 3;
  {
    for (var i = 0; i < object.sections.length; i++) {
      final value = object.sections[i];
      bytesCount += value.length * 3;
    }
  }
  return bytesCount;
}

void _courseSerialize(
  Course object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeBool(offsets[0], object.hidden);
  writer.writeDateTime(offsets[1], object.lastAccess);
  writer.writeLong(offsets[2], object.lastOpenedSection);
  writer.writeDateTime(offsets[3], object.lastUpdate);
  writer.writeString(offsets[4], object.name);
  writer.writeStringList(offsets[5], object.nameVariations);
  writer.writeStringList(offsets[6], object.sections);
  writer.writeLong(offsets[7], object.universityId);
}

Course _courseDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = Course();
  object.hidden = reader.readBool(offsets[0]);
  object.id = id;
  object.lastAccess = reader.readDateTime(offsets[1]);
  object.lastOpenedSection = reader.readLong(offsets[2]);
  object.lastUpdate = reader.readDateTime(offsets[3]);
  object.name = reader.readStringOrNull(offsets[4]);
  object.nameVariations = reader.readStringList(offsets[5]) ?? [];
  object.sections = reader.readStringList(offsets[6]) ?? [];
  object.universityId = reader.readLong(offsets[7]);
  return object;
}

P _courseDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readBool(offset)) as P;
    case 1:
      return (reader.readDateTime(offset)) as P;
    case 2:
      return (reader.readLong(offset)) as P;
    case 3:
      return (reader.readDateTime(offset)) as P;
    case 4:
      return (reader.readStringOrNull(offset)) as P;
    case 5:
      return (reader.readStringList(offset) ?? []) as P;
    case 6:
      return (reader.readStringList(offset) ?? []) as P;
    case 7:
      return (reader.readLong(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _courseGetId(Course object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _courseGetLinks(Course object) {
  return [object.universityAccount];
}

void _courseAttach(IsarCollection<dynamic> col, Id id, Course object) {
  object.id = id;
  object.universityAccount.attach(
      col, col.isar.collection<UniversityAccount>(), r'universityAccount', id);
}

extension CourseQueryWhereSort on QueryBuilder<Course, Course, QWhere> {
  QueryBuilder<Course, Course, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension CourseQueryWhere on QueryBuilder<Course, Course, QWhereClause> {
  QueryBuilder<Course, Course, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<Course, Course, QAfterWhereClause> idNotEqualTo(Id id) {
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

  QueryBuilder<Course, Course, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<Course, Course, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<Course, Course, QAfterWhereClause> idBetween(
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
}

extension CourseQueryFilter on QueryBuilder<Course, Course, QFilterCondition> {
  QueryBuilder<Course, Course, QAfterFilterCondition> hiddenEqualTo(
      bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'hidden',
        value: value,
      ));
    });
  }

  QueryBuilder<Course, Course, QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Course, Course, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<Course, Course, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<Course, Course, QAfterFilterCondition> idBetween(
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

  QueryBuilder<Course, Course, QAfterFilterCondition> lastAccessEqualTo(
      DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastAccess',
        value: value,
      ));
    });
  }

  QueryBuilder<Course, Course, QAfterFilterCondition> lastAccessGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lastAccess',
        value: value,
      ));
    });
  }

  QueryBuilder<Course, Course, QAfterFilterCondition> lastAccessLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lastAccess',
        value: value,
      ));
    });
  }

  QueryBuilder<Course, Course, QAfterFilterCondition> lastAccessBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lastAccess',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Course, Course, QAfterFilterCondition> lastOpenedSectionEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastOpenedSection',
        value: value,
      ));
    });
  }

  QueryBuilder<Course, Course, QAfterFilterCondition>
      lastOpenedSectionGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lastOpenedSection',
        value: value,
      ));
    });
  }

  QueryBuilder<Course, Course, QAfterFilterCondition> lastOpenedSectionLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lastOpenedSection',
        value: value,
      ));
    });
  }

  QueryBuilder<Course, Course, QAfterFilterCondition> lastOpenedSectionBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lastOpenedSection',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Course, Course, QAfterFilterCondition> lastUpdateEqualTo(
      DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastUpdate',
        value: value,
      ));
    });
  }

  QueryBuilder<Course, Course, QAfterFilterCondition> lastUpdateGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lastUpdate',
        value: value,
      ));
    });
  }

  QueryBuilder<Course, Course, QAfterFilterCondition> lastUpdateLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lastUpdate',
        value: value,
      ));
    });
  }

  QueryBuilder<Course, Course, QAfterFilterCondition> lastUpdateBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lastUpdate',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Course, Course, QAfterFilterCondition> nameIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'name',
      ));
    });
  }

  QueryBuilder<Course, Course, QAfterFilterCondition> nameIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'name',
      ));
    });
  }

  QueryBuilder<Course, Course, QAfterFilterCondition> nameEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Course, Course, QAfterFilterCondition> nameGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Course, Course, QAfterFilterCondition> nameLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Course, Course, QAfterFilterCondition> nameBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'name',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Course, Course, QAfterFilterCondition> nameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Course, Course, QAfterFilterCondition> nameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Course, Course, QAfterFilterCondition> nameContains(String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Course, Course, QAfterFilterCondition> nameMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'name',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Course, Course, QAfterFilterCondition> nameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<Course, Course, QAfterFilterCondition> nameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<Course, Course, QAfterFilterCondition>
      nameVariationsElementEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'nameVariations',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Course, Course, QAfterFilterCondition>
      nameVariationsElementGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'nameVariations',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Course, Course, QAfterFilterCondition>
      nameVariationsElementLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'nameVariations',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Course, Course, QAfterFilterCondition>
      nameVariationsElementBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'nameVariations',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Course, Course, QAfterFilterCondition>
      nameVariationsElementStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'nameVariations',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Course, Course, QAfterFilterCondition>
      nameVariationsElementEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'nameVariations',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Course, Course, QAfterFilterCondition>
      nameVariationsElementContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'nameVariations',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Course, Course, QAfterFilterCondition>
      nameVariationsElementMatches(String pattern,
          {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'nameVariations',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Course, Course, QAfterFilterCondition>
      nameVariationsElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'nameVariations',
        value: '',
      ));
    });
  }

  QueryBuilder<Course, Course, QAfterFilterCondition>
      nameVariationsElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'nameVariations',
        value: '',
      ));
    });
  }

  QueryBuilder<Course, Course, QAfterFilterCondition>
      nameVariationsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'nameVariations',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<Course, Course, QAfterFilterCondition> nameVariationsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'nameVariations',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<Course, Course, QAfterFilterCondition>
      nameVariationsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'nameVariations',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<Course, Course, QAfterFilterCondition>
      nameVariationsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'nameVariations',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<Course, Course, QAfterFilterCondition>
      nameVariationsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'nameVariations',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<Course, Course, QAfterFilterCondition>
      nameVariationsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'nameVariations',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<Course, Course, QAfterFilterCondition> sectionsElementEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'sections',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Course, Course, QAfterFilterCondition>
      sectionsElementGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'sections',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Course, Course, QAfterFilterCondition> sectionsElementLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'sections',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Course, Course, QAfterFilterCondition> sectionsElementBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'sections',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Course, Course, QAfterFilterCondition> sectionsElementStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'sections',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Course, Course, QAfterFilterCondition> sectionsElementEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'sections',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Course, Course, QAfterFilterCondition> sectionsElementContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'sections',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Course, Course, QAfterFilterCondition> sectionsElementMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'sections',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Course, Course, QAfterFilterCondition> sectionsElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'sections',
        value: '',
      ));
    });
  }

  QueryBuilder<Course, Course, QAfterFilterCondition>
      sectionsElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'sections',
        value: '',
      ));
    });
  }

  QueryBuilder<Course, Course, QAfterFilterCondition> sectionsLengthEqualTo(
      int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'sections',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<Course, Course, QAfterFilterCondition> sectionsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'sections',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<Course, Course, QAfterFilterCondition> sectionsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'sections',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<Course, Course, QAfterFilterCondition> sectionsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'sections',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<Course, Course, QAfterFilterCondition> sectionsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'sections',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<Course, Course, QAfterFilterCondition> sectionsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'sections',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<Course, Course, QAfterFilterCondition> universityIdEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'universityId',
        value: value,
      ));
    });
  }

  QueryBuilder<Course, Course, QAfterFilterCondition> universityIdGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'universityId',
        value: value,
      ));
    });
  }

  QueryBuilder<Course, Course, QAfterFilterCondition> universityIdLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'universityId',
        value: value,
      ));
    });
  }

  QueryBuilder<Course, Course, QAfterFilterCondition> universityIdBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'universityId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension CourseQueryObject on QueryBuilder<Course, Course, QFilterCondition> {}

extension CourseQueryLinks on QueryBuilder<Course, Course, QFilterCondition> {
  QueryBuilder<Course, Course, QAfterFilterCondition> universityAccount(
      FilterQuery<UniversityAccount> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'universityAccount');
    });
  }

  QueryBuilder<Course, Course, QAfterFilterCondition>
      universityAccountIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'universityAccount', 0, true, 0, true);
    });
  }
}

extension CourseQuerySortBy on QueryBuilder<Course, Course, QSortBy> {
  QueryBuilder<Course, Course, QAfterSortBy> sortByHidden() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hidden', Sort.asc);
    });
  }

  QueryBuilder<Course, Course, QAfterSortBy> sortByHiddenDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hidden', Sort.desc);
    });
  }

  QueryBuilder<Course, Course, QAfterSortBy> sortByLastAccess() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastAccess', Sort.asc);
    });
  }

  QueryBuilder<Course, Course, QAfterSortBy> sortByLastAccessDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastAccess', Sort.desc);
    });
  }

  QueryBuilder<Course, Course, QAfterSortBy> sortByLastOpenedSection() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastOpenedSection', Sort.asc);
    });
  }

  QueryBuilder<Course, Course, QAfterSortBy> sortByLastOpenedSectionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastOpenedSection', Sort.desc);
    });
  }

  QueryBuilder<Course, Course, QAfterSortBy> sortByLastUpdate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastUpdate', Sort.asc);
    });
  }

  QueryBuilder<Course, Course, QAfterSortBy> sortByLastUpdateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastUpdate', Sort.desc);
    });
  }

  QueryBuilder<Course, Course, QAfterSortBy> sortByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<Course, Course, QAfterSortBy> sortByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<Course, Course, QAfterSortBy> sortByUniversityId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'universityId', Sort.asc);
    });
  }

  QueryBuilder<Course, Course, QAfterSortBy> sortByUniversityIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'universityId', Sort.desc);
    });
  }
}

extension CourseQuerySortThenBy on QueryBuilder<Course, Course, QSortThenBy> {
  QueryBuilder<Course, Course, QAfterSortBy> thenByHidden() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hidden', Sort.asc);
    });
  }

  QueryBuilder<Course, Course, QAfterSortBy> thenByHiddenDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hidden', Sort.desc);
    });
  }

  QueryBuilder<Course, Course, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<Course, Course, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<Course, Course, QAfterSortBy> thenByLastAccess() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastAccess', Sort.asc);
    });
  }

  QueryBuilder<Course, Course, QAfterSortBy> thenByLastAccessDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastAccess', Sort.desc);
    });
  }

  QueryBuilder<Course, Course, QAfterSortBy> thenByLastOpenedSection() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastOpenedSection', Sort.asc);
    });
  }

  QueryBuilder<Course, Course, QAfterSortBy> thenByLastOpenedSectionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastOpenedSection', Sort.desc);
    });
  }

  QueryBuilder<Course, Course, QAfterSortBy> thenByLastUpdate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastUpdate', Sort.asc);
    });
  }

  QueryBuilder<Course, Course, QAfterSortBy> thenByLastUpdateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastUpdate', Sort.desc);
    });
  }

  QueryBuilder<Course, Course, QAfterSortBy> thenByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<Course, Course, QAfterSortBy> thenByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<Course, Course, QAfterSortBy> thenByUniversityId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'universityId', Sort.asc);
    });
  }

  QueryBuilder<Course, Course, QAfterSortBy> thenByUniversityIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'universityId', Sort.desc);
    });
  }
}

extension CourseQueryWhereDistinct on QueryBuilder<Course, Course, QDistinct> {
  QueryBuilder<Course, Course, QDistinct> distinctByHidden() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'hidden');
    });
  }

  QueryBuilder<Course, Course, QDistinct> distinctByLastAccess() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastAccess');
    });
  }

  QueryBuilder<Course, Course, QDistinct> distinctByLastOpenedSection() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastOpenedSection');
    });
  }

  QueryBuilder<Course, Course, QDistinct> distinctByLastUpdate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastUpdate');
    });
  }

  QueryBuilder<Course, Course, QDistinct> distinctByName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'name', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Course, Course, QDistinct> distinctByNameVariations() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'nameVariations');
    });
  }

  QueryBuilder<Course, Course, QDistinct> distinctBySections() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'sections');
    });
  }

  QueryBuilder<Course, Course, QDistinct> distinctByUniversityId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'universityId');
    });
  }
}

extension CourseQueryProperty on QueryBuilder<Course, Course, QQueryProperty> {
  QueryBuilder<Course, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<Course, bool, QQueryOperations> hiddenProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'hidden');
    });
  }

  QueryBuilder<Course, DateTime, QQueryOperations> lastAccessProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastAccess');
    });
  }

  QueryBuilder<Course, int, QQueryOperations> lastOpenedSectionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastOpenedSection');
    });
  }

  QueryBuilder<Course, DateTime, QQueryOperations> lastUpdateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastUpdate');
    });
  }

  QueryBuilder<Course, String?, QQueryOperations> nameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'name');
    });
  }

  QueryBuilder<Course, List<String>, QQueryOperations>
      nameVariationsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'nameVariations');
    });
  }

  QueryBuilder<Course, List<String>, QQueryOperations> sectionsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'sections');
    });
  }

  QueryBuilder<Course, int, QQueryOperations> universityIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'universityId');
    });
  }
}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetModuleCollection on Isar {
  IsarCollection<Module> get modules => this.collection();
}

const ModuleSchema = CollectionSchema(
  name: r'Module',
  id: -2335926089013615123,
  properties: {
    r'description': PropertySchema(
      id: 0,
      name: r'description',
      type: IsarType.string,
    ),
    r'download': PropertySchema(
      id: 1,
      name: r'download',
      type: IsarType.double,
    ),
    r'favoritedSince': PropertySchema(
      id: 2,
      name: r'favoritedSince',
      type: IsarType.dateTime,
    ),
    r'filepath': PropertySchema(
      id: 3,
      name: r'filepath',
      type: IsarType.string,
    ),
    r'index': PropertySchema(
      id: 4,
      name: r'index',
      type: IsarType.long,
    ),
    r'lastUsed': PropertySchema(
      id: 5,
      name: r'lastUsed',
      type: IsarType.dateTime,
    ),
    r'previewFilepath': PropertySchema(
      id: 6,
      name: r'previewFilepath',
      type: IsarType.string,
    ),
    r'progress': PropertySchema(
      id: 7,
      name: r'progress',
      type: IsarType.double,
    ),
    r'section': PropertySchema(
      id: 8,
      name: r'section',
      type: IsarType.long,
    ),
    r'title': PropertySchema(
      id: 9,
      name: r'title',
      type: IsarType.string,
    ),
    r'type': PropertySchema(
      id: 10,
      name: r'type',
      type: IsarType.string,
      enumMap: _ModuletypeEnumValueMap,
    ),
    r'universityId': PropertySchema(
      id: 11,
      name: r'universityId',
      type: IsarType.long,
    ),
    r'url': PropertySchema(
      id: 12,
      name: r'url',
      type: IsarType.string,
    )
  },
  estimateSize: _moduleEstimateSize,
  serialize: _moduleSerialize,
  deserialize: _moduleDeserialize,
  deserializeProp: _moduleDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {
    r'course': LinkSchema(
      id: -7257654071660926752,
      name: r'course',
      target: r'Course',
      single: true,
    ),
    r'searchable': LinkSchema(
      id: 3773926044280167684,
      name: r'searchable',
      target: r'Searchable',
      single: true,
      linkName: r'module',
    ),
    r'submodules': LinkSchema(
      id: -4163506058939294619,
      name: r'submodules',
      target: r'Module',
      single: false,
    )
  },
  embeddedSchemas: {},
  getId: _moduleGetId,
  getLinks: _moduleGetLinks,
  attach: _moduleAttach,
  version: '3.1.0+1',
);

int _moduleEstimateSize(
  Module object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.description;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.filepath;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.previewFilepath;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.title.length * 3;
  bytesCount += 3 + object.type.name.length * 3;
  {
    final value = object.url;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _moduleSerialize(
  Module object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.description);
  writer.writeDouble(offsets[1], object.download);
  writer.writeDateTime(offsets[2], object.favoritedSince);
  writer.writeString(offsets[3], object.filepath);
  writer.writeLong(offsets[4], object.index);
  writer.writeDateTime(offsets[5], object.lastUsed);
  writer.writeString(offsets[6], object.previewFilepath);
  writer.writeDouble(offsets[7], object.progress);
  writer.writeLong(offsets[8], object.section);
  writer.writeString(offsets[9], object.title);
  writer.writeString(offsets[10], object.type.name);
  writer.writeLong(offsets[11], object.universityId);
  writer.writeString(offsets[12], object.url);
}

Module _moduleDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = Module();
  object.description = reader.readStringOrNull(offsets[0]);
  object.download = reader.readDoubleOrNull(offsets[1]);
  object.favoritedSince = reader.readDateTimeOrNull(offsets[2]);
  object.filepath = reader.readStringOrNull(offsets[3]);
  object.id = id;
  object.index = reader.readLong(offsets[4]);
  object.lastUsed = reader.readDateTimeOrNull(offsets[5]);
  object.previewFilepath = reader.readStringOrNull(offsets[6]);
  object.progress = reader.readDoubleOrNull(offsets[7]);
  object.section = reader.readLongOrNull(offsets[8]);
  object.title = reader.readString(offsets[9]);
  object.type = _ModuletypeValueEnumMap[reader.readStringOrNull(offsets[10])] ??
      ModuleType.text;
  object.universityId = reader.readLongOrNull(offsets[11]);
  object.url = reader.readStringOrNull(offsets[12]);
  return object;
}

P _moduleDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readStringOrNull(offset)) as P;
    case 1:
      return (reader.readDoubleOrNull(offset)) as P;
    case 2:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 3:
      return (reader.readStringOrNull(offset)) as P;
    case 4:
      return (reader.readLong(offset)) as P;
    case 5:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 6:
      return (reader.readStringOrNull(offset)) as P;
    case 7:
      return (reader.readDoubleOrNull(offset)) as P;
    case 8:
      return (reader.readLongOrNull(offset)) as P;
    case 9:
      return (reader.readString(offset)) as P;
    case 10:
      return (_ModuletypeValueEnumMap[reader.readStringOrNull(offset)] ??
          ModuleType.text) as P;
    case 11:
      return (reader.readLongOrNull(offset)) as P;
    case 12:
      return (reader.readStringOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _ModuletypeEnumValueMap = {
  r'text': r'text',
  r'html': r'html',
  r'image': r'image',
  r'video': r'video',
  r'file': r'file',
  r'pdf': r'pdf',
  r'folder': r'folder',
  r'page': r'page',
  r'unsupported': r'unsupported',
};
const _ModuletypeValueEnumMap = {
  r'text': ModuleType.text,
  r'html': ModuleType.html,
  r'image': ModuleType.image,
  r'video': ModuleType.video,
  r'file': ModuleType.file,
  r'pdf': ModuleType.pdf,
  r'folder': ModuleType.folder,
  r'page': ModuleType.page,
  r'unsupported': ModuleType.unsupported,
};

Id _moduleGetId(Module object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _moduleGetLinks(Module object) {
  return [object.course, object.searchable, object.submodules];
}

void _moduleAttach(IsarCollection<dynamic> col, Id id, Module object) {
  object.id = id;
  object.course.attach(col, col.isar.collection<Course>(), r'course', id);
  object.searchable
      .attach(col, col.isar.collection<Searchable>(), r'searchable', id);
  object.submodules
      .attach(col, col.isar.collection<Module>(), r'submodules', id);
}

extension ModuleQueryWhereSort on QueryBuilder<Module, Module, QWhere> {
  QueryBuilder<Module, Module, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension ModuleQueryWhere on QueryBuilder<Module, Module, QWhereClause> {
  QueryBuilder<Module, Module, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<Module, Module, QAfterWhereClause> idNotEqualTo(Id id) {
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

  QueryBuilder<Module, Module, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<Module, Module, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<Module, Module, QAfterWhereClause> idBetween(
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
}

extension ModuleQueryFilter on QueryBuilder<Module, Module, QFilterCondition> {
  QueryBuilder<Module, Module, QAfterFilterCondition> descriptionIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'description',
      ));
    });
  }

  QueryBuilder<Module, Module, QAfterFilterCondition> descriptionIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'description',
      ));
    });
  }

  QueryBuilder<Module, Module, QAfterFilterCondition> descriptionEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Module, Module, QAfterFilterCondition> descriptionGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Module, Module, QAfterFilterCondition> descriptionLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Module, Module, QAfterFilterCondition> descriptionBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'description',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Module, Module, QAfterFilterCondition> descriptionStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Module, Module, QAfterFilterCondition> descriptionEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Module, Module, QAfterFilterCondition> descriptionContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Module, Module, QAfterFilterCondition> descriptionMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'description',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Module, Module, QAfterFilterCondition> descriptionIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'description',
        value: '',
      ));
    });
  }

  QueryBuilder<Module, Module, QAfterFilterCondition> descriptionIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'description',
        value: '',
      ));
    });
  }

  QueryBuilder<Module, Module, QAfterFilterCondition> downloadIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'download',
      ));
    });
  }

  QueryBuilder<Module, Module, QAfterFilterCondition> downloadIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'download',
      ));
    });
  }

  QueryBuilder<Module, Module, QAfterFilterCondition> downloadEqualTo(
    double? value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'download',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Module, Module, QAfterFilterCondition> downloadGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'download',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Module, Module, QAfterFilterCondition> downloadLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'download',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Module, Module, QAfterFilterCondition> downloadBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'download',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Module, Module, QAfterFilterCondition> favoritedSinceIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'favoritedSince',
      ));
    });
  }

  QueryBuilder<Module, Module, QAfterFilterCondition>
      favoritedSinceIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'favoritedSince',
      ));
    });
  }

  QueryBuilder<Module, Module, QAfterFilterCondition> favoritedSinceEqualTo(
      DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'favoritedSince',
        value: value,
      ));
    });
  }

  QueryBuilder<Module, Module, QAfterFilterCondition> favoritedSinceGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'favoritedSince',
        value: value,
      ));
    });
  }

  QueryBuilder<Module, Module, QAfterFilterCondition> favoritedSinceLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'favoritedSince',
        value: value,
      ));
    });
  }

  QueryBuilder<Module, Module, QAfterFilterCondition> favoritedSinceBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'favoritedSince',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Module, Module, QAfterFilterCondition> filepathIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'filepath',
      ));
    });
  }

  QueryBuilder<Module, Module, QAfterFilterCondition> filepathIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'filepath',
      ));
    });
  }

  QueryBuilder<Module, Module, QAfterFilterCondition> filepathEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'filepath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Module, Module, QAfterFilterCondition> filepathGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'filepath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Module, Module, QAfterFilterCondition> filepathLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'filepath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Module, Module, QAfterFilterCondition> filepathBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'filepath',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Module, Module, QAfterFilterCondition> filepathStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'filepath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Module, Module, QAfterFilterCondition> filepathEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'filepath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Module, Module, QAfterFilterCondition> filepathContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'filepath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Module, Module, QAfterFilterCondition> filepathMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'filepath',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Module, Module, QAfterFilterCondition> filepathIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'filepath',
        value: '',
      ));
    });
  }

  QueryBuilder<Module, Module, QAfterFilterCondition> filepathIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'filepath',
        value: '',
      ));
    });
  }

  QueryBuilder<Module, Module, QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Module, Module, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<Module, Module, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<Module, Module, QAfterFilterCondition> idBetween(
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

  QueryBuilder<Module, Module, QAfterFilterCondition> indexEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'index',
        value: value,
      ));
    });
  }

  QueryBuilder<Module, Module, QAfterFilterCondition> indexGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'index',
        value: value,
      ));
    });
  }

  QueryBuilder<Module, Module, QAfterFilterCondition> indexLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'index',
        value: value,
      ));
    });
  }

  QueryBuilder<Module, Module, QAfterFilterCondition> indexBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'index',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Module, Module, QAfterFilterCondition> lastUsedIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'lastUsed',
      ));
    });
  }

  QueryBuilder<Module, Module, QAfterFilterCondition> lastUsedIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'lastUsed',
      ));
    });
  }

  QueryBuilder<Module, Module, QAfterFilterCondition> lastUsedEqualTo(
      DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastUsed',
        value: value,
      ));
    });
  }

  QueryBuilder<Module, Module, QAfterFilterCondition> lastUsedGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lastUsed',
        value: value,
      ));
    });
  }

  QueryBuilder<Module, Module, QAfterFilterCondition> lastUsedLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lastUsed',
        value: value,
      ));
    });
  }

  QueryBuilder<Module, Module, QAfterFilterCondition> lastUsedBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lastUsed',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Module, Module, QAfterFilterCondition> previewFilepathIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'previewFilepath',
      ));
    });
  }

  QueryBuilder<Module, Module, QAfterFilterCondition>
      previewFilepathIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'previewFilepath',
      ));
    });
  }

  QueryBuilder<Module, Module, QAfterFilterCondition> previewFilepathEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'previewFilepath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Module, Module, QAfterFilterCondition>
      previewFilepathGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'previewFilepath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Module, Module, QAfterFilterCondition> previewFilepathLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'previewFilepath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Module, Module, QAfterFilterCondition> previewFilepathBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'previewFilepath',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Module, Module, QAfterFilterCondition> previewFilepathStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'previewFilepath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Module, Module, QAfterFilterCondition> previewFilepathEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'previewFilepath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Module, Module, QAfterFilterCondition> previewFilepathContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'previewFilepath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Module, Module, QAfterFilterCondition> previewFilepathMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'previewFilepath',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Module, Module, QAfterFilterCondition> previewFilepathIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'previewFilepath',
        value: '',
      ));
    });
  }

  QueryBuilder<Module, Module, QAfterFilterCondition>
      previewFilepathIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'previewFilepath',
        value: '',
      ));
    });
  }

  QueryBuilder<Module, Module, QAfterFilterCondition> progressIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'progress',
      ));
    });
  }

  QueryBuilder<Module, Module, QAfterFilterCondition> progressIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'progress',
      ));
    });
  }

  QueryBuilder<Module, Module, QAfterFilterCondition> progressEqualTo(
    double? value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'progress',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Module, Module, QAfterFilterCondition> progressGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'progress',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Module, Module, QAfterFilterCondition> progressLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'progress',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Module, Module, QAfterFilterCondition> progressBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'progress',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Module, Module, QAfterFilterCondition> sectionIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'section',
      ));
    });
  }

  QueryBuilder<Module, Module, QAfterFilterCondition> sectionIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'section',
      ));
    });
  }

  QueryBuilder<Module, Module, QAfterFilterCondition> sectionEqualTo(
      int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'section',
        value: value,
      ));
    });
  }

  QueryBuilder<Module, Module, QAfterFilterCondition> sectionGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'section',
        value: value,
      ));
    });
  }

  QueryBuilder<Module, Module, QAfterFilterCondition> sectionLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'section',
        value: value,
      ));
    });
  }

  QueryBuilder<Module, Module, QAfterFilterCondition> sectionBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'section',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Module, Module, QAfterFilterCondition> titleEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Module, Module, QAfterFilterCondition> titleGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Module, Module, QAfterFilterCondition> titleLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Module, Module, QAfterFilterCondition> titleBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'title',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Module, Module, QAfterFilterCondition> titleStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Module, Module, QAfterFilterCondition> titleEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Module, Module, QAfterFilterCondition> titleContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Module, Module, QAfterFilterCondition> titleMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'title',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Module, Module, QAfterFilterCondition> titleIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'title',
        value: '',
      ));
    });
  }

  QueryBuilder<Module, Module, QAfterFilterCondition> titleIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'title',
        value: '',
      ));
    });
  }

  QueryBuilder<Module, Module, QAfterFilterCondition> typeEqualTo(
    ModuleType value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'type',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Module, Module, QAfterFilterCondition> typeGreaterThan(
    ModuleType value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'type',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Module, Module, QAfterFilterCondition> typeLessThan(
    ModuleType value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'type',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Module, Module, QAfterFilterCondition> typeBetween(
    ModuleType lower,
    ModuleType upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'type',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Module, Module, QAfterFilterCondition> typeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'type',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Module, Module, QAfterFilterCondition> typeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'type',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Module, Module, QAfterFilterCondition> typeContains(String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'type',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Module, Module, QAfterFilterCondition> typeMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'type',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Module, Module, QAfterFilterCondition> typeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'type',
        value: '',
      ));
    });
  }

  QueryBuilder<Module, Module, QAfterFilterCondition> typeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'type',
        value: '',
      ));
    });
  }

  QueryBuilder<Module, Module, QAfterFilterCondition> universityIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'universityId',
      ));
    });
  }

  QueryBuilder<Module, Module, QAfterFilterCondition> universityIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'universityId',
      ));
    });
  }

  QueryBuilder<Module, Module, QAfterFilterCondition> universityIdEqualTo(
      int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'universityId',
        value: value,
      ));
    });
  }

  QueryBuilder<Module, Module, QAfterFilterCondition> universityIdGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'universityId',
        value: value,
      ));
    });
  }

  QueryBuilder<Module, Module, QAfterFilterCondition> universityIdLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'universityId',
        value: value,
      ));
    });
  }

  QueryBuilder<Module, Module, QAfterFilterCondition> universityIdBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'universityId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Module, Module, QAfterFilterCondition> urlIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'url',
      ));
    });
  }

  QueryBuilder<Module, Module, QAfterFilterCondition> urlIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'url',
      ));
    });
  }

  QueryBuilder<Module, Module, QAfterFilterCondition> urlEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'url',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Module, Module, QAfterFilterCondition> urlGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'url',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Module, Module, QAfterFilterCondition> urlLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'url',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Module, Module, QAfterFilterCondition> urlBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'url',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Module, Module, QAfterFilterCondition> urlStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'url',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Module, Module, QAfterFilterCondition> urlEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'url',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Module, Module, QAfterFilterCondition> urlContains(String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'url',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Module, Module, QAfterFilterCondition> urlMatches(String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'url',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Module, Module, QAfterFilterCondition> urlIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'url',
        value: '',
      ));
    });
  }

  QueryBuilder<Module, Module, QAfterFilterCondition> urlIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'url',
        value: '',
      ));
    });
  }
}

extension ModuleQueryObject on QueryBuilder<Module, Module, QFilterCondition> {}

extension ModuleQueryLinks on QueryBuilder<Module, Module, QFilterCondition> {
  QueryBuilder<Module, Module, QAfterFilterCondition> course(
      FilterQuery<Course> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'course');
    });
  }

  QueryBuilder<Module, Module, QAfterFilterCondition> courseIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'course', 0, true, 0, true);
    });
  }

  QueryBuilder<Module, Module, QAfterFilterCondition> searchable(
      FilterQuery<Searchable> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'searchable');
    });
  }

  QueryBuilder<Module, Module, QAfterFilterCondition> searchableIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'searchable', 0, true, 0, true);
    });
  }

  QueryBuilder<Module, Module, QAfterFilterCondition> submodules(
      FilterQuery<Module> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'submodules');
    });
  }

  QueryBuilder<Module, Module, QAfterFilterCondition> submodulesLengthEqualTo(
      int length) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'submodules', length, true, length, true);
    });
  }

  QueryBuilder<Module, Module, QAfterFilterCondition> submodulesIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'submodules', 0, true, 0, true);
    });
  }

  QueryBuilder<Module, Module, QAfterFilterCondition> submodulesIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'submodules', 0, false, 999999, true);
    });
  }

  QueryBuilder<Module, Module, QAfterFilterCondition> submodulesLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'submodules', 0, true, length, include);
    });
  }

  QueryBuilder<Module, Module, QAfterFilterCondition>
      submodulesLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'submodules', length, include, 999999, true);
    });
  }

  QueryBuilder<Module, Module, QAfterFilterCondition> submodulesLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(
          r'submodules', lower, includeLower, upper, includeUpper);
    });
  }
}

extension ModuleQuerySortBy on QueryBuilder<Module, Module, QSortBy> {
  QueryBuilder<Module, Module, QAfterSortBy> sortByDescription() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'description', Sort.asc);
    });
  }

  QueryBuilder<Module, Module, QAfterSortBy> sortByDescriptionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'description', Sort.desc);
    });
  }

  QueryBuilder<Module, Module, QAfterSortBy> sortByDownload() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'download', Sort.asc);
    });
  }

  QueryBuilder<Module, Module, QAfterSortBy> sortByDownloadDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'download', Sort.desc);
    });
  }

  QueryBuilder<Module, Module, QAfterSortBy> sortByFavoritedSince() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'favoritedSince', Sort.asc);
    });
  }

  QueryBuilder<Module, Module, QAfterSortBy> sortByFavoritedSinceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'favoritedSince', Sort.desc);
    });
  }

  QueryBuilder<Module, Module, QAfterSortBy> sortByFilepath() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'filepath', Sort.asc);
    });
  }

  QueryBuilder<Module, Module, QAfterSortBy> sortByFilepathDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'filepath', Sort.desc);
    });
  }

  QueryBuilder<Module, Module, QAfterSortBy> sortByIndex() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'index', Sort.asc);
    });
  }

  QueryBuilder<Module, Module, QAfterSortBy> sortByIndexDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'index', Sort.desc);
    });
  }

  QueryBuilder<Module, Module, QAfterSortBy> sortByLastUsed() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastUsed', Sort.asc);
    });
  }

  QueryBuilder<Module, Module, QAfterSortBy> sortByLastUsedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastUsed', Sort.desc);
    });
  }

  QueryBuilder<Module, Module, QAfterSortBy> sortByPreviewFilepath() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'previewFilepath', Sort.asc);
    });
  }

  QueryBuilder<Module, Module, QAfterSortBy> sortByPreviewFilepathDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'previewFilepath', Sort.desc);
    });
  }

  QueryBuilder<Module, Module, QAfterSortBy> sortByProgress() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'progress', Sort.asc);
    });
  }

  QueryBuilder<Module, Module, QAfterSortBy> sortByProgressDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'progress', Sort.desc);
    });
  }

  QueryBuilder<Module, Module, QAfterSortBy> sortBySection() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'section', Sort.asc);
    });
  }

  QueryBuilder<Module, Module, QAfterSortBy> sortBySectionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'section', Sort.desc);
    });
  }

  QueryBuilder<Module, Module, QAfterSortBy> sortByTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.asc);
    });
  }

  QueryBuilder<Module, Module, QAfterSortBy> sortByTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.desc);
    });
  }

  QueryBuilder<Module, Module, QAfterSortBy> sortByType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.asc);
    });
  }

  QueryBuilder<Module, Module, QAfterSortBy> sortByTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.desc);
    });
  }

  QueryBuilder<Module, Module, QAfterSortBy> sortByUniversityId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'universityId', Sort.asc);
    });
  }

  QueryBuilder<Module, Module, QAfterSortBy> sortByUniversityIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'universityId', Sort.desc);
    });
  }

  QueryBuilder<Module, Module, QAfterSortBy> sortByUrl() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'url', Sort.asc);
    });
  }

  QueryBuilder<Module, Module, QAfterSortBy> sortByUrlDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'url', Sort.desc);
    });
  }
}

extension ModuleQuerySortThenBy on QueryBuilder<Module, Module, QSortThenBy> {
  QueryBuilder<Module, Module, QAfterSortBy> thenByDescription() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'description', Sort.asc);
    });
  }

  QueryBuilder<Module, Module, QAfterSortBy> thenByDescriptionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'description', Sort.desc);
    });
  }

  QueryBuilder<Module, Module, QAfterSortBy> thenByDownload() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'download', Sort.asc);
    });
  }

  QueryBuilder<Module, Module, QAfterSortBy> thenByDownloadDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'download', Sort.desc);
    });
  }

  QueryBuilder<Module, Module, QAfterSortBy> thenByFavoritedSince() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'favoritedSince', Sort.asc);
    });
  }

  QueryBuilder<Module, Module, QAfterSortBy> thenByFavoritedSinceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'favoritedSince', Sort.desc);
    });
  }

  QueryBuilder<Module, Module, QAfterSortBy> thenByFilepath() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'filepath', Sort.asc);
    });
  }

  QueryBuilder<Module, Module, QAfterSortBy> thenByFilepathDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'filepath', Sort.desc);
    });
  }

  QueryBuilder<Module, Module, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<Module, Module, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<Module, Module, QAfterSortBy> thenByIndex() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'index', Sort.asc);
    });
  }

  QueryBuilder<Module, Module, QAfterSortBy> thenByIndexDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'index', Sort.desc);
    });
  }

  QueryBuilder<Module, Module, QAfterSortBy> thenByLastUsed() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastUsed', Sort.asc);
    });
  }

  QueryBuilder<Module, Module, QAfterSortBy> thenByLastUsedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastUsed', Sort.desc);
    });
  }

  QueryBuilder<Module, Module, QAfterSortBy> thenByPreviewFilepath() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'previewFilepath', Sort.asc);
    });
  }

  QueryBuilder<Module, Module, QAfterSortBy> thenByPreviewFilepathDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'previewFilepath', Sort.desc);
    });
  }

  QueryBuilder<Module, Module, QAfterSortBy> thenByProgress() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'progress', Sort.asc);
    });
  }

  QueryBuilder<Module, Module, QAfterSortBy> thenByProgressDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'progress', Sort.desc);
    });
  }

  QueryBuilder<Module, Module, QAfterSortBy> thenBySection() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'section', Sort.asc);
    });
  }

  QueryBuilder<Module, Module, QAfterSortBy> thenBySectionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'section', Sort.desc);
    });
  }

  QueryBuilder<Module, Module, QAfterSortBy> thenByTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.asc);
    });
  }

  QueryBuilder<Module, Module, QAfterSortBy> thenByTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.desc);
    });
  }

  QueryBuilder<Module, Module, QAfterSortBy> thenByType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.asc);
    });
  }

  QueryBuilder<Module, Module, QAfterSortBy> thenByTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.desc);
    });
  }

  QueryBuilder<Module, Module, QAfterSortBy> thenByUniversityId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'universityId', Sort.asc);
    });
  }

  QueryBuilder<Module, Module, QAfterSortBy> thenByUniversityIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'universityId', Sort.desc);
    });
  }

  QueryBuilder<Module, Module, QAfterSortBy> thenByUrl() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'url', Sort.asc);
    });
  }

  QueryBuilder<Module, Module, QAfterSortBy> thenByUrlDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'url', Sort.desc);
    });
  }
}

extension ModuleQueryWhereDistinct on QueryBuilder<Module, Module, QDistinct> {
  QueryBuilder<Module, Module, QDistinct> distinctByDescription(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'description', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Module, Module, QDistinct> distinctByDownload() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'download');
    });
  }

  QueryBuilder<Module, Module, QDistinct> distinctByFavoritedSince() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'favoritedSince');
    });
  }

  QueryBuilder<Module, Module, QDistinct> distinctByFilepath(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'filepath', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Module, Module, QDistinct> distinctByIndex() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'index');
    });
  }

  QueryBuilder<Module, Module, QDistinct> distinctByLastUsed() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastUsed');
    });
  }

  QueryBuilder<Module, Module, QDistinct> distinctByPreviewFilepath(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'previewFilepath',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Module, Module, QDistinct> distinctByProgress() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'progress');
    });
  }

  QueryBuilder<Module, Module, QDistinct> distinctBySection() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'section');
    });
  }

  QueryBuilder<Module, Module, QDistinct> distinctByTitle(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'title', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Module, Module, QDistinct> distinctByType(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'type', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Module, Module, QDistinct> distinctByUniversityId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'universityId');
    });
  }

  QueryBuilder<Module, Module, QDistinct> distinctByUrl(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'url', caseSensitive: caseSensitive);
    });
  }
}

extension ModuleQueryProperty on QueryBuilder<Module, Module, QQueryProperty> {
  QueryBuilder<Module, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<Module, String?, QQueryOperations> descriptionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'description');
    });
  }

  QueryBuilder<Module, double?, QQueryOperations> downloadProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'download');
    });
  }

  QueryBuilder<Module, DateTime?, QQueryOperations> favoritedSinceProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'favoritedSince');
    });
  }

  QueryBuilder<Module, String?, QQueryOperations> filepathProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'filepath');
    });
  }

  QueryBuilder<Module, int, QQueryOperations> indexProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'index');
    });
  }

  QueryBuilder<Module, DateTime?, QQueryOperations> lastUsedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastUsed');
    });
  }

  QueryBuilder<Module, String?, QQueryOperations> previewFilepathProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'previewFilepath');
    });
  }

  QueryBuilder<Module, double?, QQueryOperations> progressProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'progress');
    });
  }

  QueryBuilder<Module, int?, QQueryOperations> sectionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'section');
    });
  }

  QueryBuilder<Module, String, QQueryOperations> titleProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'title');
    });
  }

  QueryBuilder<Module, ModuleType, QQueryOperations> typeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'type');
    });
  }

  QueryBuilder<Module, int?, QQueryOperations> universityIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'universityId');
    });
  }

  QueryBuilder<Module, String?, QQueryOperations> urlProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'url');
    });
  }
}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetSearchableCollection on Isar {
  IsarCollection<Searchable> get searchables => this.collection();
}

const SearchableSchema = CollectionSchema(
  name: r'Searchable',
  id: 9186330909257167683,
  properties: {
    r'transcript': PropertySchema(
      id: 0,
      name: r'transcript',
      type: IsarType.string,
    ),
    r'transcriptWords': PropertySchema(
      id: 1,
      name: r'transcriptWords',
      type: IsarType.stringList,
    )
  },
  estimateSize: _searchableEstimateSize,
  serialize: _searchableSerialize,
  deserialize: _searchableDeserialize,
  deserializeProp: _searchableDeserializeProp,
  idName: r'id',
  indexes: {
    r'transcriptWords': IndexSchema(
      id: 2873836045662318586,
      name: r'transcriptWords',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'transcriptWords',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    )
  },
  links: {
    r'module': LinkSchema(
      id: -2524499017825524899,
      name: r'module',
      target: r'Module',
      single: true,
    )
  },
  embeddedSchemas: {},
  getId: _searchableGetId,
  getLinks: _searchableGetLinks,
  attach: _searchableAttach,
  version: '3.1.0+1',
);

int _searchableEstimateSize(
  Searchable object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.transcript;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.transcriptWords.length * 3;
  {
    for (var i = 0; i < object.transcriptWords.length; i++) {
      final value = object.transcriptWords[i];
      bytesCount += value.length * 3;
    }
  }
  return bytesCount;
}

void _searchableSerialize(
  Searchable object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.transcript);
  writer.writeStringList(offsets[1], object.transcriptWords);
}

Searchable _searchableDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = Searchable();
  object.id = id;
  object.transcript = reader.readStringOrNull(offsets[0]);
  return object;
}

P _searchableDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readStringOrNull(offset)) as P;
    case 1:
      return (reader.readStringList(offset) ?? []) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _searchableGetId(Searchable object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _searchableGetLinks(Searchable object) {
  return [object.module];
}

void _searchableAttach(IsarCollection<dynamic> col, Id id, Searchable object) {
  object.id = id;
  object.module.attach(col, col.isar.collection<Module>(), r'module', id);
}

extension SearchableQueryWhereSort
    on QueryBuilder<Searchable, Searchable, QWhere> {
  QueryBuilder<Searchable, Searchable, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<Searchable, Searchable, QAfterWhere>
      anyTranscriptWordsElement() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'transcriptWords'),
      );
    });
  }
}

extension SearchableQueryWhere
    on QueryBuilder<Searchable, Searchable, QWhereClause> {
  QueryBuilder<Searchable, Searchable, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<Searchable, Searchable, QAfterWhereClause> idNotEqualTo(Id id) {
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

  QueryBuilder<Searchable, Searchable, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<Searchable, Searchable, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<Searchable, Searchable, QAfterWhereClause> idBetween(
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

  QueryBuilder<Searchable, Searchable, QAfterWhereClause>
      transcriptWordsElementEqualTo(String transcriptWordsElement) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'transcriptWords',
        value: [transcriptWordsElement],
      ));
    });
  }

  QueryBuilder<Searchable, Searchable, QAfterWhereClause>
      transcriptWordsElementNotEqualTo(String transcriptWordsElement) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'transcriptWords',
              lower: [],
              upper: [transcriptWordsElement],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'transcriptWords',
              lower: [transcriptWordsElement],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'transcriptWords',
              lower: [transcriptWordsElement],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'transcriptWords',
              lower: [],
              upper: [transcriptWordsElement],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<Searchable, Searchable, QAfterWhereClause>
      transcriptWordsElementGreaterThan(
    String transcriptWordsElement, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'transcriptWords',
        lower: [transcriptWordsElement],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<Searchable, Searchable, QAfterWhereClause>
      transcriptWordsElementLessThan(
    String transcriptWordsElement, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'transcriptWords',
        lower: [],
        upper: [transcriptWordsElement],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<Searchable, Searchable, QAfterWhereClause>
      transcriptWordsElementBetween(
    String lowerTranscriptWordsElement,
    String upperTranscriptWordsElement, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'transcriptWords',
        lower: [lowerTranscriptWordsElement],
        includeLower: includeLower,
        upper: [upperTranscriptWordsElement],
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Searchable, Searchable, QAfterWhereClause>
      transcriptWordsElementStartsWith(String TranscriptWordsElementPrefix) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'transcriptWords',
        lower: [TranscriptWordsElementPrefix],
        upper: ['$TranscriptWordsElementPrefix\u{FFFFF}'],
      ));
    });
  }

  QueryBuilder<Searchable, Searchable, QAfterWhereClause>
      transcriptWordsElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'transcriptWords',
        value: [''],
      ));
    });
  }

  QueryBuilder<Searchable, Searchable, QAfterWhereClause>
      transcriptWordsElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.lessThan(
              indexName: r'transcriptWords',
              upper: [''],
            ))
            .addWhereClause(IndexWhereClause.greaterThan(
              indexName: r'transcriptWords',
              lower: [''],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.greaterThan(
              indexName: r'transcriptWords',
              lower: [''],
            ))
            .addWhereClause(IndexWhereClause.lessThan(
              indexName: r'transcriptWords',
              upper: [''],
            ));
      }
    });
  }
}

extension SearchableQueryFilter
    on QueryBuilder<Searchable, Searchable, QFilterCondition> {
  QueryBuilder<Searchable, Searchable, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Searchable, Searchable, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<Searchable, Searchable, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<Searchable, Searchable, QAfterFilterCondition> idBetween(
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

  QueryBuilder<Searchable, Searchable, QAfterFilterCondition>
      transcriptIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'transcript',
      ));
    });
  }

  QueryBuilder<Searchable, Searchable, QAfterFilterCondition>
      transcriptIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'transcript',
      ));
    });
  }

  QueryBuilder<Searchable, Searchable, QAfterFilterCondition> transcriptEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'transcript',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Searchable, Searchable, QAfterFilterCondition>
      transcriptGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'transcript',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Searchable, Searchable, QAfterFilterCondition>
      transcriptLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'transcript',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Searchable, Searchable, QAfterFilterCondition> transcriptBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'transcript',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Searchable, Searchable, QAfterFilterCondition>
      transcriptStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'transcript',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Searchable, Searchable, QAfterFilterCondition>
      transcriptEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'transcript',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Searchable, Searchable, QAfterFilterCondition>
      transcriptContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'transcript',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Searchable, Searchable, QAfterFilterCondition> transcriptMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'transcript',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Searchable, Searchable, QAfterFilterCondition>
      transcriptIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'transcript',
        value: '',
      ));
    });
  }

  QueryBuilder<Searchable, Searchable, QAfterFilterCondition>
      transcriptIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'transcript',
        value: '',
      ));
    });
  }

  QueryBuilder<Searchable, Searchable, QAfterFilterCondition>
      transcriptWordsElementEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'transcriptWords',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Searchable, Searchable, QAfterFilterCondition>
      transcriptWordsElementGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'transcriptWords',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Searchable, Searchable, QAfterFilterCondition>
      transcriptWordsElementLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'transcriptWords',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Searchable, Searchable, QAfterFilterCondition>
      transcriptWordsElementBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'transcriptWords',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Searchable, Searchable, QAfterFilterCondition>
      transcriptWordsElementStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'transcriptWords',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Searchable, Searchable, QAfterFilterCondition>
      transcriptWordsElementEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'transcriptWords',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Searchable, Searchable, QAfterFilterCondition>
      transcriptWordsElementContains(String value,
          {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'transcriptWords',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Searchable, Searchable, QAfterFilterCondition>
      transcriptWordsElementMatches(String pattern,
          {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'transcriptWords',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Searchable, Searchable, QAfterFilterCondition>
      transcriptWordsElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'transcriptWords',
        value: '',
      ));
    });
  }

  QueryBuilder<Searchable, Searchable, QAfterFilterCondition>
      transcriptWordsElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'transcriptWords',
        value: '',
      ));
    });
  }

  QueryBuilder<Searchable, Searchable, QAfterFilterCondition>
      transcriptWordsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'transcriptWords',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<Searchable, Searchable, QAfterFilterCondition>
      transcriptWordsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'transcriptWords',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<Searchable, Searchable, QAfterFilterCondition>
      transcriptWordsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'transcriptWords',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<Searchable, Searchable, QAfterFilterCondition>
      transcriptWordsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'transcriptWords',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<Searchable, Searchable, QAfterFilterCondition>
      transcriptWordsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'transcriptWords',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<Searchable, Searchable, QAfterFilterCondition>
      transcriptWordsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'transcriptWords',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }
}

extension SearchableQueryObject
    on QueryBuilder<Searchable, Searchable, QFilterCondition> {}

extension SearchableQueryLinks
    on QueryBuilder<Searchable, Searchable, QFilterCondition> {
  QueryBuilder<Searchable, Searchable, QAfterFilterCondition> module(
      FilterQuery<Module> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'module');
    });
  }

  QueryBuilder<Searchable, Searchable, QAfterFilterCondition> moduleIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'module', 0, true, 0, true);
    });
  }
}

extension SearchableQuerySortBy
    on QueryBuilder<Searchable, Searchable, QSortBy> {
  QueryBuilder<Searchable, Searchable, QAfterSortBy> sortByTranscript() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'transcript', Sort.asc);
    });
  }

  QueryBuilder<Searchable, Searchable, QAfterSortBy> sortByTranscriptDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'transcript', Sort.desc);
    });
  }
}

extension SearchableQuerySortThenBy
    on QueryBuilder<Searchable, Searchable, QSortThenBy> {
  QueryBuilder<Searchable, Searchable, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<Searchable, Searchable, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<Searchable, Searchable, QAfterSortBy> thenByTranscript() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'transcript', Sort.asc);
    });
  }

  QueryBuilder<Searchable, Searchable, QAfterSortBy> thenByTranscriptDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'transcript', Sort.desc);
    });
  }
}

extension SearchableQueryWhereDistinct
    on QueryBuilder<Searchable, Searchable, QDistinct> {
  QueryBuilder<Searchable, Searchable, QDistinct> distinctByTranscript(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'transcript', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Searchable, Searchable, QDistinct> distinctByTranscriptWords() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'transcriptWords');
    });
  }
}

extension SearchableQueryProperty
    on QueryBuilder<Searchable, Searchable, QQueryProperty> {
  QueryBuilder<Searchable, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<Searchable, String?, QQueryOperations> transcriptProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'transcript');
    });
  }

  QueryBuilder<Searchable, List<String>, QQueryOperations>
      transcriptWordsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'transcriptWords');
    });
  }
}
