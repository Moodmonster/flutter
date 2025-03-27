// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'webtoon_paragraph.model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$WebtoonParagraph {

 List<String> get imgList; String get music_url;
/// Create a copy of WebtoonParagraph
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WebtoonParagraphCopyWith<WebtoonParagraph> get copyWith => _$WebtoonParagraphCopyWithImpl<WebtoonParagraph>(this as WebtoonParagraph, _$identity);

  /// Serializes this WebtoonParagraph to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WebtoonParagraph&&const DeepCollectionEquality().equals(other.imgList, imgList)&&(identical(other.music_url, music_url) || other.music_url == music_url));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(imgList),music_url);

@override
String toString() {
  return 'WebtoonParagraph(imgList: $imgList, music_url: $music_url)';
}


}

/// @nodoc
abstract mixin class $WebtoonParagraphCopyWith<$Res>  {
  factory $WebtoonParagraphCopyWith(WebtoonParagraph value, $Res Function(WebtoonParagraph) _then) = _$WebtoonParagraphCopyWithImpl;
@useResult
$Res call({
 List<String> imgList, String music_url
});




}
/// @nodoc
class _$WebtoonParagraphCopyWithImpl<$Res>
    implements $WebtoonParagraphCopyWith<$Res> {
  _$WebtoonParagraphCopyWithImpl(this._self, this._then);

  final WebtoonParagraph _self;
  final $Res Function(WebtoonParagraph) _then;

/// Create a copy of WebtoonParagraph
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? imgList = null,Object? music_url = null,}) {
  return _then(_self.copyWith(
imgList: null == imgList ? _self.imgList : imgList // ignore: cast_nullable_to_non_nullable
as List<String>,music_url: null == music_url ? _self.music_url : music_url // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// @nodoc
@JsonSerializable()

class _WebtoonParagraph implements WebtoonParagraph {
   _WebtoonParagraph({required final  List<String> imgList, required this.music_url}): _imgList = imgList;
  factory _WebtoonParagraph.fromJson(Map<String, dynamic> json) => _$WebtoonParagraphFromJson(json);

 final  List<String> _imgList;
@override List<String> get imgList {
  if (_imgList is EqualUnmodifiableListView) return _imgList;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_imgList);
}

@override final  String music_url;

/// Create a copy of WebtoonParagraph
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WebtoonParagraphCopyWith<_WebtoonParagraph> get copyWith => __$WebtoonParagraphCopyWithImpl<_WebtoonParagraph>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WebtoonParagraphToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WebtoonParagraph&&const DeepCollectionEquality().equals(other._imgList, _imgList)&&(identical(other.music_url, music_url) || other.music_url == music_url));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_imgList),music_url);

@override
String toString() {
  return 'WebtoonParagraph(imgList: $imgList, music_url: $music_url)';
}


}

/// @nodoc
abstract mixin class _$WebtoonParagraphCopyWith<$Res> implements $WebtoonParagraphCopyWith<$Res> {
  factory _$WebtoonParagraphCopyWith(_WebtoonParagraph value, $Res Function(_WebtoonParagraph) _then) = __$WebtoonParagraphCopyWithImpl;
@override @useResult
$Res call({
 List<String> imgList, String music_url
});




}
/// @nodoc
class __$WebtoonParagraphCopyWithImpl<$Res>
    implements _$WebtoonParagraphCopyWith<$Res> {
  __$WebtoonParagraphCopyWithImpl(this._self, this._then);

  final _WebtoonParagraph _self;
  final $Res Function(_WebtoonParagraph) _then;

/// Create a copy of WebtoonParagraph
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? imgList = null,Object? music_url = null,}) {
  return _then(_WebtoonParagraph(
imgList: null == imgList ? _self._imgList : imgList // ignore: cast_nullable_to_non_nullable
as List<String>,music_url: null == music_url ? _self.music_url : music_url // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
