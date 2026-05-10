import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ruang_sehat/features/auth/providers/auth_provider.dart';
import 'package:ruang_sehat/theme/app_colors.dart';
import 'package:ruang_sehat/utils/snackbar_helper.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  static const routeName = '/profile';

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

// nilai untuk text form field
class _ProfileScreenState extends State<ProfileScreen> { 
  final nameController = TextEditingController();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  bool _prefilled = false;

// ambil data profile saat halaman pertama kali di buka
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final auth = context.read<AuthProvider>();
      if (auth.profile == null) {
        auth.getProfile();
      }
    });
  }

// bersihkan controller saat halaman di dispose untuk menghindari memory leak
  @override
  void dispose() {
    nameController.dispose();
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

// fungsi untuk mengisi data lama ke form jika belum diisi, agar user bisa lihat data lama sebagai referensi saat ingin mengedit
  void _prefillIfNeeded(AuthProvider auth) {
    final p = auth.profile;
    if (p == null) return;

    if (!_prefilled) {
      nameController.text = p.name;
      usernameController.text = p.username;
      _prefilled = true;
    }
  }

  InputDecoration _dec({
    required String hint,
    required IconData icon,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: AppColors.hintText),
      prefixIcon: Icon(icon, color: AppColors.primary),
      filled: true,
      fillColor: AppColors.secondary,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.border, width: 2),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.primary, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
    );
  }

// fungsi untuk menangani proses edit profile saat tombol simpan ditekan
// trim() untuk menghilangkan spasi di awal/akhir input, dan validasi agar name dan username tidak boleh kosong
  Future<void> _handleEdit() async {
    final auth = context.read<AuthProvider>();

    final name = nameController.text.trim();
    final username = usernameController.text.trim();
    final password = passwordController.text.trim().isEmpty
        ? null
        : passwordController.text.trim();

    if (name.isEmpty || username.isEmpty) {
      SnackbarHelper.show(
        context,
        message: 'Name dan Username wajib diisi',
        isError: true,
      );
      return;
    }

// Memanggil method Provider → Provider memanggil service → API PUT /auth/profile.
    final ok = await auth.updateProfile(
      name: name,
      username: username,
      password: password,
    );

// Menghindari error jika user sudah pindah halaman saat request masih berjalan.
    if (!mounted) return;

    if (ok) {
      SnackbarHelper.show(
        context,
        message: auth.successMesage ?? 'Berhasil memperbarui profil',
      );

      // pastikan form ikut menampilkan data terbaru dari provider
      final p = auth.profile;
      if (p != null) {
        nameController.text = p.name;
        usernameController.text = p.username;
      }

      passwordController.clear();
    } else {
      SnackbarHelper.show(
        context,
        message: auth.errorMessage ?? 'Gagal memperbarui profil',
        isError: true,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    _prefillIfNeeded(auth);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Header
              Container(
                height: 170,
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(22),
                    bottomRight: Radius.circular(22),
                  ),
                ),
                child: const Center(
                  child: Text(
                    'Edit Profil',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),

              // Avatar
              Transform.translate(
                offset: const Offset(0, -40),
                child: const CircleAvatar(
                  radius: 44,
                  backgroundColor: Colors.white,
                  child: CircleAvatar(
                    radius: 40,
                    backgroundImage: AssetImage('assets/images/profile.png'),
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Name',
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: nameController,
                      decoration: _dec(
                        // ketentuan: tampilkan data lama sebagai placeholder/hint
                        hint: auth.profile?.name ?? 'Masukkan nama',
                        icon: Icons.person_outline,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Username',
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: usernameController,
                      decoration: _dec(
                        hint: auth.profile?.username ?? 'Masukkan username',
                        icon: Icons.alternate_email,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Password',
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: passwordController,
                      obscureText: true,
                      decoration: _dec(
                        hint: 'Password baru (opsional)',
                        icon: Icons.lock_outline,
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: auth.isLoading ? null : _handleEdit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        minimumSize: const Size.fromHeight(52),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: auth.isLoading
                          ? const SizedBox(
                              width: 22,
                              height: 22,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Text(
                              'Simpan Perubahan',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
