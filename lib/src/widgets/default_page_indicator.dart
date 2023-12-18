import 'package:collection/collection.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:stepper_page_view/src/models/page_controls_details.dart';
import 'package:stepper_page_view/src/models/page_step.dart';
import 'package:stepper_page_view/src/utils/list_utils.dart';

/// A default page indicator with dots and circle pages
class DefaultPageIndicator extends StatelessWidget {
  const DefaultPageIndicator({
    super.key,
    required this.pageSteps,
    required this.pageControlsDetails,
    required this.pageProgress,
    this.iconName,
    this.iconTap,
  });

  final List<PageStep> pageSteps;

  final PageControlsDetails pageControlsDetails;

  final ValueListenable<double> pageProgress;

  final VoidCallback? iconTap;

  final IconData? iconName;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final currentStep = pageControlsDetails.currentStep;
    final onStepSelect = pageControlsDetails.onStepSelect;

    return Material(
      // borderRadius: BorderRadius.circular(32.0),
      color: Color(0xFFFDF0F2),
      elevation: 0.0,
      child: Padding(
          padding: const EdgeInsets.only(left: 10.0, top: 5.0, bottom: 5.0),
          child: Row(
              children: [
                IconButton(
                  icon: Icon(
                      iconName,
                      color: Color(0xFFF22853)
                  ),
                  onPressed: iconTap,
                ),
                Expanded(
                  child: Padding(
                      padding: const EdgeInsets.only(left: 6.0, right: 16.0),
                  child: ValueListenableBuilder<double>(
                    valueListenable: pageProgress,
                    builder: (context, progress, _) {
                      // progress goes up to pageSteps.length

                      return Row(
                        mainAxisSize: MainAxisSize.max,
                        children: pageSteps.mapIndexed<Widget>(
                              (index, step) {
                            final maybeIcon = step.icon;

                            Widget iconChild;

                            final isPrevious = index < currentStep;
                            final isNext = index > currentStep;
                            final Color backgroundColor;
                            final Color iconColor;
                            final double elevation;

                            if (maybeIcon == null) {
                              iconChild = isPrevious == true
                                  ? Icon(Icons.check_rounded, color: Colors.white)
                                  : Text('${index + 1}', style: TextStyle(
                                color: isNext == true ? Color(0xFF635D74) : Colors.white,
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.w700,),
                              );
                            } else {
                              iconChild = maybeIcon;
                            }

                            if (isPrevious) {
                              backgroundColor = Color(0xFFF6A519);
                              iconColor = Colors.white;
                              elevation = 0.0;
                            } else if (isNext) {
                              backgroundColor = Color(0xFFE4E3E7);
                              iconColor = Color(0xFF161616);
                              elevation = 5.0;
                            } else
                              /* current */ {
                              backgroundColor = Color(0xFFF22853);
                              iconColor = Colors.white;
                              elevation = 0.0;
                            }

                            return Material(
                              shape: const CircleBorder(),
                              elevation: elevation,
                              color: backgroundColor,
                              child: IconButton(
                                padding: const EdgeInsets.all(4.0),
                                constraints: const BoxConstraints(),
                                color: iconColor,
                                onPressed: onStepSelect == null
                                    ? null
                                    : () => onStepSelect(index),
                                icon: iconChild,
                              ),
                            );
                          },
                        ).intersperseIndexed(
                              (int index) {
                            final elementIndex = (index ~/ 2);
                            final currentProgress = progress - elementIndex;

                            return Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                                child: ShaderMask(
                                  shaderCallback: (Rect bounds) {
                                    return LinearGradient(
                                      colors: <Color>[
                                        theme.colorScheme.primary,
                                        theme.brightness == Brightness.dark
                                            ? theme.colorScheme.onSurface
                                            : theme.colorScheme.surface,
                                      ],
                                      stops: <double>[currentProgress, currentProgress],
                                    ).createShader(bounds);
                                  },
                                  child: const DottedLine(
                                    dashRadius: 6.0,
                                    dashGapLength: 6.0,
                                    dashColor: Color(0xFF8A8792),
                                    lineThickness: 4.0,
                                  ),
                                ),
                              ),
                            );
                          },
                        ).toList(),
                      );
                    },
                  )),
                )
              ]
          )
      ),
    );
  }
}
