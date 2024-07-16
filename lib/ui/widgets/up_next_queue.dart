import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:harmonymusic/ui/player/player_controller.dart';

import 'image_widget.dart';
import 'marqwee_widget.dart';
import 'songinfo_bottom_sheet.dart';

class UpNextQueue extends StatelessWidget {
  const UpNextQueue(
      {super.key,
      this.onReorderEnd,
      this.onReorderStart,
      this.isQueueInSlidePanel = true});
  final void Function(int)? onReorderStart;
  final void Function(int)? onReorderEnd;
  final bool isQueueInSlidePanel;

  @override
  Widget build(BuildContext context) {
    final playerController = Get.find<PlayerController>();
    return Container(
      color: Theme.of(context).bottomSheetTheme.backgroundColor,
      child: Obx(() {
        return ReorderableListView.builder(
          scrollController:
              isQueueInSlidePanel ? playerController.scrollController : null,
          onReorder: playerController.onReorder,
          onReorderStart: onReorderStart,
          onReorderEnd: onReorderEnd,
          itemCount: playerController.currentQueue.length,
          padding: EdgeInsets.only(
              top: isQueueInSlidePanel ? 55 : 0,
              bottom: Get.mediaQuery.padding.bottom),
          physics: const AlwaysScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            final homeScaffoldContext =
                playerController.homeScaffoldkey.currentContext!;
            //print("${playerController.currentSongIndex.value == index} $index");
            return Material(
              key: Key('$index'),
              child: Obx(
                () => ListTile(
                  onTap: () {
                    playerController.seekByIndex(index);
                  },
                  onLongPress: () {
                    showModalBottomSheet(
                      constraints: const BoxConstraints(maxWidth: 500),
                      shape: const RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(10.0)),
                      ),
                      isScrollControlled: true,
                      context: playerController
                          .homeScaffoldkey.currentState!.context,
                      //constraints: BoxConstraints(maxHeight:Get.height),
                      barrierColor: Colors.transparent.withAlpha(100),
                      builder: (context) => SongInfoBottomSheet(
                        playerController.currentQueue[index],
                        calledFromQueue: true,
                      ),
                    ).whenComplete(() => Get.delete<SongInfoController>());
                  },
                  contentPadding:
                      const EdgeInsets.only(top: 0, left: 30, right: 25),
                  tileColor: playerController.currentSongIndex.value == index
                      ? Theme.of(homeScaffoldContext).colorScheme.secondary
                      : Theme.of(homeScaffoldContext)
                          .bottomSheetTheme
                          .backgroundColor,
                  leading: ImageWidget(
                    size: 50,
                    song: playerController.currentQueue[index],
                  ),
                  title: MarqueeWidget(
                    child: Text(
                      playerController.currentQueue[index].title,
                      maxLines: 1,
                      style:
                          Theme.of(homeScaffoldContext).textTheme.titleMedium,
                    ),
                  ),
                  subtitle: Text(
                    "${playerController.currentQueue[index].artist}",
                    maxLines: 1,
                    style: playerController.currentSongIndex.value == index
                        ? Theme.of(homeScaffoldContext)
                            .textTheme
                            .titleSmall!
                            .copyWith(
                                color: Theme.of(homeScaffoldContext)
                                    .textTheme
                                    .titleMedium!
                                    .color!
                                    .withOpacity(0.35))
                        : Theme.of(homeScaffoldContext).textTheme.titleSmall,
                  ),
                  trailing: ReorderableDragStartListener(
                    enabled: !GetPlatform.isDesktop,
                    index: index,
                    child: Container(
                      padding: EdgeInsets.only(
                          right: (GetPlatform.isDesktop) ? 20 : 5, left: 20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          if (!GetPlatform.isDesktop)
                            const Icon(
                              Icons.drag_handle_rounded,
                            ),
                          playerController.currentSongIndex.value == index
                              ? const Icon(
                                  Icons.equalizer_rounded,
                                  color: Colors.white,
                                )
                              : Text(
                                  playerController.currentQueue[index]
                                          .extras!['length'] ??
                                      "",
                                  style: Theme.of(homeScaffoldContext)
                                      .textTheme
                                      .titleSmall,
                                ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
