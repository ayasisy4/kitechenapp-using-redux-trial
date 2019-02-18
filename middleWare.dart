import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:redux/redux.dart';
import 'package:redux_epics/redux_epics.dart';
import 'package:rxdart/rxdart.dart';
import '../Model.dart/model.dart';
import '../Model.dart/reducers.dart';
import '../Model.dart/actions.dart';

List<Middleware<AppState>> createMiddleWares() {
  return [
    new EpicMiddleware(_epic),
    new TypedMiddleware((Store<AppState> store, action, NextDispatcher next) {
      debugPrint('Logging action: ${action.runtimeType}');
      next(action);
    }),
  ];
}

final Epic<AppState> _epic = combineEpics(
  <Epic<AppState>>[
    _itemsEpic,
    _editItemEpic,
  ],
);

Stream<dynamic> _itemsEpic(Stream<dynamic> actions, EpicStore<AppState> store) {
  final changeOrder = Observable(actions).ofType(TypeToken<ChangeOrderBy>());
  final request =
      Observable(actions).ofType(TypeToken<RequestItemDataEventAction>());
  final mapper = (changeOrderAction) {
    return _getItemStreamsFromFirestore(changeOrderAction.orderBy)
        .map((items) => new OnListChangedAction(items))
        .takeUntil(
            actions.where((action) => action is CancelItemDataEventAction));
  };
  return Observable.combineLatest2<RequestItemDataEventAction, ChangeOrderBy,
      ChangeOrderBy>(
    request,
    changeOrder,
    (_, changeOrderAction) => changeOrderAction,
  ).switchMap(mapper);
}

Observable<List<Order>> _getItemStreamsFromFirestore(OrderBy orderBy) {
  Query query = Firestore.instance.collection('items');

  if (orderBy == OrderBy.titleDesc || orderBy == OrderBy.titleAsc) {
    query = query.orderBy('title', descending: orderBy == OrderBy.titleDesc);
  } else if (orderBy == OrderBy.timeDesc || orderBy == OrderBy.timeAsc) {
    query = query.orderBy('time', descending: orderBy == OrderBy.timeDesc);
  }

  debugPrint('Order: $orderBy');

  return new Observable(query.snapshots()).map<List<Order>>((querySnapshot) {
    return querySnapshot.documents.map((docSnapshot) {
      return Order(
          type: docSnapshot['type'],
          name: docSnapshot['name'],
          discription: docSnapshot['discription'],
          photoUrl: docSnapshot['photoUrl'],
          price: docSnapshot['price']);
    }).toList();
  });
}

Stream<dynamic> _editItemEpic(
    Stream<dynamic> actions, EpicStore<AppState> store) {
  return new Observable(actions)
      .ofType(TypeToken<EditItemAction>())
      .flatMap((editItemAction) {
    final edit = Firestore.instance
        .collection('items')
        .document(editItemAction.item.id)
        .setData(editItemAction.item.tofactory())
        .then((_) => editItemAction.onComplete())
        .catchError(editItemAction.onError);
    return new Stream.fromFuture(edit);
  });
}
