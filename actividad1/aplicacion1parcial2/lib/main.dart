import 'package:flutter/material.dart';
import 'data_service.dart';
import 'image_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App Ross',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.purple,
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.purple,
          accentColor: const Color(0xFF4DB6AC),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF7E57C2),
          foregroundColor: Colors.white,
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Color(0xFF4DB6AC),
          foregroundColor: Colors.white,
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          selectedItemColor: Color(0xFF4DB6AC),
          unselectedItemColor: Color(0xFF7E57C2),
          backgroundColor: Colors.white,
        ),
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _counter = 0;
  int _selectedIndex = 0;
  final List<Widget> _widgetOptions = [
    CounterPage(counter: 0),
    const ListPage(),
    const CardPage(),
    const ImagesPage(),
  ];

  void _incrementCounter() {
    setState(() {
      if (_counter < 20) {
        _counter++;
        _widgetOptions[0] = CounterPage(counter: _counter);
      }
    });
  }

  void _decrementCounter() {
    setState(() {
      if (_counter > 0) {
        _counter--;
        _widgetOptions[0] = CounterPage(counter: _counter);
      }
    });
  }

  void _resetCounter() {
    setState(() {
      _counter = 0;
      _widgetOptions[0] = CounterPage(counter: _counter);
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Mostrar mensaje cuando el contador llegue a 20
    if (_counter == 20) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('¡Alcanzaste el límite de 20!'),
            duration: Duration(seconds: 2),
            backgroundColor: Colors.red,
          ),
        );
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('ACTIVIDAD 1: Uso de widget Scaffold + Navigation'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 67, 7, 98),
              ),
              child: Text(
                'Menú Principal',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home, color: Color(0xFF7E57C2)),
              title: const Text('Inicio'),
              onTap: () {
                setState(() {
                  _selectedIndex = 0;
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.access_time, color: Color(0xFF7E57C2)),
              title: const Text('Hora'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings, color: Color(0xFF7E57C2)),
              title: const Text('Ajustes'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      body: _widgetOptions.elementAt(_selectedIndex),
      floatingActionButton: _selectedIndex == 0
          ? Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                FloatingActionButton(
                  onPressed: _incrementCounter,
                  tooltip: 'Incrementar',
                  child: const Icon(Icons.add),
                ),
                const SizedBox(height: 10),
                FloatingActionButton(
                  onPressed: _decrementCounter,
                  tooltip: 'Decrementar',
                  child: const Icon(Icons.remove),
                ),
                const SizedBox(height: 10),
                FloatingActionButton(
                  onPressed: _resetCounter,
                  tooltip: 'Reiniciar',
                  backgroundColor: Colors.red,
                  child: const Icon(Icons.refresh),
                ),
              ],
            )
          : null,
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Lista',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.card_giftcard),
            label: 'Tarjeta',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.image),
            label: 'Galería',
          ),
        ],
        currentIndex: _selectedIndex == 0 ? 0 : _selectedIndex - 1,
        onTap: (index) {
          if (index == 4) return;
          _onItemTapped(index + 1);
        },
      ),
    );
  }
}

class CounterPage extends StatelessWidget {
  final int counter;
  
  const CounterPage({super.key, required this.counter});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Text(
            'Rosalba Moncada Lazcano',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF7E57C2),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            '$counter',
            style: const TextStyle(
              fontSize: 48,
              fontWeight: FontWeight.bold,
              color: Color(0xFF4DB6AC),
            ),
          ),
        ],
      ),
    );
  }
}

class ListPage extends StatefulWidget {
  const ListPage({super.key});

  @override
  State<ListPage> createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  List<Map<String, String>> purpleFlowers = [];

  @override
  void initState() {
    super.initState();
    _loadFlowers();
  }

  Future<void> _loadFlowers() async {
    final data = await DataService.loadData();
    setState(() {
      purpleFlowers = List<Map<String, String>>.from(
        data['flowers'].map((flower) => Map<String, String>.from(flower))
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    if (purpleFlowers.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    return ListView.builder(
      itemCount: purpleFlowers.length,
      itemBuilder: (context, index) {
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          color: index % 2 == 0 ? const Color(0xFFE8F5E9) : const Color(0xFFF3E5F5),
          child: ListTile(
            leading: Icon(Icons.local_florist, color: Colors.purple[300]),
            title: Text(
              purpleFlowers[index]['name']!,
              style: const TextStyle(color: Color(0xFF7E57C2)),
            ),
            subtitle: Text(
              purpleFlowers[index]['description']!,
              style: TextStyle(color: Colors.purple[300]),
            ),
          ),
        );
      },
    );
  }
}

class CardPage extends StatelessWidget {
  const CardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 600,
        height: 300,
        child: Card(
          elevation: 8,
          margin: const EdgeInsets.all(20),
          color: const Color(0xFFF3E5F5),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 150,
                  height: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.asset(
                      'assets/hydrangea-5076212_640.jpg',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                
                const SizedBox(width: 20),
                
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Floristería Morada',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF7E57C2),
                          ),
                        ),
                        const SizedBox(height: 15),
                        Text(
                          'Rosalba Moncada Lazcano',
                          style: TextStyle(
                            fontSize: 18,
                            color: Color(0xFF7E57C2),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Florista Profesional',
                          style: TextStyle(
                            fontSize: 16,
                            fontStyle: FontStyle.italic,
                            color: Color(0xFF7E57C2),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'Especializada en flores moradas de todas las variedades. '
                          'Ofrezco arreglos florales únicos para ocasiones especiales, '
                          'bodas y eventos. Cada flor es seleccionada cuidadosamente '
                          'para garantizar la máxima belleza y duración.',
                          style: TextStyle(color: Color(0xFF7E57C2)),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ImagesPage extends StatefulWidget {
  const ImagesPage({super.key});

  @override
  State<ImagesPage> createState() => _ImagesPageState();
}

class _ImagesPageState extends State<ImagesPage> {
  List<Map<String, dynamic>> imagesData = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadImagesData();
  }

  Future<void> _loadImagesData() async {
    try {
      final data = await ImageService.loadImagesData();
      setState(() {
        imagesData = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _showFullImage(BuildContext context, String imagePath, String description) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: InteractiveViewer(
                  panEnabled: true,
                  minScale: 0.5,
                  maxScale: 3.0,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(
                      imagePath,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Container(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.8,
                ),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.9),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  description,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Color(0xFF7E57C2),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: imagesData.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () => _showFullImage(
            context, 
            imagesData[index]['path']!, 
            imagesData[index]['description']!
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: index % 2 == 0 ? const Color(0xFFE8F5E9) : const Color(0xFFEDE7F6),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withValues(alpha: 0.3),
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  )
                ],
              ),
              child: Image.asset(
                imagesData[index]['path']!,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.image, size: 40, color: Colors.purple[300]),
                        Text(
                          'Imagen ${index + 1}',
                          style: TextStyle(
                            color: Colors.purple[300],
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}