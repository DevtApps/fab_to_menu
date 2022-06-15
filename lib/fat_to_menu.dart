library fat_to_menu;

import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class FabToMenu extends StatefulWidget {
  Color? menuColor;
  Color? fabColor;
  Color? iconFabColor;
  ///Duration of animation
  Duration? duration;
  ///width of menu
  double width;
  ///height of menu
  double? height;
  ///current item selected, optional
  dynamic value;
  ///callback item clicked, return a value
  Function(dynamic) onSelected;
  List<FabMenuItem> items;

  FabToMenu(
      {
        required this.items,
      required this.onSelected,
      this.height,
      this.value,
      this.width = 200,
      this.menuColor,
      this.fabColor,
      this.iconFabColor,
      this.duration});

  @override
  State<FabToMenu> createState() => _FabToMenuState();
}

class _FabToMenuState extends State<FabToMenu> {
  bool isOpen = false;
  bool showItems = false;
  bool isMaterial3 = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();


  }

  @override
  Widget build(BuildContext context) {
    isMaterial3 = Theme.of(context).useMaterial3;
    if (widget.height == null) {
      widget.height = widget.items.length * 60;
    }
    return AnimatedContainer(
      width: isOpen ? widget.width : 60,
      height: isOpen ? widget.height : 60,
      duration: widget.duration?? Duration(milliseconds: 500),
      curve: Curves.ease,
      onEnd: () {
        if (isOpen) {
          setState(() {
            showItems = true;
          });
        }
      },
      child: Stack(
        children: [
          AnimatedContainer(
            width: isOpen ? widget.width : 60,
            height: isOpen ? widget.height : 60,
            duration:  widget.duration?? Duration(milliseconds: 500),
            curve: Curves.ease,
            child: FloatingActionButton(
              backgroundColor: widget.fabColor,
              foregroundColor: widget.iconFabColor,
              onPressed: () {
                setState(() {
                  isOpen = true;
                });
              },
              child: Icon(Icons.filter_list_outlined),
            ),
          ),
          IgnorePointer(
            ignoring: !isOpen,
            child: AnimatedOpacity(
              opacity: isOpen ? 1 : 0,
              alwaysIncludeSemantics: true,
              duration:  widget.duration != null?Duration(milliseconds: (widget.duration!.inMilliseconds *0.7).toInt() ):Duration(milliseconds: 500),
              child: AnimatedContainer(
                curve: Curves.ease,
                width: isOpen ? widget.width : 60,
                height: isOpen ? widget.height : 60,
                decoration: BoxDecoration(
                  color: isOpen
                      ? widget.menuColor?? Colors.white
                      : widget.fabColor?? Theme.of(context).primaryColor.withOpacity(isOpen ? 1 : 0),
                  borderRadius: isMaterial3? BorderRadius.circular( isOpen?16:100): BorderRadius.circular(16),
                ),
                duration:  widget.duration?? Duration(milliseconds: 500),
                child: ListView(
                  children: List.generate(widget.items.length, (index) {
                    FabMenuItem fabMenuItem = widget.items[index];
                    return Container(
                      height: 60,
                      child: ListTile(
                        tileColor: widget.menuColor?? Colors.white ,
                        selected: fabMenuItem.value == (widget.value??""),
                        title: Text(fabMenuItem.title),
                        subtitle: fabMenuItem.subtitle,
                        onTap: () {
                          widget.onSelected(fabMenuItem.value);
                          setState(() {
                            isOpen = false;
                          });
                        },
                    ),
                    );
                  }),
                )
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class FabMenuItem {
  String title;
  Text? subtitle;
  dynamic value;

  FabMenuItem(
      {required this.title, required this.value, this.subtitle});
}
