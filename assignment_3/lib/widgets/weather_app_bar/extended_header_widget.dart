import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:weather_me_up/models/weather_information.dart';

class ExpandedHeader extends StatefulWidget {
  final Temperature temperatures;
  final Uri iconUrl;
  const ExpandedHeader({
    super.key,
    required this.temperatures,
    required this.iconUrl,
  });

  @override
  State<ExpandedHeader> createState() => _ExpandedHeaderState();
}

class _ExpandedHeaderState extends State<ExpandedHeader>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..forward(from: 0);
    _animation =
        CurvedAnimation(parent: _animationController, curve: Curves.easeIn);

    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FlexibleSpaceBar(
      background: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            FadeTransition(
              opacity: _animation,
              child: RichText(
                softWrap: true,
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: '${widget.temperatures.currentToString}\n',
                      style: Theme.of(context).textTheme.displayLarge,
                    ),
                    TextSpan(
                      text:
                          "Feels like ${widget.temperatures.feelsLikeToString}\n",
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    TextSpan(
                      text:
                          "${widget.temperatures.maxToString}/${widget.temperatures.minToString}",
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: FadeInImage.memoryNetwork(
                  placeholder: kTransparentImage,
                  fit: BoxFit.fill,
                  image: widget.iconUrl.toString()),
            ),
          ],
        ),
      ),
    );
  }
}
