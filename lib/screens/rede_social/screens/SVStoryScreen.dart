// ignore_for_file: file_names

import 'package:app_tuddo_gramado/data/models/SVStoryModel.dart';
import 'package:app_tuddo_gramado/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:story_view/story_view.dart';

class SVStoryScreen extends StatefulWidget {
  final SVStoryModel? story;

  const SVStoryScreen({super.key, required this.story});

  @override
  State<SVStoryScreen> createState() => _SVStoryScreenState();
}

class _SVStoryScreenState extends State<SVStoryScreen>
    with TickerProviderStateMixin {
  List<String> imageList = [];
  StoryController storyController = StoryController();

  TextEditingController messageController = TextEditingController();

  @override
  void initState() {
    imageList = widget.story!.storyImages.validate();
    setStatusBarColor(Colors.transparent);
    super.initState();
    init();
  }

  void init() {
    //
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          StoryView(
            storyItems: [
              StoryItem.text(
                title:
                    "I guess you'd love to see more of our food. That's great.",
                backgroundColor: Colors.blue,
              ),
              StoryItem.text(
                title: "Nice!\n\nTap to continue.",
                backgroundColor: pink,
                textStyle: const TextStyle(
                  fontFamily: 'Dancing',
                  fontSize: 40,
                ),
              ),
/*          StoryItem.pageImage(
                url: "https://image.ibb.co/cU4WGx/Omotuo-Groundnut-Soup-braperucci-com-1.jpg",
                caption: "Still sampling",
                controller: storyController,
              ),*/
/*          StoryItem.pageImage(url: "https://media.giphy.com/media/5GoVLqeAOo6PK/giphy.gif", caption: "Working with gifs", controller: storyController),
              StoryItem.pageImage(
                url: "https://media.giphy.com/media/XcA8krYsrEAYXKf4UQ/giphy.gif",
                caption: "Hello, from the other side",
                controller: storyController,
              ),
              StoryItem.pageImage(
                url: "https://media.giphy.com/media/XcA8krYsrEAYXKf4UQ/giphy.gif",
                caption: "Hello, from the other side2",
                controller: storyController,
              ),*/
            ],
            progressPosition: ProgressPosition.top,
            repeat: false,
            controller: storyController,
          ),
          Positioned(
            left: 16,
            top: 70,
            child: SizedBox(
              height: 48,
              child: Row(
                children: [
                  Image.asset(
                    widget.story!.profileImage.validate(),
                    height: 48,
                    width: 48,
                    fit: BoxFit.cover,
                  ).cornerRadiusWithClipRRect(8),
                  16.width,
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.story!.name.validate(),
                        style: color94SemiBold16,
                      ),
                      Text(
                        '${widget.story!.time.validate()} ago',
                        style: color94SemiBold16,
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
          Row(
            children: [
              Container(
                width: context.width() * 0.76,
                padding: const EdgeInsets.only(left: 16, right: 4, bottom: 16),
                child: AppTextField(
                  controller: messageController,
                  textStyle: color94SemiBold16,
                  textFieldType: TextFieldType.OTHER,
                  decoration: InputDecoration(
                    hintText: 'Send Message',
                    hintStyle: color94SemiBold16,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide:
                            const BorderSide(width: 1.0, color: Colors.white)),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide:
                            const BorderSide(width: 1.0, color: Colors.white)),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide:
                            const BorderSide(width: 1.0, color: Colors.white)),
                  ),
                ),
              ),
              Image.asset('assets/social/ic_Send.png',
                      height: 24,
                      width: 24,
                      fit: BoxFit.cover,
                      color: Colors.white)
                  .onTap(() {
                messageController.clear();
              },
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent),
              IconButton(
                icon: widget.story!.like.validate()
                    ? Image.asset('assets/social/ic_HeartFilled.png',
                        height: 20, width: 22, fit: BoxFit.fill)
                    : Image.asset('assets/social/ic_Heart.png',
                        height: 24,
                        width: 24,
                        fit: BoxFit.cover,
                        color: Colors.white),
                onPressed: () {
                  widget.story!.like = !widget.story!.like.validate();
                  setState(() {});
                },
              )
            ],
          ),
        ],
      ),
    );
  }
}
