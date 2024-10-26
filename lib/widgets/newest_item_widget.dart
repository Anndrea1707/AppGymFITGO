import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class NewestItemWidget extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // Alinea todo el contenido a la izquierda
          children: [

            //Single Item
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Container(
                width: 380,
                height: 150,
                decoration: BoxDecoration(
                  color: Color(0xFFF5EDE4),
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 3,
                      blurRadius: 10,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start, // Alinea los elementos dentro de la fila a la parte superior
                  children: [
                    InkWell(
                      onTap: (){
                         Navigator.pushNamed(context, "itemPage");
                      },
                      child: Container(
                        alignment: Alignment.center,
                        child: Image.asset(
                          "images/omelet.jpeg", 
                          height: 120, 
                          width: 150,
                        ), 
                      ),
                    ),
                    SizedBox(width: 10), // Espacio entre imagen y texto
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start, // Alinea el contenido de la columna a la izquierda
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(
                            "Omelet", 
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "Omletet de huevos con tocinita, perfecto para tu desayuno", 
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                          RatingBar.builder(
                            initialRating: 4,
                            minRating: 1,
                            direction: Axis.horizontal,
                            itemCount: 5,
                            itemSize: 18,
                            itemPadding: EdgeInsets.symmetric(horizontal: 4),
                            itemBuilder: (context, _) => Icon(
                              Icons.star, 
                              color: Colors.yellow,
                            ),
                            onRatingUpdate: (index){},
                          ),
                          Text(
                            "Pr. 11gr", 
                            style: TextStyle(
                              fontSize: 20, 
                              color: Colors.black, 
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Icon(
                        Icons.favorite_border, 
                        color: Colors.black,
                        size: 26,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            //Single Item
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Container(
                width: 380,
                height: 150,
                decoration: BoxDecoration(
                  color: Color(0xFFF5EDE4),
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 3,
                      blurRadius: 10,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start, // Alinea los elementos dentro de la fila a la parte superior
                  children: [
                    InkWell(
                      onTap: (){
                         Navigator.pushNamed(context, "itemPage");
                      },
                      child: Container(
                        alignment: Alignment.center,
                        child: Image.asset(
                          "images/receta_lentejas.jpg", 
                          height: 120, 
                          width: 150,
                        ), 
                      ),
                    ),
                    SizedBox(width: 10), // Espacio entre imagen y texto
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start, // Alinea el contenido de la columna a la izquierda
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(
                            "Ensalada", 
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "Ensalada de lentejas, con aguacate", 
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                          RatingBar.builder(
                            initialRating: 4,
                            minRating: 1,
                            direction: Axis.horizontal,
                            itemCount: 5,
                            itemSize: 18,
                            itemPadding: EdgeInsets.symmetric(horizontal: 4),
                            itemBuilder: (context, _) => Icon(
                              Icons.star, 
                              color: Colors.yellow,
                            ),
                            onRatingUpdate: (index){},
                          ),
                          Text(
                            "Pr. 20gr", 
                            style: TextStyle(
                              fontSize: 20, 
                              color: Colors.black, 
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Icon(
                        Icons.favorite_border, 
                        color: Colors.black,
                        size: 26,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            //Single Item
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Container(
                width: 380,
                height: 150,
                decoration: BoxDecoration(
                  color: Color(0xFFF5EDE4),
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 3,
                      blurRadius: 10,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start, // Alinea los elementos dentro de la fila a la parte superior
                  children: [
                    InkWell(
                      onTap: (){
                         Navigator.pushNamed(context, "itemPage");
                      },
                      child: Container(
                        alignment: Alignment.center,
                        child: Image.asset(
                          "images/receta_pechuga.jpeg", 
                          height: 120, 
                          width: 150,
                        ), 
                      ),
                    ),
                    SizedBox(width: 10), // Espacio entre imagen y texto
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start, // Alinea el contenido de la columna a la izquierda
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(
                            "Pechuga", 
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "Pechuga en salsa, acompañada de arroz", 
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                          RatingBar.builder(
                            initialRating: 4,
                            minRating: 1,
                            direction: Axis.horizontal,
                            itemCount: 5,
                            itemSize: 18,
                            itemPadding: EdgeInsets.symmetric(horizontal: 4),
                            itemBuilder: (context, _) => Icon(
                              Icons.star, 
                              color: Colors.yellow,
                            ),
                            onRatingUpdate: (index){},
                          ),
                          Text(
                            "Pr. 117gr", 
                            style: TextStyle(
                              fontSize: 20, 
                              color: Colors.black, 
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Icon(
                        Icons.favorite_border, 
                        color: Colors.black,
                        size: 26,
                      ),
                    ),
                  ],
                ),
              ),
            ),



            //Single Item
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Container(
                width: 380,
                height: 150,
                decoration: BoxDecoration(
                  color: Color(0xFFF5EDE4),
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 3,
                      blurRadius: 10,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start, // Alinea los elementos dentro de la fila a la parte superior
                  children: [
                    InkWell(
                      onTap: (){
                         Navigator.pushNamed(context, "itemPage");
                      },
                      child: Container(
                        alignment: Alignment.center,
                        child: Image.asset(
                          "images/receta_carne.jpg", 
                          height: 120, 
                          width: 150,
                        ), 
                      ),
                    ),
                    SizedBox(width: 10), // Espacio entre imagen y texto
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start, // Alinea el contenido de la columna a la izquierda
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(
                            "Carne", 
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "Carne con verduras, gran idea de almuerzo", 
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                          RatingBar.builder(
                            initialRating: 4,
                            minRating: 1,
                            direction: Axis.horizontal,
                            itemCount: 5,
                            itemSize: 18,
                            itemPadding: EdgeInsets.symmetric(horizontal: 4),
                            itemBuilder: (context, _) => Icon(
                              Icons.star, 
                              color: Colors.yellow,
                            ),
                            onRatingUpdate: (index){},
                          ),
                          Text(
                            "Pr. 117gr", 
                            style: TextStyle(
                              fontSize: 20, 
                              color: Colors.black, 
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Icon(
                        Icons.favorite_border, 
                        color: Colors.black,
                        size: 26,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Similar structure for other items, ensure alignment properties are applied

            //Single Item 2
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Container(
                width: 380,
                height: 150,
                decoration: BoxDecoration(
                  color: Color(0xFFF5EDE4),
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 3,
                      blurRadius: 10,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: (){},
                      child: Container(
                        alignment: Alignment.topLeft,
                        child: Image.asset(
                          "images/receta_pollo.jpg", 
                          height: 120, 
                          width: 150,
                        ), 
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(
                            "Pollo", 
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "Pernil de pollo con papitas", 
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                          RatingBar.builder(
                            initialRating: 4,
                            minRating: 1,
                            direction: Axis.horizontal,
                            itemCount: 5,
                            itemSize: 18,
                            itemPadding: EdgeInsets.symmetric(horizontal: 4),
                            itemBuilder: (context, _) => Icon(
                              Icons.star, 
                              color: Colors.yellow,
                            ),
                            onRatingUpdate: (index){},
                          ),
                          Text(
                            "Pr. 48gr", 
                            style: TextStyle(
                              fontSize: 20, 
                              color: Colors.black, 
                              fontWeight: FontWeight.bold,
                            ),
                    ),
                ],
                ),
              ),

              Padding(
                        padding: EdgeInsets.symmetric(vertical: 10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Icon(Icons.favorite_border, 
                          color: Colors.black,
                          size: 26,)
                        ],
                        ),
                        ),
          ],),
          ),
        ),

         //Single Item
          
        Padding(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Container(width: 380, height: 150,
          decoration: BoxDecoration(
            color: Color(0xFFF5EDE4),
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 3,
                blurRadius: 10,
                offset: Offset(0, 3),
              ),
            ],),
          child: Row(
            children: [
            InkWell( 
              onTap: (){},
              child: Container(
                alignment: Alignment.center,
                child: Image.asset("images/almu_lente.jpg", 
                height: 120, 
                width: 150,
                ), 
              ),
              ),
              Container(
                width: 190,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      "Lentejas", 
                      style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                    ),

                    Text(
                      "Almuerzo casero de lentejas", 
                      style: TextStyle(
                      fontSize: 16,
                      //fontWeight: FontWeight.bold,
                    ),
                    ),

                    RatingBar.builder(
                      initialRating: 4,
                      minRating: 1,
                      direction: Axis.horizontal,
                      itemCount: 5,
                      itemSize: 18,
                      itemPadding: EdgeInsets.symmetric(horizontal: 4),
                      itemBuilder: (context, _) => Icon(Icons.star, color: Colors.yellow,
                      ),
                      onRatingUpdate: (index){},
                      ),

                      Text("Pr. 100gr", style: TextStyle(fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold
                      ),
                    ),
                ],
                ),
              ),

              Padding(
                        padding: EdgeInsets.symmetric(vertical: 10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Icon(Icons.favorite_border, 
                          color: Colors.black,
                          size: 26,)
                        ],
                        ),
                        ),
          ],),
          ),
        ),

         //Single Item
          
        Padding(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Container(width: 380, height: 150,
          decoration: BoxDecoration(
            color: Color(0xFFF5EDE4),
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 3,
                blurRadius: 10,
                offset: Offset(0, 3),
              ),
            ],),
          child: Row(
            children: [
            InkWell( 
              onTap: (){},
              child: Container(
                alignment: Alignment.center,
                child: Image.asset("images/receta_brocoli.jpg", 
                height: 120, 
                width: 150,
                ), 
              ),
              ),
              Container(
                width: 190,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      "Brocoli", 
                      style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                    ),

                    Text(
                      "Brocoli salteado con pimenton, zanahoria", 
                      style: TextStyle(
                      fontSize: 16,
                      //fontWeight: FontWeight.bold,
                    ),
                    ),

                    RatingBar.builder(
                      initialRating: 4,
                      minRating: 1,
                      direction: Axis.horizontal,
                      itemCount: 5,
                      itemSize: 18,
                      itemPadding: EdgeInsets.symmetric(horizontal: 4),
                      itemBuilder: (context, _) => Icon(Icons.star, color: Colors.yellow,
                      ),
                      onRatingUpdate: (index){},
                      ),

                      Text("Pr. 97gr", style: TextStyle(fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold
                      ),
                    ),
                ],
                ),
              ),

              Padding(
                        padding: EdgeInsets.symmetric(vertical: 10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Icon(Icons.favorite_border, 
                          color: Colors.black,
                          size: 26,)
                        ],
                        ),
                        ),
          ],),
          ),
        ),
      ],
      ),
      ),

    );

    
  }

}