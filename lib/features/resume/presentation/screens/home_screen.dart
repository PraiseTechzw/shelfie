import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:printing/printing.dart';
import '../widgets/customization_panel.dart';
import '../../application/resume_generator.dart';
import '../../application/resume_state.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final resumeState = ref.watch(resumeStateProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Resume Generator'),
        centerTitle: true,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth > 600) {
            return Row(
              children: [
                SizedBox(
                  width: 300,
                  child: SingleChildScrollView(
                    child: CustomizationPanel(),
                  ),
                ),
                Expanded(
                  child: _buildPdfPreview(resumeState),
                ),
              ],
            );
          } else {
            return Column(
              children: [
                CustomizationPanel(),
                Expanded(
                  child: _buildPdfPreview(resumeState),
                ),
              ],
            );
          }
        },
      ),
    );
  }

  Widget _buildPdfPreview(ResumeState resumeState) {
    return PdfPreview(
      build: (format) => generateResume(
        format,
        resumeState.fontSize,
        resumeState.fontColor,
        resumeState.backgroundColor,
      ),
      allowPrinting: true,
      allowSharing: true,
      canChangeOrientation: false,
      canChangePageFormat: false,
      maxPageWidth: 700,
    );
  }
}

