import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart' show ChangeNotifier;
import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:movil/app/helpers/image_to_bytes.dart';
import 'package:movil/app/ui/utils/map_style.dart';
import 'package:geolocator/geolocator.dart';

class HomeController extends ChangeNotifier {
  final Map<MarkerId, Marker> _markers = {};
  final Map<PolylineId, Polyline> _polylines = {};
  final Map<PolygonId, Polygon> _polygons = {};


  Set<Marker> get markers => _markers.values.toSet();
  Set<Polyline> get polylines => _polylines.values.toSet();
  Set<Polygon> get polygons => _polygons.values.toSet();

  late BitmapDescriptor _carPin;
  

  final _markersController = StreamController<String>.broadcast();
  Stream<String> get onMarkerTap => _markersController.stream;

  Position? _initialPosition, _lastPosition ;
  Position? get initialPosition => _initialPosition;

  //final  _bolsaIcon = Completer<BitmapDescriptor>();

  bool _loading = true;
  bool get loading => _loading;

  late bool _gpsEnabled;
  bool get gpsEnabled => _gpsEnabled;

  StreamSubscription? _gpsSubscription, _positionSubscription;
  GoogleMapController? _mapController;
  
  String _polylineId = '0';
  String _polygonId = '0';

  HomeController() {
    _init();
  }

  Future<void> _init() async {
   _carPin = BitmapDescriptor.fromBytes(await assetToBytes('assets/bolsa-de-dinero.png', width: 95));
    //  assetToBytes('assets/bolsa-de-dinero.png', width:130 ).then((value) {
    //     final bitmap = BitmapDescriptor.fromBytes(value);
    //     _bolsaIcon.complete(bitmap);
    //   },);
    _gpsEnabled = await Geolocator.isLocationServiceEnabled();
    _loading = false;
    _gpsSubscription = Geolocator.getServiceStatusStream().listen(
      (status) async {
        _gpsEnabled = status == ServiceStatus.enabled;
        print("_gpsEnabled $_gpsEnabled");
        if (_gpsEnabled) {
          _initLocationUpdates();
        }
      },
    );
    _initLocationUpdates();
  }

  Future<void> _initLocationUpdates() async {
    bool initialized = false;
    await _positionSubscription?.cancel();
    _positionSubscription = Geolocator.getPositionStream(
      desiredAccuracy: LocationAccuracy.high,
      distanceFilter: 10,
    ).listen(
      (position) async{
         _setMyPositionMarker(position);
        if(initialized){
          notifyListeners();
        }

        if (!initialized) {
          _setInitialPosition(position);
          initialized = true;
          notifyListeners();
        }

       


        if(_mapController !=null){
          final zoom = await _mapController!.getZoomLevel();
          final cameraUpdate = CameraUpdate.newLatLngZoom(
            LatLng(position.latitude, position.longitude),
             zoom, 
             );
          _mapController!.animateCamera(cameraUpdate);
        }
      },
      onError: (e) {
        if (e is LocationServiceDisabledException) {
          _gpsEnabled = false;
          notifyListeners();
        }
      },
    );
  }

  void _setInitialPosition(Position position) {
    if (_gpsEnabled && _initialPosition == null) {
      //_initialPosition = await Geolocator.getLastKnownPosition();
      _initialPosition = position;
    }
  }
  void _setMyPositionMarker(Position position){
    double rotation = 0; 
    if(_lastPosition != null){
    rotation = Geolocator.bearingBetween(
        _lastPosition!.latitude, 
        _lastPosition!.longitude, 
        position.latitude, 
        position.longitude);
    }
    const markerId = MarkerId('my-position');
    final marker = Marker(
      markerId: markerId,
      position: LatLng(position.latitude, position.longitude),
      icon: _carPin,
      anchor: const Offset(0.5, 0.5),
      rotation: rotation, 
      );
      _markers [markerId] = marker;
      _lastPosition = position;
  }

  void onMapCreated(GoogleMapController controller) {
    controller.setMapStyle(mapStyle);
    _mapController = controller;
  }

  Future<void> turnOnGPS() => Geolocator.openLocationSettings();

  // void newPolyline (){
  //   _polylineId = DateTime.now().millisecondsSinceEpoch.toString();
  // }

  // void newPolygon (){
  //   _polygonId = DateTime.now().millisecondsSinceEpoch.toString();
  // }

  void onTap(LatLng position) async {
//MARCADORES 
    final id = _markers.length.toString();
    final markerId = MarkerId(id);

  //  final icon = await _bolsaIcon.future;

    final marker = Marker(
      markerId: markerId,
      position: position,
      draggable: true,
      // anchor: const Offset(0.5, 1),
      //icon: icon,
      onTap: (){
        _markersController.sink.add(id);
      },
      onDragEnd: (newPosition){
        print("new position $newPosition");
      }
    );

    _markers[markerId] = marker;
    notifyListeners();

//POLYLINES

    // final PolylineId polylineId = PolylineId(_polylineId);
    // late Polyline polyline;
    // if (_polylines.containsKey(polylineId)) {
    //  final tmp =  _polylines[polylineId]!;
    //  polyline = tmp.copyWith(
    //    pointsParam: [...tmp.points, position ], 
    //    );
    // } else {
    //   final color = Colors.primaries[_polylines.length];
    //   polyline = Polyline(
    //     polylineId: polylineId, 
    //   points: [position],
    //   width: 5,
    //   color: color,
    //   startCap: Cap.roundCap,
    //   endCap: Cap.roundCap,
    //   );
    // }
    // _polylines[polylineId] = polyline;

//POLYGONOS 

  // final polygonId = PolygonId(_polygonId);
  // late Polygon polygon;
  // if(_polygons.containsKey(polygonId)){
  //   final tmp =  _polygons[polygonId]!;
  //   polygon = tmp.copyWith(
  //     pointsParam: [...tmp.points, position],
  //   );
  // }else{
  //  final color = Colors.primaries[_polygons.length];
  //   polygon = Polygon(
  //     polygonId: polygonId,
  //     points: [position],
  //     strokeWidth: 4,
  //     strokeColor: color,
  //     fillColor: color.withOpacity(0.4)
  //     );
  // }

  //   _polygons[polygonId] = polygon;

  //   notifyListeners();
   }

  @override
  void dispose() {
    _positionSubscription?.cancel();
    _gpsSubscription?.cancel();
    _markersController.close();
    super.dispose();
  }
}
