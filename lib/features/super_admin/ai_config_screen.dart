// lib/features/super_admin/ai_config_screen.dart
import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/common_widgets.dart';

class AiConfigScreen extends StatefulWidget {
  const AiConfigScreen({super.key});

  @override
  State<AiConfigScreen> createState() => _AiConfigScreenState();
}

class _AiConfigScreenState extends State<AiConfigScreen> {
  bool _cataractModel = true;
  bool _glaucomaModel = true;
  bool _drModel = true;
  bool _hotspotDetection = true;
  bool _demandForecast = false;
  double _riskThreshold = 0.65;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Model Configuration'),
        backgroundColor: AppColors.primaryBlue,
        leading: const AppBarBackButton(),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          SwitchListTile(
            title: const Text('Cataract Risk Model'),
            subtitle: const Text('Predict cataract risk from age, symptoms & history'),
            value: _cataractModel,
            onChanged: (v) => setState(() => _cataractModel = v),
          ),
          SwitchListTile(
            title: const Text('Glaucoma Risk Model'),
            value: _glaucomaModel,
            onChanged: (v) => setState(() => _glaucomaModel = v),
          ),
          SwitchListTile(
            title: const Text('Diabetic Retinopathy Model'),
            value: _drModel,
            onChanged: (v) => setState(() => _drModel = v),
          ),
          SwitchListTile(
            title: const Text('Disease Hotspot Identification'),
            value: _hotspotDetection,
            onChanged: (v) => setState(() => _hotspotDetection = v),
          ),
          SwitchListTile(
            title: const Text('Spectacle Demand Forecasting'),
            value: _demandForecast,
            onChanged: (v) => setState(() => _demandForecast = v),
          ),
          const SizedBox(height: 16),
          Text('High-Risk Alert Threshold: ${(_riskThreshold * 100).round()}%'),
          Slider(
            value: _riskThreshold,
            onChanged: (v) => setState(() => _riskThreshold = v),
            min: 0.4,
            max: 0.9,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('AI configuration saved')),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.accent, minimumSize: const Size.fromHeight(48)),
            child: const Text('Save Configuration'),
          ),
        ],
      ),
    );
  }
}
