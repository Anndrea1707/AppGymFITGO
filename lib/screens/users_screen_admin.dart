import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UsersScreenAdmin extends StatelessWidget {
  Future<void> _deleteUser(BuildContext context, String userId) async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Confirmar eliminación'),
          content: Text('¿Estás seguro de que deseas eliminar este usuario?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Cancelar
              },
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(context); // Cierra el diálogo
                try {
                  await FirebaseFirestore.instance
                      .collection('usuarios')
                      .doc(userId)
                      .delete();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Usuario eliminado')),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error al eliminar usuario: $e')),
                  );
                }
              },
              child: Text('Confirmar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0322),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF5EDE4),
        title: const Text(
          'Usuarios Registrados',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection('usuarios').snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(color: Colors.purple),
                    );
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(
                      child: Text(
                        'No hay usuarios registrados.',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    );
                  }

                  final users = snapshot.data!.docs;

                  return ListView.builder(
                    itemCount: users.length,
                    itemBuilder: (context, index) {
                      final Map<String, dynamic> userData = users[index].data() as Map<String, dynamic>;
                      final String userId = users[index].id;
                      final String? photoUrl = userData['photoUrl']; // Corregido a 'photoUrl' para coincidir con la captura

                      return Card(
                        color: const Color(0xFFF5EDE4),
                        margin: const EdgeInsets.symmetric(vertical: 8.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        elevation: 5,
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // Foto de perfil
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child: photoUrl != null && photoUrl.isNotEmpty
                                    ? Image.network(
                                        photoUrl,
                                        width: 60,
                                        height: 60,
                                        fit: BoxFit.cover,
                                        cacheWidth: 60,
                                        cacheHeight: 60,
                                        loadingBuilder: (context, child, loadingProgress) {
                                          if (loadingProgress == null) return child;
                                          return const SizedBox(
                                            width: 60,
                                            height: 60,
                                            child: Center(child: CircularProgressIndicator()),
                                          );
                                        },
                                        errorBuilder: (context, error, stackTrace) {
                                          print('Error al cargar la imagen. URL: $photoUrl, Error: $error');
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(content: Text('Error al cargar la foto: $error')),
                                          );
                                          return Image.network(
                                            'https://img.freepik.com/vector-gratis/circulo-azul-usuario-blanco_78370-4707.jpg?uid=R14880236&ga=GA1.1.742260549.1736050892&semt=ais_hybrid&w=740',
                                            width: 60,
                                            height: 60,
                                            fit: BoxFit.cover,
                                          );
                                        },
                                      )
                                    : Image.network(
                                        'https://img.freepik.com/vector-gratis/circulo-azul-usuario-blanco_78370-4707.jpg?uid=R14880236&ga=GA1.1.742260549.1736050892&semt=ais_hybrid&w=740',
                                        width: 60,
                                        height: 60,
                                        fit: BoxFit.cover,
                                      ),
                              ),
                              const SizedBox(width: 16.0),
                              // Información del usuario
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      userData['name'] ?? 'Sin nombre',
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 4.0),
                                    Text(
                                      'Edad: ${userData['age']?.toString() ?? 'N/A'}',
                                      style: const TextStyle(
                                        color: Colors.black54,
                                        fontSize: 14,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Text(
                                      'Email: ${userData['email'] ?? 'Sin email'}',
                                      style: const TextStyle(
                                        color: Colors.black54,
                                        fontSize: 14,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Text(
                                      'Rol: ${userData['role'] ?? 'Sin rol'}',
                                      style: const TextStyle(
                                        color: Colors.black54,
                                        fontSize: 14,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                              // Botones de acción
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.edit, color: Colors.blue),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => AddUserScreen(userId: userId),
                                        ),
                                      );
                                    },
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete, color: Colors.red),
                                    onPressed: () => _deleteUser(context, userId),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddUserScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              child: const Text(
                'Agregar Usuario',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AddUserScreen extends StatelessWidget {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController roleController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final String? userId;

  AddUserScreen({Key? key, this.userId}) : super(key: key);

  Future<void> loadUserData() async {
    if (userId != null) {
      final doc = await FirebaseFirestore.instance.collection('usuarios').doc(userId).get();
      final userData = doc.data() as Map<String, dynamic>;
      nameController.text = userData['name'] ?? '';
      emailController.text = userData['email'] ?? '';
      roleController.text = userData['role'] ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    loadUserData();

    return Scaffold(
      backgroundColor: const Color(0xFF0A0322),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF5EDE4),
        title: Text(
          userId == null ? 'Agregar Usuario' : 'Editar Usuario',
          style: const TextStyle(color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Nombre',
                labelStyle: TextStyle(color: Colors.white),
                border: OutlineInputBorder(),
              ),
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: 'Correo',
                labelStyle: TextStyle(color: Colors.white),
                border: OutlineInputBorder(),
              ),
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: roleController,
              decoration: const InputDecoration(
                labelText: 'Rol',
                labelStyle: TextStyle(color: Colors.white),
                border: OutlineInputBorder(),
              ),
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(
                labelText: 'Contraseña',
                labelStyle: TextStyle(color: Colors.white),
                border: OutlineInputBorder(),
              ),
              obscureText: true,
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                if (nameController.text.isEmpty ||
                    emailController.text.isEmpty ||
                    roleController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Por favor completa todos los campos')),
                  );
                  return;
                }

                final userData = {
                  'name': nameController.text,
                  'email': emailController.text,
                  'role': roleController.text,
                  'password': passwordController.text,
                  'photoUrl': '', // Placeholder, debería ser actualizado si se agrega funcionalidad de subida
                };

                if (userId == null) {
                  await FirebaseFirestore.instance.collection('usuarios').add(userData);
                } else {
                  await FirebaseFirestore.instance.collection('usuarios').doc(userId).update(userData);
                }
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple,
              ),
              child: Text(
                userId == null ? 'Guardar Usuario' : 'Guardar Cambios',
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}