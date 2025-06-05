import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gym_fitgo/screens/home_screen.dart';
import 'package:gym_fitgo/screens/challenges_screen.dart';
import 'package:gym_fitgo/screens/rutinas_screen.dart';
import 'package:gym_fitgo/screens/gym_suvery_screen.dart';
import 'package:gym_fitgo/screens/login_screen.dart';
import 'package:gym_fitgo/widgets/custom_bottom_navbar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:image_picker/image_picker.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int _currentIndex = 3;
  String name = 'Cargando...';
  int age = 0;
  double weight = 0.0;
  double height = 0.0;
  String email = '';
  String? gender;
  String? limitation;
  String? goal;
  String? profileImageUrl;
  bool _isLoadingPhoto = false;
  List<Map<String, dynamic>> participatingChallenges = [];
  List<String> selectedTrainingDays = [];

  final CloudinaryPublic cloudinary = CloudinaryPublic('dycjb5ovf', 'FitgoApp', cache: false);

  @override
  void initState() {
    super.initState();
    _loadUserEmail();
  }

  Future<void> _loadUserEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? storedEmail = prefs.getString('user_email');
    if (storedEmail != null && storedEmail.isNotEmpty) {
      setState(() {
        email = storedEmail;
      });
      await _loadUserData();
    } else {
      setState(() {
        name = 'No se encontró sesión';
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No se encontró el email del usuario')),
      );
    }
  }

  Future<void> _loadUserData() async {
    try {
      QuerySnapshot userDoc = await FirebaseFirestore.instance
          .collection('usuarios')
          .where('email', isEqualTo: email)
          .get();

      if (userDoc.docs.isNotEmpty) {
        var data = userDoc.docs.first.data() as Map<String, dynamic>;
        setState(() {
          name = data['name']?.toString() ?? 'Sin nombre';
          age = data['age'] != null ? int.tryParse(data['age'].toString()) ?? 0 : 0;
          weight = data['weight'] != null ? double.tryParse(data['weight'].toString()) ?? 0.0 : 0.0;
          height = data['height'] != null ? (double.tryParse(data['height'].toString()) ?? 0.0) / 100 : 0.0;
          gender = data['gender'] != null ? data['gender'].toString() : null;
          limitation = data['limitation'] != null ? data['limitation'].toString() : null;
          goal = data['goal'] != null ? data['goal'].toString() : null;
          profileImageUrl = data['image']?.toString();
          selectedTrainingDays = List<String>.from(data['trainingDays'] ?? []);
        });

        // Cargar retos participando
        List<dynamic> participatingChallengesData = data['participatingChallenges'] ?? [];
        if (participatingChallengesData.isNotEmpty) {
          List<String> challengeIds = participatingChallengesData
              .where((entry) => entry is Map && entry['challengeId'] != null)
              .map((entry) => entry['challengeId'].toString())
              .toList();

          Map<String, String> joinDates = {
            for (var entry in participatingChallengesData.where((e) => e is Map))
              entry['challengeId'].toString(): entry['joinDate'].toString()
          };

          if (challengeIds.isNotEmpty) {
            QuerySnapshot challengesSnapshot = await FirebaseFirestore.instance
                .collection('Retos')
                .where(FieldPath.documentId, whereIn: challengeIds)
                .get();

            setState(() {
              participatingChallenges = challengesSnapshot.docs.map((doc) {
                var challengeData = doc.data() as Map<String, dynamic>;
                String joinDate = joinDates[doc.id] ?? 'Sin fecha';
                try {
                  DateTime parsedDate = DateTime.parse(joinDate);
                  joinDate = "${parsedDate.day}/${parsedDate.month}/${parsedDate.year}";
                } catch (e) {
                  joinDate = 'Fecha inválida';
                }
                return {
                  'name': challengeData['name']?.toString() ?? 'Sin nombre',
                  'duration': challengeData['duration']?.toString() ?? '0',
                  'joinDate': joinDate,
                };
              }).toList();
            });
          } else {
            setState(() {
              participatingChallenges = [];
            });
          }
        } else {
          setState(() {
            participatingChallenges = [];
          });
        }
      } else {
        setState(() {
          name = 'No se encontraron datos';
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No se encontraron datos para este email ($email) en Firestore.')),
        );
      }
    } catch (e) {
      setState(() {
        name = 'Error al cargar';
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al cargar datos: $e')),
      );
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
        await _loadUserData();
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al actualizar datos: $e')),
      );
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
            title: const Text('Confirmar cambio de foto'),
            content: const Text('¿Estás seguro de que quieres cambiar tu foto de perfil?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancelar'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('Confirmar'),
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
            CloudinaryFile.fromFile(image.path, resourceType: CloudinaryResourceType.Image),
          );
          String newPhotoUrl = response.secureUrl;
          await _updateUserData({'image': newPhotoUrl});
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error al subir la foto: $e')),
          );
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
          title: const Text('Cerrar sesión'),
          content: const Text('¿Estás seguro de que quieres cerrar sesión?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Cerrar sesión'),
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
    if (index != _currentIndex) {
      setState(() {
        _currentIndex = index;
      });
      switch (index) {
        case 0:
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => HomeScreen()));
          break;
        case 1:
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => RutinasScreen()));
          break;
        case 2:
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => ChallengesScreen()));
          break;
        case 3:
          break;
      }
    }
  }

  void _selectTrainingDays() {
    List<String> daysOfWeek = ['Lunes', 'Martes', 'Miércoles', 'Jueves', 'Viernes', 'Sábado', 'Domingo'];
    List<String> tempSelectedDays = List.from(selectedTrainingDays);

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Seleccionar días de entrenamiento'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: daysOfWeek.map((day) {
                    return CheckboxListTile(
                      title: Text(day),
                      value: tempSelectedDays.contains(day),
                      onChanged: (bool? value) {
                        setDialogState(() {
                          if (value == true) {
                            tempSelectedDays.add(day);
                          } else {
                            tempSelectedDays.remove(day);
                          }
                        });
                      },
                    );
                  }).toList(),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancelar'),
                ),
                TextButton(
                  onPressed: () async {
                    setState(() {
                      selectedTrainingDays = tempSelectedDays;
                    });
                    await _updateUserData({'trainingDays': selectedTrainingDays});
                    Navigator.pop(context);
                  },
                  child: const Text('Guardar'),
                ),
              ],
            );
          },
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
                      alignment: Alignment.center,
                      children: [
                        Container(
                          width: 90,
                          height: 90,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xFFF8E1FF),
                          ),
                        ),
                        CircleAvatar(
                          radius: 40,
                          backgroundImage: profileImageUrl != null && profileImageUrl!.isNotEmpty
                              ? NetworkImage(profileImageUrl!)
                              : const NetworkImage('https://cdn-icons-png.flaticon.com/512/3135/3135768.png'),
                          onBackgroundImageError: (exception, stackTrace) {
                            setState(() {
                              profileImageUrl = null;
                            });
                          },
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: GestureDetector(
                            onTap: _pickAndUploadPhoto,
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: const Color(0xFF7A0180),
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.white, width: 2),
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
                          fontWeight: FontWeight.bold),
                    ),
                    const Text(
                      "Nivel: principiante",
                      style: TextStyle(color: Colors.white70, fontSize: 16),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildUserDetail("Edad", age > 0 ? "$age años" : "Cargando..."),
                  _buildUserDetail("Peso", weight > 0 ? "$weight kg" : "Cargando..."),
                  _buildUserDetail("Altura", height > 0 ? "${height.toStringAsFixed(2)} m" : "Cargando..."),
                  _buildUserDetail("Fecha inicio", "03/03/2024"),
                ],
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => GymSurveyScreen(userEmail: email),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF7A0180),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text("Actualizar", style: TextStyle(color: Colors.white)),
              ),
              const SizedBox(height: 24),
              _buildSection("Retos participación"),
              const SizedBox(height: 16),
              _buildTrainingDaysSection(),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _logout,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text("Cerrar sesión", style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _currentIndex,
        onTap: _onTap,
      ),
    );
  }

  Widget _buildUserDetail(String title, String value) {
    return Column(
      children: [
        Text(title, style: const TextStyle(color: Colors.white70, fontSize: 14)),
        Text(value,
            style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildSection(String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        participatingChallenges.isEmpty
            ? const Text(
                'No hay retos en los que estés participando actualmente.',
                style: TextStyle(color: Colors.white70, fontSize: 14),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: participatingChallenges.map((challenge) {
                  return _buildCard(
                    challenge['name'],
                    'Días de duración: ${challenge['duration']}',
                    'Fecha de unión: ${challenge['joinDate']}',
                  );
                }).toList(),
              ),
      ],
    );
  }

  Widget _buildTrainingDaysSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Días de entrenamiento',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.white),
              onPressed: _selectTrainingDays,
            ),
          ],
        ),
        const SizedBox(height: 8),
        selectedTrainingDays.isEmpty
            ? const Text(
                'No has seleccionado días de entrenamiento.',
                style: TextStyle(color: Colors.white70, fontSize: 14),
              )
            : Wrap(
                spacing: 8.0,
                runSpacing: 4.0,
                children: selectedTrainingDays.map((day) {
                  return Chip(
                    label: Text(day, style: const TextStyle(color: Color(0xFF2B192E))),
                    backgroundColor: const Color(0xFFF8E1FF),
                  );
                }).toList(),
              ),
      ],
    );
  }

  Widget _buildCard(String title, String duration, String joinDate) {
    return Container(
      width: 150,
      decoration: BoxDecoration(
          color: const Color(0xFFF8E1FF),
          borderRadius: BorderRadius.circular(12)),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(
                  color: Color(0xFF2B192E),
                  fontSize: 14,
                  fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(duration, style: const TextStyle(color: Color.fromARGB(255, 43, 25, 46), fontSize: 12)),
          const SizedBox(height: 4),
          Text(joinDate, style: const TextStyle(color: Color.fromARGB(255, 43, 25, 46), fontSize: 12)),
        ],
      ),
    );
  }
}