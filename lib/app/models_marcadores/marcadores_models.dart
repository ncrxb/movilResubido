import 'package:flutter/material.dart';


class MarcadoresCModel{
  String nombre_negocio;
  String direccion;
  int latitud;
  int longitud;


  MarcadoresCModel({
    required nombre_negocio,
    required direccion,
    required latitud,
    required longitud,

  });

  factory MarcadoresCModel.formMapJson(Map<String,dynamic> marcadores) =>
    MarcadoresCModel(
      nombre_negocio: marcadores['nombre_negocio'], 
      direccion: marcadores['direccion'],
      latitud: marcadores['latitud'],
      longitud: marcadores['longitud'],
      );


}