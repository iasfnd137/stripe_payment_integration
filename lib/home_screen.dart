import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:payment_project_flutter/payment_screen.dart';
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}
var money;

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('HomeScreen'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('Select Payment'),
            ElevatedButton(onPressed: (){
              setState(() {
                var money1 = 6.35;
                money = money1;
              });
            }, child: Text('\$6')),
            const SizedBox(height: 20,),
            ElevatedButton(onPressed: (){
              setState(() {
                var money2 = 26.5;
                money = money2;
              });
            }, child: const Text('\$26')),
            const SizedBox(height: 20,),
            ElevatedButton(onPressed: (){
              setState(() {
                var money3 = 45.34;
                money = money3;
              });
            }, child: const Text('\$45')),
            const SizedBox(height: 40,),
            ElevatedButton(onPressed: (){
              if(money==null){
                Fluttertoast.showToast(
                    msg: "Please Select Payment",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.CENTER,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.purpleAccent,
                    textColor: Colors.white,
                    fontSize: 16.0
                );
              }else{
                Navigator.of(context).push(MaterialPageRoute(builder: (ctx){
                  return PaymentScreen(money: money,);
                }));
              }
            }, child: const Text('Continue')),


          ],
        ),
      ),
    );
  }
}
