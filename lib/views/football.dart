import 'package:flutter/material.dart';
import 'package:zyron/src/rust/api/football.dart';

class FootballView extends StatelessWidget {
  const FootballView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: FutureBuilder(
        future: scrapeLiveScore(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return Center(
                child: Text(
                  'Error: ${snapshot.error}',
                  textAlign: TextAlign.justify,
                ),
              );
            } else {
              final stages = snapshot.data as List<Stage>;
              return ListView.builder(
                itemCount: stages.length,
                itemBuilder: (context, index) {
                  final stage = stages[index];
                  return ExpansionTile(
                    title: Text(
                      stage.name,
                      style: const TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    children: stage.games.map((game) {
                      return ListTile(
                        title: Text(
                          '${game.homeTeam} vs ${game.awayTeam}',
                        ),
                        subtitle: Text(
                          '${game.homeScore} - ${game.awayScore}',
                        ),
                        trailing: Text(
                          game.matchClock,
                        ),
                      );
                    }).toList(),
                  );
                },
              );
            }
          }

          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
