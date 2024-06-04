import 'package:flutter/material.dart';
import 'package:bucks_buddy/common/widgets/custom_shapes/containers/circular_container.dart';
import 'package:bucks_buddy/common/widgets/custom_shapes/curved_edges/curved.edges_widget.dart';
import 'package:bucks_buddy/utils/constants/colors.dart';

class TPrimaryHeaderContainer extends StatelessWidget {
  const TPrimaryHeaderContainer({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return TCurvedEdgeWidget(
      child: Container(    

        color: const Color.fromARGB(159, 149, 137, 0),  
        /// ---- if['size.isfinite': is not true.in stock] error occured -> read README.md fle
      
        child: Stack(
          children: [
            /// -- background custom shape
            Positioned(
                top: -150,
                right: -250,
                child: TCircularContainer(
                  backgroundColor: TColors.textWhite.withOpacity(0.1),
                )),
            Positioned(
                top: 100,
                right: -300,
                child: TCircularContainer(
                  backgroundColor: TColors.textWhite.withOpacity(0.1),
                )),
            child,
          ],
        ),
      ),
    );
  }
}
