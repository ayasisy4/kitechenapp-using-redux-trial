import 'package:flutter/material.dart';
import 'package:kitchen_app/Model.dart/actions.dart';
import 'package:kitchen_app/Model.dart/model.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:kitchen_app/UI/productContainer.dart';

@immutable
class HomePageViewModel {
  final List<Order> items;
  final void Function(Order) onTakencallback;
  final void Function(Order) onReadycallback;
  final ValueChanged<OrderBy> orderByCallback;
  final VoidCallback removeAllCallback;

  HomePageViewModel({
    this.items,
    @required this.onTakencallback,
    this.onReadycallback,
    this.orderByCallback,
    this.removeAllCallback,
  });
}

class MyHomePage2 extends StatelessWidget {
  final _scaffoldKey = new GlobalKey<ScaffoldState>();
  final _colors = <Color>[
    Colors.cyan,
    Colors.blue,
    Colors.purple,
    Colors.pink,
    Colors.black,
    Colors.teal
  ];

  @override
  Widget build(BuildContext context) {
    return new StoreConnector<AppState, HomePageViewModel>(
      onInit: (store) {
        store.dispatch(RequestItemDataEventAction());
        store.dispatch(ChangeOrderBy(OrderBy.timeDesc));
      },
      onDispose: (store) => store.dispatch(CancelItemDataEventAction()),
      builder: (BuildContext context, HomePageViewModel viewModel) {
        return new Scaffold(
          key: _scaffoldKey,
          appBar: new AppBar(
            title: new Text('Demo redux flutter'),
            actions: <Widget>[
              IconButton(
                tooltip: 'Sort order',
                icon: Icon(Icons.sort),
                onPressed: () =>
                    _showSortOrderDialog(viewModel.orderByCallback, context),
              ),
              IconButton(
                tooltip: 'Remove all',
                icon: Icon(Icons.delete_forever),
                onPressed: () => null,
              )
//here I SHOULD remove all the elemnt               ),
            ],
          ),
          body: new ListView.builder(
              itemBuilder: (BuildContext context, int index) {
            final item = viewModel.items[index];
            return new ProductContainer(
              photoUrl: item.photoUrl,
              title: item.name,
              description: item.discription,
              price: item.price,
              onTaken: null,
              onReady: null,
            );
          }),
        );
      },
      converter: (Store<AppState> store) {
        return new HomePageViewModel(
          items: store.state.allOrders,
          onTakencallback: (Order item) {
            store.dispatch(
              EditItemAction(
                item: item,
                onComplete: () => _showMessage('Item added successfully'),
                onError: (e) => _showMessage('Item added error: $e'),
              ),
            );
          },
          onReadycallback: (item) {
            store.dispatch(
              EditItemAction(
                item: item,
                onComplete: () => _showMessage('Item edited successfully'),
                onError: (e) => _showMessage('Item edited error: $e'),
              ),
            );
          },
          orderByCallback: (OrderBy value) =>
              store.dispatch(ChangeOrderBy(value)),
          removeAllCallback: () => store.dispatch(
                RemoveAllItemAction(
                  onError: (e) => _showMessage('Remove all error: $e'),
                  onComplete: () => _showMessage('Remove all successfully'),
                ),
              ),
        );
      },
    );
  }

  _showMessage(String msg) {
    _scaffoldKey.currentState?.showSnackBar(SnackBar(content: Text(msg)));
  }

  _showSortOrderDialog(
      ValueChanged<OrderBy> orderByCallback, BuildContext context) async {
    final orderBy = await showDialog<OrderBy>(
        context: context,
        builder: (BuildContext context) {
          return new SimpleDialog(
            title: Text('Select sort order'),
            children: <Widget>[
              new SimpleDialogOption(
                child: Text('Title ascending'),
                onPressed: () =>
                    Navigator.pop<OrderBy>(context, OrderBy.titleAsc),
              ),
              new SimpleDialogOption(
                child: Text('Title descending'),
                onPressed: () =>
                    Navigator.pop<OrderBy>(context, OrderBy.titleDesc),
              ),
              new SimpleDialogOption(
                child: Text('Time ascending'),
                onPressed: () =>
                    Navigator.pop<OrderBy>(context, OrderBy.timeAsc),
              ),
              new SimpleDialogOption(
                child: Text('Time descending'),
                onPressed: () =>
                    Navigator.pop<OrderBy>(context, OrderBy.timeDesc),
              ),
            ],
          );
        });
    orderByCallback(orderBy);
  }
}
