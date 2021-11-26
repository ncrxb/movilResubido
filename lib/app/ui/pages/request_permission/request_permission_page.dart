
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:movil/app/ui/pages/request_permission/request_permission_controller.dart';
import 'package:movil/app/ui/routes/routes.dart';    
import 'package:permission_handler/permission_handler.dart';


class RequestPermissionPage extends StatefulWidget {
  RequestPermissionPage({Key? key}) : super(key: key);

  @override
  _RequestPermissionPageState createState() => _RequestPermissionPageState();
}

class _RequestPermissionPageState extends State<RequestPermissionPage> with WidgetsBindingObserver {
 final _controller = RequestPermissionController(Permission.locationWhenInUse);
 late StreamSubscription _subscription;
 bool _fromSettings = false;

 @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
    _subscription = _controller.onStatusChanged.listen(
      (status) {
        switch(status){
          case PermissionStatus.granted:
          _goToHome();
           break;
          case PermissionStatus.permanentlyDenied:
          showDialog(
            context: context, 
            builder: (_)=> AlertDialog(
              title: const Text("INFO"),
              content: const Text("No se pudo acceder a la ubicación del dispositivo favor de hacerlo mediante Ajustes"),
              actions: [
                TextButton(
                onPressed: ()async {
                  Navigator.pop(context);
                _fromSettings = await openAppSettings();
                },
                child: const Text("Ir a ajustes")
                ),
              
                TextButton(onPressed: (){
                  Navigator.pop(context);
                },
                child: const Text("Cancelar")
                ),
            ],
            ),
          );
          break;
        }
      },
    ); 
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async{
  print("state $state");
  if(state == AppLifecycleState.resumed && _fromSettings) {
   final status = await _controller.check();
   if(status == PermissionStatus.granted){
     _goToHome();
   }
  }
  _fromSettings = false;
  }

  @override
  void dispose(){
    WidgetsBinding.instance!.removeObserver(this);
    _subscription.cancel();
    _controller.disponse();
    super.dispose();
  }

void _goToHome(){
Navigator.pushReplacementNamed(context, Routes.HOME);

}

 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          alignment: Alignment.center,
          child: ElevatedButton(
            child: const Text("Permiso para acceder a la ubi"),
            onPressed: (){
              _controller.request();
            },),
        ),
        ),
    );
  }
      
}