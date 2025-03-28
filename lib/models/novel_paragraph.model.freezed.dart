// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'novel_paragraph.model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$NovelParagraph {

 String get text; String get music_url;
/// Create a copy of NovelParagraph
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NovelParagraphCopyWith<NovelParagraph> get copyWith => _$NovelParagraphCopyWithImpl<NovelParagraph>(this as NovelParagraph, _$identity);

  /// Serializes this NovelParagraph to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NovelParagraph&&(identical(other.text, text) || other.text == text)&&(identical(other.music_url, music_url) || other.music_url == music_url));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,text,music_url);

@override
String toString() {
  return 'NovelParagraph(text: $text, music_url: $music_url)';
}


}

/// @nodoc
abstract mixin class $NovelParagraphCopyWith<$Res>  {
  factory $NovelParagraphCopyWith(NovelParagraph value, $Res Function(NovelParagraph) _then) = _$NovelParagraphCopyWithImpl;
@useResult
$Res call({
 String text, String music_url
});




}
/// @nodoc
class _$NovelParagraphCopyWithImpl<$Res>
    implements $NovelParagraphCopyWith<$Res> {
  _$NovelParagraphCopyWithImpl(this._self, this._then);

  final NovelParagraph _self;
  final $Res Function(NovelParagraph) _then;

/// Create a copy of NovelParagraph
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? text = null,Object? music_url = null,}) {
  return _then(_self.copyWith(
text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,music_url: null == music_url ? _self.music_url : music_url // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// @nodoc
@JsonSerializable()

class _NovelParagraph implements NovelParagraph {
   _NovelParagraph({required this.text, required this.music_url});
  factory _NovelParagraph.fromJson(Map<String, dynamic> json) => _$NovelParagraphFromJson(json);

@override final  String text;
@override final  String music_url;

/// Create a copy of NovelParagraph
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NovelParagraphCopyWith<_NovelParagraph> get copyWith => __$NovelParagraphCopyWithImpl<_NovelParagraph>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$NovelParagraphToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _NovelParagraph&&(identical(other.text, text) || other.text == text)&&(identical(other.music_url, music_url) || other.music_url == music_url));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,text,music_url);

@override
String toString() {
  return 'NovelParagraph(text: $text, music_url: $music_url)';
}


}

/// @nodoc
abstract mixin class _$NovelParagraphCopyWith<$Res> implements $NovelParagraphCopyWith<$Res> {
  factory _$NovelParagraphCopyWith(_NovelParagraph value, $Res Function(_NovelParagraph) _then) = __$NovelParagraphCopyWithImpl;
@override @useResult
$Res call({
 String text, String music_url
});




}
/// @nodoc
class __$NovelParagraphCopyWithImpl<$Res>
    implements _$NovelParagraphCopyWith<$Res> {
  __$NovelParagraphCopyWithImpl(this._self, this._then);

  final _NovelParagraph _self;
  final $Res Function(_NovelParagraph) _then;

/// Create a copy of NovelParagraph
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? text = null,Object? music_url = null,}) {
  return _then(_NovelParagraph(
text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,music_url: null == music_url ? _self.music_url : music_url // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
