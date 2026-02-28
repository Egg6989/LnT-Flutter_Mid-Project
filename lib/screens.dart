import 'package:flutter/material.dart';
import 'models.dart';

class HomeScreen extends StatelessWidget {
  final List<StepEntry> numSteps;
  final List<WaterEntry> water;

  const HomeScreen({
    super.key,
    required this.numSteps,
    required this.water,
  });

  @override
  Widget build(BuildContext context) {
    // Today entry if exist
    final today = DateTime.now();
    final todayNumSteps = numSteps.where((e) =>
      e.date.year == today.year &&
      e.date.month == today.month &&
      e.date.day == today.day
    ).firstOrNull;

    final todayWater = water.where((e) =>
      e.date.year == today.year &&
      e.date.month == today.month &&
      e.date.day == today.day
    ).firstOrNull;

    return Scaffold(
      appBar: AppBar(
        title: const Text('MyFit - Fitness Tracker'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            
            const Text(
              'Hello there 👋',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            
            const Text(
              'Here''s your fitness summary',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),

            // stats/cards
            const Text('TODAY', style: TextStyle(fontSize: 12, letterSpacing: 2, fontWeight: FontWeight.bold, color: Colors.grey)),
            const SizedBox(height: 10),
            Row(
              children: [
                // Card: Steps
                Expanded(
                  child: _StatCard(
                    icon: '👟',
                    value: todayNumSteps != null
                      ? '${todayNumSteps.numSteps.toString()} steps'
                      : '--',
                      label: todayNumSteps?.label ?? 'No data',
                      color: Colors.blue,
                  ),
                ),
                const SizedBox(width: 12),
                // Card: Water
                Expanded(
                  child: _StatCard(
                    icon: '💧',
                    value: todayWater != null
                      ? '${todayWater.liters}L'
                      : '--',
                      label: todayWater?.label ?? 'No data',
                      color: Colors.green,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Buttons
            const Text('TRACKER', style: TextStyle(fontSize: 12, letterSpacing: 2, fontWeight: FontWeight.bold, color: Colors.grey)),
            const SizedBox(height: 10),

            // Steps button
            _TrackerButton(
              icon: '👟',
              label: 'Steps Tracker',
              subtitle: '${numSteps.length} entries logged',
              color: Colors.blue,
              onTap: (){
                // navigation
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const StepsScreen()),
                  );
              },
            ),
            const SizedBox(height: 10),

            // Water Button
            _TrackerButton(
              icon: '💧',
              label: 'Water Intake',
              subtitle: '${water.length} entries logged',
              color: Colors.green,
              onTap: (){
                // navigation
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const WaterScreen()),
                  );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String icon;
  final String value;
  final String label;
  final Color color;

  const _StatCard({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(icon, style: const TextStyle(fontSize: 24)),
          const SizedBox(height: 8),
          Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(label, style: TextStyle(fontSize: 11, color: color, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}

class _TrackerButton extends StatelessWidget {
  final String icon;
  final String label;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  const _TrackerButton({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Row(
          children: [
            Text(icon, style: const TextStyle(fontSize: 26)),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                  Text(subtitle, style: const TextStyle(fontSize: 11, color: Colors.grey)),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}

// place holder - steps screen
class StepsScreen extends StatelessWidget {
  const StepsScreen ({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Steps Tracker'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text('Coming soon!'),
      ),
    );
  }
}

// place holder - water screen
class WaterScreen extends StatelessWidget {
  const WaterScreen ({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Water Intake'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text('Coming soon!'),
      ),
    );
  }
}