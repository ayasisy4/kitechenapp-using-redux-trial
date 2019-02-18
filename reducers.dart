import '../Model.dart/model.dart';
import '../Model.dart/actions.dart';
import 'package:redux/redux.dart';

final appReducer = combineReducers(<Reducer<AppState>>[
  TypedReducer<AppState, OnListChangedAction>(onListChangeReducer),
  TypedReducer<AppState, ChangeOrderBy>(changeOrderByReducer),
]);

AppState onListChangeReducer(AppState state, OnListChangedAction action) {
  return state.copyWith(orders: action.items);
}

// Order editTaken(Order state,EditItemAction action){
//   return state.copywith(Order:action.item)
// }

AppState changeOrderByReducer(AppState state, ChangeOrderBy action) {
  final comparator = getComparator(action.orderBy);
  final items = new List<Order>.of(state.allOrders)..sort(comparator);
  return state.copyWith(orders: items);
}

Comparator<Order> getComparator(OrderBy orderBy) {
  if (orderBy == OrderBy.titleAsc) {
    return (l, r) => l.name.compareTo(r.name);
  }
  if (orderBy == OrderBy.titleDesc) {
    return (l, r) => r.name.compareTo(l.name);
  }
  if (orderBy == OrderBy.timeAsc) {
    return (l, r) => l.name.compareTo(r.name);
  }
  if (orderBy == OrderBy.timeDesc) {
    return (l, r) => r.name.compareTo(l.name);
  }
  throw StateError('State error');
}
// AppState appStateReducer(AppState state, action) {
//   return AppState(
//     allOrders: null,
//     user: userReducer(state.user, action),
//   );
// }

// User userReducer(User user, action) {
// //actionsss test
//   if (action is EditName) {
//     print('object');
//     print(action.name);
//     //print(user.imgUrl);

//     return user.copywith(name: action.name);
//   } else if (action is AddPhotoFromCam) {
//     return User(imgUrl: action.cam);
//   } else if (action is AddPhotoFromGall) {
//     return User(imgUrl: action.gall);
//   }
//   return User(name: user.name, imgUrl: user.imgUrl);
// }
