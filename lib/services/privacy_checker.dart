import '../models/risk_model.dart';

class PrivacyChecker {
  List<RiskModel> checkPost(
      String text,
      String audience,
      bool postingNow,
      bool hasImage,
      )
  {
    List<RiskModel> risks = [];

    String lowerText = text.toLowerCase();

    // Check identity information
    if (lowerText.contains('i work at') ||
        lowerText.contains('my university') ||
        lowerText.contains('my school') ||
        lowerText.contains('employee id') ||
        lowerText.contains('student id')) {
      risks.add(
        RiskModel(
          title: 'Identity Risk',
          message:
          'Your post may contain information that can help identify you.',
          score: 65,
          advice: [
            'Remove unnecessary workplace or university information.',
            'Do not share employee or student IDs.',
          ],
        ),
      );
    }

    // Check location
    if (lowerText.contains('i am at') ||
        lowerText.contains('i am in') ||
        lowerText.contains('currently at') ||
        lowerText.contains('currently in') ||
        lowerText.contains('i live in') ||
        lowerText.contains('my address')) {
      risks.add(
        RiskModel(
          title: 'Location Risk',
          message:
          'Your post may reveal your current location or home area.',
          score: 70,
          advice: [
            'Remove your exact location.',
            'Avoid sharing your home address.',
            'Post after leaving the location.',
          ],
        ),
      );
    }

    // Check routine
    if (lowerText.contains('every day') ||
        lowerText.contains('every night') ||
        lowerText.contains('every morning') ||
        lowerText.contains('daily') ||
        lowerText.contains('finish work at') ||
        lowerText.contains('start work at')) {
      risks.add(
        RiskModel(
          title: 'Routine Risk',
          message:
          'Your post may reveal a regular routine or schedule.',
          score: 60,
          advice: [
            'Avoid sharing exact daily times.',
            'Do not post your routine in real time.',
          ],
        ),
      );
    }

    // Check email
    if (lowerText.contains('@')) {
      risks.add(
        RiskModel(
          title: 'Contact Information Risk',
          message:
          'Your post may contain an email address.',
          score: 80,
          advice: [
            'Remove your email address before posting.',
            'Share contact information privately instead.',
          ],
        ),
      );
    }

    // Check sensitive words
    if (lowerText.contains('password') ||
        lowerText.contains('passport') ||
        lowerText.contains('bank account') ||
        lowerText.contains('credit card')) {
      risks.add(
        RiskModel(
          title: 'Sensitive Information Risk',
          message:
          'Your post may contain sensitive personal information.',
          score: 95,
          advice: [
            'Remove sensitive information.',
            'Never post passwords or banking information.',
          ],
        ),
      );
    }

    // Simple image warning
    if (hasImage) {
      risks.add(
        RiskModel(
          title: 'Image Privacy Risk',
          message:
          'Your image may contain a face, badge, document, street sign or other identifying information.',
          score: 30,
          advice: [
            'Check the background of the photo.',
            'Hide badges or documents.',
            'Crop street signs or landmarks if necessary.',
          ],
        ),
      );
    }

    // Add extra risk for public posts
    if (audience == 'Public') {
      for (int i = 0; i < risks.length; i++) {
        risks[i].score = risks[i].score + 10;

        if (risks[i].score > 100) {
          risks[i].score = 100;
        }

        risks[i].advice.add(
          'Consider changing the audience from Public to Friends.',
        );
      }
    }

    // Add extra risk for posting now
    if (postingNow) {
      for (int i = 0; i < risks.length; i++) {
        if (risks[i].title == 'Location Risk' ||
            risks[i].title == 'Routine Risk') {
          risks[i].score = risks[i].score + 10;

          if (risks[i].score > 100) {
            risks[i].score = 100;
          }
        }
      }
    }

    return risks;
  }

  int calculateOverallScore(List<RiskModel> risks) {
    if (risks.isEmpty) {
      return 0;
    }

    int total = 0;

    for (int i = 0; i < risks.length; i++) {
      total = total + risks[i].score;
    }

    int average = total ~/ risks.length;

    if (risks.length >= 3) {
      average = average + 10;
    }

    if (average > 100) {
      average = 100;
    }

    return average;
  }
}