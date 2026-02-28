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

// Steps Screen
class StepsScreen extends StatefulWidget {
  const StepsScreen({super.key});

  @override
  State<StepsScreen> createState() => _StepsScreenState();
}

class _StepsScreenState extends State<StepsScreen> {
  final List<StepEntry> _steps = [];
  final TextEditingController _stepsController = TextEditingController();
  DateTime? _selectedDate;
  DateTime? _editingDate;
  final TextEditingController _editController = TextEditingController();

  // Date picker dialog
  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  // Check if date already has an entry
  bool _dateExists(DateTime date) {
    return _steps.any((e) =>
      e.date.year == date.year &&
      e.date.month == date.month &&
      e.date.day == date.day
    );
  }

  void _addEntry() {
    // Validate fields
    if (_selectedDate == null || _stepsController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields.')),
      );
      return;
    }

    final steps = int.tryParse(_stepsController.text);
    if (steps == null || steps < 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid step count.')),
      );
      return;
    }

    // Validate: one entry per date
    if (_dateExists(_selectedDate!)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('An entry for this date already exists!')),
      );
      return;
    }

    setState(() {
      _steps.add(StepEntry(date: _selectedDate!, numSteps: steps));
      _steps.sort((a, b) => b.date.compareTo(a.date));
      _stepsController.clear();
      _selectedDate = null;
    });
  }

  // Delete entry
  void _deleteEntry(DateTime date) {
    setState(() {
      _steps.removeWhere((e) =>
        e.date.year == date.year &&
        e.date.month == date.month &&
        e.date.day == date.day
      );
    });
  }

  // Start editing an entry
  void _startEdit(StepEntry entry) {
    setState(() {
      _editingDate = entry.date;
      _editController.text = entry.numSteps.toString();
    });
  }

  // Save edited entry
  void _saveEdit(DateTime date) {
    final steps = int.tryParse(_editController.text);
    if (steps == null || steps < 0) return;

    setState(() {
      final index = _steps.indexWhere((e) =>
        e.date.year == date.year &&
        e.date.month == date.month &&
        e.date.day == date.day
      );
      if (index != -1) {
        _steps[index] = StepEntry(date: date, numSteps: steps);
      }
      _editingDate = null;
      _editController.clear();
    });
  }

  // Label color
  Color _labelColor(String label) {
    if (label == 'Good') return Colors.green;
    if (label == 'Average') return Colors.orange;
    return Colors.red;
  }

  // Format date for display
  String _formatDate(DateTime date) {
    const months = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Steps Tracker'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // Add Entry Form
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.blue.withOpacity(0.3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('ADD ENTRY', style: TextStyle(fontSize: 11, letterSpacing: 2, color: Colors.grey)),
                  const SizedBox(height: 12),

                  // Date picker button
                  GestureDetector(
                    onTap: _pickDate,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.07),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.white.withOpacity(0.12)),
                      ),
                      child: Text(
                        _selectedDate == null
                            ? 'Tap to select date'
                            : _formatDate(_selectedDate!),
                        style: TextStyle(
                          color: _selectedDate == null ? Colors.grey : Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Steps input
                  TextField(
                    controller: _stepsController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: 'Number of steps',
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.07),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.white.withOpacity(0.12)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Add button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _addEntry,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text('+ Add Entry', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Entries List
            Text(
              'ENTRIES (${_steps.length})',
              style: const TextStyle(fontSize: 11, letterSpacing: 2, color: Colors.grey),
            ),
            const SizedBox(height: 10),

            // Empty state
            if (_steps.isEmpty)
              const Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 32),
                  child: Text(
                    'No entries yet.\nStart tracking your steps!',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              ),

            // List of entries
            ..._steps.map((entry) {
              final isEditing = _editingDate != null &&
                _editingDate!.year == entry.date.year &&
                _editingDate!.month == entry.date.month &&
                _editingDate!.day == entry.date.day;

              return Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.04),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: Colors.white.withOpacity(0.08)),
                ),
                child: isEditing
                    // Edit mode
                    ? Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _formatDate(entry.date),
                                  style: const TextStyle(fontSize: 11, color: Colors.grey),
                                ),
                                const SizedBox(height: 6),
                                TextField(
                                  controller: _editController,
                                  keyboardType: TextInputType.number,
                                  autofocus: true,
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Colors.white.withOpacity(0.07),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    isDense: true,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          // Save button
                          ElevatedButton(
                            onPressed: () => _saveEdit(entry.date),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            ),
                            child: const Text('Save'),
                          ),
                          const SizedBox(width: 6),
                          // Cancel button
                          TextButton(
                            onPressed: () => setState(() => _editingDate = null),
                            child: const Text('✕'),
                          ),
                        ],
                      )
                    // ── View mode ──
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _formatDate(entry.date),
                                style: const TextStyle(fontSize: 11, color: Colors.grey),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${entry.numSteps.toString()} steps',
                                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              // Label badge
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                                decoration: BoxDecoration(
                                  color: _labelColor(entry.label).withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(color: _labelColor(entry.label).withOpacity(0.3)),
                                ),
                                child: Text(
                                  entry.label,
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: _labelColor(entry.label),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  // Edit button
                                  GestureDetector(
                                    onTap: () => _startEdit(entry),
                                    child: Container(
                                      padding: const EdgeInsets.all(6),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.07),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: const Text('✏️'),
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  // Delete button
                                  GestureDetector(
                                    onTap: () => _deleteEntry(entry.date),
                                    child: Container(
                                      padding: const EdgeInsets.all(6),
                                      decoration: BoxDecoration(
                                        color: Colors.red.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: const Text('🗑'),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
              );
            }),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _stepsController.dispose();
    _editController.dispose();
    super.dispose();
  }
}

// Water Screen
class WaterScreen extends StatefulWidget {
  const WaterScreen({super.key});

  @override
  State<WaterScreen> createState() => _WaterScreenState();
}

class _WaterScreenState extends State<WaterScreen> {
  final List<WaterEntry> _water = [];
  final TextEditingController _waterController = TextEditingController();
  DateTime? _selectedDate;

  // Date picker
  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  // Check duplicate date
  bool _dateExists(DateTime date) {
    return _water.any((e) =>
      e.date.year == date.year &&
      e.date.month == date.month &&
      e.date.day == date.day
    );
  }

  void _addEntry() {
    if (_selectedDate == null || _waterController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields.')),
      );
      return;
    }

    final liters = double.tryParse(_waterController.text);
    if (liters == null || liters < 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid amount.')),
      );
      return;
    }

    if (_dateExists(_selectedDate!)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('An entry for this date already exists!')),
      );
      return;
    }

    setState(() {
      _water.add(WaterEntry(date: _selectedDate!, liters: liters));
      _water.sort((a, b) => b.date.compareTo(a.date));
      _waterController.clear();
      _selectedDate = null;
    });
  }

  // Helpers
  Color _labelColor(String label) {
    if (label == 'Good') return Colors.green;
    if (label == 'Average') return Colors.orange;
    return Colors.red;
  }

  String _formatDate(DateTime date) {
    const months = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Water Intake'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // Add Entry Form 
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.green.withOpacity(0.3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('ADD ENTRY', style: TextStyle(fontSize: 11, letterSpacing: 2, color: Colors.grey)),
                  const SizedBox(height: 12),

                  // Date picker
                  GestureDetector(
                    onTap: _pickDate,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.07),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.white.withOpacity(0.12)),
                      ),
                      child: Text(
                        _selectedDate == null
                            ? 'Tap to select date'
                            : _formatDate(_selectedDate!),
                        style: TextStyle(
                          color: _selectedDate == null ? Colors.grey : Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Water input
                  TextField(
                    controller: _waterController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    decoration: InputDecoration(
                      hintText: 'Amount in liters (e.g. 1.5)',
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.07),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.white.withOpacity(0.12)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Add button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _addEntry,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text('+ Add Entry', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Entries List
            Text(
              'ENTRIES (${_water.length})',
              style: const TextStyle(fontSize: 11, letterSpacing: 2, color: Colors.grey),
            ),
            const SizedBox(height: 10),

            if (_water.isEmpty)
              const Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 32),
                  child: Text(
                    'No entries yet.\nStart tracking your water intake!',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              ),

            ..._water.map((entry) => Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.04),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.white.withOpacity(0.08)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _formatDate(entry.date),
                        style: const TextStyle(fontSize: 11, color: Colors.grey),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${entry.liters} L',
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                    decoration: BoxDecoration(
                      color: _labelColor(entry.label).withOpacity(0.15),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: _labelColor(entry.label).withOpacity(0.3)),
                    ),
                    child: Text(
                      entry.label,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: _labelColor(entry.label),
                      ),
                    ),
                  ),
                ],
              ),
            )),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _waterController.dispose();
    super.dispose();
  }
}