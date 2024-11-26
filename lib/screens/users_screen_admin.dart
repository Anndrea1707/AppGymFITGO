import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UsersScreenAdmin extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0322),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF5EDE4),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () {
                Navigator.pop(context); // Volver a la página anterior
              },
            ),
            const Text(
              'Usuarios Registrados',
              style: TextStyle(color: Colors.black),
            ),
          ],
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('usuarios')
                    .snapshots(),
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

                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      border: TableBorder.all(color: Colors.purple),
                      columnSpacing: 16.0,
                      headingRowColor:
                          MaterialStateProperty.all(Colors.purple.shade700),
                      columns: const [
                        DataColumn(
                          label: Text(
                            'Nombre',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'Edad',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'Email',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'Rol',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'Eliminar',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'Editar',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                      rows: users.map((user) {
                        final Map<String, dynamic> userData =
                            user.data() as Map<String, dynamic>;

                        return DataRow(
                          cells: [
                            DataCell(Text(
                              userData['name'] ?? 'Sin nombre',
                              style: const TextStyle(color: Colors.white),
                            )),
                            DataCell(Text(
                              userData['age']?.toString() ?? 'N/A',
                              style: const TextStyle(color: Colors.white),
                            )),
                            DataCell(Text(
                              userData['email'] ?? 'Sin email',
                              style: const TextStyle(color: Colors.white),
                            )),
                            DataCell(Text(
                              userData['role'] ?? 'Sin rol',
                              style: const TextStyle(color: Colors.white),
                            )),
                            DataCell(
                              IconButton(
                                icon:
                                    const Icon(Icons.delete, color: Colors.red),
                                onPressed: () async {
                                  await FirebaseFirestore.instance
                                      .collection('usuarios')
                                      .doc(user.id)
                                      .delete();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text('Usuario eliminado')),
                                  );
                                },
                              ),
                            ),
                            DataCell(IconButton(
                                icon:
                                    const Icon(Icons.edit, color: Colors.blue),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => AddUserScreen(
                                        userId: user
                                            .id, // Pasa el userId para editar
                                      ),
                                    ),
                                  );
                                }))
                          ],
                        );
                      }).toList(),
                    ),
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
                backgroundColor:
                    Colors.purple, // Cambiado de 'primary' a 'backgroundColor'
              ),
              child: const Text(
                'Agregar Usuario',
                style: TextStyle(color: Colors.white),
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

  final String?
      userId; // Este parámetro es para identificar el usuario a editar (si es necesario)

  // Constructor para agregar o editar un usuario
  AddUserScreen({Key? key, this.userId}) : super(key: key);

  // Cargar los datos del usuario en el formulario (solo si estamos editando un usuario)
  Future<void> loadUserData() async {
    if (userId != null) {
      // Si el ID del usuario no es nulo, es que estamos editando un usuario existente
      final doc = await FirebaseFirestore.instance
          .collection('usuarios')
          .doc(userId)
          .get();
      final userData = doc.data() as Map<String, dynamic>;

      // Cargar los datos en los campos
      nameController.text = userData['name'] ?? '';
      emailController.text = userData['email'] ?? '';
      roleController.text = userData['role'] ?? '';
      // No cargamos la contraseña, ya que no debe ser editable
      // passwordController.text = userData['password'] ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    // Cargar los datos del usuario cuando la pantalla se construye
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
                // Validación de campos vacíos
                if (nameController.text.isEmpty ||
                    emailController.text.isEmpty ||
                    roleController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Por favor completa todos los campos')),
                  );
                  return;
                }

                final userData = {
                  'name': nameController.text,
                  'email': emailController.text,
                  'role': roleController.text,
                  // No agregamos la contraseña aquí, solo los datos editables
                  // 'password': passwordController.text, // Omitido en este caso
                };

                if (userId == null) {
                  // Si no hay userId, estamos agregando un nuevo usuario
                  await FirebaseFirestore.instance
                      .collection('usuarios')
                      .add(userData);
                } else {
                  // Si hay userId, estamos editando un usuario
                  await FirebaseFirestore.instance
                      .collection('usuarios')
                      .doc(userId)
                      .update(userData);
                }

                // Volver a la pantalla anterior
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple, // Estilo del botón
              ),
              child: Text(
                userId == null ? 'Guardar Usuario' : 'Guardar Cambios',
                style: const TextStyle(color: Colors.white),
              ),
            )
          ],
        ),
      ),
    );
  }
}
