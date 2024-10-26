import 'package:flutter/material.dart';

class PopularItemsWidget extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(padding: EdgeInsets.symmetric(vertical: 15, horizontal: 5),
      child: Row(children: [

         //for (int i=0; i<10; i++)
        //Single Item
       
        Padding(padding: EdgeInsets.symmetric(horizontal: 7),
        child: Container(
          width: 170,
          height: 270,
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
              ]),

              child: Padding(padding: EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                crossAxisAlignment:  CrossAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, "itemPage");
                    },
                    child: Container(
                      alignment: Alignment.center,
                      child: Image.asset("images/omelet.jpeg",
                      height: 130,
                      ),
                    ),
                  ),
                  Text("Omelet", style: TextStyle(
                    fontSize: 30, 
                    fontWeight: FontWeight.bold,
                  ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    "Omelet de huevo con tocineta",
                     style: TextStyle(
                    fontSize: 15, 
                    //fontWeight: FontWeight.bold,
                  ),
                  ),
                  SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Pr. 11gr", style: TextStyle(
                        fontSize: 17,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                      ),

                      Icon(
                        Icons.favorite_border,
                        color: Colors.black,
                        size: 24,
                      ),
                    ],),
                ],),
              ),
        ),
        ),

        //Single Item
       
        Padding(padding: EdgeInsets.symmetric(horizontal: 7),
        child: Container(
          width: 170,
          height: 270,
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
              ]),

              child: Padding(padding: EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                crossAxisAlignment:  CrossAxisAlignment.start,
                children: [
                  Container(
                    alignment: Alignment.center,
                    child: Image.asset("images/receta_lentejas.jpg",
                    height: 130,

                    ),
                  ),
                  Text("Ensalada", style: TextStyle(
                    fontSize: 30, 
                    fontWeight: FontWeight.bold,
                  ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    "Ensalada de lentejas y aguacate",
                     style: TextStyle(
                    fontSize: 15, 
                    //fontWeight: FontWeight.bold,
                  ),
                  ),
                  SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Pr. 20gr", style: TextStyle(
                        fontSize: 17,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                      ),

                      Icon(
                        Icons.favorite_border,
                        color: Colors.black,
                        size: 10,
                      ),
                    ],),
                ],),
              ),
        ),
        ),

        //Single Item
       
        Padding(padding: EdgeInsets.symmetric(horizontal: 7),
        child: Container(
          width: 170,
          height: 270,
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
              ]),

              child: Padding(padding: EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                crossAxisAlignment:  CrossAxisAlignment.start,
                children: [
                  Container(
                    alignment: Alignment.center,
                    child: Image.asset("images/receta_pechuga.jpeg",
                    height: 130,

                    ),
                  ),
                  Text("Pechuga", style: TextStyle(
                    fontSize: 30, 
                    fontWeight: FontWeight.bold,
                  ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    "Pechuga acompañada de arroz",
                     style: TextStyle(
                    fontSize: 15, 
                    //fontWeight: FontWeight.bold,
                  ),
                  ),
                  SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Pr. 36gr", style: TextStyle(
                        fontSize: 17,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                      ),

                      Icon(
                        Icons.favorite_border,
                        color: Colors.black,
                        size: 10,
                      ),
                    ],),
                ],),
              ),
        ),
        ),

         //Single Item
       
        Padding(padding: EdgeInsets.symmetric(horizontal: 7),
        child: Container(
          width: 170,
          height: 270,
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
              ]),

              child: Padding(padding: EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                crossAxisAlignment:  CrossAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, "itemPage");
                    },
                    child: Container(
                      alignment: Alignment.center,
                      child: Image.asset("images/receta_carne.jpg",
                      height: 130,
                      ),
                    ),
                  ),
                  Text("Carne", style: TextStyle(
                    fontSize: 30, 
                    fontWeight: FontWeight.bold,
                  ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    "Carne, acompañada de verduras",
                     style: TextStyle(
                    fontSize: 15, 
                    //fontWeight: FontWeight.bold,
                  ),
                  ),
                  SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Pr. 139gr", style: TextStyle(
                        fontSize: 17,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                      ),

                      Icon(
                        Icons.favorite_border,
                        color: Colors.black,
                        size: 10,
                      ),
                    ],),
                ],),
              ),
        ),
        ),

         //Single Item
       
        Padding(padding: EdgeInsets.symmetric(horizontal: 7),
        child: Container(
          width: 170,
          height: 270,
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
              ]),

              child: Padding(padding: EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                crossAxisAlignment:  CrossAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, "itemPage");
                    },
                    child: Container(
                      alignment: Alignment.center,
                      child: Image.asset("images/receta_pollo.jpg",
                      height: 130,
                      ),
                    ),
                  ),
                  Text("Pollo", style: TextStyle(
                    fontSize: 30, 
                    fontWeight: FontWeight.bold,
                  ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    "Contramuslo de pollo asado",
                     style: TextStyle(
                    fontSize: 15, 
                    //fontWeight: FontWeight.bold,
                  ),
                  ),
                  SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Pr. 251gr", style: TextStyle(
                        fontSize: 17,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                      ),

                      Icon(
                        Icons.favorite_border,
                        color: Colors.black,
                        size: 10,
                      ),
                    ],),
                ],),
              ),
        ),
        ),

         //Single Item
       
        Padding(padding: EdgeInsets.symmetric(horizontal: 7),
        child: Container(
          width: 170,
          height: 270,
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
              ]),

              child: Padding(padding: EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                crossAxisAlignment:  CrossAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, "itemPage");
                    },
                    child: Container(
                      alignment: Alignment.center,
                      child: Image.asset("images/almu_lente.jpg",
                      height: 130,
                      ),
                    ),
                  ),
                  Text("Lentejas", style: TextStyle(
                    fontSize: 30, 
                    fontWeight: FontWeight.bold,
                  ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    "Almuerzo casero con lentejas",
                     style: TextStyle(
                    fontSize: 15, 
                    //fontWeight: FontWeight.bold,
                  ),
                  ),
                  SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Pr. 78gr", style: TextStyle(
                        fontSize: 17,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                      ),

                      Icon(
                        Icons.favorite_border,
                        color: Colors.black,
                        size: 10,
                      ),
                    ],),
                ],),
              ),
        ),
        ),

        //Single Item
       
        Padding(padding: EdgeInsets.symmetric(horizontal: 7),
        child: Container(
          width: 170,
          height: 270,
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
              ]),

              child: Padding(padding: EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                crossAxisAlignment:  CrossAxisAlignment.start,
                children: [
                  Container(
                    alignment: Alignment.center,
                    child: Image.asset("images/receta_brocoli.jpg",
                    height: 130,

                    ),
                  ),
                  Text("Brocoli", style: TextStyle(
                    fontSize: 30, 
                    fontWeight: FontWeight.bold,
                  ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    "Brocoli salteado con pimenton",
                     style: TextStyle(
                    fontSize: 15, 
                    //fontWeight: FontWeight.bold,
                  ),
                  ),
                  SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Pr. 11gr", style: TextStyle(
                        fontSize: 17,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                      ),

                      Icon(
                        Icons.favorite_border,
                        color: Colors.black,
                        size: 10,
                      ),
                    ],),
                ],),
              ),
        ),
        ),


      ],),
      ),
    );
  }
}