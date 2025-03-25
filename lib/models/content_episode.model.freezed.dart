// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'content_episode.model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ContentEpisode {

 String get code; String get contentCode;//해당 에피소드가 속해있는 웹툰의 고유 코드
 String get epTitle; DateTime get uploadDate;//업로드된 날짜
 String get thumbnailUrl;
/// Create a copy of ContentEpisode
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ContentEpisodeCopyWith<ContentEpisode> get copyWith => _$ContentEpisodeCopyWithImpl<ContentEpisode>(this as ContentEpisode, _$identity);

  /// Serializes this ContentEpisode to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ContentEpisode&&(identical(other.code, code) || other.code == code)&&(identical(other.contentCode, contentCode) || other.contentCode == contentCode)&&(identical(other.epTitle, epTitle) || other.epTitle == epTitle)&&(identical(other.uploadDate, uploadDate) || other.uploadDate == uploadDate)&&(identical(other.thumbnailUrl, thumbnailUrl) || other.thumbnailUrl == thumbnailUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,code,contentCode,epTitle,uploadDate,thumbnailUrl);

@override
String toString() {
  return 'ContentEpisode(code: $code, contentCode: $contentCode, epTitle: $epTitle, uploadDate: $uploadDate, thumbnailUrl: $thumbnailUrl)';
}


}

/// @nodoc
abstract mixin class $ContentEpisodeCopyWith<$Res>  {
  factory $ContentEpisodeCopyWith(ContentEpisode value, $Res Function(ContentEpisode) _then) = _$ContentEpisodeCopyWithImpl;
@useResult
$Res call({
 String code, String contentCode, String epTitle, DateTime uploadDate, String thumbnailUrl
});




}
/// @nodoc
class _$ContentEpisodeCopyWithImpl<$Res>
    implements $ContentEpisodeCopyWith<$Res> {
  _$ContentEpisodeCopyWithImpl(this._self, this._then);

  final ContentEpisode _self;
  final $Res Function(ContentEpisode) _then;

/// Create a copy of ContentEpisode
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? code = null,Object? contentCode = null,Object? epTitle = null,Object? uploadDate = null,Object? thumbnailUrl = null,}) {
  return _then(_self.copyWith(
code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,contentCode: null == contentCode ? _self.contentCode : contentCode // ignore: cast_nullable_to_non_nullable
as String,epTitle: null == epTitle ? _self.epTitle : epTitle // ignore: cast_nullable_to_non_nullable
as String,uploadDate: null == uploadDate ? _self.uploadDate : uploadDate // ignore: cast_nullable_to_non_nullable
as DateTime,thumbnailUrl: null == thumbnailUrl ? _self.thumbnailUrl : thumbnailUrl // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// @nodoc
@JsonSerializable()

class _ContentEpisode implements ContentEpisode {
   _ContentEpisode({required this.code, required this.contentCode, required this.epTitle, required this.uploadDate, required this.thumbnailUrl});
  factory _ContentEpisode.fromJson(Map<String, dynamic> json) => _$ContentEpisodeFromJson(json);

@override final  String code;
@override final  String contentCode;
//해당 에피소드가 속해있는 웹툰의 고유 코드
@override final  String epTitle;
@override final  DateTime uploadDate;
//업로드된 날짜
@override final  String thumbnailUrl;

/// Create a copy of ContentEpisode
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ContentEpisodeCopyWith<_ContentEpisode> get copyWith => __$ContentEpisodeCopyWithImpl<_ContentEpisode>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ContentEpisodeToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ContentEpisode&&(identical(other.code, code) || other.code == code)&&(identical(other.contentCode, contentCode) || other.contentCode == contentCode)&&(identical(other.epTitle, epTitle) || other.epTitle == epTitle)&&(identical(other.uploadDate, uploadDate) || other.uploadDate == uploadDate)&&(identical(other.thumbnailUrl, thumbnailUrl) || other.thumbnailUrl == thumbnailUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,code,contentCode,epTitle,uploadDate,thumbnailUrl);

@override
String toString() {
  return 'ContentEpisode(code: $code, contentCode: $contentCode, epTitle: $epTitle, uploadDate: $uploadDate, thumbnailUrl: $thumbnailUrl)';
}


}

/// @nodoc
abstract mixin class _$ContentEpisodeCopyWith<$Res> implements $ContentEpisodeCopyWith<$Res> {
  factory _$ContentEpisodeCopyWith(_ContentEpisode value, $Res Function(_ContentEpisode) _then) = __$ContentEpisodeCopyWithImpl;
@override @useResult
$Res call({
 String code, String contentCode, String epTitle, DateTime uploadDate, String thumbnailUrl
});




}
/// @nodoc
class __$ContentEpisodeCopyWithImpl<$Res>
    implements _$ContentEpisodeCopyWith<$Res> {
  __$ContentEpisodeCopyWithImpl(this._self, this._then);

  final _ContentEpisode _self;
  final $Res Function(_ContentEpisode) _then;

/// Create a copy of ContentEpisode
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? code = null,Object? contentCode = null,Object? epTitle = null,Object? uploadDate = null,Object? thumbnailUrl = null,}) {
  return _then(_ContentEpisode(
code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,contentCode: null == contentCode ? _self.contentCode : contentCode // ignore: cast_nullable_to_non_nullable
as String,epTitle: null == epTitle ? _self.epTitle : epTitle // ignore: cast_nullable_to_non_nullable
as String,uploadDate: null == uploadDate ? _self.uploadDate : uploadDate // ignore: cast_nullable_to_non_nullable
as DateTime,thumbnailUrl: null == thumbnailUrl ? _self.thumbnailUrl : thumbnailUrl // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on