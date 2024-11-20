import 'package:flutter/material.dart';

class ProgressScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0a0322), // Fondo personalizado
      appBar: AppBar(
        backgroundColor: Color(0xFFF5EDE4), // Beige personalizado
        title: Text(
          'Feed Deportivo',
          style: TextStyle(color: Colors.black), // Texto negro para contraste
        ),
        iconTheme: IconThemeData(color: Colors.black), // Iconos negros
      ),
      body: Sportsfeed(),
    );
  }
}

class Sportsfeed extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.all(0),
      children: <Widget>[
        // Publicación 1
        Padding(
          padding: const EdgeInsets.only(bottom: 20.0),
          child: Column(
            children: <Widget>[
              // Cabecera
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        ClipOval(
                          child: Image.network(
                            'https://images.imagenmia.com/example_images/1727263116410-0a082c11-3b97-4a26-826c-d0814d559ced.webp', // Cambia la URL de la imagen
                            width: 50.0,
                            height: 50.0,
                            fit: BoxFit.cover,
                          ),
                        ),
                        SizedBox(width: 13.0),
                        Text(
                          'silvi', // Cambia el nombre
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white, // Texto blanco
                          ),
                        ),
                      ],
                    ),
                    Icon(Icons.more_vert, color: Colors.white), // Icono blanco
                  ],
                ),
              ),

              // Imagen del post
              Container(
                margin: EdgeInsets.symmetric(horizontal: 15.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.5),
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.network(
                    'https://images.imagenmia.com/example_images/1727263135338-f100241e-8113-4e5c-b4e5-b7b6103a6412.webp', // Cambia la URL de la imagen
                  ),
                ),
              ),

              Padding(
  padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
  child: Row(
    crossAxisAlignment: CrossAxisAlignment.center, // Centra verticalmente
    children: <Widget>[
      // Columna con el ícono de corazón
      Column(
        crossAxisAlignment: CrossAxisAlignment.start, // Alinea el ícono a la izquierda
        children: [
          Align(
            alignment: Alignment.centerLeft, // Asegura que el ícono esté a la izquierda
            child: Icon(Icons.favorite_border, size: 35.0, color: Colors.white), // Icono blanco
          ),
          SizedBox(height: 8.0),
          Text(
            'Amo este lugar', // Cambia el texto
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
      // Icono de "guardar" (save) alineado a la derecha
      Spacer(), // Esto asegura que el ícono de save se alinee a la derecha
      Icon(Icons.save_alt, size: 35.0, color: Colors.white), // Icono blanco
    ],
  ),
),


              // Likes
              Row(
                children: <Widget>[
                  SizedBox(width: 15.0),
                  ClipOval(
                    child: Image.network(
                      'https://images.imagenmia.com/example_images/1727263116410-0a082c11-3b97-4a26-826c-d0814d559ced.webp', // Cambia la URL de la imagen
                      width: 25.0,
                      height: 25.0,
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(width: 15.0),
                  Text(
                    'Les gusta a ',
                    style: TextStyle(color: Colors.white),
                  ),
                  SizedBox(width: 5.0),
                  Text(
                    'Paula13', // Cambia el nombre
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white, // Texto blanco
                    ),
                  ),
                  SizedBox(width: 5.0),
                  Text(
                    'y',
                    style: TextStyle(color: Colors.white),
                  ),
                  SizedBox(width: 5.0),
                  Text(
                    '1,000 más', // Cambia el número
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white, // Texto blanco
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        // Publicación 2 (Repite el bloque con contenido diferente)
        Padding(
          padding: const EdgeInsets.only(bottom: 20.0),
          child: Column(
            children: <Widget>[
              // Cabecera
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        ClipOval(
                          child: Image.network(
                            'https://images.imagenmia.com/example_images/1727263130989-3c4e81d3-a3c9-41c5-86e2-79d8dd5bf716.webp', // Cambia la URL de la imagen
                            width: 50.0,
                            height: 50.0,
                            fit: BoxFit.cover,
                          ),
                        ),
                        SizedBox(width: 13.0),
                        Text(
                          'juanp', // Cambia el nombre
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white, // Texto blanco
                          ),
                        ),
                      ],
                    ),
                    Icon(Icons.more_vert, color: Colors.white), // Icono blanco
                  ],
                ),
              ),

              // Imagen del post
              Container(
                margin: EdgeInsets.symmetric(horizontal: 15.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.5),
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.network(
                    'https://images.imagenmia.com/example_images/1727263130191-f1388700-d7a8-486b-a421-749f0aa342d8.webp', // Cambia la URL de la imagen
                  ),
                ),
              ),

             Padding(
  padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
  child: Row(
    crossAxisAlignment: CrossAxisAlignment.center, // Centra verticalmente
    children: <Widget>[
      // Columna con el ícono de corazón
      Column(
        crossAxisAlignment: CrossAxisAlignment.start, // Alinea el ícono a la izquierda
        children: [
          Align(
            alignment: Alignment.centerLeft, // Asegura que el ícono esté a la izquierda
            child: Icon(Icons.favorite_border, size: 35.0, color: Colors.white), // Icono blanco
          ),
          SizedBox(height: 8.0),
          Text(
            'Segunda casa', // Cambia el texto
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
      // Icono de "guardar" (save) alineado a la derecha
      Spacer(), // Esto asegura que el ícono de save se alinee a la derecha
      Icon(Icons.save_alt, size: 35.0, color: Colors.white), // Icono blanco
    ],
  ),
),

              // Likes
              Row(
                children: <Widget>[
                  SizedBox(width: 15.0),
                  ClipOval(
                    child: Image.network(
                      'https://images.imagenmia.com/example_images/1727263085173-51b6593f-2436-4e85-9747-549c93f13b53.webp', // Cambia la URL de la imagen
                      width: 25.0,
                      height: 25.0,
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(width: 15.0),
                  Text(
                    'Les gusta a ',
                    style: TextStyle(color: Colors.white),
                  ),
                  SizedBox(width: 5.0),
                  Text(
                    'Juana', // Cambia el nombre
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white, // Texto blanco
                    ),
                  ),
                  SizedBox(width: 5.0),
                  Text(
                    'y',
                    style: TextStyle(color: Colors.white),
                  ),
                  SizedBox(width: 5.0),
                  Text(
                    '500 más', // Cambia el número
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white, // Texto blanco
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

          // Publicación 3 (Repite el bloque con contenido diferente)
        Padding(
          padding: const EdgeInsets.only(bottom: 20.0),
          child: Column(
            children: <Widget>[
              // Cabecera
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        ClipOval(
                          child: Image.network(
                            'https://images.imagenmia.com/example_images/1727263112983-76ad98f2-2d8c-4d35-b494-229a6b410348.webp', // Cambia la URL de la imagen
                            width: 50.0,
                            height: 50.0,
                            fit: BoxFit.cover,
                          ),
                        ),
                        SizedBox(width: 13.0),
                        Text(
                          'Andrea_fit', // Cambia el nombre
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white, // Texto blanco
                          ),
                        ),
                      ],
                    ),
                    Icon(Icons.more_vert, color: Colors.white), // Icono blanco
                  ],
                ),
              ),

              // Imagen del post
              Container(
                margin: EdgeInsets.symmetric(horizontal: 15.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.5),
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.network(
                    'https://images.imagenmia.com/example_images/1727263115721-66c83754-e3e3-4010-803a-e98ee19f35a5.webp', // Cambia la URL de la imagen
                  ),
                ),
              ),

             Padding(
  padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
  child: Row(
    crossAxisAlignment: CrossAxisAlignment.center, // Centra verticalmente
    children: <Widget>[
      // Columna con el ícono de corazón
      Column(
        crossAxisAlignment: CrossAxisAlignment.start, // Alinea el ícono a la izquierda
        children: [
          Align(
            alignment: Alignment.centerLeft, // Asegura que el ícono esté a la izquierda
            child: Icon(Icons.favorite_border, size: 35.0, color: Colors.white), // Icono blanco
          ),
          SizedBox(height: 8.0),
          Text(
            'Cada esfuerzo vale', // Cambia el texto
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
      // Icono de "guardar" (save) alineado a la derecha
      Spacer(), // Esto asegura que el ícono de save se alinee a la derecha
      Icon(Icons.save_alt, size: 35.0, color: Colors.white), // Icono blanco
    ],
  ),
),

              // Likes
              Row(
                children: <Widget>[
                  SizedBox(width: 15.0),
                  ClipOval(
                    child: Image.network(
                      'https://images.imagenmia.com/example_images/1727263054930-bc442f12-c2bd-4549-9959-5e825434ad06.webp', // Cambia la URL de la imagen
                      width: 25.0,
                      height: 25.0,
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(width: 15.0),
                  Text(
                    'Les gusta a ',
                    style: TextStyle(color: Colors.white),
                  ),
                  SizedBox(width: 5.0),
                  Text(
                    'Andres', // Cambia el nombre
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white, // Texto blanco
                    ),
                  ),
                  SizedBox(width: 5.0),
                  Text(
                    'y',
                    style: TextStyle(color: Colors.white),
                  ),
                  SizedBox(width: 5.0),
                  Text(
                    '967 más', // Cambia el número
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white, // Texto blanco
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
