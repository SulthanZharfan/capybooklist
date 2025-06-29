import 'package:flutter/material.dart';
import 'package:capybooklist/db/user_dao.dart';
import 'package:capybooklist/models/user.dart';
import 'package:capybooklist/screens/root_screen.dart';

class UserProfileScreen extends StatefulWidget {
  final bool forceCreate;

  const UserProfileScreen({super.key, this.forceCreate = false});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  User? _user;
  bool _isLoading = true;

  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  final _cityController = TextEditingController();

  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    final user = await UserDao().getUser();
    if (mounted) {
      setState(() {
        _user = user;
        _isLoading = false;
        if (user != null) {
          _nameController.text = user.name;
          _ageController.text = user.age.toString();
          _cityController.text = user.city ?? '';
        }

        // If forced create, immediately enter editing mode
        if (widget.forceCreate) {
          _isEditing = true;
        }
      });
    }
  }

  Future<void> _saveUser() async {
    if (!_formKey.currentState!.validate()) return;

    final newUser = User(
      id: _user?.id,
      name: _nameController.text.trim(),
      age: int.parse(_ageController.text.trim()),
      city: _cityController.text.trim(),
    );

    try {
      await UserDao().insertOrUpdateUser(newUser);

      if (!mounted) return;

      if (widget.forceCreate) {
        // kalau ini register pertama kali: ke root
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const RootScreen()),
        );
      } else {
        setState(() {
          _isEditing = false;
          _user = newUser;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated successfully!')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving profile: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background
          Image.asset(
            'assets/images/Picture1.png',
            fit: BoxFit.cover,
          ),
          Container(
            color: Colors.black.withOpacity(0.5),
          ),

          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Fake AppBar
                  const Text(
                    'Account',
                    style: TextStyle(
                      color: Color(0xFFEEEEEE),
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),

                  const SizedBox(height: 24),

                  _isEditing
                      ? _buildEditForm()
                      : _buildProfileView()
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Your Profile 👤',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFFEEEEEE),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Name: ${_user?.name ?? '-'}',
          style: const TextStyle(fontSize: 16, color: Color(0xFFEEEEEE)),
        ),
        const SizedBox(height: 8),
        Text(
          'Age: ${_user?.age ?? '-'}',
          style: const TextStyle(fontSize: 16, color: Color(0xFFEEEEEE)),
        ),
        const SizedBox(height: 8),
        Text(
          'City: ${_user?.city ?? '-'}',
          style: const TextStyle(fontSize: 16, color: Color(0xFFEEEEEE)),
        ),
        const SizedBox(height: 24),
        ElevatedButton(
          onPressed: () {
            setState(() {
              _isEditing = true;
            });
          },
          style: _buttonStyle(),
          child: const Text('Edit'),
        ),
      ],
    );
  }

  Widget _buildEditForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Edit Profile ✏️',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFFEEEEEE),
          ),
        ),
        const SizedBox(height: 16),
        Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                style: const TextStyle(color: Color(0xFFEEEEEE)),
                decoration: _inputDecoration('Name'),
                validator: (value) =>
                value == null || value.isEmpty ? 'Enter name' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _ageController,
                keyboardType: TextInputType.number,
                style: const TextStyle(color: Color(0xFFEEEEEE)),
                decoration: _inputDecoration('Age'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Enter age';
                  }
                  final age = int.tryParse(value);
                  if (age == null || age <= 0) {
                    return 'Enter valid age';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _cityController,
                style: const TextStyle(color: Color(0xFFEEEEEE)),
                decoration: _inputDecoration('City'),
                validator: (value) =>
                value == null || value.isEmpty ? 'Enter city' : null,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _saveUser,
                style: _buttonStyle(),
                child: const Text('Save'),
              ),
            ],
          ),
        ),
      ],
    );
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Color(0xFFCCCCCC)),
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Color(0xFFCCCCCC)),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Color(0xFFEEEEEE)),
      ),
    );
  }

  ButtonStyle _buttonStyle() {
    return ElevatedButton.styleFrom(
      backgroundColor: const Color(0x88262C4F),
      elevation: 4,
      side: const BorderSide(color: Color(0xFFEEEEEE)),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      foregroundColor: const Color(0xFFEEEEEE),
      textStyle: const TextStyle(fontWeight: FontWeight.bold),
    );
  }
}
