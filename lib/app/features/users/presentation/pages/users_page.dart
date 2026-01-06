import 'package:bokrah/app/features/users/data/entities/user_entity.dart';
import 'package:bokrah/app/features/users/data/services/users_service.dart';
import 'package:flutter/material.dart';

class UsersPage extends StatefulWidget {
  const UsersPage({super.key});

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  final UsersService _usersService = UsersService();
  List<UserEntity> _users = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    setState(() => _isLoading = true);
    final users = await _usersService.getAllUsers();
    setState(() {
      _users = users;
      _isLoading = false;
    });
  }

  Future<void> _showAddEditDialog({UserEntity? user}) async {
    final isEditing = user != null;
    final formKey = GlobalKey<FormState>();

    final nameController = TextEditingController(text: user?.name ?? '');
    final emailController = TextEditingController(text: user?.email ?? '');
    final phoneController = TextEditingController(
      text: user?.phoneNumber ?? '',
    );
    final addressController = TextEditingController(text: user?.address ?? '');
    final birthDateController = TextEditingController(
      text: user?.birthDate ?? '',
    );

    String? selectedGender = user?.gender ?? 'ذكر';
    List<String> selectedRoles = user?.roles ?? ['Staff'];
    bool isActive = user?.isActive ?? true;

    await showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) {
          return Directionality(
            textDirection: TextDirection.rtl,
            child: AlertDialog(
              title: Text(isEditing ? 'تعديل مستخدم' : 'إضافة مستخدم جديد'),
              content: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildTextField(
                        nameController,
                        'الاسم الكامل *',
                        Icons.person,
                      ),
                      const SizedBox(height: 12),
                      _buildTextField(
                        emailController,
                        'البريد الإلكتروني *',
                        Icons.email,
                        isEmail: true,
                      ),
                      const SizedBox(height: 12),
                      _buildTextField(
                        phoneController,
                        'رقم الهاتف',
                        Icons.phone,
                      ),
                      const SizedBox(height: 12),
                      _buildTextField(
                        addressController,
                        'العنوان',
                        Icons.location_on,
                      ),
                      const SizedBox(height: 12),
                      _buildTextField(
                        birthDateController,
                        'تاريخ الميلاد',
                        Icons.cake,
                        isDate: true,
                      ),
                      const SizedBox(height: 16),

                      // Gender Selection
                      Row(
                        children: [
                          const Text(
                            'الجنس:',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(width: 16),
                          ChoiceChip(
                            label: const Text('ذكر'),
                            selected: selectedGender == 'ذكر',
                            onSelected: (val) =>
                                setDialogState(() => selectedGender = 'ذكر'),
                          ),
                          const SizedBox(width: 8),
                          ChoiceChip(
                            label: const Text('أنثى'),
                            selected: selectedGender == 'أنثى',
                            onSelected: (val) =>
                                setDialogState(() => selectedGender = 'أنثى'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Roles Selection
                      const Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          'الأدوار:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      CheckboxListTile(
                        title: const Text('مسؤول (Admin)'),
                        value: selectedRoles.contains('Admin'),
                        onChanged: (val) {
                          setDialogState(() {
                            if (val == true) {
                              selectedRoles.add('Admin');
                            } else {
                              selectedRoles.remove('Admin');
                            }
                          });
                        },
                      ),
                      CheckboxListTile(
                        title: const Text('موظف (Staff)'),
                        value: selectedRoles.contains('Staff'),
                        onChanged: (val) {
                          setDialogState(() {
                            if (val == true) {
                              selectedRoles.add('Staff');
                            } else {
                              selectedRoles.remove('Staff');
                            }
                          });
                        },
                      ),

                      SwitchListTile(
                        title: const Text('حساب نشط'),
                        value: isActive,
                        onChanged: (val) =>
                            setDialogState(() => isActive = val),
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('إلغاء'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      final newUser = UserEntity(
                        id: user?.id,
                        name: nameController.text.trim(),
                        email: emailController.text.trim(),
                        phoneNumber: phoneController.text.trim(),
                        address: addressController.text.trim(),
                        birthDate: birthDateController.text.trim(),
                        gender: selectedGender,
                        roles: selectedRoles,
                        isActive: isActive,
                        createdAt: user?.createdAt,
                      );

                      bool success = isEditing
                          ? await _usersService.updateUser(newUser)
                          : await _usersService.saveUser(newUser);

                      if (success) {
                        Navigator.pop(context);
                        _loadUsers();
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2E7D64),
                    foregroundColor: Colors.white,
                  ),
                  child: Text(isEditing ? 'تحديث' : 'حفظ'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label,
    IconData icon, {
    bool isEmail = false,
    bool isDate = false,
  }) {
    return TextFormField(
      controller: controller,
      readOnly: isDate,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: const OutlineInputBorder(),
      ),
      onTap: isDate
          ? () async {
              DateTime? pickedDate = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(1950),
                lastDate: DateTime(2100),
              );
              if (pickedDate != null) {
                controller.text =
                    "${pickedDate.year}-${pickedDate.month}-${pickedDate.day}";
              }
            }
          : null,
      validator: (v) {
        if (label.contains('*') && (v == null || v.isEmpty)) {
          return 'هذا الحقل مطلوب';
        }
        if (isEmail && v != null && v.isNotEmpty && !v.contains('@')) {
          return 'بريد غير صحيح';
        }
        return null;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: AppBar(
          title: const Text(
            'إدارة المستخدمين',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          backgroundColor: const Color(0xFF2E7D64),
          foregroundColor: Colors.white,
          actions: [
            IconButton(
              icon: const Icon(Icons.person_add),
              onPressed: () => _showAddEditDialog(),
            ),
          ],
        ),
        body: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _users.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.people_outline,
                      size: 80,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'لا يوجد مستخدمون بعد',
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: () => _showAddEditDialog(),
                      icon: const Icon(Icons.add),
                      label: const Text('إضافة مستخدم'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2E7D64),
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ],
                ),
              )
            : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: _users.length,
                itemBuilder: (context, index) {
                  final user = _users[index];
                  return Card(
                    elevation: 2,
                    margin: const EdgeInsets.only(bottom: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: user.isActive
                            ? const Color(0xFF2E7D64)
                            : Colors.grey,
                        child: const Icon(Icons.person, color: Colors.white),
                      ),
                      title: Text(
                        user.name,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(user.email),
                          Text(
                            'الأدوار: ${user.roles.join(', ')}',
                            style: const TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.blue),
                            onPressed: () => _showAddEditDialog(user: user),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () async {
                              final confirm = await showDialog<bool>(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text('حذف مستخدم'),
                                  content: const Text(
                                    'هل أنت متأكد من حذف هذا المستخدم؟',
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.pop(context, false),
                                      child: const Text('إلغاء'),
                                    ),
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.pop(context, true),
                                      child: const Text(
                                        'حذف',
                                        style: TextStyle(color: Colors.red),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                              if (confirm == true) {
                                await _usersService.deleteUser(user.id!);
                                _loadUsers();
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => _showAddEditDialog(),
          backgroundColor: const Color(0xFF2E7D64),
          child: const Icon(Icons.person_add, color: Colors.white),
        ),
      ),
    );
  }
}
