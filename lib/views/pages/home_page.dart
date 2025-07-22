import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}
 

class _HomePageState extends State<HomePage> {
   int _counter = 0;

  void _addcounter(){
    setState ((){
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
        backgroundColor: Colors.deepPurple,
      ),

      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text("you have touch the button: $_counter"),
            FilledButton(
              onPressed:_addcounter, 
              child:Text('add count')
             
              )
            
          ],
        ),
      ),
    );
  }
  
  
}