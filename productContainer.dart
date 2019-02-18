import 'package:flutter/material.dart';

class ProductContainer extends StatefulWidget {
  final String photoUrl;
  final String title;
  final String description;
  final num price;
  final void Function() onTaken;
  final Function onReady;
  ProductContainer(
      {Key key,
      @required this.description,
      @required this.photoUrl,
      @required this.title,
      this.onReady,
      @required this.price,
      @required this.onTaken})
      : super(key: key);

  @override
  ProductContainerState createState() {
    return new ProductContainerState();
  }
}

class ProductContainerState extends State<ProductContainer> {
  int _maxLines = 3;
  @override
  Widget build(BuildContext context) {
    return Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0)),
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: SizedBox(
            // height: 120.0,
            child: Row(
              children: <Widget>[
                Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        CircleAvatar(
                          backgroundImage: NetworkImage(widget.photoUrl),
                          radius: 40,
                        )
                      ],
                    ),
                    flex: 2),
                Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                            child: Text(
                              widget.title,
                              style: TextStyle(
                                  fontSize: 20.0, fontWeight: FontWeight.w600),
                            ),
                            padding: EdgeInsets.only(left: 8.0)),
                        Padding(
                            padding: EdgeInsets.only(
                                bottom: 12.0, top: 4.0, left: 8.0),
                            child: Text(
                              "EGP ${widget.price}",
                              style: TextStyle(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.w600,
                                  color: Theme.of(context).accentColor),
                            )),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: InkWell(
                            onDoubleTap: () {
                              setState(() {
                                _maxLines = _maxLines == 3 ? 20 : 3;
                              });
                            },
                            child: Text(
                              widget.description,
                              style: TextStyle(color: Colors.grey.shade600),
                              overflow: TextOverflow.ellipsis,
                              maxLines: _maxLines,
                            ),
                          ),
                        ),
                      ],
                    ),
                    flex: 6),
                Container(
                    decoration: BoxDecoration(
                        //  color: Theme.of(context).primaryColor.withOpacity(0.7),
                        border:
                            Border.all(color: Theme.of(context).splashColor),
                        borderRadius: BorderRadius.circular(4.0)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        IconButton(
                          icon: Icon(Icons.add_circle_outline),
                          color: Colors.lightGreen,
                          onPressed: widget.onTaken,
                        ),
                        // Center(child: Text(widget.qty.toString())),
                        IconButton(
                          icon: Icon(Icons.cloud_done),
                          color: Colors.redAccent,
                          onPressed: widget.onReady,
                        ),
                      ],
                    )),
              ],
            ),
          ),
        ));
  }
}
