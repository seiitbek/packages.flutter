// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:math';

import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:epub_view/epub_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_xlider/flutter_xlider.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

import 'custom_slider.dart';

class EpubPage extends StatefulWidget {
  const EpubPage({super.key});

  @override
  State<EpubPage> createState() => _EpubPageState();
}

class _EpubPageState extends State<EpubPage> {
  late EpubController _epubReaderController;
  bool visible = true;
  bool showMore = false;
  bool showThumbValue = true;
  String _lastViewedPosition = '';
  int _sliding = 0;
  int chosenColor = 0;
  double? fontSize = 16;
  double? textHeight = 2;
  double? textPadding = 1;
  String fontFamily = 'Roboto';
  double currentPage = 0;

  double slider1 = 78;

  @override
  void initState() {
    // _epubReaderController = EpubController(
    //   document:
    //       // EpubDocument.openAsset('assets/New-Findings-on-Shirdi-Sai-Baba.epub'),
    //       EpubDocument.openAsset('assets/New-Findings-on-Shirdi-Sai-Baba.epub'),

    //   epubCfi: 'epubcfi(/6/6[chapter-2]!/4/2/1612)',
    //   // epubCfi:
    //   //     'epubcfi(/6/26[id4]!/4/2/2[id4]/22)', // book.epub Chapter 3 paragraph 10
    //   // epubCfi:
    //   //     'epubcfi(/6/6[chapter-2]!/4/2/1612)', // book_2.epub Chapter 16 paragraph 3
    // );
    _initializeEpubController();
    super.initState();
  }

  void _initializeEpubController() {
    _epubReaderController = EpubController(
      document: EpubDocument.openAsset('assets/5.epub'),
      epubCfi: _lastViewedPosition, // Set the last viewed position
    );
  }

  // void _loadLastViewedPosition() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   setState(() {
  //     _lastViewedPosition = prefs.getString('lastViewedPosition') ?? '';
  //   });
  // }

  // void _saveLastViewedPosition(String cfi) async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   prefs.setString('lastViewedPosition', cfi);
  // }

  @override
  void dispose() {
    _epubReaderController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: visible == true
            ? AppBar(
                shadowColor: Colors.transparent,
                iconTheme: IconThemeData(
                  color: chosenColor == 0
                      ? Color(0xFF0144ED)
                      : chosenColor == 1
                          ? Colors.black
                          : Colors.white,
                ),
                backgroundColor: chosenColor == 0
                    ? Colors.white
                    : chosenColor == 1
                        ? Color(0xFFEFE0C9)
                        : Color(0xFF222222),
                // title: EpubViewActualChapter(
                //   controller: _epubReaderController,
                //   builder: (chapterValue) => Text(
                //     chapterValue?.chapter?.Title?.replaceAll('\n', '').trim() ??
                //         '',
                //     style: TextStyle(color: Color(0xFF0144ED)),
                //     textAlign: TextAlign.start,
                //   ),
                // ),
                actions: <Widget>[
                  // IconButton(
                  //   icon: const Icon(Icons.save_alt),
                  //   onPressed: () => _showCurrentEpubCfi(context),
                  // ),
                ],
              )
            : null,
        drawer: Drawer(
          child: EpubViewTableOfContents(
            controller: _epubReaderController,
            backgroundColor: chosenColor == 0
                ? Colors.white
                : chosenColor == 1
                    ? Color(0xFFEFE0C9)
                    : Color(0xFF222222),
            textColor: chosenColor == 2 ? Colors.white : Colors.black,
          ),
        ),
        body: GestureDetector(
          onTap: () {
            setState(() {
              visible = !visible;
              showMore = false;
            });
          },
          child: Stack(
            children: [
              EpubView(
                builders: EpubViewBuilders<DefaultBuilderOptions>(
                  options: DefaultBuilderOptions(
                    textStyle: TextStyle(
                      height: textHeight! * 0.7,
                      fontSize: fontSize,
                      letterSpacing: textPadding,
                      fontFamily: fontFamily,
                      color: chosenColor == 2 ? Colors.white : Colors.black,
                    ),
                  ),
                  chapterDividerBuilder: (_) => const Divider(),
                ),
                controller: _epubReaderController,
                backgroundColor: chosenColor == 0
                    ? Colors.white
                    : chosenColor == 1
                        ? Color(0xFFEFE0C9)
                        : Color(0xFF222222),
                onChapterChanged: (chapter) {
                  currentPage = chapter!.paragraphNumber.toDouble();
                },
              ),
              if (visible)
                Container(
                  color: Colors.black
                      .withOpacity(0.35), // Adjust opacity and color
                ),
            ],
          ),
        ),
        bottomNavigationBar: visible == true
            ? Container(
                color: chosenColor == 0
                    ? Colors.white
                    : chosenColor == 1
                        ? Color(0xFFEFE0C9)
                        : Color(0xFF222222),
                padding: const EdgeInsets.only(
                    left: 4, right: 12, top: 10, bottom: 30),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(
                        Icons.close,
                        size: 30,
                        color: chosenColor == 0
                            ? const Color(0xFF0144ED)
                            : chosenColor == 1
                                ? Colors.black
                                : Colors.white,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(18),
                          color: chosenColor == 0
                              ? Color(0xFFE7EAF4)
                              : chosenColor == 1
                                  ? Colors.white
                                  : Colors.white
                                      .withOpacity(0.1599999964237213),
                        ),
                        child: Container(
                            height: 36,
                            child: FlutterSlider(
                              tooltip: FlutterSliderTooltip(
                                  textStyle: TextStyle(
                                      color: chosenColor == 2
                                          ? Colors.black
                                          : Colors.white),
                                  boxStyle: FlutterSliderTooltipBox(
                                      decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16),
                                    color: chosenColor == 0
                                        ? const Color(0xFF0144ED)
                                        : chosenColor == 1
                                            ? Colors.black
                                            : Colors.white,
                                  ))),
                              trackBar: const FlutterSliderTrackBar(
                                  inactiveTrackBar:
                                      BoxDecoration(color: Colors.transparent),
                                  activeTrackBar:
                                      BoxDecoration(color: Colors.transparent)),
                              values: [currentPage.roundToDouble()],
                              max: 73,
                              min: 0,
                              onDragging:
                                  (handlerIndex, lowerValue, upperValue) {
                                print('CURRENT PARAGRAPH' +
                                    _epubReaderController.currentValueListenable
                                        .value!.paragraphNumber
                                        .toString());
                                // // currentPage = handlerIndex;
                                // // // _lowerValue = lowerValue;
                                // // // _upperValue = upperValue;
                                // // setState(() {
                                // //   _epubReaderController.scrollTo(
                                // //       index: currentPage,
                                // //       duration: Duration(milliseconds: 30));
                                // // });
                                // currentPage = lowerValue;
                                // // _lowerValue = lowerValue;
                                // // _upperValue = upperValue;
                                // setState(() {
                                //   _epubReaderController.scrollTo(
                                //       index: currentPage.round(),
                                //       duration: Duration(milliseconds: 100));
                                // });
                                currentPage = lowerValue;
                                print(lowerValue);
                                setState(() {
                                  _epubReaderController.jumpTo(
                                    index: currentPage.round(),
                                  );
                                  print('HERE:' +
                                      _epubReaderController
                                          .currentValueListenable
                                          .value!
                                          .paragraphNumber
                                          .toString());
                                });
                              },
                              onDragStarted:
                                  (handlerIndex, lowerValue, upperValue) {
                                setState(() {
                                  showThumbValue = false;
                                });
                              },
                              onDragCompleted:
                                  (handlerIndex, lowerValue, upperValue) {
                                // currentPage = lowerValue;
                                // _lowerValue = lowerValue;
                                // _upperValue = upperValue;
                                setState(() {
                                  showThumbValue = true;

                                  // _epubReaderController.scrollTo(
                                  //     index: currentPage.round(),
                                  //     duration: Duration(milliseconds: 250));
                                });
                                // setState(() {
                                //   showThumbValue = true;
                                // });
                              },
                              handler: FlutterSliderHandler(
                                decoration: const BoxDecoration(),
                                child: Material(
                                  type: MaterialType.transparency,
                                  child: Container(
                                      height: 30,
                                      width: 40,
                                      decoration: ShapeDecoration(
                                        color: chosenColor == 0
                                            ? const Color(0xFF0144ED)
                                            : chosenColor == 1
                                                ? Colors.black
                                                : Colors.white,
                                        shape: RoundedRectangleBorder(
                                          side: const BorderSide(
                                            width: 1,
                                            strokeAlign:
                                                BorderSide.strokeAlignOutside,
                                            color: Color(0x3D0144ED),
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(1000),
                                        ),
                                      ),
                                      padding: const EdgeInsets.all(5),
                                      child: Center(
                                        child: showThumbValue == true
                                            ? Text(
                                                currentPage.round().toString(),
                                                style: TextStyle(
                                                    color: chosenColor == 2
                                                        ? Colors.black
                                                        : Colors.white,
                                                    fontSize: 10),
                                              )
                                            : null,
                                      )),
                                ),
                              ),
                            )),
                      ),
                    ),
                    const SizedBox(width: 12),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          showMore = !showMore;
                        });
                      },
                      icon: SvgPicture.asset(
                        showMore == false
                            ? chosenColor == 0
                                ? 'assets/more_settings_closed.svg'
                                : chosenColor == 1
                                    ? 'assets/more_closed_milk_mode.svg'
                                    : 'assets/more_closed_dark_mode.svg'
                            : chosenColor == 0
                                ? 'assets/more_settings_opened.svg'
                                : chosenColor == 1
                                    ? 'assets/more_opened_milk_mode.svg'
                                    : 'assets/more_opened_dark_mode.svg',
                      ),
                    ),
                  ],
                ),
              )
            : null,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: Visibility(
          visible: showMore,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: BlurryContainer(
              // width: 374,
              // height: 266,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
              blur: 5,
              elevation: 0,
              color: const Color.fromARGB(255, 219, 219, 219).withOpacity(0.7),
              borderRadius: const BorderRadius.all(Radius.circular(20)),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    height: 160,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Container(
                            height: 160,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Stack(
                                  children: [
                                    RotatedBox(
                                      quarterTurns: 3,
                                      child: SliderTheme(
                                        data: SliderTheme.of(context).copyWith(
                                          // tickMarkShape: MyRectSliderTickMarkShape(tickMarkRadius: 4.0),
                                          trackShape:
                                              const CustomRoundedRectSliderTrackShape(),
                                          overlayShape:
                                              SliderComponentShape.noThumb,
                                          trackHeight: 70,
                                          thumbColor: Colors.transparent,
                                          thumbShape:
                                              const RoundSliderThumbShape(
                                                  enabledThumbRadius: 0.0),
                                        ),
                                        child: Slider(
                                          value: fontSize!,
                                          max: 40,
                                          min: 5,
                                          activeColor: Colors.white,
                                          inactiveColor:
                                              const Color(0xB7020305),
                                          onChanged: (double value) {
                                            setState(() {
                                              slider1 = value;
                                              fontSize = value;
                                            });
                                          },
                                        ),
                                      ),
                                    ),
                                    IgnorePointer(
                                      child: Column(
                                        children: [
                                          Spacer(),
                                          Container(
                                            width: 70,
                                            child: SvgPicture.asset(
                                              'assets/text_size.svg',
                                              height: 22,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 16,
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(width: 12),
                                Stack(
                                  children: [
                                    RotatedBox(
                                      quarterTurns: 3,
                                      child: SliderTheme(
                                        data: SliderTheme.of(context).copyWith(
                                          trackShape:
                                              const CustomRoundedRectSliderTrackShape(),
                                          overlayShape:
                                              SliderComponentShape.noThumb,
                                          trackHeight: 70,
                                          thumbColor: Colors.transparent,
                                          thumbShape:
                                              const RoundSliderThumbShape(
                                                  enabledThumbRadius: 0.0),
                                        ),
                                        child: Slider(
                                          // divisions: 10,
                                          value: textHeight!,
                                          max: 4,
                                          min: 1,
                                          activeColor: Colors.white,
                                          inactiveColor:
                                              const Color(0xB7020305),
                                          onChanged: (double value) {
                                            setState(() {
                                              textHeight = value;
                                            });
                                          },
                                        ),
                                      ),
                                    ),
                                    IgnorePointer(
                                      child: Column(
                                        children: [
                                          Spacer(),
                                          Container(
                                            width: 70,
                                            child: SvgPicture.asset(
                                              'assets/text_height.svg',
                                            ),
                                          ),
                                          SizedBox(
                                            height: 16,
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: SizedBox(
                            height: double.infinity,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Stack(
                                  children: [
                                    RotatedBox(
                                      quarterTurns: 3,
                                      child: SliderTheme(
                                        data: SliderTheme.of(context).copyWith(
                                          // tickMarkShape: MyRectSliderTickMarkShape(tickMarkRadius: 4.0),
                                          trackShape:
                                              const CustomRoundedRectSliderTrackShape(),
                                          overlayShape:
                                              SliderComponentShape.noThumb,
                                          trackHeight: 70,
                                          thumbColor: Colors.transparent,
                                          thumbShape:
                                              const RoundSliderThumbShape(
                                                  enabledThumbRadius: 0.0),
                                        ),
                                        child: Slider(
                                          value: textPadding!,
                                          max: 3,
                                          min: -1,
                                          activeColor: Colors.white,
                                          inactiveColor:
                                              const Color(0xB7020305),
                                          onChanged: (double value) {
                                            setState(() {
                                              textPadding = value;
                                            });
                                          },
                                        ),
                                      ),
                                    ),
                                    IgnorePointer(
                                      child: Column(
                                        children: [
                                          Spacer(),
                                          Container(
                                            width: 70,
                                            child: SvgPicture.asset(
                                              'assets/horizontal_padding.svg',
                                            ),
                                          ),
                                          SizedBox(
                                            height: 16,
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Container(
                                    height: double.infinity,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 16),
                                    clipBehavior: Clip.antiAlias,
                                    decoration: ShapeDecoration(
                                      color: const Color(0xB7020305),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                    ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              chosenColor = 0;
                                            });
                                          },
                                          child: CustomRadioButtonWidget(
                                            color: Colors.white,
                                            chosen:
                                                chosenColor == 0 ? true : false,
                                          ),
                                        ),
                                        const Spacer(),
                                        GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              chosenColor = 1;
                                            });
                                          },
                                          child: CustomRadioButtonWidget(
                                            color: const Color(0xFFEFE0C9),
                                            chosen:
                                                chosenColor == 1 ? true : false,
                                          ),
                                        ),
                                        const Spacer(),
                                        GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              chosenColor = 2;
                                            });
                                          },
                                          child: CustomRadioButtonWidget(
                                            color: const Color(0xFF222222),
                                            chosen:
                                                chosenColor == 2 ? true : false,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),
                  SizedBox(
                    width: double.infinity,
                    // alignment: Alignment.center,
                    // padding: EdgeInsets.all(10),
                    child: CupertinoSlidingSegmentedControl<int>(
                        backgroundColor: const Color(0xB7020305),
                        children: {
                          0: Padding(
                              padding: const EdgeInsets.all(8),
                              child: Text(
                                'Aa',
                                style: TextStyle(
                                  color: _sliding == 0
                                      ? const Color(0xB7020305)
                                      : Colors.white.withOpacity(0.5),
                                  fontSize: 19,
                                  fontFamily: 'Roboto',
                                  fontWeight: FontWeight.w400,
                                ),
                              )),
                          1: Text(
                            'Aa',
                            style: TextStyle(
                              color: _sliding == 1
                                  ? const Color(0xB7020305)
                                  : Colors.white.withOpacity(0.5),
                              fontSize: 19,
                              fontFamily: 'Bookerly',
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          2: Text(
                            'Aa',
                            style: TextStyle(
                              color: _sliding == 2
                                  ? const Color(0xB7020305)
                                  : Colors.white.withOpacity(0.5),
                              fontSize: 19,
                              fontFamily: 'Baskerville',
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          3: Text(
                            'Aa',
                            style: TextStyle(
                              color: _sliding == 3
                                  ? const Color(0xB7020305)
                                  : Colors.white.withOpacity(0.5),
                              fontSize: 19,
                              fontFamily: 'Times New Roman',
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          4: Text(
                            'Aa',
                            style: TextStyle(
                              color: _sliding == 4
                                  ? const Color(0xB7020305)
                                  : Colors.white.withOpacity(0.5),
                              fontSize: 19,
                              fontFamily: 'Arial',
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        },
                        groupValue: _sliding,
                        onValueChanged: (newValue) {
                          setState(() {
                            _sliding = newValue!;

                            switch (_sliding) {
                              case 0:
                                fontFamily = 'Roboto';
                                break;
                              case 1:
                                fontFamily = 'Bookerly';
                                break;
                              case 2:
                                fontFamily = 'Baskerville';
                                break;
                              case 3:
                                fontFamily = 'Times New Roman';
                                break;
                              case 4:
                                fontFamily = 'Arial';
                                break;
                            }
                          });
                        }),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

  void _showCurrentEpubCfi(context) {
    final cfi = _epubReaderController.generateEpubCfi();

    if (cfi != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(cfi),
          action: SnackBarAction(
            label: 'GO',
            onPressed: () {
              _epubReaderController.gotoEpubCfi(cfi);
            },
          ),
        ),
      );
    }
  }
}

class CustomRadioButtonWidget extends StatelessWidget {
  Color color;
  bool chosen;
  CustomRadioButtonWidget({
    Key? key,
    required this.color,
    required this.chosen,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return chosen == true
        ? SizedBox(
            width: 30,
            height: 30,
            child: Stack(
              children: [
                Positioned(
                  left: 4,
                  top: 4,
                  child: Container(
                    width: 22,
                    height: 22,
                    decoration: ShapeDecoration(
                      color: color,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(11),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 0,
                  top: 0,
                  child: Container(
                    width: 30,
                    height: 30,
                    decoration: ShapeDecoration(
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                          width: 1.50,
                          strokeAlign: BorderSide.strokeAlignCenter,
                          color: color,
                        ),
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        : Container(
            width: 30,
            height: 30,
            decoration: ShapeDecoration(
              color: color,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
          );
  }
}
