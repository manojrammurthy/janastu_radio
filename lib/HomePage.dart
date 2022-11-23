 import 'package:flutter/material.dart';
 import 'package:url_launcher/url_launcher.dart';

//  class Homepage extends StatelessWidget {
//   const Homepage({Key? key}) : super(key: key);
 
//   static const String _title = 'Heli Keli Radio';

//   @override
//   Widget build(BuildContext context)
//   {
//     return Center(
//       child: Text('home'),
       
//     );
//   }
//  }

Future<void> launchUrlStart({required String url}) async {
if (!await launchUrl(Uri.parse(url))) {
  throw 'Could not launch $url';
 }
}

 class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  _HomepageState createState() => _HomepageState();
}

 
class _HomepageState extends State<Homepage> {
   @override
  Widget build(BuildContext context) {
   return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 60.0),
              child: Center(
                child: Container(
                    width: 200,
                    height: 100,
                    /*decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(50.0)),*/
                    child: Image.asset('images/Janastulogo.jpg')
                    ),
              ),
            ),
            // Padding(
            //   //padding: const EdgeInsets.only(left:15.0,right: 15.0,top:0,bottom: 0),
            //   padding: EdgeInsets.symmetric(horizontal: 15),
            //   child: TextField(
            //     decoration: InputDecoration(
            //         border: OutlineInputBorder(),
            //         labelText: 'Email',
            //         hintText: 'Enter valid email id as abc@gmail.com'),
            //   ),
            // ),
            // Padding(
            //   padding: const EdgeInsets.only(
            //       left: 15.0, right: 15.0, top: 15, bottom: 0),
            //   //padding: EdgeInsets.symmetric(horizontal: 15),
            //   child: TextField(

            //     obscureText: true,
            //     decoration: InputDecoration(
            //         border: OutlineInputBorder(),
            //         labelText: 'Password',
            //         hintText: 'Enter secure password'),
            //   ),
            // ),
            // FlatButton(
            //   onPressed: (){
            //     //TODO FORGOT PASSWORD SCREEN GOES HERE
            //   },
            //   child: Text(
            //     'Forgot Password',
            //     style: TextStyle(color: Colors.blue, fontSize: 15),
            //   ),
            // ),
            // Container(
            //   height: 50,
            //   width: 250,
            //   decoration: BoxDecoration(
            //       color: Colors.blue, borderRadius: BorderRadius.circular(20)),
            //   child: FlatButton(
            //     onPressed: () {
            //       print('pushed');
            //       // Navigator.push(
            //       //     context, MaterialPageRoute(builder: (_) => HomePage()));
            //     },
            //     child: Text(
            //       'Login',
            //       style: TextStyle(color: Colors.white, fontSize: 25),
            //     ),
            //   ),
            // ),
            // SizedBox(
            //   height: 130,
            // ),
            // Text('New User? Create Account'),
            Column(
             children: [
             ElevatedButton.icon(
            onPressed: () async {
                final url = Uri.parse(
                  'https://janastu.org',
                );
                if (await canLaunchUrl(url)) {
                  launchUrl(url);
                } else {
                  // ignore: avoid_print
                  print("Can't launch $url");
                }
            }, label: Text('Janastu'), icon: Icon(Icons.insert_link),
        ),
        ElevatedButton.icon(
            onPressed: () async {
                final url = Uri.parse(
                  'http://servelots.com/',
                );
                if (await canLaunchUrl(url)) {
                  launchUrl(url);
                } else {
                  // ignore: avoid_print
                  print("Can't launch $url");
                }
            }, label: Text('Servelots'), icon: Icon(Icons.insert_link),
        ),
             ]
            )
          ],
        ),
      ),
   );

  }
  
}

