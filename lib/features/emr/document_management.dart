// lib/features/emr/document_management.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/common_widgets.dart';

class DocumentManagementScreen extends StatefulWidget {
  const DocumentManagementScreen({super.key});

  @override
  State<DocumentManagementScreen> createState() => _DocumentManagementScreenState();
}

class _DocumentManagementScreenState extends State<DocumentManagementScreen> {
  String _searchQuery = '';
  String _selectedCategory = 'All';
  bool _isGridView = true;

  // Mock list of uploaded documents
  final List<Map<String, dynamic>> _documents = [
    {
      'id': 'DOC-1029',
      'title': 'Ophthalmic Refraction Report',
      'category': 'Prescription',
      'patient': 'Venkateswara Rao',
      'patientId': 'AP-V-9082',
      'date': '2026-05-28',
      'size': '1.2 MB',
      'physician': 'Dr. K. Srinivas',
      'verified': true,
      'fileType': 'PDF',
    },
    {
      'id': 'DOC-1028',
      'title': 'Fundus Photography Scan - Left Eye',
      'category': 'Diagnostic Scan',
      'patient': 'Lakshmi Devi',
      'patientId': 'AP-V-3042',
      'date': '2026-05-27',
      'size': '4.8 MB',
      'physician': 'Dr. M. Sravani',
      'verified': true,
      'fileType': 'JPG',
    },
    {
      'id': 'DOC-1027',
      'title': 'Fundus Photography Scan - Right Eye',
      'category': 'Diagnostic Scan',
      'patient': 'Lakshmi Devi',
      'patientId': 'AP-V-3042',
      'date': '2026-05-27',
      'size': '4.6 MB',
      'physician': 'Dr. M. Sravani',
      'verified': true,
      'fileType': 'JPG',
    },
    {
      'id': 'DOC-1026',
      'title': 'Tele-Ophthalmology Consultation Summary',
      'category': 'Clinical Notes',
      'patient': 'Ramanamma G.',
      'patientId': 'AP-V-8821',
      'date': '2026-05-25',
      'size': '850 KB',
      'physician': 'Dr. A. Rajesh',
      'verified': true,
      'fileType': 'PDF',
    },
    {
      'id': 'DOC-1025',
      'title': 'Glucose & Diabetic Profile Report',
      'category': 'Lab Report',
      'patient': 'Venkateswara Rao',
      'patientId': 'AP-V-9082',
      'date': '2026-05-20',
      'size': '2.1 MB',
      'physician': 'Dr. K. Srinivas',
      'verified': false,
      'fileType': 'PDF',
    },
    {
      'id': 'DOC-1024',
      'title': 'Surgical Consent Form (Cataract)',
      'category': 'Consent',
      'patient': 'Narayana Swamy',
      'patientId': 'AP-V-1209',
      'date': '2026-05-18',
      'size': '3.4 MB',
      'physician': 'Dr. K. Srinivas',
      'verified': true,
      'fileType': 'PDF',
    },
  ];

  final List<String> _categories = [
    'All',
    'Prescription',
    'Diagnostic Scan',
    'Clinical Notes',
    'Lab Report',
    'Consent',
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final filteredDocs = _documents.where((doc) {
      final matchesSearch = doc['title'].toLowerCase().contains(_searchQuery.toLowerCase()) ||
          doc['patient'].toLowerCase().contains(_searchQuery.toLowerCase()) ||
          doc['id'].toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesCategory = _selectedCategory == 'All' || doc['category'] == _selectedCategory;
      return matchesSearch && matchesCategory;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Document Management', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
            Text('AP Digital EMR Vault & Registry', style: TextStyle(fontSize: 11, color: Colors.white70)),
          ],
        ),
        backgroundColor: AppColors.superAdminColor,
        leading: const AppBarBackButton(),
        actions: [
          IconButton(
            icon: Icon(_isGridView ? Icons.view_list_rounded : Icons.grid_view_rounded),
            onPressed: () => setState(() => _isGridView = !_isGridView),
            tooltip: _isGridView ? 'Switch to List' : 'Switch to Grid',
          ),
          IconButton(
            icon: const Icon(Icons.file_upload_rounded),
            onPressed: _showUploadDialog,
            tooltip: 'Upload Document',
          ),
        ],
      ),
      body: Column(
        children: [
          // Filter & Search bar
          Container(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            color: isDark ? AppColors.darkBackground : Colors.grey[50],
            child: Column(
              children: [
                TextField(
                  onChanged: (val) => setState(() => _searchQuery = val),
                  decoration: InputDecoration(
                    hintText: 'Search documents, patient name, or ID...',
                    prefixIcon: const Icon(Icons.search_rounded),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear_rounded),
                            onPressed: () => setState(() => _searchQuery = ''),
                          )
                        : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 38,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _categories.length,
                    itemBuilder: (context, index) {
                      final cat = _categories[index];
                      final isSelected = _selectedCategory == cat;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: FilterChip(
                          label: Text(cat),
                          selected: isSelected,
                          onSelected: (selected) {
                            setState(() => _selectedCategory = cat);
                          },
                          selectedColor: AppColors.superAdminColor.withOpacity(0.2),
                          checkmarkColor: AppColors.superAdminColor,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

          // Main Documents view
          Expanded(
            child: filteredDocs.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.folder_open_rounded, size: 64, color: Colors.grey[400]),
                        const SizedBox(height: 16),
                        Text(
                          'No documents found',
                          style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Try adjusting your search filters or upload a new file.',
                          style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey[500]),
                        ),
                      ],
                    ),
                  )
                : _isGridView
                    ? GridView.builder(
                        padding: const EdgeInsets.all(16),
                        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 320,
                          mainAxisExtent: 185,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                        ),
                        itemCount: filteredDocs.length,
                        itemBuilder: (context, index) {
                          final doc = filteredDocs[index];
                          return _DocumentGridCard(
                            doc: doc,
                            onTap: () => _viewDocument(doc),
                          ).animate(delay: (index * 40).ms).fadeIn(duration: 300.ms).slideY(begin: 0.05);
                        },
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        itemCount: filteredDocs.length,
                        itemBuilder: (context, index) {
                          final doc = filteredDocs[index];
                          return Card(
                            margin: const EdgeInsets.only(bottom: 8),
                            child: ListTile(
                              leading: Container(
                                width: 44,
                                height: 44,
                                decoration: BoxDecoration(
                                  color: _getFileTypeColor(doc['fileType']).withOpacity(0.12),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Center(
                                  child: Text(
                                    doc['fileType'],
                                    style: TextStyle(
                                      fontWeight: FontWeight.w900,
                                      fontSize: 12,
                                      color: _getFileTypeColor(doc['fileType']),
                                    ),
                                  ),
                                ),
                              ),
                              title: Text(doc['title'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                              subtitle: Text(
                                '${doc['patient']} (${doc['patientId']}) • ${doc['category']}',
                                style: const TextStyle(fontSize: 12),
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  if (doc['verified'])
                                    const Tooltip(
                                      message: 'Digitally Verified',
                                      child: Icon(Icons.verified_user_rounded, color: AppColors.success, size: 18),
                                    ),
                                  const SizedBox(width: 8),
                                  Text(doc['size'], style: const TextStyle(fontSize: 11, color: Colors.grey)),
                                  IconButton(
                                    icon: const Icon(Icons.visibility_outlined, size: 20),
                                    onPressed: () => _viewDocument(doc),
                                  ),
                                ],
                              ),
                            ),
                          ).animate(delay: (index * 30).ms).fadeIn(duration: 250.ms).slideX(begin: 0.05);
                        },
                      ),
          ),
        ],
      ),
    );
  }

  Color _getFileTypeColor(String type) {
    switch (type) {
      case 'PDF':
        return Colors.red[700]!;
      case 'JPG':
      case 'PNG':
        return Colors.blue[700]!;
      case 'DOCX':
        return Colors.indigo[700]!;
      default:
        return Colors.grey[700]!;
    }
  }

  void _viewDocument(Map<String, dynamic> doc) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.85,
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                border: Border(bottom: BorderSide(color: Colors.grey[300]!, width: 0.5)),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: _getFileTypeColor(doc['fileType']).withOpacity(0.12),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      doc['fileType'],
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: _getFileTypeColor(doc['fileType']),
                        fontSize: 12,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          doc['title'],
                          style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          'ID: ${doc['id']} • Published by ${doc['physician']}',
                          style: const TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),

            // Document Content / Placeholder EMR report viewer
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Mock Document Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Image.network(
                          'https://upload.wikimedia.org/wikipedia/commons/b/bd/Emblem_of_Andhra_Pradesh.svg',
                          height: 50,
                          errorBuilder: (_, __, ___) => Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.primaryBlue.withOpacity(0.1),
                            ),
                            child: const Icon(Icons.visibility, color: AppColors.primaryBlue, size: 24),
                          ),
                        ),
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              'GOVERNMENT OF ANDHRA PRADESH',
                              style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 0.8),
                            ),
                            Text(
                              'Department of Health & Family Welfare',
                              style: TextStyle(fontSize: 9, color: Colors.grey),
                            ),
                            Text(
                              'AP DIGITAL VISION HEALTH PLATFORM',
                              style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: AppColors.primaryBlue),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const Divider(height: 32, thickness: 1),

                    // Patient Details Block
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.withOpacity(0.2)),
                      ),
                      child: GridView.count(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisCount: 2,
                        childAspectRatio: 3,
                        children: [
                          _buildReportField('Patient Name', doc['patient']),
                          _buildReportField('Patient ID / ABHA', doc['patientId']),
                          _buildReportField('Date of Issue', doc['date']),
                          _buildReportField('Issuing Authority', doc['physician']),
                          _buildReportField('Document Type', doc['category']),
                          _buildReportField('Signature Status', doc['verified'] ? 'Digitally Verified ✓' : 'Pending Signature'),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Medical Document Details Mock Content
                    Text('DOCUMENT CONTENT PREVIEW', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey[500], letterSpacing: 1)),
                    const SizedBox(height: 12),

                    if (doc['category'] == 'Prescription') ...[
                      const Text(
                        'Refraction Findings:',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        '• Right Eye (OD): SPH -1.25 | CYL -0.50 | AXIS 90 | VA 6/6\n'
                        '• Left Eye (OS): SPH -1.00 | CYL -0.25 | AXIS 180 | VA 6/6\n'
                        '• Near Add: +1.50 DS (Both Eyes)\n'
                        '• Frame Type Recommended: Full Rim, Rectangular, Medium\n'
                        '• Lens Treatment: Anti-reflective (ARC) with Blue Cut filter',
                        style: TextStyle(height: 1.6),
                      ),
                    ] else if (doc['category'] == 'Diagnostic Scan') ...[
                      const Text(
                        'Ocular Fundus Photography Findings:',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        height: 200,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.grey[300]!),
                        ),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.image_rounded, size: 48, color: Colors.grey[400]),
                              const SizedBox(height: 8),
                              const Text('High-Resolution Fundus Image Scan', style: TextStyle(fontWeight: FontWeight.bold)),
                              Text('Resolution: 3000 x 3000 pixels • Size: ${doc['size']}', style: TextStyle(color: Colors.grey[500], fontSize: 12)),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Optic Disc: Normal limits, cup-to-disc ratio 0.3. Macula: Clear, no exudates, no hemorrhage. '
                        'Vessels: Normal caliber and course. Background retina is healthy with no diabetic retinopathy changes seen.',
                        style: TextStyle(height: 1.6),
                      ),
                    ] else ...[
                      const Text(
                        'Clinical EMR Summary:',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'This document serves as an official clinical entry in the Andhra Pradesh Digital Health Record system. '
                        'The EMR details have been safely registered and cryptographically anchored to patient ${doc['patientId']} profile under '
                        'supervision of ${doc['physician']}.\n\n'
                        'For questions or corrections regarding these records, please contact the respective Nodal Health Center or '
                        'District Ophthalmology Board.',
                        style: const TextStyle(height: 1.6),
                      ),
                    ],

                    const SizedBox(height: 40),
                    // Security Footer
                    Center(
                      child: Column(
                        children: [
                          Icon(Icons.lock_rounded, color: Colors.green[700], size: 28),
                          const SizedBox(height: 8),
                          Text(
                            'Secured with SHA-256 AP EMR Vault Standard',
                            style: TextStyle(color: Colors.green[700], fontSize: 12, fontWeight: FontWeight.bold),
                          ),
                          const Text(
                            'Verifiable Digital Document Registry ID: e6ba9782fc89d09a27e7',
                            style: TextStyle(color: Colors.grey, fontSize: 10),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Actions footer
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              color: Theme.of(context).cardColor,
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.share_rounded),
                      label: const Text('Share Record'),
                      onPressed: () {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Secure access link generated for ${doc['patient']}'),
                            backgroundColor: AppColors.success,
                            behavior: SnackBarBehavior.floating,
                            duration: const Duration(seconds: 1),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.download_rounded),
                      label: const Text('Download PDF'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.superAdminColor,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Downloading document vault bundle...'),
                            backgroundColor: AppColors.primaryBlue,
                            behavior: SnackBarBehavior.floating,
                            duration: Duration(seconds: 1),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReportField(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 10, fontWeight: FontWeight.bold)),
        const SizedBox(height: 2),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13), overflow: TextOverflow.ellipsis),
      ],
    );
  }

  void _showUploadDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Upload New EMR Document'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Upload prescriptions, scans, or clinical notes safely to AP Vision EMR Vault.'),
            const SizedBox(height: 16),
            Container(
              height: 120,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.05),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.superAdminColor.withOpacity(0.3), style: BorderStyle.solid),
              ),
              child: InkWell(
                onTap: () {
                  Navigator.pop(context);
                  _simulateUpload();
                },
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.cloud_upload_rounded, size: 40, color: AppColors.superAdminColor),
                    SizedBox(height: 8),
                    Text('Tap to select file from device', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                    Text('PDF, JPG, PNG up to 10MB supported', style: TextStyle(color: Colors.grey, fontSize: 11)),
                  ],
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            child: const Text('Cancel'),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  void _simulateUpload() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const _UploadProgressDialog(),
    ).then((result) {
      if (result != null && result is Map<String, dynamic>) {
        setState(() {
          _documents.insert(0, result);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('"${result['title']}" uploaded and signed successfully!'),
            backgroundColor: AppColors.success,
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 1),
          ),
        );
      }
    });
  }
}

class _UploadProgressDialog extends StatefulWidget {
  const _UploadProgressDialog();

  @override
  State<_UploadProgressDialog> createState() => _UploadProgressDialogState();
}

class _UploadProgressDialogState extends State<_UploadProgressDialog> {
  double _progress = 0.0;
  String _statusText = 'Initializing secure upload tunnel...';

  @override
  void initState() {
    super.initState();
    _startSimulation();
  }

  void _startSimulation() async {
    await Future.delayed(const Duration(milliseconds: 600));
    if (!mounted) return;
    setState(() {
      _progress = 0.35;
      _statusText = 'Transferring encrypted payload to EMR vault...';
    });
    await Future.delayed(const Duration(milliseconds: 800));
    if (!mounted) return;
    setState(() {
      _progress = 0.75;
      _statusText = 'Cryptographically signing file with doctor key...';
    });
    await Future.delayed(const Duration(milliseconds: 700));
    if (!mounted) return;
    setState(() {
      _progress = 1.0;
      _statusText = 'Finalizing verification...';
    });
    await Future.delayed(const Duration(milliseconds: 400));
    if (!mounted) return;
    Navigator.pop(context, {
      'id': 'DOC-1030',
      'title': 'New Scan Diagnostic Report.pdf',
      'category': 'Diagnostic Scan',
      'patient': 'Srikanth K.',
      'patientId': 'AP-V-1582',
      'date': '2026-06-02',
      'size': '1.8 MB',
      'physician': 'Dr. K. Srinivas',
      'verified': true,
      'fileType': 'PDF',
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.superAdminColor),
            ),
            const SizedBox(height: 20),
            Text(
              _statusText,
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            LinearProgressIndicator(
              value: _progress,
              backgroundColor: Colors.grey[200],
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.success),
            ),
            const SizedBox(height: 8),
            Text('${(_progress * 100).round()}% complete', style: const TextStyle(fontSize: 12, color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}

class _DocumentGridCard extends StatelessWidget {
  final Map<String, dynamic> doc;
  final VoidCallback onTap;

  const _DocumentGridCard({required this.doc, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Card(
      elevation: 2,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              color: _getFileTypeColor(doc['fileType']).withOpacity(0.08),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: _getFileTypeColor(doc['fileType']),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      doc['fileType'],
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                        fontSize: 9,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      doc['id'],
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 11,
                        color: Colors.grey[600],
                      ),
                    ),
                  ),
                  if (doc['verified'])
                    const Icon(
                      Icons.verified_user_rounded,
                      color: AppColors.success,
                      size: 16,
                    ),
                ],
              ),
            ),
            // Body
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      doc['title'],
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 13,
                        height: 1.2,
                      ),
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        const Icon(Icons.person_outline_rounded, size: 14, color: Colors.grey),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            doc['patient'],
                            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          doc['category'],
                          style: TextStyle(
                            fontSize: 10,
                            color: AppColors.superAdminColor,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          doc['date'],
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getFileTypeColor(String type) {
    switch (type) {
      case 'PDF':
        return Colors.red[700]!;
      case 'JPG':
      case 'PNG':
        return Colors.blue[700]!;
      case 'DOCX':
        return Colors.indigo[700]!;
      default:
        return Colors.grey[700]!;
    }
  }
}
