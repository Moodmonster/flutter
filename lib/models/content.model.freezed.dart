// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'content.model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Content {

 int get code; String get title; String get desc; String get author; String get userId; ContentType get contentType;//웹툰인지 소설인지
 int get clickCount;//클릭수
 String get thumbnailUrl;
/// Create a copy of Content
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ContentCopyWith<Content> get copyWith => _$ContentCopyWithImpl<Content>(this as Content, _$identity);

  /// Serializes this Content to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Content&&(identical(other.code, code) || other.code == code)&&(identical(other.title, title) || other.title == title)&&(identical(other.desc, desc) || other.desc == desc)&&(identical(other.author, author) || other.author == author)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.contentType, contentType) || other.contentType == contentType)&&(identical(other.clickCount, clickCount) || other.clickCount == clickCount)&&(identical(other.thumbnailUrl, thumbnailUrl) || other.thumbnailUrl == thumbnailUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,code,title,desc,author,userId,contentType,clickCount,thumbnailUrl);

@override
String toString() {
  return 'Content(code: $code, title: $title, desc: $desc, author: $author, userId: $userId, contentType: $contentType, clickCount: $clickCount, thumbnailUrl: $thumbnailUrl)';
}


}

/// @nodoc
abstract mixin class $ContentCopyWith<$Res>  {
  factory $ContentCopyWith(Content value, $Res Function(Content) _then) = _$ContentCopyWithImpl;
@useResult
$Res call({
 int code, String title, String desc, String author, String userId, ContentType contentType, int clickCount, String thumbnailUrl
});




}
/// @nodoc
class _$ContentCopyWithImpl<$Res>
    implements $ContentCopyWith<$Res> {
  _$ContentCopyWithImpl(this._self, this._then);

  final Content _self;
  final $Res Function(Content) _then;

/// Create a copy of Content
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? code = null,Object? title = null,Object? desc = null,Object? author = null,Object? userId = null,Object? contentType = null,Object? clickCount = null,Object? thumbnailUrl = null,}) {
  return _then(_self.copyWith(
code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,desc: null == desc ? _self.desc : desc // ignore: cast_nullable_to_non_nullable
as String,author: null == author ? _self.author : author // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,contentType: null == contentType ? _self.contentType : contentType // ignore: cast_nullable_to_non_nullable
as ContentType,clickCount: null == clickCount ? _self.clickCount : clickCount // ignore: cast_nullable_to_non_nullable
as int,thumbnailUrl: null == thumbnailUrl ? _self.thumbnailUrl : thumbnailUrl // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// @nodoc
@JsonSerializable()

class _Content implements Content {
   _Content({required this.code, required this.title, required this.desc, required this.author, required this.userId, required this.contentType, required this.clickCount, required this.thumbnailUrl});
  factory _Content.fromJson(Map<String, dynamic> json) => _$ContentFromJson(json);

@override final  int code;
@override final  String title;
@override final  String desc;
@override final  String author;
@override final  String userId;
@override final  ContentType contentType;
//웹툰인지 소설인지
@override final  int clickCount;
//클릭수
@override final  String thumbnailUrl;

/// Create a copy of Content
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ContentCopyWith<_Content> get copyWith => __$ContentCopyWithImpl<_Content>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ContentToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Content&&(identical(other.code, code) || other.code == code)&&(identical(other.title, title) || other.title == title)&&(identical(other.desc, desc) || other.desc == desc)&&(identical(other.author, author) || other.author == author)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.contentType, contentType) || other.contentType == contentType)&&(identical(other.clickCount, clickCount) || other.clickCount == clickCount)&&(identical(other.thumbnailUrl, thumbnailUrl) || other.thumbnailUrl == thumbnailUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,code,title,desc,author,userId,contentType,clickCount,thumbnailUrl);

@override
String toString() {
  return 'Content(code: $code, title: $title, desc: $desc, author: $author, userId: $userId, contentType: $contentType, clickCount: $clickCount, thumbnailUrl: $thumbnailUrl)';
}


}

/// @nodoc
abstract mixin class _$ContentCopyWith<$Res> implements $ContentCopyWith<$Res> {
  factory _$ContentCopyWith(_Content value, $Res Function(_Content) _then) = __$ContentCopyWithImpl;
@override @useResult
$Res call({
 int code, String title, String desc, String author, String userId, ContentType contentType, int clickCount, String thumbnailUrl
});




}
/// @nodoc
class __$ContentCopyWithImpl<$Res>
    implements _$ContentCopyWith<$Res> {
  __$ContentCopyWithImpl(this._self, this._then);

  final _Content _self;
  final $Res Function(_Content) _then;

/// Create a copy of Content
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? code = null,Object? title = null,Object? desc = null,Object? author = null,Object? userId = null,Object? contentType = null,Object? clickCount = null,Object? thumbnailUrl = null,}) {
  return _then(_Content(
code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,desc: null == desc ? _self.desc : desc // ignore: cast_nullable_to_non_nullable
as String,author: null == author ? _self.author : author // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,contentType: null == contentType ? _self.contentType : contentType // ignore: cast_nullable_to_non_nullable
as ContentType,clickCount: null == clickCount ? _self.clickCount : clickCount // ignore: cast_nullable_to_non_nullable
as int,thumbnailUrl: null == thumbnailUrl ? _self.thumbnailUrl : thumbnailUrl // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
