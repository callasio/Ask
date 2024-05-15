// ignore_for_file: prefer_const_constructors_in_immutables

import 'package:flutter/animation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Category {
  static const List<String> types = ["학과", "강의", "분반"];
  static const List<String> depts = [
    'ME',
    'ITM',
    'AS',
    'RE',
    'QU',
    'MBI',
    'SS',
    'EE',
    'CD',
    'BTM',
    'CTP',
    'CC',
    'ICE',
    'SPE',
    'GFS',
    'GCT',
    'BiS',
    'PD',
    'BME',
    'DS',
    'ID',
    'FS',
    'MSE',
    'MO',
    'CBE',
    'IP',
    'MS',
    'CS',
    'SJ',
    'GDI',
    'BIZ',
    'BCS',
    'EB',
    'GGS',
    'URP',
    'SEP',
    'MIP',
    'HSS',
    'KTP',
    'STP',
    'MAS',
    'ST',
    'FSM',
    'MV',
    'CoE',
    'CH',
    'PH',
    'IE',
    'KEI',
    'NQE',
    'BAF',
    'BCE',
    'BS',
    'DHS',
    'IS',
    'AI',
    'AE',
    'TS',
    'CE'
  ];
}

class ChooseCategory extends StatefulWidget {
  final Function(Category) onCategorySelected;

  ChooseCategory({super.key, required this.onCategorySelected});

  @override
  State<ChooseCategory> createState() => _ChooseCategoryState();
}

class _ChooseCategoryState extends State<ChooseCategory>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _animation;

  String? _department;
  String? _courseNum;
  String? _section;

  int get _pageNum => _department == null
      ? 0
      : _courseNum == null
          ? 1
          : _section == null
              ? 2
              : 3;

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisSize: MainAxisSize.min, children: [
      appBarBuilder(),
      Expanded(
        child: <Widget>[
          ListView.builder(
              itemCount: Category.depts.length,
              itemBuilder: (context, index) {
                var dept = Category.depts[index];
                return Row(
                  children: [
                    const Spacer(flex: 3),
                    Expanded(
                      flex: 2,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 1.5),
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _department = dept;
                            });
                          },
                          child: Text(dept),
                        ),
                      ),
                    ),
                    const Spacer(flex: 3),
                  ],
                );
              }),
          const Text("SeLeCt CoRuSe")
        ][_pageNum],
      ),
    ]);
  }

  Widget appBarBuilder() {
    final currentTextStyle = Theme.of(context).textTheme.headlineSmall;
    final selectedTextStyle = Theme.of(context).textTheme.bodyMedium;

    var children = <Widget>[];
    if (_department == null) {
      children = [
        Text(
          "학과",
          style: currentTextStyle,
        )
      ];
    } else {
      if (_courseNum == null) {
        children = [
          Text(
            _department!,
            style: selectedTextStyle,
          ),
          const Icon(Icons.navigate_next),
          Text(
            "강의",
            style: currentTextStyle,
          )
        ];
      } else {
        children = [
          Text(
            "$_department$_courseNum",
            style: selectedTextStyle,
          ),
          const Icon(Icons.navigate_next),
          Text(
            "분반",
            style: currentTextStyle,
          )
        ];
      }
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          IconButton(
            onPressed: () {
              setState(() {
                if (_pageNum == 0) {
                  Navigator.pop(context);
                } else if (_pageNum == 1) {
                  _department = null;
                } else if (_pageNum == 2) {
                  _courseNum = null;
                }
              });
            },
            icon: const Icon(Icons.close),
          ),
          const SizedBox(
            width: 6,
          ),
          Row(
            children: children,
          ),
        ],
      ),
    );
  }
}
