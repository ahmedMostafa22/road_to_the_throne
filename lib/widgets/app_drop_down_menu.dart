import 'package:flutter/material.dart';

class MyPopupMenu extends StatefulWidget {
  const MyPopupMenu({Key? key, required this.data, required this.onChanged})
      : super(key: key);
  final List<String> data;
  final ValueChanged<dynamic> onChanged;

  @override
  _MyPopupMenuState createState() => _MyPopupMenuState();
}

class _MyPopupMenuState extends State<MyPopupMenu> {
  late Object? value;

  @override
  void initState() {
    value = widget.data[0];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(40),
          color: Theme.of(context).primaryColor),
      child: PopupMenuButton(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                value.toString(),
                style: TextStyle(
                    fontSize: 20, color: Theme.of(context).canvasColor),
              ),
              SizedBox(width: 4),
              Icon(Icons.keyboard_arrow_down,
                  color: Theme.of(context).canvasColor, size: 35)
            ],
          ),
        ),
        color: Theme.of(context).primaryColor,
        initialValue: value,
        onSelected: (val) {
          setState(() => value = val);
          widget.onChanged(val);
        },
        itemBuilder: (BuildContext context) => widget.data
            .map((p) => PopupMenuItem(
                child: Text(
                  p,
                  style: TextStyle(
                    color: Theme.of(context).canvasColor,
                    fontSize: 20,
                  ),
                ),
                value: p))
            .toList(),
      ),
    );
  }
}
