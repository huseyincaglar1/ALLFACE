import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MyListTile extends StatelessWidget {
  const MyListTile(
      {super.key,
      required this.time,
      required this.title,
      this.subTitle,
      this.onEdit,
      this.actionType});

  final String title;
  final String? subTitle;
  final DateTime time;
  final VoidCallback? onEdit;
  final String? actionType;
  @override
  Widget build(BuildContext context) {
    String formattedDate = DateFormat('MMMM d, yyyy, h:mm a').format(time);

    IconData getIconBasedOnAction() {
      if (actionType == 'edit') {
        return Icons.edit_note_rounded;
      } else if (actionType == 'publish') {
        return Icons.share_outlined;
      }
      return Icons.help; // Default or fallback icon
    }

    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, bottom: 10),
      child: Container(
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            borderRadius: BorderRadius.circular(12)),
        child: ListTile(
          title: Text(
            title,
          ),
          subtitle: subTitle != null
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(
                        softWrap: false, //maxLine ve overflow da aynı amaç için tek tek kullanılabilir
                        // maxLines: 1,
                        // overflow: TextOverflow.ellipsis,
                        subTitle!,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      formattedDate,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                  ],
                )
              : Text(
                  formattedDate,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
          trailing: actionType != null
              ? IconButton(
                  icon: Icon(getIconBasedOnAction()),
                  onPressed: onEdit,
                )
              : null,
        ),
      ),
    );
  }
}
