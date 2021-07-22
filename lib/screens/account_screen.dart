import 'package:academy_app/screens/edit_password_screen.dart';
import 'package:academy_app/screens/edit_profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants.dart';
import '../providers/auth.dart';
import '../widgets/custom_text.dart';
import '../widgets/acoount_list_tile.dart';

class AccountScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Provider.of<Auth>(context, listen: false).getUserInfo(),
      builder: (ctx, dataSnapshot) {
        if (dataSnapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else {
          if (dataSnapshot.error != null) {
            //error
            return Center(
              child: Text('Error Occured'),
            );
          } else {
            return Consumer<Auth>(builder: (context, authData, child) {
              final user = authData.user;
              return SingleChildScrollView(
                child: Container(
                  width: double.infinity,
                  child: Column(
                    // mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        height: 70,
                      ),
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: NetworkImage(user.image),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Customtext(
                          text: '${user.firstName} ${user.lastName}',
                          colors: kTextColor,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Customtext(
                            text: 'Account Page',
                            colors: kTextColor,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(10),
                        child: Card(
                          color: kBackgroundColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          elevation: 4,
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              children: <Widget>[
                                GestureDetector(
                                  child: AccountListTile(
                                    titleText: 'Edit Profile',
                                    icon: Icons.account_circle,
                                    actionType: 'edit',
                                  ),
                                  onTap: () {
                                    Navigator.of(context).pushNamed(EditProfileScreen.routeName);
                                  },
                                ),
                                Divider(),
                                GestureDetector(
                                  child: AccountListTile(
                                    titleText: 'Change Password',
                                    icon: Icons.vpn_key,
                                    actionType: 'change_password',
                                  ),
                                  onTap: () {
                                    Navigator.of(context).pushNamed(EditPasswordScreen.routeName);
                                  },
                                ),
                                Divider(),
                                GestureDetector(
                                  child: AccountListTile(
                                    titleText: 'Log Out',
                                    icon: Icons.exit_to_app,
                                    actionType: 'logout',
                                  ),
                                  onTap: () {
                                    Provider.of<Auth>(context, listen: false).logout().then((_) =>
                                        Navigator.pushNamedAndRemoveUntil(context, '/home', (r) => false));
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            });
          }
        }
      },
    );
  }
}
