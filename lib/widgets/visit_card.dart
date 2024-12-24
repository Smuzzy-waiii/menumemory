import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:menumemory/models/visit.dart';
import 'package:readmore/readmore.dart';

class VisitCard extends StatefulWidget {
  Visit visit;
  VisitCard({super.key, required this.visit});

  @override
  State<VisitCard> createState() => _VisitCardState();
}

class _VisitCardState extends State<VisitCard> {
  bool isMinimized = false;
  bool seeAll = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: widget.visit == null
          ? CircularProgressIndicator()
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        textBaseline: TextBaseline.ideographic,
                        children: [
                          Text(
                            widget.visit!.restaurant_info.name,
                            style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            DateFormat("dd MMM yyyy  K:ma")
                                .format(widget.visit.datetime),
                          )
                        ],
                      ),
                      IconButton(
                          onPressed: () {
                            setState(() {
                              isMinimized = !isMinimized;
                            });
                          },
                          icon: Icon(isMinimized
                              ? Icons.arrow_drop_up_sharp
                              : Icons.arrow_drop_down_sharp))
                    ],
                  ),
                  if (!isMinimized)
                    ...widget.visit!.order.sublist(0, seeAll ? widget.visit!.order.length : min(2, widget.visit!.order.length)).map((order) => Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 5),
                            Row(
                              children: [
                                Text(
                                  order.dish.name,
                                  style: TextStyle(fontSize: 20),
                                ),
                                SizedBox(width: 10),
                                Center(
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(20)),
                                      border: Border.all(
                                        color: Colors.black,
                                        width:
                                            0.5, // Adjust the width for a thicker or thinner border
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          "${order.rating}",
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 16,
                                          ),
                                        ),
                                        SizedBox(width: 4),
                                        Text(
                                          "🥨",
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                            // Added the readmore functionality
                            ReadMoreText(
                              '"${order.review_text!}"',
                              trimMode: TrimMode.Line,
                              trimLines: 3,
                              colorClickableText: Colors.black,
                              trimCollapsedText: ' Read more',
                              trimExpandedText: ' Read less',
                              moreStyle: TextStyle(fontSize: 16),
                              style: TextStyle(fontSize: 16),
                            ),
                            SizedBox(height: 5),
                            Divider(thickness: 1, color: Colors.grey)
                ],
              ),
            ),
            if (!isMinimized)
              Center(
                  child: TextButton(
                      onPressed: () {
                        setState(() {
                          seeAll = !seeAll;
                        });
                      },
                      child: Text(seeAll ? "See less" : "See more")))
    ])));
  }
}
