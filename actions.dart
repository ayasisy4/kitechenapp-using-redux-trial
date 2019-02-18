import 'dart:async';
import 'dart:ui';

import "../Model.dart/model.dart";
import 'dart:io';

class EditName {
  final String name;
  EditName({this.name});
}

class AddPhotoFromCam {
  final File cam;
  AddPhotoFromCam({this.cam});
}

class AddPhotoFromGall {
  final File gall;
  AddPhotoFromGall({this.gall});
}

class ChangeOrderBy {
  final OrderBy orderBy;

  ChangeOrderBy(this.orderBy);
}

class OnListChangedAction {
  final List<Order> items;

  OnListChangedAction(this.items);
}

class RequestItemDataEventAction {}

class CancelItemDataEventAction {}

class AddItemAction {
  final Order item;
  final VoidCallback onComplete;
  final FutureOr<dynamic> Function(dynamic error) onError;

  AddItemAction({
    this.item,
    this.onComplete,
    this.onError,
  });
}

class EditItemAction {
  final Order item;
  final VoidCallback onComplete;
  final FutureOr<dynamic> Function(dynamic error) onError;

  EditItemAction({
    this.item,
    this.onComplete,
    this.onError,
  });
}

class RemoveItemAction {
  final Order item;
  final VoidCallback onComplete;
  final FutureOr<dynamic> Function(dynamic error) onError;

  RemoveItemAction({
    this.item,
    this.onComplete,
    this.onError,
  });
}

class RemoveAllItemAction {
  final VoidCallback onComplete;
  final FutureOr<dynamic> Function(dynamic error) onError;

  RemoveAllItemAction({
    this.onComplete,
    this.onError,
  });
}
