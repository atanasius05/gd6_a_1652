import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:gd6_a_1652/database/sql_helper.dart';
import 'package:gd6_a_1652/entity/employee.dart';
import 'package:gd6_a_1652/inputPage.dart';
import 'package:gd6_a_1652/inputPageGadget.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SQFLITE',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(title: 'SQFLITE'),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, dynamic>> employee = [];
  List<Map<String, dynamic>> gadget = [];
  List<Map<String, dynamic>> filteredList = [];
  int _selectedIndex = 0;
  bool _isSearching = false;
  TextEditingController _searchController = TextEditingController();

  void refresh() async {
    final data = await SQLHelper.getEmployee();
    final data2 = await SQLHelper.getGadget();
    setState(() {
      employee = data;
      gadget = data2;
      filteredList = _selectedIndex == 0 ? employee : gadget;
    });
  }

  @override
  void initState() {
    refresh();
    super.initState();
  }

  // Handle search input changes (triggered by button or enter key)
  void _onSearchChanged() {
    setState(() {
      if (_selectedIndex == 0) {
        filteredList = employee
            .where((e) => e['name']
                .toString()
                .toLowerCase()
                .contains(_searchController.text.toLowerCase()))
            .toList();
      } else {
        filteredList = gadget
            .where((g) => g['name']
                .toString()
                .toLowerCase()
                .contains(_searchController.text.toLowerCase()))
            .toList();
      }
    });
  }

  // Toggle search mode
  void _toggleSearch() {
    setState(() {
      _isSearching = !_isSearching;
      _searchController.clear();
      filteredList = _selectedIndex == 0 ? employee : gadget;
    });
  }

  // Navigation function to switch between pages
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      filteredList = index == 0 ? employee : gadget;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        title: _isSearching
            ? Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      autofocus: true,
                      decoration: const InputDecoration(
                        hintText: 'Search...',
                        border: InputBorder.none,
                        hintStyle: TextStyle(color: Colors.white60),
                      ),
                      style: const TextStyle(color: Colors.white),
                      onSubmitted: (_) => _onSearchChanged(),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.search),
                    onPressed: _onSearchChanged,
                  ),
                ],
              )
            : Text(_selectedIndex == 0 ? "EMPLOYEE" : "GADGET"),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            icon: Icon(_isSearching ? Icons.close : Icons.search),
            onPressed: _toggleSearch,
          ),
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () async {
              if (_selectedIndex == 0) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const InputPage(
                      title: 'INPUT EMPLOYEE',
                      id: null,
                      name: null,
                      email: null,
                    ),
                  ),
                ).then((_) => refresh());
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const inputPageGadget(
                      title: 'INPUT GADGET',
                      id: null,
                      name: null,
                      merk: null,
                    ),
                  ),
                ).then((_) => refresh());
              }
            },
          ),
        ],
      ),
      body: _selectedIndex == 0 ? _buildEmployeeList() : _buildGadgetList(),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.blue,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Employee',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.devices),
            label: 'Gadget',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white54,
        onTap: _onItemTapped,
      ),
    );
  }

  Widget _buildEmployeeList() {
    return ListView.builder(
      itemCount: filteredList.length,
      itemBuilder: (context, index) {
        return Slidable(
          key: ValueKey(filteredList[index]['id']),
          endActionPane: ActionPane(
            motion: const DrawerMotion(),
            children: [
              SlidableAction(
                onPressed: (context) async {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => InputPage(
                        title: 'INPUT EMPLOYEE',
                        id: filteredList[index]['id'],
                        name: filteredList[index]['name'],
                        email: filteredList[index]['email'],
                      ),
                    ),
                  ).then((_) => refresh());
                },
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                icon: Icons.update,
                label: 'Update',
              ),
              SlidableAction(
                onPressed: (context) async {
                  await deleteEmployee(filteredList[index]['id']);
                },
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                icon: Icons.delete,
                label: 'Delete',
              ),
            ],
          ),
          child: ListTile(
            title: Text(filteredList[index]['name']),
            subtitle: Text(filteredList[index]['email']),
          ),
        );
      },
    );
  }

  Widget _buildGadgetList() {
    return ListView.builder(
      itemCount: filteredList.length,
      itemBuilder: (context, index) {
        return Slidable(
          key: ValueKey(filteredList[index]['id']),
          endActionPane: ActionPane(
            motion: const DrawerMotion(),
            children: [
              SlidableAction(
                onPressed: (context) async {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => inputPageGadget(
                        title: 'INPUT GADGET',
                        id: filteredList[index]['id'],
                        name: filteredList[index]['name'],
                        merk: filteredList[index]['merk'],
                      ),
                    ),
                  ).then((_) => refresh());
                },
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                icon: Icons.update,
                label: 'Update',
              ),
              SlidableAction(
                onPressed: (context) async {
                  await deleteGadget(filteredList[index]['id']);
                },
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                icon: Icons.delete,
                label: 'Delete',
              ),
            ],
          ),
          child: ListTile(
            title: Text(filteredList[index]['name']),
            subtitle: Text(filteredList[index]['merk']),
          ),
        );
      },
    );
  }

  Future<void> deleteEmployee(int id) async {
    await SQLHelper.deleteEmployee(id);
    refresh();
  }

  Future<void> deleteGadget(int id) async {
    await SQLHelper.deleteGadget(id);
    refresh();
  }
}
