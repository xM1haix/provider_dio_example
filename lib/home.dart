import "package:flutter/material.dart";
import "package:provider_dio_example/user_data.dart";

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late Future<List<UserData>> _future;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Users")),
      body: FutureBuilder(
        future: _future,
        builder: (context, snapshot) {
          //Checks if the future ends with error
          if (snapshot.hasError) {
            final err = snapshot.error!;
            if (err is DioException) {
              return Center(child: Text("Connection issues ;(!\n$err"));
            }
            return Center(child: Text("Something went wrong:$err"));
          }
          //Checks if it doesn't have data which means it's still awaiting
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          //It finished with success
          final data = snapshot.data!;
          //Checks if `data` is an empty list so will give a nice feedback
          if (data.isEmpty) {
            return const Center(child: Text("Nothing here yet"));
          }
          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              final userData = data[index];
              return ListTile(
                title: Text(userData.name),
                subtitle: Text(userData.email),
              );
            },
          );
        },
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _init();
  }

  ///Represents the function called in `initState`
  ///It can be used later too, for example on a
  ///refresh call the function should be called again
  void _init() {
    setState(() {
      _future = UserData.fetchUsers();
    });
  }
}
