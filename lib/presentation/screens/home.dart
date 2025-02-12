import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:velo/core/configs/theme/app_fonts.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<String> timeSlots = [
    '8:00AM', '9:00AM', '10:00AM', '11:00AM',
    '12:00PM', '1:00PM', '2:00PM'
  ];
  
  late DateTime selectedDate;
  int activities = 0;
  String time = '0h 0m';
  double distance = 0.0;

  @override
  void initState() {
    super.initState();
    selectedDate = DateTime.now();
    _fetchWeeklyProgress();
  }

  Future<void> _fetchWeeklyProgress() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final weekStart = selectedDate.subtract(Duration(days: selectedDate.weekday - 1));
        final weekEnd = weekStart.add(const Duration(days: 7));
        
        final snapshot = await FirebaseFirestore.instance
            .collection('user_activities')
            .doc(user.uid)
            .collection('activities')
            .where('date', isGreaterThanOrEqualTo: weekStart)
            .where('date', isLessThan: weekEnd)
            .get();

        int totalActivities = snapshot.docs.length;
        int totalMinutes = snapshot.docs.fold(0, (sum, doc) => sum + (doc['duration'] as int));
        double totalDistance = snapshot.docs.fold(0.0, (sum, doc) => sum + (doc['distance'] as double));

        setState(() {
          activities = totalActivities;
          time = '${totalMinutes ~/ 60}h ${totalMinutes % 60}m';
          distance = totalDistance;
        });
      }
    } catch (e) {
      print('Error fetching weekly progress: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF561C24),
      appBar: AppBar(
        backgroundColor: const Color(0xFF561C24),
        elevation: 0,
        title: Text('HOME', style: AppFonts.bold.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.w600,
        )),
        actions: [
          IconButton(
            icon: const Icon(Icons.cloud_outlined, color: Colors.white),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.notifications_outlined, color: Colors.white),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.person_outline, color: Colors.white),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              if (mounted) {
                Navigator.of(context).pushReplacementNamed('/login');
              }
            },
          ),
        ],
      ),
      body: Column(
        children: [
          _buildWeeklyProgress(),
          _buildCalendar(),
          Expanded(child: _buildTimeSlots()),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        onPressed: _addActivity,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF561C24),
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white70,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.message), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: ''),
        ],
      ),
    );
  }

  Widget _buildWeeklyProgress() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Your Weekly Progress',
            style: AppFonts.medium.copyWith(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildProgressItem('Activities', activities.toString(), '0'),
              _buildProgressItem('Time', time, '0'),
              _buildProgressItem('Distance', '${distance.toStringAsFixed(2)}km', '0'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProgressItem(String label, String value, String delta) {
    return Column(
      children: [
        Text(
          label,
          style: AppFonts.light.copyWith(
            fontSize: 14,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: AppFonts.light.copyWith(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        Row(
          children: [
            const Icon(Icons.arrow_upward, size: 12, color: Colors.green),
            Text(delta, style: AppFonts.light.copyWith(color: Colors.green)),
          ],
        ),
      ],
    );
  }

  Widget _buildCalendar() {
    final weekStart = selectedDate.subtract(Duration(days: selectedDate.weekday - 1));
    final days = List.generate(7, (index) => weekStart.add(Duration(days: index)));

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  DateFormat('MMMM yyyy').format(selectedDate),
                  style: AppFonts.light.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.view_list, color: Colors.black),
                      onPressed: () {},
                    ),
                    IconButton(
                      icon: const Icon(Icons.search, color: Colors.black),
                      onPressed: () {},
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            height: 80,
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 7,
              itemBuilder: (context, index) {
                final date = days[index];
                final isSelected = date.day == selectedDate.day;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedDate = date;
                    });
                  },
                  child: Container(
                    width: 50,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      border: Border.all(color: isSelected ? Colors.blue : Colors.grey[300]!),
                      borderRadius: BorderRadius.circular(8),
                      color: isSelected ? Colors.blue.withOpacity(0.1) : null,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          DateFormat('E').format(date).substring(0, 1),
                          style: AppFonts.light.copyWith(
                            fontSize: 12,
                            color: isSelected ? Colors.blue : Colors.black,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          date.day.toString(),
                          style: AppFonts.light.copyWith(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: isSelected ? Colors.blue : Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeSlots() {
    return Container(
      color: Colors.white,
      child: ListView.builder(
        itemCount: timeSlots.length,
        itemBuilder: (context, index) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Colors.grey[300]!),
              ),
            ),
            child: Text(
              timeSlots[index],
              style: AppFonts.light.copyWith(
                fontSize: 14,
                color: Colors.black87,
              ),
            ),
          );
        },
      ),
    );
  }

  void _addActivity() async {
    // This is a simple implementation. You might want to create a more detailed form.
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseFirestore.instance
          .collection('user_activities')
          .doc(user.uid)
          .collection('activities')
          .add({
        'date': Timestamp.fromDate(selectedDate),
        'duration': 30, // 30 minutes as an example
        'distance': 2.5, // 2.5 km as an example
      });
      _fetchWeeklyProgress(); // Refresh the weekly progress
    }
  }
}