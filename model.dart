import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:io';

class User {
  // final num phone;
  String name, photoUrl;
  File imgUrl;
  List<Order> accOrders;
  List<Order> readyOrders;
  User(
      {this.name,
      this.imgUrl,
      this.accOrders,
      this.readyOrders,
      this.photoUrl});
  User.initialState()
      : accOrders = List.unmodifiable(<Order>[]),
        readyOrders = List.unmodifiable(<Order>[]),
        imgUrl = null,
        photoUrl =
            'https://cdn.arstechnica.net/wp-content/uploads/2018/09/Screen-Shot-2018-09-21-at-3.36.21-PM-800x597.png',
        name = '';
  // phone = null;

  User copyWith({int phone, String name, String imgUrl}) {
    return User(
      imgUrl: imgUrl ?? this.imgUrl,
      name: name ?? this.name,
    );
  }
}

enum OrderBy { titleAsc, timeAsc, titleDesc, timeDesc }

class Order {
  final String name, discription, type, photoUrl, id;
  final num price;
  final bool taken, ready;

  Map<String, dynamic> tofactory() => {
        'name': name,
        'discription': discription,
        'type': type,
        'price': price,
        'taken': taken,
        'ready': ready,
        'photoUrl': photoUrl,
      };
  Order(
      {@required this.name,
      this.discription,
      this.id,
      this.price,
      this.taken,
      this.ready,
      @required this.type,
      @required this.photoUrl});
  Order copyWithp(
      {nameadd, typeadd, takenadd, readyadd, discription, photoUrl}) {
    return Order(
      name: nameadd ?? this.name,
      type: typeadd ?? this.type,
      taken: takenadd ?? this.taken,
      ready: readyadd ?? this.ready,
      discription: discription ?? this.discription,
      photoUrl: photoUrl ?? this.photoUrl,
    );
  }
}

class AppState {
  List<Order> allOrders;
  User user;
  AppState({this.user, this.allOrders});
  AppState.initialState()
      : user = User.initialState(),
        allOrders = List.unmodifiable(<Order>[]);
  AppState copyWith({List<Order> orders, User useridentity}) {
    return AppState(
      allOrders: orders ?? this.allOrders,
      user: useridentity ?? this.user,
    );
  }
}
