import 'package:flutter/material.dart';

import '../models/risk_model.dart';

class ResultScreen extends StatelessWidget {
  final List<RiskModel> risks;
  final int score;

  const ResultScreen({
    super.key,
    required this.risks,
    required this.score,
  });

  String getRiskLevel() {
    if (score >= 75) {
      return 'HIGH';
    } else if (score >= 40) {
      return 'MEDIUM';
    } else {
      return 'LOW';
    }
  }

  Color getRiskColor() {
    if (score >= 75) {
      return Colors.red;
    } else if (score >= 40) {
      return Colors.orange;
    } else {
      return Colors.green;
    }
  }

  @override
  Widget build(BuildContext context) {
    Color riskColor = getRiskColor();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacy Result'),
      ),

      body: ListView(
        padding: const EdgeInsets.all(20),

        children: [
          Center(
            child: Column(
              children: [
                const Text(
                  'Privacy Risk Score',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),

                const SizedBox(height: 10),

                Text(
                  '$score / 100',
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: riskColor,
                  ),
                ),

                Text(
                  getRiskLevel(),
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: riskColor,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 30),

          if (risks.isEmpty)
            const Card(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Text(
                  'No obvious privacy risks were found.',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
              ),
            ),

          for (int i = 0; i < risks.length; i++)
            Card(
              margin: const EdgeInsets.only(
                bottom: 15,
              ),

              child: Padding(
                padding: const EdgeInsets.all(16),

                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,

                  children: [
                    Text(
                      risks[i].title,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight:
                        FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 5),

                    Text(
                      'Risk score: ${risks[i].score}%',
                    ),

                    const SizedBox(height: 10),

                    Text(
                      risks[i].message,
                    ),

                    const SizedBox(height: 15),

                    const Text(
                      'Advice:',
                      style: TextStyle(
                        fontWeight:
                        FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 5),

                    for (int j = 0;
                    j < risks[i].advice.length;
                    j++)
                      Padding(
                        padding:
                        const EdgeInsets.only(
                          bottom: 5,
                        ),

                        child: Text(
                          '• ${risks[i].advice[j]}',
                        ),
                      ),
                  ],
                ),
              ),
            ),

          const SizedBox(height: 20),

          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text(
              'Edit and Analyse Again',
            ),
          ),
        ],
      ),
    );
  }
}