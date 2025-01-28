import 'dart:ui';
import 'package:flutter/painting.dart';
import 'package:pdf/pdf.dart';
import 'dart:typed_data';
import 'package:pdf/widgets.dart' as pw;
import 'package:flutter/material.dart' show Color, Size;
import '../../../core/constants/resume_data.dart';

Future<Uint8List> generateResume(
  PdfPageFormat format,
  double fontSize,
  Color fontColor,
  Color backgroundColor,
) async {
  final pdf = pw.Document();

  final pdfFontColor = PdfColor(
    fontColor.red / 255,
    fontColor.green / 255,
    fontColor.blue / 255,
  );



  final mintGreen = PdfColor(0.596, 0.886, 0.835);

  pdf.addPage(
    pw.MultiPage(
      pageFormat: format,
      build: (pw.Context context) {
        return [
          pw.Stack(
            children: [
              // Background geometric shape
              pw.Positioned(
                top: 0,
                left: 0,
                child: pw.Container(
                  width: 200,
                  height: 200,
                  child: pw.CustomPaint(
                    painter: (pw.PdfGraphics graphics, pw.Size size) {
                      graphics
                        ..setColor(mintGreen)
                        ..moveTo(0, 0)
                        ..lineTo(size.width, 0)
                        ..lineTo(0, size.height)
                        ..fillPath();
                    },
                  ),
                ),
              ),
              // Main content
              pw.Container(
                padding: const pw.EdgeInsets.all(30),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    _buildHeader(fontSize, pdfFontColor, mintGreen),
                    _buildSection(
                      'Career Objective',
                      fontSize,
                      pdfFontColor,
                      mintGreen,
                      content: ResumeData.careerObjective,
                    ),
                    _buildEducationSection(fontSize, pdfFontColor, mintGreen),
                    _buildWorkExperience(fontSize, pdfFontColor, mintGreen),
                    _buildProjectsSection(fontSize, pdfFontColor, mintGreen),
                    _buildSkillsSection(fontSize, pdfFontColor, mintGreen),
                    _buildCertificationsSection(fontSize, pdfFontColor, mintGreen),
                    _buildAchievementsSection(fontSize, pdfFontColor, mintGreen),
                    _buildInterestsSection(fontSize, pdfFontColor, mintGreen),
                    _buildReferencesSection(fontSize, pdfFontColor, mintGreen),
                  ],
                ),
              ),
            ],
          ),
        ];
      },
    ),
  );

  return pdf.save();
}

pw.Widget _buildHeader(double fontSize, PdfColor textColor, PdfColor accentColor) {
  return pw.Row(
    crossAxisAlignment: pw.CrossAxisAlignment.start,
    children: [
      pw.Expanded(
        flex: 3,
        child: pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(
              ResumeData.personalInfo['name']!,
              style: pw.TextStyle(
                fontSize: fontSize * 2,
                color: textColor,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
            pw.SizedBox(height: 5),
            pw.Text(
              ResumeData.personalInfo['title']!,
              style: pw.TextStyle(
                fontSize: fontSize * 1.2,
                color: accentColor,
              ),
            ),
            pw.SizedBox(height: 10),
            _buildContactInfo(fontSize, textColor, accentColor),
          ],
        ),
      ),
      pw.SizedBox(width: 20),
      pw.Container(
        width: 100,
        height: 100,
        decoration: pw.BoxDecoration(
          shape: pw.BoxShape.circle,
          color: PdfColor(
            (accentColor.red + 1.0) / 2,
            (accentColor.green + 1.0) / 2,
            (accentColor.blue + 1.0) / 2,
          ),
        ),
      ),
    ],
  );
}

pw.Widget _buildContactInfo(double fontSize, PdfColor textColor, PdfColor accentColor) {
  return pw.Column(
    crossAxisAlignment: pw.CrossAxisAlignment.start,
    children: [
      _buildContactItem(fontSize, textColor, ResumeData.personalInfo['address']!),
      _buildContactItem(fontSize, textColor, ResumeData.personalInfo['phone']!),
      _buildContactItem(fontSize, accentColor, ResumeData.personalInfo['email']!, underline: true),
      _buildContactItem(fontSize, accentColor, ResumeData.personalInfo['linkedin']!, underline: true),
      _buildContactItem(fontSize, accentColor, ResumeData.personalInfo['portfolio']!, underline: true),
    ],
  );
}

pw.Widget _buildContactItem(double fontSize, PdfColor color, String text, {bool underline = false}) {
  return pw.Text(
    text,
    style: pw.TextStyle(
      fontSize: fontSize,
      color: color,
      decoration: underline ? pw.TextDecoration.underline : null,
    ),
  );
}

pw.Widget _buildSection(String title, double fontSize, PdfColor textColor, PdfColor accentColor, {String? content}) {
  return pw.Container(
    margin: const pw.EdgeInsets.symmetric(vertical: 10),
    child: pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          title,
          style: pw.TextStyle(
            fontSize: fontSize * 1.5,
            color: accentColor,
            fontWeight: pw.FontWeight.bold,
          ),
        ),
        pw.SizedBox(height: 10),
        if (content != null)
          pw.Text(
            content,
            style: pw.TextStyle(fontSize: fontSize, color: textColor),
          ),
      ],
    ),
  );
}

pw.Widget _buildEducationSection(double fontSize, PdfColor textColor, PdfColor accentColor) {
  return pw.Container(
    margin: const pw.EdgeInsets.symmetric(vertical: 10),
    child: pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'Education',
          style: pw.TextStyle(
            fontSize: fontSize * 1.5,
            color: accentColor,
            fontWeight: pw.FontWeight.bold,
          ),
        ),
        pw.SizedBox(height: 10),
        ...ResumeData.education.map((edu) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(
              edu['degree'] as String,
              style: pw.TextStyle(
                fontSize: fontSize * 1.2,
                color: textColor,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
            pw.Text(
              '${edu['institution']} | ${edu['period']}',
              style: pw.TextStyle(
                fontSize: fontSize,
                color: textColor,
                fontStyle: pw.FontStyle.italic,
              ),
            ),
            pw.SizedBox(height: 5),
            pw.Text(
              'Key Coursework:',
              style: pw.TextStyle(
                fontSize: fontSize,
                color: textColor,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
            ...(edu['coursework'] as List).map((course) => pw.Padding(
              padding: const pw.EdgeInsets.only(left: 10),
              child: pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Container(
                    width: 4,
                    height: 4,
                    margin: const pw.EdgeInsets.only(top: 6, right: 5),
                    decoration: pw.BoxDecoration(
                      color: accentColor,
                      shape: pw.BoxShape.circle,
                    ),
                  ),
                  pw.Expanded(
                    child: pw.Text(
                      course,
                      style: pw.TextStyle(fontSize: fontSize, color: textColor),
                    ),
                  ),
                ],
              ),
            )),
            pw.SizedBox(height: 10),
          ],
        )),
      ],
    ),
  );
}

pw.Widget _buildWorkExperience(double fontSize, PdfColor textColor, PdfColor accentColor) {
  return pw.Container(
    margin: const pw.EdgeInsets.symmetric(vertical: 10),
    child: pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'Work Experience',
          style: pw.TextStyle(
            fontSize: fontSize * 1.5,
            color: accentColor,
            fontWeight: pw.FontWeight.bold,
          ),
        ),
        pw.SizedBox(height: 10),
        ...ResumeData.workExperience.map((exp) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(
              exp['title'] as String,
              style: pw.TextStyle(
                fontSize: fontSize * 1.2,
                color: textColor,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
            pw.Text(
              '${exp['company']} | ${exp['period']}',
              style: pw.TextStyle(
                fontSize: fontSize,
                color: textColor,
                fontStyle: pw.FontStyle.italic,
              ),
            ),
            pw.SizedBox(height: 5),
            ...(exp['responsibilities'] as List).map((resp) => pw.Padding(
              padding: const pw.EdgeInsets.only(left: 10),
              child: pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Container(
                    width: 4,
                    height: 4,
                    margin: const pw.EdgeInsets.only(top: 6, right: 5),
                    decoration: pw.BoxDecoration(
                      color: accentColor,
                      shape: pw.BoxShape.circle,
                    ),
                  ),
                  pw.Expanded(
                    child: pw.Text(
                      resp,
                      style: pw.TextStyle(fontSize: fontSize, color: textColor),
                    ),
                  ),
                ],
              ),
            )),
            pw.SizedBox(height: 10),
          ],
        )),
      ],
    ),
  );
}

pw.Widget _buildProjectsSection(double fontSize, PdfColor textColor, PdfColor accentColor) {
  return pw.Container(
    margin: const pw.EdgeInsets.symmetric(vertical: 10),
    child: pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'Projects',
          style: pw.TextStyle(
            fontSize: fontSize * 1.5,
            color: accentColor,
            fontWeight: pw.FontWeight.bold,
          ),
        ),
        pw.SizedBox(height: 10),
        ...ResumeData.projects.map((project) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(
              '${project['name']} (${project['type']})',
              style: pw.TextStyle(
                fontSize: fontSize * 1.2,
                color: textColor,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
            pw.Text(
              project['description'] as String,
              style: pw.TextStyle(fontSize: fontSize, color: textColor),
            ),
            pw.SizedBox(height: 5),
            ...(project['features'] as List).map((feature) => pw.Padding(
              padding: const pw.EdgeInsets.only(left: 10),
              child: pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Container(
                    width: 4,
                    height: 4,
                    margin: const pw.EdgeInsets.only(top: 6, right: 5),
                    decoration: pw.BoxDecoration(
                      color: accentColor,
                      shape: pw.BoxShape.circle,
                    ),
                  ),
                  pw.Expanded(
                    child: pw.Text(
                      feature,
                      style: pw.TextStyle(fontSize: fontSize, color: textColor),
                    ),
                  ),
                ],
              ),
            )),
            pw.SizedBox(height: 10),
          ],
        )),
      ],
    ),
  );
}

pw.Widget _buildSkillsSection(double fontSize, PdfColor textColor, PdfColor accentColor) {
  return pw.Container(
    margin: const pw.EdgeInsets.symmetric(vertical: 10),
    child: pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'Skills',
          style: pw.TextStyle(
            fontSize: fontSize * 1.5,
            color: accentColor,
            fontWeight: pw.FontWeight.bold,
          ),
        ),
        pw.SizedBox(height: 10),
        ...ResumeData.skills.entries.map((entry) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(
              entry.key,
              style: pw.TextStyle(
                fontSize: fontSize * 1.1,
                color: textColor,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
            pw.SizedBox(height: 5),
            pw.Wrap(
              spacing: 5,
              runSpacing: 5,
              children: entry.value.map((skill) => pw.Container(
                padding: const pw.EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: pw.BoxDecoration(
                  color: PdfColor(
                    (accentColor.red + 1.0) / 2,
                    (accentColor.green + 1.0) / 2,
                    (accentColor.blue + 1.0)                  borderRadius: pw.BorderRadius.circular(10),
                ),
                child: pw.Text(
                  skill,
                  style: pw.TextStyle(fontSize: fontSize * 0.9, color: textColor),
                ),
              )).toList(),
            ),
            pw.SizedBox(height: 10),
          ],
        )),
      ],
    ),
  );
}

pw.Widget _buildCertificationsSection(double fontSize, PdfColor textColor, PdfColor accentColor) {
  return pw.Container(
    margin: const pw.EdgeInsets.symmetric(vertical: 10),
    child: pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'Certifications',
          style: pw.TextStyle(
            fontSize: fontSize * 1.5,
            color: accentColor,
            fontWeight: pw.FontWeight.bold,
          ),
        ),
        pw.SizedBox(height: 10),
        ...ResumeData.certifications.map((cert) => pw.Padding(
          padding: const pw.EdgeInsets.only(left: 10, bottom: 5),
          child: pw.Row(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Container(
                width: 4,
                height: 4,
                margin: const pw.EdgeInsets.only(top: 6, right: 5),
                decoration: pw.BoxDecoration(
                  color: accentColor,
                  shape: pw.BoxShape.circle,
                ),
              ),
              pw.Expanded(
                child: pw.Text(
                  cert,
                  style: pw.TextStyle(fontSize: fontSize, color: textColor),
                ),
              ),
            ],
          ),
        )),
      ],
    ),
  );
}

pw.Widget _buildAchievementsSection(double fontSize, PdfColor textColor, PdfColor accentColor) {
  return pw.Container(
    margin: const pw.EdgeInsets.symmetric(vertical: 10),
    child: pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'Achievements',
          style: pw.TextStyle(
            fontSize: fontSize * 1.5,
            color: accentColor,
            fontWeight: pw.FontWeight.bold,
          ),
        ),
        pw.SizedBox(height: 10),
        ...ResumeData.achievements.map((achievement) => pw.Padding(
          padding: const pw.EdgeInsets.only(left: 10, bottom: 5),
          child: pw.Row(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Container(
                width: 4,
                height: 4,
                margin: const pw.EdgeInsets.only(top: 6, right: 5),
                decoration: pw.BoxDecoration(
                  color: accentColor,
                  shape: pw.BoxShape.circle,
                ),
              ),
              pw.Expanded(
                child: pw.Text(
                  achievement,
                  style: pw.TextStyle(fontSize: fontSize, color: textColor),
                ),
              ),
            ],
          ),
        )),
      ],
    ),
  );
}

pw.Widget _buildInterestsSection(double fontSize, PdfColor textColor, PdfColor accentColor) {
  return pw.Container(
    margin: const pw.EdgeInsets.symmetric(vertical: 10),
    child: pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'Interests',
          style: pw.TextStyle(
            fontSize: fontSize * 1.5,
            color: accentColor,
            fontWeight: pw.FontWeight.bold,
          ),
        ),
        pw.SizedBox(height: 10),
        ...ResumeData.interests.map((interest) => pw.Padding(
          padding: const pw.EdgeInsets.only(left: 10, bottom: 5),
          child: pw.Row(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Container(
                width: 4,
                height: 4,
                margin: const pw.EdgeInsets.only(top: 6, right: 5),
                decoration: pw.BoxDecoration(
                  color: accentColor,
                  shape: pw.BoxShape.circle,
                ),
              ),
              pw.Expanded(
                child: pw.Text(
                  interest,
                  style: pw.TextStyle(fontSize: fontSize, color: textColor),
                ),
              ),
            ],
          ),
        )),
      ],
    ),
  );
}

pw.Widget _buildReferencesSection(double fontSize, PdfColor textColor, PdfColor accentColor) {
  return pw.Container(
    margin: const pw.EdgeInsets.symmetric(vertical: 10),
    child: pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'References',
          style: pw.TextStyle(
            fontSize: fontSize * 1.5,
            color: accentColor,
            fontWeight: pw.FontWeight.bold,
          ),
        ),
        pw.SizedBox(height: 10),
        ...ResumeData.references.map((ref) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(
              ref['name']!,
              style: pw.TextStyle(
                fontSize: fontSize * 1.1,
                color: textColor,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
            pw.Text(
              '${ref['title']}, ${ref['institution']}',
              style: pw.TextStyle(fontSize: fontSize, color: textColor),
            ),
            pw.Text(
              'Contact: ${ref['contact']}',
              style: pw.TextStyle(fontSize: fontSize, color: textColor),
            ),
            pw.SizedBox(height: 10),
          ],
        )),
      ],
    ),
  );
}

