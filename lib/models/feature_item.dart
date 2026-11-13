import 'package:flutter/material.dart';

class FeatureItem {
  final String id;
  final String title;
  final String subtitle;
  final String category;
  final IconData iconData;
  final bool isCompleted;
  final DateTime timestamp;

  const FeatureItem({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.category,
    required this.iconData,
    required this.isCompleted,
    required this.timestamp,
  });

  FeatureItem copyWith({
    String? id,
    String? title,
    String? subtitle,
    String? category,
    IconData? iconData,
    bool? isCompleted,
    DateTime? timestamp,
  }) {
    return FeatureItem(
      id: id ?? this.id,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      category: category ?? this.category,
      iconData: iconData ?? this.iconData,
      isCompleted: isCompleted ?? this.isCompleted,
      timestamp: timestamp ?? this.timestamp,
    );
  }
}

