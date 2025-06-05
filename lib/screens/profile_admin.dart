import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:image_picker/image_picker.dart';
import 'package:gym_fitgo/screens/admin_home_screen.dart';
import 'package:gym_fitgo/screens/challenges_screen_admin.dart';
import 'package:gym_fitgo/screens/admin_rutins_screen.dart';
import 'package:gym_fitgo/screens/users_screen_admin.dart';
import 'package:gym_fitgo/screens/gym_suvery_screen.dart';
import 'package:gym_fitgo/screens/login_screen.dart';
import 'package:gym_fitgo/widgets/custom_bottom_navbar_admin.dart';

class ProfileAdmin extends StatefulWidget {
  @override
  _AdminProfileScreenState createState() => _AdminProfileScreenState();
}

class _AdminProfileScreenState extends State<ProfileAdmin> {
  int _currentIndex = 3;
  String name = 'Cargando...';
  int age = 0;
  double weight = 0.0;
  double height = 0.0;
  String email = '';
  String? photoUrl;
  bool _isLoadingPhoto = false;

  final CloudinaryPublic cloudinary =
      CloudinaryPublic('dycjb5ovf', 'FitgoApp', cache: false);

  @override
  void initState() {
    super.initState();
    _loadUserEmail();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadUserEmail();
  }

  Future<void> _loadUserEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? storedEmail = prefs.getString('user_email');
    print('Email almacenado en SharedPreferences: $storedEmail');
    if (storedEmail != null && storedEmail.isNotEmpty) {
      setState(() {
        email = storedEmail;
      });
      _loadUserData(storedEmail);
    } else {
      print(
          'No se encontró email en SharedPreferences, redirigiendo a LoginScreen');
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    }
  }

  Future<void> _loadUserData(String email) async {
    try {
      QuerySnapshot userDoc = await FirebaseFirestore.instance
          .collection('usuarios')
          .where('email', isEqualTo: email)
          .get();

      print('Documentos encontrados para email $email: ${userDoc.docs.length}');
      if (userDoc.docs.isNotEmpty) {
        var data = userDoc.docs.first.data() as Map<String, dynamic>;
        print('Datos del usuario: $data');
        setState(() {
          name = data['name'] ?? 'Sin nombre';
          age = data['age'] != null
              ? int.tryParse(data['age'].toString()) ?? 0
              : 0;
          weight = data['weight'] != null
              ? double.tryParse(data['weight'].toString()) ?? 0.0
              : 0.0;
          height = data['height'] != null
              ? (double.tryParse(data['height'].toString()) ?? 0.0) / 100
              : 0.0;
          photoUrl = data['photoUrl'];
        });
      } else {
        setState(() {
          name = 'No se encontraron datos';
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  'No se encontraron datos para este email ($email) en Firestore.')),
        );
      }
    } catch (e) {
      setState(() {
        name = 'Error al cargar';
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al cargar datos: $e')),
      );
      print('Error al cargar datos: $e');
    }
  }

  Future<void> _updateUserData(Map<String, dynamic> updatedData) async {
    try {
      QuerySnapshot userDoc = await FirebaseFirestore.instance
          .collection('usuarios')
          .where('email', isEqualTo: email)
          .get();

      if (userDoc.docs.isNotEmpty) {
        await FirebaseFirestore.instance
            .collection('usuarios')
            .doc(userDoc.docs.first.id)
            .update(updatedData);
        if (updatedData.containsKey('email')) {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('user_email', updatedData['email']);
          setState(() {
            email = updatedData['email'];
          });
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Datos actualizados con éxito')),
        );
        _loadUserData(email);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al actualizar datos: $e')),
      );
      print('Error al actualizar datos: $e');
    }
  }

  Future<void> _pickAndUploadPhoto() async {
    final picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      bool? confirm = await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Confirmar cambio de foto'),
            content:
                Text('¿Estás seguro de que quieres cambiar tu foto de perfil?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text('Cancelar'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: Text('Confirmar'),
              ),
            ],
          );
        },
      );

      if (confirm == true) {
        setState(() {
          _isLoadingPhoto = true;
        });
        try {
          final response = await cloudinary.uploadFile(
            CloudinaryFile.fromFile(image.path,
                resourceType: CloudinaryResourceType.Image),
          );
          String newPhotoUrl = response.secureUrl;
          await _updateUserData({'photoUrl': newPhotoUrl});
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error al subir la foto: $e')),
          );
          print('Error al subir la foto: $e');
        } finally {
          setState(() {
            _isLoadingPhoto = false;
          });
        }
      }
    }
  }

  Future<void> _logout() async {
    bool? confirmLogout = await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Cerrar sesión'),
          content: Text('¿Estás seguro de que quieres cerrar sesión?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text('Cerrar sesión'),
            ),
          ],
        );
      },
    );

    if (confirmLogout == true) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.clear();
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
        (Route<dynamic> route) => false,
      );
    }
  }

  void _onTap(int index) {
    setState(() {
      _currentIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => AdminHomeScreen()),
        );
        break;
      case 1:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => AdminRutinsScreen()),
        );
        break;
      case 2:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => ChallengesScreenAdmin()),
        );
        break;
      case 3:
        break;
    }
  }

  void _editUserData() {
    final TextEditingController nameController =
        TextEditingController(text: name);
    final TextEditingController emailController =
        TextEditingController(text: email);
    final TextEditingController passwordController = TextEditingController();
    final TextEditingController confirmPasswordController =
        TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Editar datos'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(labelText: 'Nombre'),
                ),
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(labelText: 'Correo'),
                  keyboardType: TextInputType.emailAddress,
                ),
                TextField(
                  controller: passwordController,
                  decoration: InputDecoration(
                      labelText: 'Contraseña (mín. 8 caracteres)'),
                  obscureText: true,
                ),
                TextField(
                  controller: confirmPasswordController,
                  decoration:
                      InputDecoration(labelText: 'Confirmar contraseña'),
                  obscureText: true,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () async {
                String? password = passwordController.text.isNotEmpty
                    ? passwordController.text
                    : null;
                String confirmPassword = confirmPasswordController.text;

                if (password != null) {
                  if (password.length < 8) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text(
                              'La contraseña debe tener al menos 8 caracteres')),
                    );
                    return;
                  }
                  if (password != confirmPassword) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Las contraseñas no coinciden')),
                    );
                    return;
                  }
                }

                final updatedData = {
                  'name': nameController.text,
                  'email': emailController.text,
                };

                if (password != null) {
                  updatedData['password'] = password;
                }

                await _updateUserData(updatedData);
                Navigator.pop(context);
              },
              child: Text('Guardar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2B192E),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 40.0, bottom: 16.0),
                child: Column(
                  children: [
                    Stack(
                      alignment:
                          Alignment.center, // Centra todos los hijos del Stack
                      children: [
                        // Círculo de fondo claro más grande
                        Container(
                          width:
                              110, // Tamaño más grande que el CircleAvatar (radius: 50 -> diámetro 100)
                          height: 110,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color:
                                Color(0xFFf8e1ff), // Color claro de referencia
                          ),
                        ),
                        // CircleAvatar con la foto de perfil
                        CircleAvatar(
                          radius: 50,
                          backgroundImage: photoUrl != null
                              ? NetworkImage(photoUrl!)
                              : const AssetImage('images/admin.jpg')
                                  as ImageProvider,
                          backgroundColor: Colors.grey,
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: GestureDetector(
                            onTap: _pickAndUploadPhoto,
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: Colors.purple,
                                shape: BoxShape.circle,
                                border:
                                    Border.all(color: Colors.white, width: 2),
                              ),
                              child: _isLoadingPhoto
                                  ? const CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    )
                                  : const Icon(
                                      Icons.camera_alt,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Text(
                      "Nivel: Administrador",
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      email,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Card(
                color: Color(0xFFF8E1FF),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Información Personal",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildUserDetail(
                              "Edad", age > 0 ? "$age años" : "Cargando..."),
                          _buildUserDetail("Peso",
                              weight > 0 ? "$weight kg" : "Cargando..."),
                          _buildUserDetail(
                              "Altura",
                              height > 0
                                  ? "${height.toStringAsFixed(2)} m"
                                  : "Cargando..."),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              _buildOptionButton(
                icon: Icons.edit,
                text: "Editar datos",
                onPressed: _editUserData,
              ),
              const SizedBox(height: 8),
              _buildOptionButton(
                icon: Icons.assessment,
                text: "Actualizar encuesta",
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => GymSurveyScreen(userEmail: email),
                    ),
                  );
                },
              ),
              const SizedBox(height: 8),
              _buildOptionButton(
                icon: Icons.group,
                text: "Gestión de usuarios",
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => UsersScreenAdmin()),
                  );
                },
              ),
              const SizedBox(height: 8),
              _buildOptionButton(
                icon: Icons.logout,
                text: "Cerrar sesión",
                onPressed: _logout,
                color: Colors.red,
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavbarAdmin(
        currentIndex: _currentIndex,
        onTap: _onTap,
      ),
    );
  }

  Widget _buildUserDetail(String title, String value) {
    return Column(
      children: [
        Text(
          title,
          style: const TextStyle(color: Colors.black, fontSize: 14),
        ),
        Text(
          value,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildOptionButton({
    required IconData icon,
    required String text,
    required VoidCallback onPressed,
    Color? color,
  }) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, color: Colors.white),
        label: Text(
          text,
          style: const TextStyle(color: Colors.white),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: color ?? const Color.fromARGB(255, 121, 53, 160),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(vertical: 12),
        ),
      ),
    );
  }
}
