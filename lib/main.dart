import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Find My Home',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        colorScheme: const ColorScheme.light(
          primary: Colors.indigo,
          secondary: Colors.orangeAccent,
        ),
        appBarTheme: const AppBarTheme(
          elevation: 4,
          backgroundColor: Colors.indigo,
          titleTextStyle: TextStyle(color: Colors.white, fontSize: 20),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: Colors.indigo,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
      ),
      home: const LoginScreen(),
    );
  }
}


// ------------------- FLAT DETAILS SCREEN -------------------
class FlatDetailsScreen extends StatelessWidget {
  final Map<String, String> post;

  const FlatDetailsScreen({super.key, required this.post});

  // Latitude and Longitude for the flat (this is an example, you should replace it with real data)
  final double latitude = 23.8103;  // Example: Dhaka latitude
  final double longitude = 90.4125; // Example: Dhaka longitude

  void bookFlat(BuildContext context) {
    // Add to booked flats
    CustomerProfileScreen.addBooking({
      'title': post['title']!,
      'description': post['description']!,
      'owner': HomeScreen._currentUserEmail ?? "unknown",
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Successfully Added in Profile", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Flat Details")),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/flat_background.jpg'), // Placeholder; replace with your image
            fit: BoxFit.cover,
            opacity: 0.8, // Slight transparency for text readability
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                post['title']!,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.indigo,
                  shadows: [Shadow(color: Colors.white, blurRadius: 2)], // Outline for readability
                ),
              ),
              const SizedBox(height: 16),
              Text(
                post['description']!,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                  shadows: [Shadow(color: Colors.white, blurRadius: 1)],
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                "Price: \$1000",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                  shadows: [Shadow(color: Colors.white, blurRadius: 1)],
                ),
              ),
              const SizedBox(height: 24),
              // Google Map for location
              Container(
                height: 300,
                child: GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: LatLng(latitude, longitude),
                    zoom: 14,
                  ),
                  markers: {
                    Marker(
                      markerId: MarkerId('flat_location'),
                      position: LatLng(latitude, longitude),
                      infoWindow: InfoWindow(title: 'Flat Location'),
                    ),
                  },
                ),
              ),
              const SizedBox(height: 24),
              Center(
                child: ElevatedButton(
                  onPressed: () => bookFlat(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orangeAccent,
                    minimumSize: const Size(200, 50),
                  ),
                  child: const Text("Added for Book", style: TextStyle(fontSize: 18)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


// ------------------- FLAT OWNER SCREEN -------------------
class FlatOwnerScreen extends StatefulWidget {
  const FlatOwnerScreen({super.key});

  @override
  _FlatOwnerScreenState createState() => _FlatOwnerScreenState();
}

class _FlatOwnerScreenState extends State<FlatOwnerScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  // Static list to store posts locally
  static List<Map<String, dynamic>> _posts = [];

  void addPost(BuildContext context) {
    String title = _titleController.text.trim();
    String description = _descriptionController.text.trim();

    // Input validation
    if (title.isEmpty || description.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please fill in both title and description", style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Add post to local list
    setState(() {
      _posts.add({
        'id': DateTime.now().millisecondsSinceEpoch.toString(), // Unique ID
        'title': title,
        'description': description,
        'owner': FirebaseAuth.instance.currentUser!.email,
      });
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Post Added Successfully", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.green,
      ),
    );
    _titleController.clear();
    _descriptionController.clear();
  }

  void logout(BuildContext context) {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginScreen()));
  }

  @override
  @override
  Widget build(BuildContext context) {
    final logoutButtonStyle = ElevatedButton.styleFrom(
      backgroundColor: Colors.redAccent,
      minimumSize: const Size(180, 50), // Fixed width of 250, height 50
      padding: const EdgeInsets.symmetric(vertical: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      textStyle: const TextStyle(fontSize: 24,  color: Colors.white),
    );

    return Scaffold(
      appBar: AppBar(title: const Text("Flat Owner Dashboard")),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.white, Colors.blueGrey],
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    TextField(
                      controller: _titleController,
                      decoration: InputDecoration(
                        labelText: "Flat Title",
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.8),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _descriptionController,
                      decoration: InputDecoration(
                        labelText: "Flat Description",
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.8),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () => addPost(context),
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.orangeAccent),
                      child: const Text("     Add Post     ", style: TextStyle(fontSize: 18)),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ViewPostedFlatsScreen())),
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.indigoAccent),
                      child: const Text(" View Posted Flats ", style: TextStyle(fontSize: 18)),
                    ),
                  ],
                ),
              ),
            ),
            Center(
              child: ElevatedButton.icon(
                onPressed: () => logout(context),
                icon: const Icon(Icons.logout),
                label: const Text("Logout"),
                style: logoutButtonStyle,
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}


// ------------------- ADMIN SCREEN -------------------
class AdminScreen extends StatelessWidget {
  const AdminScreen({super.key});

  void logout(BuildContext context) {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginScreen()));
  }

  @override
  Widget build(BuildContext context) {
    final logoutButtonStyle = ElevatedButton.styleFrom(
      backgroundColor: Colors.redAccent,
      minimumSize: const Size(180, 50),
      padding: const EdgeInsets.symmetric(vertical: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      textStyle: const TextStyle(fontSize: 24, color: Colors.white),
    );

    return Scaffold(
      appBar: AppBar(title: const Text("Admin Dashboard")),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.white, Colors.blueGrey],
          ),
        ),
        child: DefaultTabController(
          length: 2,
          child: Column(
            children: [
              const TabBar(
                tabs: [
                  Tab(icon: Icon(Icons.people), text: "Users"),
                  Tab(icon: Icon(Icons.home), text: "Flats"),
                ],
                labelColor: Colors.indigo,
                indicatorColor: Colors.orangeAccent,
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    // User List
                    StreamBuilder(
                      stream: FirebaseFirestore.instance.collection('users').snapshots(),
                      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (!snapshot.hasData) {
                          return const Center(child: CircularProgressIndicator());
                        }
                        final users = snapshot.data!.docs;
                        return ListView.builder(
                          itemCount: users.length,
                          itemBuilder: (context, index) {
                            final user = users[index];
                            return ListTile(
                              leading: const Icon(Icons.account_circle),
                              title: Text(user['name'] ?? 'No Name'),
                              subtitle: Text('${user['email']} (${user['role']})'),
                            );
                          },
                        );
                      },
                    ),

                    // Flat List
                    StreamBuilder(
                      stream: FirebaseFirestore.instance.collection('posts').snapshots(),
                      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (!snapshot.hasData) {
                          return const Center(child: CircularProgressIndicator());
                        }
                        final posts = snapshot.data!.docs;
                        return ListView.builder(
                          itemCount: posts.length,
                          itemBuilder: (context, index) {
                            final post = posts[index];
                            return ListTile(
                              title: Text(post['title']),
                              subtitle: Text(post['description']),
                              trailing: IconButton(
                                icon: const Icon(Icons.delete, color: Colors.redAccent),
                                onPressed: () async {
                                  await FirebaseFirestore.instance.collection('posts').doc(post.id).delete();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text("Flat Deleted", style: TextStyle(color: Colors.white)), backgroundColor: Colors.red),
                                  );
                                },
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
              Center(
                child: ElevatedButton.icon(
                  onPressed: () => logout(context),
                  icon: const Icon(Icons.logout),
                  label: const Text("Logout"),
                  style: logoutButtonStyle,
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
