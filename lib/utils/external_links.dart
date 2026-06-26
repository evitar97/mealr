import 'package:url_launcher/url_launcher.dart';

const mealfulPrivacyPolicyUrl = 'https://evitar97.github.io/mealr/#privacy';
const appleStandardEulaUrl =
    'https://www.apple.com/legal/internet-services/itunes/dev/stdeula/';
const cdcAdultBmiCategoriesUrl =
    'https://www.cdc.gov/bmi/adult-calculator/bmi-categories.html';
const whoBmiReferenceUrl =
    'https://www.who.int/data/gho/data/themes/topics/topic-details/GHO/body-mass-index';

Future<void> openExternalUrl(String url) async {
  final uri = Uri.parse(url);
  if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
    await launchUrl(uri, mode: LaunchMode.platformDefault);
  }
}
