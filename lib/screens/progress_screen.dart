import 'package:flutter/material.dart';

void main() => runApp(MaterialApp(home: ProgressScreen()));

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
        PostWidget(
          userName: 'silvi',
          userImage: 'https://images.imagenmia.com/example_images/1727263116410-0a082c11-3b97-4a26-826c-d0814d559ced.webp',
          postImage: 'https://images.imagenmia.com/example_images/1727263135338-f100241e-8113-4e5c-b4e5-b7b6103a6412.webp',
          postText: 'Amo este lugar',
          likesText: 'Les gusta a Paula13 y 1,000 más',
        ),

        // Publicación 2
        PostWidget(
          userName: 'juanp',
          userImage: 'https://images.imagenmia.com/example_images/1727263130989-3c4e81d3-a3c9-41c5-86e2-79d8dd5bf716.webp',
          postImage: 'https://images.imagenmia.com/example_images/1727263130191-f1388700-d7a8-486b-a421-749f0aa342d8.webp',
          postText: 'Segunda casa',
          likesText: 'Les gusta a Juana y 500 más',
        ),

        // Publicación 3
        PostWidget(
          userName: 'Andrea_fit',
          userImage: 'https://images.imagenmia.com/example_images/1727263112983-76ad98f2-2d8c-4d35-b494-229a6b410348.webp',
          postImage: 'https://images.imagenmia.com/example_images/1727263115721-66c83754-e3e3-4010-803a-e98ee19f35a5.webp',
          postText: 'Cada esfuerzo vale',
          likesText: 'Les gusta a Andres y 967 más',
        ),
      ],
    );
  }
}

class PostWidget extends StatefulWidget {
  final String userName;
  final String userImage;
  final String postImage;
  final String postText;
  final String likesText;

  PostWidget({
    required this.userName,
    required this.userImage,
    required this.postImage,
    required this.postText,
    required this.likesText,
  });

  @override
  _PostWidgetState createState() => _PostWidgetState();
}

class _PostWidgetState extends State<PostWidget> {
  bool _isFavorite = false;

  void _toggleFavorite() {
    setState(() {
      _isFavorite = !_isFavorite;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
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
                        widget.userImage,
                        width: 50.0,
                        height: 50.0,
                        fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(width: 13.0),
                    Text(
                      widget.userName,
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                Icon(Icons.more_vert, color: Colors.white),
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
                widget.postImage,
              ),
            ),
          ),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                // Columna con el ícono de corazón
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: IconButton(
                        icon: Icon(
                          _isFavorite ? Icons.favorite : Icons.favorite_border,
                          size: 35.0,
                          color: _isFavorite ? Colors.red : Colors.white,
                        ),
                        onPressed: _toggleFavorite,
                      ),
                    ),
                    SizedBox(height: 8.0),
                    Text(
                      widget.postText,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                Spacer(),
                Icon(Icons.save_alt, size: 35.0, color: Colors.white),
              ],
            ),
          ),

          // Likes
          Row(
            children: <Widget>[
              SizedBox(width: 15.0),
              ClipOval(
                child: Image.network(
                  widget.userImage,
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
                widget.likesText.split(' y ')[0],
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(width: 5.0),
              Text(
                'y',
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(width: 5.0),
              Text(
                widget.likesText.split(' y ')[1],
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
