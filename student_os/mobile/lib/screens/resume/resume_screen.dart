import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../models/resume.dart';
import '../../providers/auth_provider.dart';
import '../../services/resume_service.dart';
import '../../widgets/app_bottom_sheet.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_card.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/error_state.dart';
import '../../widgets/loading_widget.dart';

class ResumeScreen extends StatefulWidget {
  const ResumeScreen({super.key});

  @override
  State<ResumeScreen> createState() => _ResumeScreenState();
}

class _ResumeScreenState extends State<ResumeScreen> {
  Resume? _resume;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchResume();
  }

  Future<void> _fetchResume() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    final res = await ResumeService.getResume();
    if (res.success && res.data != null) {
      setState(() {
        _resume = res.data!;
        _isLoading = false;
      });
    } else {
      setState(() {
        _error = res.message ?? 'Failed to load resume';
        _isLoading = false;
      });
    }
  }

  Future<Uint8List> _generatePdfDoc(Resume resume, String name, String email, String phone) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // Header
              pw.Text(
                name.toUpperCase(),
                style: const pw.TextStyle(fontSize: 22, fontWeight: pw.FontWeight.bold, color: PdfColors.indigo900),
              ),
              pw.SizedBox(height: 4),
              pw.Text(
                '$email  |  $phone  |  ATTENT-IN Verified Portfolio',
                style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey700),
              ),
              pw.Divider(thickness: 1.5, color: PdfColors.indigo900),
              pw.SizedBox(height: 8),

              // Objective
              if (resume.objective != null) ...[
                pw.Text('CAREER OBJECTIVE', style: const pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold, color: PdfColors.indigo900)),
                pw.SizedBox(height: 4),
                pw.Text(resume.objective!, style: const pw.TextStyle(fontSize: 9.5, height: 1.3)),
                pw.SizedBox(height: 10),
              ],

              // Education
              if (resume.education.isNotEmpty) ...[
                pw.Text('EDUCATION', style: const pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold, color: PdfColors.indigo900)),
                pw.SizedBox(height: 4),
                ...resume.education.map((e) => pw.Padding(
                  padding: const pw.EdgeInsets.only(bottom: 4),
                  child: pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Text(e.degree, style: const pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold)),
                          pw.Text(e.institution, style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey700)),
                        ],
                      ),
                      pw.Text('${e.year}  (${e.gpa})', style: const pw.TextStyle(fontSize: 9)),
                    ],
                  ),
                )),
                pw.SizedBox(height: 10),
              ],

              // Technical Skills
              if (resume.skills.isNotEmpty) ...[
                pw.Text('TECHNICAL SKILLS', style: const pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold, color: PdfColors.indigo900)),
                pw.SizedBox(height: 4),
                pw.Text(resume.skills, style: const pw.TextStyle(fontSize: 9.5)),
                pw.SizedBox(height: 10),
              ],

              // Projects
              if (resume.projects.isNotEmpty) ...[
                pw.Text('KEY PROJECTS', style: const pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold, color: PdfColors.indigo900)),
                pw.SizedBox(height: 4),
                ...resume.projects.map((p) => pw.Padding(
                  padding: const pw.EdgeInsets.only(bottom: 6),
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text('${p.title}  [${p.tech}]', style: const pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold)),
                      pw.Text(p.description, style: const pw.TextStyle(fontSize: 9, height: 1.2)),
                    ],
                  ),
                )),
                pw.SizedBox(height: 10),
              ],

              // Experience
              if (resume.experience.isNotEmpty) ...[
                pw.Text('PROFESSIONAL EXPERIENCE', style: const pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold, color: PdfColors.indigo900)),
                pw.SizedBox(height: 4),
                ...resume.experience.map((exp) => pw.Padding(
                  padding: const pw.EdgeInsets.only(bottom: 6),
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          pw.Text('${exp.role} - ${exp.company}', style: const pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold)),
                          pw.Text(exp.duration, style: const pw.TextStyle(fontSize: 9)),
                        ],
                      ),
                      pw.Text(exp.description, style: const pw.TextStyle(fontSize: 9, height: 1.2)),
                    ],
                  ),
                )),
                pw.SizedBox(height: 10),
              ],

              // Certifications & Achievements
              if (resume.certifications.isNotEmpty || resume.achievements.isNotEmpty) ...[
                pw.Text('CERTIFICATIONS & HONORS', style: const pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold, color: PdfColors.indigo900)),
                pw.SizedBox(height: 4),
                ...resume.certifications.map((c) => pw.Bullet(text: c, style: const pw.TextStyle(fontSize: 9))),
                ...resume.achievements.map((a) => pw.Bullet(text: a, style: const pw.TextStyle(fontSize: 9))),
              ],
            ],
          );
        },
      ),
    );

    return pdf.save();
  }

  void _printOrExportPdf(BuildContext context) async {
    if (_resume == null) return;
    final auth = context.read<AuthProvider>();
    final name = auth.user?.profile?.fullName ?? 'Student Developer';
    final email = auth.user?.email ?? 'student@demo.com';
    final phone = auth.user?.profile?.phone ?? '+91 98765 43210';

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) => _generatePdfDoc(_resume!, name, email, phone),
    );
  }

  void _openEditObjectiveSheet(BuildContext context) {
    if (_resume == null) return;
    final objCtrl = TextEditingController(text: _resume!.objective ?? '');

    AppBottomSheet.show(
      context,
      title: 'Career Objective',
      child: Column(
        children: [
          TextFormField(
            controller: objCtrl,
            maxLines: 4,
            style: GoogleFonts.inter(fontSize: 13),
            decoration: const InputDecoration(
              hintText: 'Describe your technical strengths, core goals, and academic focus...',
            ),
          ),
          const SizedBox(height: 16),
          AppButton(
            text: 'Save Objective',
            width: double.infinity,
            onPressed: () async {
              Navigator.of(context).pop();
              await ResumeService.updateResume(
                title: _resume!.title,
                objective: objCtrl.text.trim(),
                education: _resume!.education,
                experience: _resume!.experience,
                projects: _resume!.projects,
                skills: _resume!.skills,
                certifications: _resume!.certifications,
                achievements: _resume!.achievements,
                languages: _resume!.languages,
              );
              _fetchResume();
            },
          ),
        ],
      ),
    );
  }

  void _openEditSkillsSheet(BuildContext context) {
    if (_resume == null) return;
    final skillsCtrl = TextEditingController(text: _resume!.skills);

    AppBottomSheet.show(
      context,
      title: 'Skills & Tech Stack',
      child: Column(
        children: [
          TextFormField(
            controller: skillsCtrl,
            maxLines: 3,
            style: GoogleFonts.inter(fontSize: 13),
            decoration: const InputDecoration(
              hintText: 'Flutter, Dart, Node.js, Express, Python, SQL, Git...',
            ),
          ),
          const SizedBox(height: 16),
          AppButton(
            text: 'Save Skills',
            width: double.infinity,
            onPressed: () async {
              Navigator.of(context).pop();
              await ResumeService.updateResume(
                title: _resume!.title,
                objective: _resume!.objective,
                education: _resume!.education,
                experience: _resume!.experience,
                projects: _resume!.projects,
                skills: skillsCtrl.text.trim(),
                certifications: _resume!.certifications,
                achievements: _resume!.achievements,
                languages: _resume!.languages,
              );
              _fetchResume();
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final auth = context.watch<AuthProvider>();
    final name = auth.user?.profile?.fullName ?? 'Aarav Sharma';
    final email = auth.user?.email ?? 'student@demo.com';
    final phone = auth.user?.profile?.phone ?? '+91 98765 43210';

    return Scaffold(
      appBar: AppBar(
        title: const Text('ATS Resume Builder'),
        actions: [
          IconButton(
            icon: const Icon(Icons.picture_as_pdf_outlined),
            tooltip: 'Export & Print PDF',
            onPressed: () => _printOrExportPdf(context),
          ),
        ],
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _fetchResume,
          child: _isLoading
              ? const AppLoading(message: 'Generating live resume...')
              : _error != null && _resume == null
                  ? AppError(message: _error!, onRetry: _fetchResume)
                  : _resume == null
                      ? const AppEmptyState(
                          title: 'No Resume Data',
                          description: 'Resume details will appear here.',
                        )
                      : ListView(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                          children: [
                            // Action Buttons: Print & PDF
                            Row(
                              children: [
                                Expanded(
                                  child: AppButton(
                                    text: 'Download / Print PDF',
                                    icon: Icons.print_outlined,
                                    onPressed: () => _printOrExportPdf(context),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 16),

                            // Professional Resume Preview Paper Card
                            AppCard(
                              padding: const EdgeInsets.all(20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Resume Header
                                  Text(
                                    name,
                                    style: GoogleFonts.outfit(
                                      fontSize: 22,
                                      fontWeight: FontWeight.w800,
                                      color: isDark ? AppColors.primaryLight : AppColors.primary,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    '$email • $phone • ${_resume!.languages.isNotEmpty ? _resume!.languages : "English, Hindi"}',
                                    style: GoogleFonts.inter(
                                      fontSize: 11,
                                      color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                                    ),
                                  ),
                                  const Divider(height: 24),

                                  // Objective Section
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'CAREER OBJECTIVE',
                                        style: GoogleFonts.inter(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w800,
                                          letterSpacing: 1,
                                          color: isDark ? AppColors.primaryLight : AppColors.primary,
                                        ),
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.edit_outlined, size: 16),
                                        onPressed: () => _openEditObjectiveSheet(context),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    _resume!.objective ?? 'Passionate engineering student eager to contribute.',
                                    style: GoogleFonts.inter(fontSize: 12, height: 1.4),
                                  ),

                                  const SizedBox(height: 16),

                                  // Education Section
                                  Text(
                                    'EDUCATION',
                                    style: GoogleFonts.inter(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w800,
                                      letterSpacing: 1,
                                      color: isDark ? AppColors.primaryLight : AppColors.primary,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  ..._resume!.education.map((e) => Padding(
                                    padding: const EdgeInsets.only(bottom: 8),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(e.degree, style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.bold)),
                                            Text(e.institution, style: GoogleFonts.inter(fontSize: 11, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary)),
                                          ],
                                        ),
                                        Text('${e.year} (${e.gpa})', style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w600)),
                                      ],
                                    ),
                                  )),

                                  const SizedBox(height: 16),

                                  // Technical Skills Section
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'TECHNICAL SKILLS',
                                        style: GoogleFonts.inter(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w800,
                                          letterSpacing: 1,
                                          color: isDark ? AppColors.primaryLight : AppColors.primary,
                                        ),
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.edit_outlined, size: 16),
                                        onPressed: () => _openEditSkillsSheet(context),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    _resume!.skills,
                                    style: GoogleFonts.inter(fontSize: 12, height: 1.4),
                                  ),

                                  const SizedBox(height: 16),

                                  // Projects Section
                                  Text(
                                    'KEY PROJECTS',
                                    style: GoogleFonts.inter(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w800,
                                      letterSpacing: 1,
                                      color: isDark ? AppColors.primaryLight : AppColors.primary,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  ..._resume!.projects.map((p) => Padding(
                                    padding: const EdgeInsets.only(bottom: 8),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text('${p.title}  [${p.tech}]', style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.bold)),
                                        const SizedBox(height: 2),
                                        Text(p.description, style: GoogleFonts.inter(fontSize: 12, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary)),
                                      ],
                                    ),
                                  )),

                                  const SizedBox(height: 16),

                                  // Experience Section
                                  if (_resume!.experience.isNotEmpty) ...[
                                    Text(
                                      'EXPERIENCE',
                                      style: GoogleFonts.inter(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w800,
                                        letterSpacing: 1,
                                        color: isDark ? AppColors.primaryLight : AppColors.primary,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    ..._resume!.experience.map((exp) => Padding(
                                      padding: const EdgeInsets.only(bottom: 8),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text('${exp.role} • ${exp.company}', style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.bold)),
                                              Text(exp.duration, style: GoogleFonts.inter(fontSize: 11)),
                                            ],
                                          ),
                                          const SizedBox(height: 2),
                                          Text(exp.description, style: GoogleFonts.inter(fontSize: 12, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary)),
                                        ],
                                      ),
                                    )),
                                  ],
                                ],
                              ),
                            ),

                            const SizedBox(height: 40),
                          ],
                        ),
        ),
      ),
    );
  }
}
