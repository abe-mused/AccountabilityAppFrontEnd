import 'package:flutter/material.dart';
import 'package:linear/model/user.dart';
import 'package:linear/pages/community_page/community_page.dart';
import 'package:linear/constants/themeSettings.dart';
import 'package:linear/util/date_formatter.dart';

class CommunityListWidget extends StatefulWidget {
  const CommunityListWidget(
      {super.key,
      required this.user});

  final User user;

  @override
  State<CommunityListWidget> createState() => _CommunityListWidgetState();
}

class _CommunityListWidgetState extends State<CommunityListWidget> {
  final ScrollController _scrollController = ScrollController();

  User? _userToDisplay;
  String _sortType = "";
  final List _streak = [];
  
  calculateStreak(index) {
    _streak.add(computeStreak(_userToDisplay!.communities![index]['firstStreakDate'],
        _userToDisplay!.communities![index]['lastStreakDate']));
    return _streak[index];
  }

  int computeStreak(firstStreakEpoch, lastStreakEpoch) {
    firstStreakEpoch = firstStreakEpoch is int? firstStreakEpoch : int.parse(firstStreakEpoch);
    lastStreakEpoch = lastStreakEpoch is int? lastStreakEpoch : int.parse(lastStreakEpoch);
    
    if (DateTime.now().isBefore(DateTime.fromMillisecondsSinceEpoch(lastStreakEpoch).add(const Duration(days: 1, hours: 12)))) {
      return (lastStreakEpoch - firstStreakEpoch) ~/ dayInMilliseconds;
    } else {
      return 0;
    }
  }

  @override
  void initState() {
    super.initState();

    setState(() {
      _userToDisplay = widget.user;
    });
  }

  @override
  Widget build(BuildContext context) {
    if(_userToDisplay == null){
      return Container();
    }

    return Column(
      children: [
        if (_userToDisplay!.communities!.isEmpty) ...[
          Row(
            children: [
              const SizedBox(width: 30),
              SizedBox(
                height: 100,
                width: 100,
                child: Image.asset('assets/no_communities.png'),
              ),
              const SizedBox(width: 10),
              Flexible(
                child: Text(
                  "It seems that ${_userToDisplay!.name.split(" ").first} isn't in any communities... yet.",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 15, 
                      fontWeight: FontWeight.w500
                    ),
                ),
              ),
              const SizedBox(width: 20),
            ],
          ),
        ] else ...[
          Padding(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: buildListOfCommunities(
                _userToDisplay!.communities!.length <= 3 ?
                  _userToDisplay!.communities!.length 
                  : 3
              ),
          ),
          if(_userToDisplay!.communities!.length > 3) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 5),
                  child: TextButton(
                    onPressed: () {
                      showCompleteListDialog(context);
                    },
                    child: const Text(
                      "see all communities",
                      style: TextStyle(
                        decoration: TextDecoration.underline,
                        fontSize: 15.0,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ]
        ]
      ]
    );
  }

  void showCompleteListDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('All Communities'),
        shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(15.0),
        ),
        content: SizedBox(
          height: 400,
          width: 300,
          child: SingleChildScrollView(
            controller: _scrollController,
            child:  Column(
              children: [
                buildSortComponent(context),
                buildListOfCommunities(_userToDisplay!.communities!.length),
              ]
            ),
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Close'))
        ],
      ),
    );
  }

  buildListOfCommunities(int numberOfItems) {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: numberOfItems,
      itemBuilder: (context, index) {
        return TextButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CommunityPage(
                  communityName: _userToDisplay!.communities![index]['communityName'],
                ),
              ),
            );
          },
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
          ),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    "c/${_userToDisplay!.communities![index]['communityName']}",
                    style: const TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      if (calculateStreak(index) >= 3) ...[
                        Text(
                          "${_streak[index]}",
                          style: const TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        Icon(
                          Icons.local_fire_department,
                          color: AppThemes.iconColor(context),
                          size: 30.0,
                        ),
                      ],
                      if (_userToDisplay!.username == _userToDisplay!.communities![index]['creator']) ...[
                        Icon(
                          Icons.admin_panel_settings,
                          color: AppThemes.iconColor(context),
                          size: 30.0,
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
  
  buildSortComponent(BuildContext context) {
    return ExpansionTile(
      title: Text("Sort By: $_sortType"),
      children: [
        TextButton(
          onPressed: () {
            setState(() {
              _userToDisplay!.communities!.sort((a, b) => a['dateJoined'].compareTo(b['dateJoined']));
              _sortType = "Date joined";
            });
            Navigator.pop(context);
            showCompleteListDialog(context);
          },
          child: const Text('Date joined'),
        ),
        TextButton(
          onPressed: () {
            setState(() {
              _userToDisplay!.communities!.sort((a, b) => a['lastStreakDate'].compareTo(b['lastStreakDate']));
              _sortType = "Last post date";
            });
            Navigator.pop(context);
            showCompleteListDialog(context);
          },
          child: const Text('Last post date'),
        ),
        TextButton(
          onPressed: () {
            setState(() {
              _userToDisplay!.communities!.sort((a, b) => a['communityName'].compareTo(b['communityName']));
              _sortType = "Alphabetical (A-Z)";
            });
            Navigator.pop(context);
            showCompleteListDialog(context);
          },
          child: const Text('Alphabetical (A-Z)'),
        ),
        TextButton(
          onPressed: () {
            setState(() {
              _userToDisplay!.communities!.sort((a, b) => b['communityName'].compareTo(a['communityName']));
              _sortType = "Alphabetical (Z-A)";
            });
            Navigator.pop(context);
            showCompleteListDialog(context);
          },
          child: const Text('Alphabetical (Z-A)'),
        ),
      ]
    );
  }
}