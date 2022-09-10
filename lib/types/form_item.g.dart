// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'form_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FormItem _$FormItemFromJson(Map<String, dynamic> json) => FormItem(
      type: json['type'] as String?,
      options: (json['options'] as List<dynamic>?)?.map((e) => e as String),
      spamFilter:
          (json['spamFilter'] as List<dynamic>?)?.map((e) => e as String),
      label: json['label'] as String?,
      placeholder: json['placeholder'] as String?,
      helpText: json['helpText'] as String?,
      position: json['position'] as int?,
      id: json['id'] as int?,
      isRequired: json['isRequired'] as bool?,
      isFromAddress: json['isFromAddress'] as bool?,
      isSubject: json['isSubject'] as bool?,
    );

Map<String, dynamic> _$FormItemToJson(FormItem instance) => <String, dynamic>{
      'type': instance.type,
      'options': instance.options?.toList(),
      'spamFilter': instance.spamFilter?.toList(),
      'label': instance.label,
      'placeholder': instance.placeholder,
      'helpText': instance.helpText,
      'position': instance.position,
      'id': instance.id,
      'isRequired': instance.isRequired,
      'isFromAddress': instance.isFromAddress,
      'isSubject': instance.isSubject,
    };
