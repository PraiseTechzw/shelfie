import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ResumeState {
  final double fontSize;
  final Color fontColor;
  final Color backgroundColor;

  ResumeState({
    this.fontSize = 12.0,
    this.fontColor = Colors.black,
    this.backgroundColor = Colors.white,
  });

  ResumeState copyWith({
    double? fontSize,
    Color? fontColor,
    Color? backgroundColor,
  }) {
    return ResumeState(
      fontSize: fontSize ?? this.fontSize,
      fontColor: fontColor ?? this.fontColor,
      backgroundColor: backgroundColor ?? this.backgroundColor,
    );
  }
}

final resumeStateProvider = StateNotifierProvider<ResumeStateNotifier, ResumeState>((ref) {
  return ResumeStateNotifier();
});

class ResumeStateNotifier extends StateNotifier<ResumeState> {
  ResumeStateNotifier() : super(ResumeState());

  void updateFontSize(double size) {
    state = state.copyWith(fontSize: size);
  }

  void updateFontColor(Color color) {
    state = state.copyWith(fontColor: color);
  }

  void updateBackgroundColor(Color color) {
    state = state.copyWith(backgroundColor: color);
  }
}

