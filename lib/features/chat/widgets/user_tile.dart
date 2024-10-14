import 'package:flutter/material.dart';

class UserTile extends StatelessWidget {
  final String userid;
  final bool isRead;
  final VoidCallback onTap;
  final VoidCallback onLongPress;
  final Color? color;
  const UserTile({
    super.key,
    required this.userid,
    required this.onTap,
    required this.onLongPress,
    required this.color,
    required this.isRead,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: GestureDetector(
        onLongPress: onLongPress,
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
              color: color, borderRadius: BorderRadius.circular(10)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(userid),
              isRead
                  ? const SizedBox.shrink()
                  : const Icon(
                      Icons.circle,
                      color: Colors.yellow,
                    )
            ],
          ),
        ),
      ),
    );
  }
}
