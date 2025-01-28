import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import '../../application/resume_state.dart';

class CustomizationPanel extends ConsumerWidget {
  const CustomizationPanel({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final resumeState = ref.watch(resumeStateProvider);

    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Customize Resume', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),
            _buildFontSizeSlider(context, ref, resumeState),
            const SizedBox(height: 16),
            _buildColorPickers(context, ref, resumeState),
          ],
        ),
      ),
    );
  }

  Widget _buildFontSizeSlider(BuildContext context, WidgetRef ref, ResumeState state) {
    return Row(
      children: [
        const Text('Font Size: '),
        Expanded(
          child: Slider(
            value: state.fontSize,
            min: 8.0,
            max: 24.0,
            divisions: 16,
            label: state.fontSize.toStringAsFixed(1),
            onChanged: (value) {
              ref.read(resumeStateProvider.notifier).updateFontSize(value);
            },
          ),
        ),
        Text('${state.fontSize.toStringAsFixed(1)}pt'),
      ],
    );
  }

  Widget _buildColorPickers(BuildContext context, WidgetRef ref, ResumeState state) {
    return Wrap(
      spacing: 16,
      runSpacing: 16,
      children: [
        _buildColorPickerButton(
          context,
          'Font Color',
          state.fontColor,
          (color) => ref.read(resumeStateProvider.notifier).updateFontColor(color),
        ),
        _buildColorPickerButton(
          context,
          'Background Color',
          state.backgroundColor,
          (color) => ref.read(resumeStateProvider.notifier).updateBackgroundColor(color),
        ),
      ],
    );
  }

  Widget _buildColorPickerButton(
    BuildContext context,
    String label,
    Color currentColor,
    void Function(Color) onColorChanged,
  ) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        foregroundColor: currentColor.computeLuminance() > 0.5 ? Colors.black : Colors.white, backgroundColor: currentColor,
      ),
      onPressed: () => _showColorPicker(context, label, currentColor, onColorChanged),
      child: Text(label),
    );
  }

  void _showColorPicker(
    BuildContext context,
    String label,
    Color currentColor,
    void Function(Color) onColorChanged,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Pick $label'),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: currentColor,
              onColorChanged: onColorChanged,
              pickerAreaHeightPercent: 0.8,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Done'),
            ),
          ],
        );
      },
    );
  }
}

