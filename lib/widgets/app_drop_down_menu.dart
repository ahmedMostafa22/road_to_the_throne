import 'package:flutter/material.dart';
import 'package:road_to_the_throne/models/drop_down_item.dart';

class MyPopupMenu extends StatefulWidget {
  const MyPopupMenu({Key? key, required this.data, required this.onChanged})
      : super(key: key);
  final List<DropDownItemModel> data;
  final ValueChanged<DropDownItemModel> onChanged;

  @override
  _MyPopupMenuState createState() => _MyPopupMenuState();
}

class _MyPopupMenuState extends State<MyPopupMenu> {
  late DropDownItemModel value = widget.data[0];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(80),
          color: Theme.of(context).primaryColor),
      child: PopupMenuButton(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (value.imageUrl != null)
                CircleAvatar(
                    backgroundColor: Colors.transparent,
                    backgroundImage: NetworkImage(value.imageUrl!),
                    radius: 15),
              const SizedBox(width: 8),
              Text(
                value.text,
                style: TextStyle(
                    fontSize: 20, color: Theme.of(context).canvasColor),
              ),
              const SizedBox(width: 8),
              Icon(Icons.keyboard_arrow_down,
                  color: Theme.of(context).canvasColor, size: 35)
            ],
          ),
        ),
        color: Theme.of(context).primaryColor,
        initialValue: value,
        onSelected: (val) {
          val = val as DropDownItemModel;
          setState(() => value =
              DropDownItemModel((val as DropDownItemModel).text, val.imageUrl));
          widget.onChanged(val);
        },
        itemBuilder: (BuildContext context) => widget.data
            .map((p) => PopupMenuItem(
                child: Row(
                  children: [
                    if (value.imageUrl != null)
                      CircleAvatar(
                          backgroundColor: Colors.white,
                          backgroundImage: NetworkImage(p.imageUrl!),
                          radius: 15),
                    const SizedBox(width: 8),
                    Text(
                      p.text,
                      style: TextStyle(
                          color: Theme.of(context).canvasColor, fontSize: 18),
                    ),
                  ],
                ),
                value: p))
            .toList(),
      ),
    );
  }
}
