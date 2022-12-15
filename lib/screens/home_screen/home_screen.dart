import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../utils/constants.dart';
import 'components/balance_card/balance_card.dart';
import 'components/favorites/favorites.dart';
import 'components/portfolio/portfolio.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 50,),
            Row(
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Welcome',
                      style: TextStyle(
                        fontSize: 20,
                        color: kSecondaryTextColor,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Saurav S Kamtalwar',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                
              ],
            ),
            const SizedBox(height: 36),
            const BalanceCard(),
            const SizedBox(height: 36),
            const Portfolio(),
            const SizedBox(height: 36),
            const Favorites(),
          ],
        ),
      ),
    );
  }
}
