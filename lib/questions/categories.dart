import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

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

  final String? department;
  final String? courseCode;
  final String? section;

  Category(
      {required this.department,
      required this.courseCode,
      required this.section});

  String getType() {
    return toString().split('/')[0];
  }

  String getName() {
    return toString().split('/')[1];
  }

  Color getColor(BuildContext context) {
    var type = getType();

    if (type == '학과') {
      return const Color(0XFF9DDE8B);
    }
    if (type == '강의') {
      return const Color(0XFFFFAF61);
    }
    return const Color(0XFF68D2E8);
  }

  @override
  String toString() {
    if (courseCode == null) {
      return "학과/$department";
    } else if (section == null) {
      return "강의/$department$courseCode";
    } else {
      return "분반/$department$courseCode($section)";
    }
  }

  Map<String, dynamic> toJson() {
    if (courseCode == null) {
      return {"department": department};
    } else if (section == null) {
      return {"department": department, "course": courseCode};
    } else {
      return {
        "department": department,
        "course": courseCode,
        "section": section
      };
    }
  }

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
        department: json['department'],
        courseCode: json['course'],
        section: json['section']);
  }

  Widget makeBox(BuildContext context) {
    final categoryBorderRadius = BorderRadius.circular(8);
    return Container(
      decoration: BoxDecoration(
        borderRadius: categoryBorderRadius,
        color: getColor(context),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: categoryBorderRadius,
          onTap: () {},
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 2.0),
            child: Text(
              toString(),
              style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 11.0,
                  color: Colors.black),
            ),
          ),
        ),
      ),
    );
  }
}

class ChooseCategory extends StatefulWidget {
  final Function(Category?) onCategorySelected;

  ChooseCategory({super.key, required this.onCategorySelected});

  @override
  State<ChooseCategory> createState() => _ChooseCategoryState();
}

class _ChooseCategoryState extends State<ChooseCategory>
    with SingleTickerProviderStateMixin {
  String? _department;
  String? _courseCode;
  String? _section;
  bool _askingConfirm = false;

  int hundred = 0;
  int ten = 0;
  int one = 0;

  int _pageNum = 0;

  late AnimationController _animationController;
  late Animation<Offset> _offset;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 100));

    _offset = Tween<Offset>(
            begin: const Offset(0.0, 1.0), end: const Offset(0.0, 0.0))
        .animate(_animationController);
  }

  @override
  Widget build(BuildContext context) {
    _animationController.reset();

    return Column(mainAxisSize: MainAxisSize.min, children: [
      topBarBuilder(),
      Expanded(
        child: <Widget>[
          departmentSelector(context),
          courseCodeSelector(context),
          sectionSelector(context)
        ][_pageNum],
      ),
    ]);
  }

  Widget departmentSelector(BuildContext context) {
    var home = Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: GridView.count(
          crossAxisCount: 3,
          childAspectRatio: 2,
          children: List.generate(Category.depts.length, (index) {
            var dept = Category.depts[index];
            return Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Theme.of(context).colorScheme.primary,
                          foregroundColor:
                              Theme.of(context).colorScheme.onSecondary),
                      onPressed: () {
                        setState(() {
                          _department = dept;
                          _askingConfirm = true;
                        });
                      },
                      child: Text(dept),
                    ),
                  ),
                ),
              ],
            );
          }),
        ),
      ),
    );

    if (_askingConfirm) {
      return Stack(
        children: [
          Column(
            children: [
              home,
            ],
          ),
          bottomBar(context, "\"학과/$_department\"에 질문하기", "과목 코드 선택하기")
        ],
      );
    } else {
      return Column(
        children: [
          home,
        ],
      );
    }
  }

  Widget courseCodeSelector(BuildContext context) {
    var controller = TextEditingController();

    var home = Align(
      alignment: Alignment.topCenter,
      child: SizedBox(
        width: 150,
        child: PinCodeTextField(
          controller: controller,
          length: 3,
          appContext: context,
          keyboardType: TextInputType.number,
          cursorColor: Theme.of(context).colorScheme.secondary,
          pinTheme: PinTheme(
              shape: PinCodeFieldShape.box,
              borderRadius: BorderRadius.circular(10),
              selectedColor: Theme.of(context).colorScheme.secondary,
              inactiveColor: Theme.of(context).disabledColor,
              activeColor: Theme.of(context).disabledColor),
          animationDuration: const Duration(milliseconds: 50),
          onCompleted: (value) {
            setState(() {
              _courseCode = value;
              _askingConfirm = true;
            });
          },
        ),
      ),
    );

    if (_courseCode != null) {
      controller.text = _courseCode!;
    }

    if (_askingConfirm) {
      return Stack(
        children: [
          home,
          bottomBar(context, "\"강의 $_department$_courseCode\"에 질문하기", "분반 선택하기")
        ],
      );
    }
    return home;
  }

  Widget sectionSelector(BuildContext context) {
    var controller = TextEditingController();

    var home = Align(
      alignment: Alignment.topCenter,
      child: PinCodeTextField(
        inputFormatters: [FilteringTextInputFormatter.allow(RegExp("[A-Z]"))],
        textCapitalization: TextCapitalization.characters,
        mainAxisAlignment: MainAxisAlignment.center,
        controller: controller,
        length: 1,
        appContext: context,
        cursorColor: Theme.of(context).colorScheme.secondary,
        pinTheme: PinTheme(
            shape: PinCodeFieldShape.box,
            borderRadius: BorderRadius.circular(10),
            selectedColor: Theme.of(context).colorScheme.secondary,
            inactiveColor: Theme.of(context).disabledColor,
            activeColor: Theme.of(context).disabledColor),
        animationDuration: const Duration(milliseconds: 50),
        onCompleted: (value) {
          setState(() {
            _section = value;
            _askingConfirm = true;
          });
        },
      ),
    );

    if (_section != null) {
      controller.text = _section!;
    }

    if (_askingConfirm) {
      return Stack(
        children: [
          home,
          bottomBar(
              context, "\"분반 $_department$_courseCode($_section)\"에 질문하기", null)
        ],
      );
    }
    return home;
  }

  Widget topBarBuilder() {
    final currentTextStyle = Theme.of(context).textTheme.headlineSmall;
    final selectedTextStyle = Theme.of(context).textTheme.bodyMedium;

    var children = <Widget>[];

    switch (_pageNum) {
      case 0:
        children = [
          Text(
            "학과",
            style: currentTextStyle,
          )
        ];
        break;

      case 1:
        children = [
          Text(
            _department!,
            style: selectedTextStyle,
          ),
          const Icon(Icons.navigate_next),
          Text(
            "과목 코드",
            style: currentTextStyle,
          )
        ];
        break;

      case 2:
        children = [
          Text(
            "$_department$_courseCode",
            style: selectedTextStyle,
          ),
          const Icon(Icons.navigate_next),
          Text(
            "분반",
            style: currentTextStyle,
          )
        ];
        break;
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          IconButton(
            onPressed: () {
              if (_pageNum == 0) {
                widget.onCategorySelected(null);
                Navigator.pop(context);
              } else {
                setState(() {
                  switch (_pageNum) {
                    case 1:
                      _courseCode = null;
                      break;
                    case 2:
                      _section = null;
                      break;
                  }
                  _pageNum--;
                });
              }
            },
            icon: const Icon(Icons.navigate_before),
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

  Widget bottomBar(BuildContext context, String confirmText, String? nextText) {
    _animationController.forward();
    return Align(
      alignment: Alignment.bottomCenter,
      child: FittedBox(
        child: SlideTransition(
          position: _offset,
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Card(
              color: Theme.of(context).colorScheme.primaryContainer,
              child: Column(
                children: [
                  ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Theme.of(context).colorScheme.primaryContainer,
                          foregroundColor:
                              Theme.of(context).colorScheme.onPrimaryContainer),
                      onPressed: () {
                        widget.onCategorySelected(Category(
                            department: _department,
                            courseCode: _courseCode,
                            section: _section));
                        Navigator.of(context).pop();
                      },
                      icon: const Icon(Icons.check),
                      label: Text(confirmText)),
                  nextText != null
                      ? ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(context)
                                  .colorScheme
                                  .primaryContainer,
                              foregroundColor: Theme.of(context)
                                  .colorScheme
                                  .onPrimaryContainer),
                          onPressed: () {
                            setState(() {
                              _askingConfirm = false;
                              _pageNum++;
                            });
                          },
                          icon: const Icon(Icons.navigate_next),
                          label: Text(nextText))
                      : const SizedBox()
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
