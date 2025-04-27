import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyDlBvvydVz0T2heqPR_1LDiLKm8JkNXU4I",
        authDomain: "find-my-home-4b849.firebaseapp.com",
        projectId: "find-my-home-4b849",
        storageBucket: "find-my-home-4b849.firebasestorage.app",
        messagingSenderId: "42327999124",
        appId: "1:42327999124:web:02e3d49a9ac4c26a882a81",
      ),
    );
  } else {
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
}await Firebase.initializeApp();
  }

  

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


// ------------------- LOGIN SCREEN -------------------
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void login() async {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
      if (email.contains("admin")) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const AdminScreen()));
      } else if (email.contains("owner")) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const FlatOwnerScreen()));
      } else {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) =>  HomeScreen()));
      }
    } catch (e) {
      print("Login error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Invalid email or password", style: TextStyle(color: Colors.white)), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.indigo, Colors.blueAccent],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Welcome Back", style: TextStyle(fontSize: 32, color: Colors.white, fontWeight: FontWeight.bold)),
                const SizedBox(height: 40),
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: "Email",
                    labelStyle: const TextStyle(color: Colors.white70),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.2),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  style: const TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: "Password",
                    labelStyle: const TextStyle(color: Colors.white70),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.2),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  style: const TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: login,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orangeAccent,
                    minimumSize: const Size(150, 50),
                  ),
                  child: const Text("Login", style: TextStyle(fontSize: 18)),
                ),
                const SizedBox(height: 20),
                TextButton(
                  onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const RegisterScreen())),
                  child: const Text("Don't have an account? Register", style: TextStyle(color: Colors.white70)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ------------------- REGISTER SCREEN -------------------
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  bool _isCustomer = false;
  bool _isFlatOwner = false;

  void register() async {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();
    String name = _nameController.text.trim();

    // Input validation
    if (email.isEmpty || !RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter a valid email", style: TextStyle(color: Colors.white)), backgroundColor: Colors.red),
      );
      return;
    }
    if (password.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Password must be at least 6 characters", style: TextStyle(color: Colors.white)), backgroundColor: Colors.red),
      );
      return;
    }
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter your name", style: TextStyle(color: Colors.white)), backgroundColor: Colors.red),
      );
      return;
    }
    if (!_isCustomer && !_isFlatOwner && !email.contains("admin")) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select a role (Customer or Flat Owner)", style: TextStyle(color: Colors.white)), backgroundColor: Colors.red),
      );
      return;
    }


    try {
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
      String role;
      if (email.contains("admin")) {
        role = 'admin'; // Admin role unchanged from previous logic
      } else {
        role = _isCustomer ? 'customer' : 'flat_owner'; // Role based on checkbox
      }
      try {
        await FirebaseFirestore.instance.collection('users').doc(userCredential.user!.uid).set({
          'name': name,
          'email': email,
          'role': role,
        });
      } catch (firestoreError) {
        print("Firestore write error: $firestoreError");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("User created, but data save failed", style: TextStyle(color: Colors.white)), backgroundColor: Colors.orange),
        );
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Registration Successful", style: TextStyle(color: Colors.white)), backgroundColor: Colors.green),
      );
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginScreen()));
    } catch (e) {
      print("Registration error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Registration failed: $e", style: const TextStyle(color: Colors.white)), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.blueAccent, Colors.indigo],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Create Account", style: TextStyle(fontSize: 32, color: Colors.white, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 40),
                  TextField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: "Name",
                      labelStyle: const TextStyle(color: Colors.white70),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.2),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    style: const TextStyle(color: Colors.white),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: "Email",
                      labelStyle: const TextStyle(color: Colors.white70),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.2),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    style: const TextStyle(color: Colors.white),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: "Password",
                      labelStyle: const TextStyle(color: Colors.white70),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.2),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    style: const TextStyle(color: Colors.white),
                  ),
                  const SizedBox(height: 20),
                  const Text("Select Role (if not Admin)", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Checkbox(
                        value: _isCustomer,
                        onChanged: (value) {
                          setState(() {
                            _isCustomer = value ?? false;
                            if (_isCustomer) _isFlatOwner = false; // Ensure only one is selected
                          });
                        },
                        activeColor: Colors.orangeAccent,
                      ),
                      const Text("Customer", style: TextStyle(color: Colors.white)),
                      const SizedBox(width: 20),
                      Checkbox(
                        value: _isFlatOwner,
                        onChanged: (value) {
                          setState(() {
                            _isFlatOwner = value ?? false;
                            if (_isFlatOwner) _isCustomer = false; // Ensure only one is selected
                          });
                        },
                        activeColor: Colors.orangeAccent,
                      ),
                      const Text("Flat Owner", style: TextStyle(color: Colors.white)),
                    ],
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: register,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orangeAccent,
                      minimumSize: const Size(160, 50),
                    ),
                    child: const Text("Register", style: TextStyle(fontSize: 18)),
                  ),
                  const SizedBox(height: 20),
                  TextButton(
                    onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const LoginScreen())),
                    child: const Text(
                      "Already have an account? Login",
                      style: TextStyle(color: Colors.white70, fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
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


                
// ------------------- PLACEHOLDER LOGIN SCREEN -------------------
class PlaceholderLoginScreen extends StatelessWidget {
  const PlaceholderLoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Login")),
      body: const Center(child: Text("Login Screen Placeholder")),
    );
  }
}



// ------------------- CUSTOMER PROFILE SCREEN -------------------
class CustomerProfileScreen extends StatelessWidget {
  const CustomerProfileScreen({super.key});

  // Static list to store booked flats
  static final List<Map<String, String>> _bookedFlats = [];

  // Method to add a booking (updated to include confirmed: false)
  static void addBooking(Map<String, String> flat) {
    _bookedFlats.add({
      ...flat,
      'confirmed': 'false', // Initialize as unconfirmed
    });
  }

  // Method to confirm a booking
  static void confirmBooking(int index, BuildContext context) {
    _bookedFlats[index]['confirmed'] = 'true';
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Booking Confirmed", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Filter bookings by current user
    final userBookings = _bookedFlats
        .asMap()
        .entries
        .where((entry) => entry.value['owner'] == HomeScreen._currentUserEmail)
        .toList();

    return Scaffold(
      appBar: AppBar(title: const Text("Customer Profile")),
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
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: CircleAvatar(
                radius: 50,
                backgroundColor: Colors.indigo,
                child: Icon(Icons.person, size: 60, color: Colors.white),
              ),
            ),
            Text(
              HomeScreen._currentUserEmail ?? "Customer",
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.indigo),
            ),
            const SizedBox(height: 16),
            const Text(
              "Booked Flats",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87),
            ),
            Expanded(
              child: userBookings.isEmpty
                  ? const Center(child: Text("No flats booked yet", style: TextStyle(fontSize: 18, color: Colors.black54)))
                  : ListView.builder(
                itemCount: userBookings.length,
                itemBuilder: (context, index) {
                  final entry = userBookings[index];
                  final flat = entry.value;
                  final originalIndex = entry.key; // Index in _bookedFlats
                  final isConfirmed = flat['confirmed'] == 'true';
                  return Card(
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    elevation: 4,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: ListTile(
                      title: Text(
                        flat['title']!,
                        style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.indigo),
                      ),
                      subtitle: Text(flat['description']!),
                      trailing: ElevatedButton(
                        onPressed: isConfirmed
                            ? null // Disable if confirmed
                            : () {
                          confirmBooking(originalIndex, context);
                          (context as Element).markNeedsBuild(); // Force rebuild
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isConfirmed ? Colors.grey : Colors.orangeAccent,
                          minimumSize: const Size(100, 36),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        child: Text(
                          isConfirmed ? "Confirmed" : "Confirm Book",
                          style: const TextStyle(fontSize: 14, color: Colors.white),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
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
// ------------------- HOME SCREEN -------------------

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  // Current user email for global access
  static String? _currentUserEmail = "customer@example.com";

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Map<String, String>> dummyPosts = const [
    {'title': 'Flat in Dhanmondi', 'description': '2 bed, 2 bath flat'},
    {'title': 'Flat in Gulshan', 'description': '3 bed, 3 bath luxury flat'},
    {'title': 'Flat in Mirpur1', 'description': '2 bed, 1 bath flat'},
    {'title': 'Flat in Savar', 'description': '3 bed, 2 bath luxury flat'},
    {'title': 'Flat in Uttora', 'description': '2 bed, 1 bath flat'},
    {'title': 'Flat in Mirpur10', 'description': '3 bed, 2 bath luxury flat'},
  ];

  final TextEditingController _searchController = TextEditingController();
  List<Map<String, String>> _filteredPosts = [];

  @override
  void initState() {
    super.initState();
    _filteredPosts = List.from(dummyPosts); // Initialize with all posts
    _searchController.addListener(_filterPosts);
  }

  void _filterPosts() {
    String query = _searchController.text.trim().toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filteredPosts = List.from(dummyPosts);
      } else {
        _filteredPosts = dummyPosts
            .where((post) => post['title']!.toLowerCase().contains(query))
            .toList();
      }
    });
  }

  void logout(BuildContext context) {
    HomeScreen._currentUserEmail = null; // Clear user session
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginScreen()));
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
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
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.person, color: Colors.white),
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const CustomerProfileScreen()),
          ),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Find My Home",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Container(
              width: 320, // Fixed width to prevent overflow
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      decoration: const InputDecoration(
                        hintText: "Search by flat title...",
                        hintStyle: TextStyle(color: Colors.white70),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      ),
                      style: const TextStyle(color: Colors.white, fontSize: 14),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.search, color: Colors.white, size: 20),
                    onPressed: _filterPosts, // Optional: Explicit search trigger
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          Container(
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
                  child: _filteredPosts.isEmpty
                      ? const Center(child: Text("No flats found", style: TextStyle(fontSize: 18, color: Colors.black54)))
                      : ListView.builder(
                    itemCount: _filteredPosts.length,
                    itemBuilder: (context, index) {
                      final post = _filteredPosts[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        elevation: 4,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        child: ListTile(
                          title: Text(post['title']!, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.indigo)),
                          subtitle: Text(post['description']!),
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => FlatDetailsScreen(post: post)),
                          ),
                        ),
                      );
                    },
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
                const SizedBox(height: 16), // Bottom spacing
              ],
            ),
          ),
        ],
      ),
    );
  }
}


// ------------------- VIEW POSTED FLATS SCREEN -------------------
class ViewPostedFlatsScreen extends StatelessWidget {
  const ViewPostedFlatsScreen({super.key});

  void deletePost(BuildContext context, String postId) {
    // Remove post from local list
    _FlatOwnerScreenState._posts.removeWhere((post) => post['id'] == postId);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Post Deleted", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Access local posts from FlatOwnerScreen
    final posts = _FlatOwnerScreenState._posts
        .where((post) => post['owner'] == FirebaseAuth.instance.currentUser!.email)
        .toList();

    return Scaffold(
      appBar: AppBar(title: const Text("Posted Flats")),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.white, Colors.blueGrey],
          ),
        ),
        child: posts.isEmpty
            ? const Center(child: Text("No flats posted yet", style: TextStyle(fontSize: 18, color: Colors.black54)))
            : ListView.builder(
          itemCount: posts.length,
          itemBuilder: (context, index) {
            final flat = posts[index];
            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: ListTile(
                title: Text(
                  flat['title'] ?? 'No Title',
                  style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.indigo),
                ),
                subtitle: Text(flat['description'] ?? 'No Description'),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.redAccent),
                  onPressed: () {
                    deletePost(context, flat['id']);
                    // Force rebuild by navigating back to the same screen
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const ViewPostedFlatsScreen()),
                    );
                  },
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}