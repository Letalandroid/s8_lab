import 'package:flutter/material.dart';
import 'Dog.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Dog App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Dog List'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Dog> dogList = [];

  @override
  void initState() {
    super.initState();
    _loadDogs();
  }

  Future<void> _loadDogs() async {
    final fido = Dog(id: 0, name: 'Fido', age: 35);
    await insertDog(fido);
    await updateDog(Dog(id: 0, name: 'Fido', age: 16));
    final TaoPai = Dog(id: 4, name: 'TaoPai', age: 98);
    await insertDog(TaoPai);
    await deleteDog(2);
    await deleteDog(3);

    dogList = await dogs();
    print(dogList);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: dogList.isEmpty
            ? Text('No dogs found.')
            : ListView.builder(
          itemCount: dogList.length,
          itemBuilder: (context, index) {
            final dog = dogList[index];
            return ListTile(
              title: Text(dog.name ?? 'Unnamed Dog'),
              subtitle: Text('Age: ${dog.age}'),
            );
          },
        ),
      ),
    );
  }
}
