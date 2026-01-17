import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BookingScreen extends ConsumerStatefulWidget {
  const BookingScreen({super.key});

  @override
  ConsumerState<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends ConsumerState<BookingScreen> {
  int _selectedIndex = 1;
  final _formKey = GlobalKey<FormState>();
  String? _selectedService;
  DateTime? _selectedDate;
  String? _selectedTimeSlot;
  String? _selectedProviderId;
  final _descriptionController = TextEditingController();

  final List<String> _services = [
    'Plumbing',
    'Electrical',
    'Cleaning',
    'Carpentry',
    'Painting',
    'AC Repair',
  ];

  final List<String> _timeSlots = [
    '9:00 AM - 11:00 AM',
    '11:00 AM - 1:00 PM',
    '1:00 PM - 3:00 PM',
    '3:00 PM - 5:00 PM',
    '5:00 PM - 7:00 PM',
  ];

  // Sample service providers data
  final List<Map<String, dynamic>> _providers = [
    {
      'id': '1',
      'name': 'John Smith',
      'image': 'https://i.pravatar.cc/150?img=1',
      'rating': 4.8,
      'completedTasks': 156,
    },
    {
      'id': '2',
      'name': 'Sarah Johnson',
      'image': 'https://i.pravatar.cc/150?img=2',
      'rating': 4.9,
      'completedTasks': 203,
    },
    {
      'id': '3',
      'name': 'Mike Davis',
      'image': 'https://i.pravatar.cc/150?img=3',
      'rating': 4.7,
      'completedTasks': 128,
    },
    {
      'id': '4',
      'name': 'Emma Wilson',
      'image': 'https://i.pravatar.cc/150?img=4',
      'rating': 4.9,
      'completedTasks': 189,
    },
  ];

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);

    switch (index) {
      case 0:
        Navigator.pushNamed(context, '/home');
        break;
      case 1:
        // Already on booking
        break;
      case 2:
        Navigator.pushNamed(context, '/profile');
        break;
    }
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)),
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  Future<void> _createBooking() async {
    if (_formKey.currentState!.validate() &&
        _selectedService != null &&
        _selectedDate != null &&
        _selectedTimeSlot != null &&
        _selectedProviderId != null) {
      // Show success dialog
      final selectedProvider =
          _providers.firstWhere((p) => p['id'] == _selectedProviderId);

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Booking Confirmed'),
          content: Text(
              'Your booking with ${selectedProvider['name']} has been created successfully!'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/booking-history');
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content:
              Text('Please fill all required fields and select a provider'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Book a Service'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              DropdownButtonFormField<String>(
                value: _selectedService,
                decoration: const InputDecoration(
                  labelText: 'Select Service',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.build),
                ),
                items: _services.map((service) {
                  return DropdownMenuItem(
                    value: service,
                    child: Text(service),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() => _selectedService = value);
                },
                validator: (value) {
                  if (value == null) {
                    return 'Please select a service';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              ListTile(
                title: Text(_selectedDate == null
                    ? 'Select Date'
                    : 'Date: ${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}'),
                leading: const Icon(Icons.calendar_today),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: _selectDate,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                  side: BorderSide(color: Colors.grey.shade400),
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedTimeSlot,
                decoration: const InputDecoration(
                  labelText: 'Select Time Slot',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.access_time),
                ),
                items: _timeSlots.map((slot) {
                  return DropdownMenuItem(
                    value: slot,
                    child: Text(slot),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() => _selectedTimeSlot = value);
                },
                validator: (value) {
                  if (value == null) {
                    return 'Please select a time slot';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                maxLines: 4,
                decoration: const InputDecoration(
                  labelText: 'Description (Optional)',
                  hintText: 'Describe your issue...',
                  border: OutlineInputBorder(),
                  alignLabelWithHint: true,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Select Service Provider',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 16),
              // Provider Selection Grid
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.9,
                ),
                itemCount: _providers.length,
                itemBuilder: (context, index) {
                  final provider = _providers[index];
                  final isSelected = _selectedProviderId == provider['id'];

                  return GestureDetector(
                    onTap: () {
                      setState(() => _selectedProviderId = provider['id']);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isSelected
                              ? Theme.of(context).colorScheme.secondary
                              : Colors.grey.shade300,
                          width: isSelected ? 3 : 1,
                        ),
                        color: isSelected
                            ? Theme.of(context)
                                .colorScheme
                                .secondary
                                .withOpacity(0.05)
                            : Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // Profile Photo
                            CircleAvatar(
                              radius: 30,
                              backgroundImage: NetworkImage(provider['image']),
                            ),
                            const SizedBox(height: 8),
                            // Name
                            Text(
                              provider['name'],
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: Theme.of(context).primaryColor,
                              ),
                              textAlign: TextAlign.center,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 6),
                            // Rating
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.star,
                                  size: 14,
                                  color: Colors.amber,
                                ),
                                const SizedBox(width: 2),
                                Text(
                                  '${provider['rating']}',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            // Completed Tasks
                            Text(
                              '${provider['completedTasks']} tasks',
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.grey.shade600,
                              ),
                            ),
                            // Selection Checkmark
                            if (isSelected)
                              Padding(
                                padding: const EdgeInsets.only(top: 6.0),
                                child: Icon(
                                  Icons.check_circle,
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                  size: 20,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _createBooking,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('Confirm Booking',
                    style: TextStyle(fontSize: 16)),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          backgroundColor: Colors.white,
          selectedItemColor: Theme.of(context).colorScheme.secondary,
          unselectedItemColor: Colors.grey,
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.history_outlined),
              activeIcon: Icon(Icons.history),
              label: 'Bookings',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              activeIcon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}
