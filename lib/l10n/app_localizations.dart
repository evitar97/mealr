import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_hu.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('de'),
    Locale('en'),
    Locale('es'),
    Locale('hu'),
  ];

  /// Application title
  ///
  /// In en, this message translates to:
  /// **'Mealful'**
  String get appTitle;

  /// Source text:  – de nem a kalóriájából. Ha a kész súlyt írod be a kalóriaszámlálóba,
  ///
  /// In en, this message translates to:
  /// **' - but not calories. If you enter cooked weight into your calorie tracker, '**
  String get m0001;

  /// Source text:  – ezt mérd le és írd be.
  ///
  /// In en, this message translates to:
  /// **' - measure this and enter it.'**
  String get m0002;

  /// Source text:  és írd be ide.
  ///
  /// In en, this message translates to:
  /// **' and enter it here.'**
  String get m0003;

  /// Source text:  Ha a kész súlyt írod be a kalóriaszámlálóba, téves értéket kapsz.
  ///
  /// In en, this message translates to:
  /// **' If you enter cooked weight into your calorie tracker, you get an incorrect value.'**
  String get m0004;

  /// Source text:  Pro extrák lezárva
  ///
  /// In en, this message translates to:
  /// **' · Pro extras locked'**
  String get m0005;

  /// Source text: , de
  ///
  /// In en, this message translates to:
  /// **', but '**
  String get m0006;

  /// Source text: , de ettől
  ///
  /// In en, this message translates to:
  /// **', but this '**
  String get m0007;

  /// Source text: /év
  ///
  /// In en, this message translates to:
  /// **'/yr'**
  String get m0008;

  /// Source text: /hó
  ///
  /// In en, this message translates to:
  /// **'/mo'**
  String get m0009;

  /// Source text: → Ezt a számot írd be a kalóriaszámlálódba
  /// (pl. MyFitnessPal, Cronometer stb.)
  ///
  /// In en, this message translates to:
  /// **'→ Enter this number into your calorie tracker\n(e.g. MyFitnessPal, Cronometer, etc.)'**
  String get m0010;

  /// Source text: = 1.00€/hó · legjobb ár
  ///
  /// In en, this message translates to:
  /// **'= 1.00€/mo · best value'**
  String get m0011;

  /// Source text: 1500 kcal étrendek
  ///
  /// In en, this message translates to:
  /// **'1500 kcal meal plans'**
  String get m0012;

  /// Source text: 30 nap
  ///
  /// In en, this message translates to:
  /// **'30 days'**
  String get m0013;

  /// Source text: 30/60 napos súlydiagram és statisztika
  ///
  /// In en, this message translates to:
  /// **'30/60-day weight chart and statistics'**
  String get m0014;

  /// Source text: 7 nap
  ///
  /// In en, this message translates to:
  /// **'7 days'**
  String get m0015;

  /// Source text: A banánt törd össze.
  ///
  /// In en, this message translates to:
  /// **'Mash the banana.'**
  String get m0016;

  /// Source text: A BMI 18.5 alatt sovány tartomány.
  ///
  /// In en, this message translates to:
  /// **'BMI below 18.5 is underweight.'**
  String get m0017;

  /// Source text: A BMI 25–29.9 között túlsúly.
  ///
  /// In en, this message translates to:
  /// **'BMI between 25-29.9 is overweight.'**
  String get m0018;

  /// Source text: A BMI 30 felett obezitás tartomány.
  ///
  /// In en, this message translates to:
  /// **'BMI above 30 is obesity range.'**
  String get m0019;

  /// Source text: A BMI csak tájékoztató. Nem veszi figyelembe az izomtömeget. Orvosi diagnózisra nem alkalmas.
  ///
  /// In en, this message translates to:
  /// **'BMI is for guidance only. It does not account for muscle mass and is not a medical diagnosis.'**
  String get m0020;

  /// Source text: A brokkolit párold roppanósra.
  ///
  /// In en, this message translates to:
  /// **'Steam the broccoli until crisp-tender.'**
  String get m0021;

  /// Source text: A bulgurt főzd meg.
  ///
  /// In en, this message translates to:
  /// **'Cook the bulgur.'**
  String get m0022;

  /// Source text: A burgonyát főzd vagy süsd puhára.
  ///
  /// In en, this message translates to:
  /// **'Boil or roast the potatoes until tender.'**
  String get m0023;

  /// Source text: A cottage cheese-t kanalazd tálba.
  ///
  /// In en, this message translates to:
  /// **'Spoon the cottage cheese into a bowl.'**
  String get m0024;

  /// Source text: A csicseriborsót forgasd össze a fűszerkeverékkel, majd pirítsd át 6-8 perc alatt.
  ///
  /// In en, this message translates to:
  /// **'Toss the chickpeas with the spice mix, then roast or pan-fry for 6-8 minutes.'**
  String get m0025;

  /// Source text: A csicseriborsót főzd össze paradicsommal, kókusztejjel és curryvel.
  ///
  /// In en, this message translates to:
  /// **'Cook the chickpeas with tomato, coconut milk, and curry.'**
  String get m0026;

  /// Source text: A csirkemellet süsd készre és szeleteld fel.
  ///
  /// In en, this message translates to:
  /// **'Cook the chicken breast and slice it.'**
  String get m0027;

  /// Source text: A csirkét fűszerezd és süsd készre.
  ///
  /// In en, this message translates to:
  /// **'Season and cook the chicken through.'**
  String get m0028;

  /// Source text: A főtt étel súlya változik, a kalória nem.
  ///
  /// In en, this message translates to:
  /// **'Cooked food weight changes, calories do not.'**
  String get m0029;

  /// Source text: A garnélát kevés olajon pirítsd készre.
  ///
  /// In en, this message translates to:
  /// **'Cook the shrimp in a little oil.'**
  String get m0030;

  /// Source text: A holnap a ma esti előkészítéssel indul.
  ///
  /// In en, this message translates to:
  /// **'Tomorrow starts with tonight’s prep.'**
  String get m0031;

  /// Source text: A jelenlegi súlyod
  ///
  /// In en, this message translates to:
  /// **'Current weight'**
  String get m0032;

  /// Source text: A joghurtból készíts egyszerű öntetet.
  ///
  /// In en, this message translates to:
  /// **'Make a simple dressing from the yogurt.'**
  String get m0033;

  /// Source text: A joghurtot kanalazd pohárba vagy tálba.
  ///
  /// In en, this message translates to:
  /// **'Spoon the yogurt into a glass or bowl.'**
  String get m0034;

  /// Source text: A kitöltött adatok azonnal bekerülnek a BMI kalkulátorba, a Kalória menübe és a Profilba is, így nem kell később újra megadnod őket.
  ///
  /// In en, this message translates to:
  /// **'The details you enter are saved straight to the BMI calculator, the Calorie menu, and your Profile, so you do not have to enter them again later.'**
  String get m0035;

  /// Source text: A konkrét napi étrendeket a következő lépésben töltjük fel.
  ///
  /// In en, this message translates to:
  /// **'We will add the concrete daily meal plans in the next step.'**
  String get m0036;

  /// Source text: A kuszkuszt forró vízzel párold meg.
  ///
  /// In en, this message translates to:
  /// **'Steam the couscous with hot water.'**
  String get m0037;

  /// Source text: A lazacot sózd, borsozd, majd süsd készre.
  ///
  /// In en, this message translates to:
  /// **'Season the salmon with salt and pepper, then cook it through.'**
  String get m0038;

  /// Source text: A little prep goes a long way.
  ///
  /// In en, this message translates to:
  /// **'A little prep goes a long way.'**
  String get m0039;

  /// Source text: A marhahúst pirítsd le, majd add hozzá a zöldségeket.
  ///
  /// In en, this message translates to:
  /// **'Brown the beef, then add the vegetables.'**
  String get m0040;

  /// Source text: A Mealful abban segít, hogy főzés, adagolás és meal prep közben ne kelljen fejben számolgatnod. Pár rövid lépésben megmutatjuk, hogyan hozd ki belőle a legtöbbet.
  ///
  /// In en, this message translates to:
  /// **'Mealful helps you avoid mental math while cooking, portioning, and meal prepping. In a few short steps, we’ll show you how to get the most out of it.'**
  String get m0041;

  /// Source text: A Mealful azért kell, hogy ne kelljen fejben számolgatnod, amikor főzés után kevesebb vagy több lesz az étel tömege. Beírod a nyers, kész és kimért súlyt, az app pedig megmondja, mennyi nyers alapanyagnak felel meg az adag.
  ///
  /// In en, this message translates to:
  /// **'Mealful saves you from mental math when food weighs less or more after cooking. Enter raw, cooked, and served weight, and the app tells you the raw ingredient equivalent of your portion.'**
  String get m0042;

  /// Source text: A Mealful egy helyre gyűjti a főzéshez, adagoláshoz és célkövetéshez hasznos eszközöket, hogy ne több app között kelljen ugrálnod.
  ///
  /// In en, this message translates to:
  /// **'Mealful brings cooking, portioning, and goal-tracking tools into one place so you do not have to jump between apps.'**
  String get m0043;

  /// Source text: A mentett ételekhez bármikor visszatérhetsz – naponta csak a kimért adagot kell módosítani.
  ///
  /// In en, this message translates to:
  /// **'You can return to saved foods anytime - daily you only adjust the served amount.'**
  String get m0044;

  /// Source text: A normál BMI tartomány 18.5–24.9. Egészséges testsúlyon vagy!
  ///
  /// In en, this message translates to:
  /// **'Normal BMI range is 18.5-24.9. You are in a healthy range!'**
  String get m0045;

  /// Source text: A paprikákat vágd félbe és magozd ki.
  ///
  /// In en, this message translates to:
  /// **'Cut the peppers in half and remove the seeds.'**
  String get m0046;

  /// Source text: A pitát kend meg hummusszal.
  ///
  /// In en, this message translates to:
  /// **'Spread the pita with hummus.'**
  String get m0047;

  /// Source text: A pulykahúsból tojással és morzsával formázz golyókat.
  ///
  /// In en, this message translates to:
  /// **'Form balls from the turkey, egg, and breadcrumbs.'**
  String get m0048;

  /// Source text: A pulykahúst kevés olajon pirítsd le.
  ///
  /// In en, this message translates to:
  /// **'Brown the turkey in a little oil.'**
  String get m0049;

  /// Source text: A quinoát főzd meg.
  ///
  /// In en, this message translates to:
  /// **'Cook the quinoa.'**
  String get m0050;

  /// Source text: A rizsszeleteket kend meg cottage cheese-zel.
  ///
  /// In en, this message translates to:
  /// **'Spread the rice cakes with cottage cheese.'**
  String get m0051;

  /// Source text: A rizsszeleteket kend meg hummusszal.
  ///
  /// In en, this message translates to:
  /// **'Spread the rice cakes with hummus.'**
  String get m0052;

  /// Source text: A rizst főzd meg, a csirkemellet fűszerezd és süsd készre.
  ///
  /// In en, this message translates to:
  /// **'Cook the rice, season the chicken breast, and cook it through.'**
  String get m0053;

  /// Source text: A rizst főzd meg.
  ///
  /// In en, this message translates to:
  /// **'Cook the rice.'**
  String get m0054;

  /// Source text: A rizstésztát áztasd vagy főzd meg a csomagolás szerint.
  ///
  /// In en, this message translates to:
  /// **'Soak or cook the rice noodles according to the package.'**
  String get m0055;

  /// Source text: A sertésszüzet fűszerezd és süsd szeletekre.
  ///
  /// In en, this message translates to:
  /// **'Season the pork tenderloin and cook it in slices.'**
  String get m0056;

  /// Source text: A steady plate keeps the day steady.
  ///
  /// In en, this message translates to:
  /// **'A steady plate keeps the day steady.'**
  String get m0057;

  /// Source text: a száraz, nyers hozzávalók össztömege főzés előtt
  ///
  /// In en, this message translates to:
  /// **'the total dry, raw ingredient weight before cooking'**
  String get m0058;

  /// Source text: A szójagranulátumot áztasd be, majd pirítsd le.
  ///
  /// In en, this message translates to:
  /// **'Soak the soy granules, then brown them.'**
  String get m0059;

  /// Source text: A tésztát főzd meg és hűtsd vissza.
  ///
  /// In en, this message translates to:
  /// **'Cook the pasta and cool it down.'**
  String get m0060;

  /// Source text: A tofut kockázd fel és pirítsd meg.
  ///
  /// In en, this message translates to:
  /// **'Dice and fry the tofu.'**
  String get m0061;

  /// Source text: A tojásokat főzd meg.
  ///
  /// In en, this message translates to:
  /// **'Boil the eggs.'**
  String get m0062;

  /// Source text: A tojásokat készítsd el főzve, tükörtojásként vagy rántottaként.
  ///
  /// In en, this message translates to:
  /// **'Prepare the eggs boiled, fried, or scrambled.'**
  String get m0063;

  /// Source text: A tojásokat verd fel.
  ///
  /// In en, this message translates to:
  /// **'Beat the eggs.'**
  String get m0064;

  /// Source text: A tonhalat keverd össze citromlével, sóval és borssal.
  ///
  /// In en, this message translates to:
  /// **'Mix the tuna with lemon juice, salt, and pepper.'**
  String get m0065;

  /// Source text: A tonhalat keverd össze joghurttal.
  ///
  /// In en, this message translates to:
  /// **'Mix the tuna with yogurt.'**
  String get m0066;

  /// Source text: A tortillát kend meg joghurtos szósszal.
  ///
  /// In en, this message translates to:
  /// **'Spread the tortilla with yogurt sauce.'**
  String get m0067;

  /// Source text: A túrót keverd krémesre.
  ///
  /// In en, this message translates to:
  /// **'Stir the curd cheese until creamy.'**
  String get m0068;

  /// Source text: A zabpelyhet melegítsd össze a tejjel vagy növényi itallal.
  ///
  /// In en, this message translates to:
  /// **'Warm the oats with the milk or plant drink.'**
  String get m0069;

  /// Source text: A zöldségeket pirítsd át.
  ///
  /// In en, this message translates to:
  /// **'Sauté the vegetables.'**
  String get m0070;

  /// Source text: A zöldségeket rendezd tálba.
  ///
  /// In en, this message translates to:
  /// **'Arrange the vegetables in a bowl.'**
  String get m0071;

  /// Source text: A zöldségeket terítsd tepsibe.
  ///
  /// In en, this message translates to:
  /// **'Spread the vegetables on a baking tray.'**
  String get m0072;

  /// Source text: A zöldségeket vágd fel.
  ///
  /// In en, this message translates to:
  /// **'Cut the vegetables.'**
  String get m0073;

  /// Source text: A zöldségeket vágd hasábokra.
  ///
  /// In en, this message translates to:
  /// **'Cut the vegetables into sticks.'**
  String get m0074;

  /// Source text: A zöldségeket vágd kisebb darabokra.
  ///
  /// In en, this message translates to:
  /// **'Cut the vegetables into smaller pieces.'**
  String get m0075;

  /// Source text: A zöldségeket vágd kockára.
  ///
  /// In en, this message translates to:
  /// **'Dice the vegetables.'**
  String get m0076;

  /// Source text: adag
  ///
  /// In en, this message translates to:
  /// **'portion'**
  String get m0077;

  /// Source text: Adagok
  ///
  /// In en, this message translates to:
  /// **'Portions'**
  String get m0078;

  /// Source text: Adagok száma
  ///
  /// In en, this message translates to:
  /// **'Number of servings'**
  String get m0079;

  /// Source text: Add hozzá a babot, kukoricát, paradicsomot és fűszert.
  ///
  /// In en, this message translates to:
  /// **'Add the beans, corn, tomato, and spices.'**
  String get m0080;

  /// Source text: Add hozzá a babot, paradicsomszószt és fűszert.
  ///
  /// In en, this message translates to:
  /// **'Add the beans, tomato sauce, and spices.'**
  String get m0081;

  /// Source text: Add hozzá a főtt rizst, majd forgasd össze, amíg átmelegszik.
  ///
  /// In en, this message translates to:
  /// **'Add the cooked rice and toss until heated through.'**
  String get m0082;

  /// Source text: Add hozzá a hagymát, majd adagold dobozokba.
  ///
  /// In en, this message translates to:
  /// **'Add the onion, then portion into boxes.'**
  String get m0083;

  /// Source text: Add hozzá a paradicsomszószt, majd főzd össze.
  ///
  /// In en, this message translates to:
  /// **'Add the tomato sauce, then simmer together.'**
  String get m0084;

  /// Source text: Add hozzá a rizst és a felvert tojást.
  ///
  /// In en, this message translates to:
  /// **'Add the rice and beaten eggs.'**
  String get m0085;

  /// Source text: Add hozzá a tojást, tekerd fel, majd félbevágva tálald.
  ///
  /// In en, this message translates to:
  /// **'Add the egg, roll it up, then serve cut in half.'**
  String get m0086;

  /// Source text: Add meg az alapadataidat.
  ///
  /// In en, this message translates to:
  /// **'Add your basic details.'**
  String get m0087;

  /// Source text: Add mellé a feldarabolt zöldségeket és a kenyeret.
  ///
  /// In en, this message translates to:
  /// **'Add the chopped vegetables and bread on the side.'**
  String get m0088;

  /// Source text: Add össze a száraz, nyers hozzávalókat főzés
  ///
  /// In en, this message translates to:
  /// **'Add up the dry, raw ingredients '**
  String get m0089;

  /// Source text: adj 150–300 kcal-t a szintentartóhoz.
  ///
  ///
  ///
  /// In en, this message translates to:
  /// **'add 150-300 kcal to maintenance.\n\n'**
  String get m0090;

  /// Source text: Adj előnyt az estédnek.
  ///
  /// In en, this message translates to:
  /// **'Give your evening a head start.'**
  String get m0091;

  /// Source text: Adj hozzá legalább két súlyt a diagramhoz.
  ///
  /// In en, this message translates to:
  /// **'Add at least two weights to show the chart.'**
  String get m0092;

  /// Source text: Advanced
  ///
  /// In en, this message translates to:
  /// **'Advanced'**
  String get m0093;

  /// Source text: Aktív előfizetés ·
  ///
  /// In en, this message translates to:
  /// **'Active subscription · '**
  String get m0094;

  /// Source text: Aktív nap
  ///
  /// In en, this message translates to:
  /// **'Active Day'**
  String get m0095;

  /// Source text: Alap nap
  ///
  /// In en, this message translates to:
  /// **'Basic Day'**
  String get m0096;

  /// Source text: Alapértelmezett: English
  ///
  /// In en, this message translates to:
  /// **'Default: English'**
  String get m0097;

  /// Source text: Allergének
  ///
  /// In en, this message translates to:
  /// **'Allergens'**
  String get m0098;

  /// Source text: Alma
  ///
  /// In en, this message translates to:
  /// **'Apple'**
  String get m0099;

  /// Source text: Almás fahéjas overnight oats
  ///
  /// In en, this message translates to:
  /// **'Apple cinnamon overnight oats'**
  String get m0100;

  /// Source text: Almás túrós sült zab
  ///
  /// In en, this message translates to:
  /// **'Baked apple cottage oats'**
  String get m0101;

  /// Source text: Almaszeletek mogyoróvajjal
  ///
  /// In en, this message translates to:
  /// **'Apple slices with peanut butter'**
  String get m0102;

  /// Source text: amit a tányérra teszel → megkapod a
  ///
  /// In en, this message translates to:
  /// **'what you put on your plate → you get the '**
  String get m0103;

  /// Source text: Amit már most használhatsz
  ///
  /// In en, this message translates to:
  /// **'Included in Free'**
  String get m0104;

  /// Source text: Avokádó
  ///
  /// In en, this message translates to:
  /// **'Avocado'**
  String get m0105;

  /// Source text: Avokádós tonhalas tojásfalat
  ///
  /// In en, this message translates to:
  /// **'Avocado tuna egg bite'**
  String get m0106;

  /// Source text: Az almát szeleteld fel.
  ///
  /// In en, this message translates to:
  /// **'Slice the apple.'**
  String get m0107;

  /// Source text: Az app a mentett kész mennyiséget osztja el az adagok között.
  ///
  /// In en, this message translates to:
  /// **'The app splits the saved cooked amount between portions.'**
  String get m0108;

  /// Source text: Az avokádót szeleteld mellé, citromlével ízesítsd.
  ///
  /// In en, this message translates to:
  /// **'Slice the avocado beside it and season with lemon juice.'**
  String get m0109;

  /// Source text: Az avokádót törd össze citromlével, sóval és borssal, majd kend a pirítósra.
  ///
  /// In en, this message translates to:
  /// **'Mash the avocado with lemon juice, salt, and pepper, then spread it on the toast.'**
  String get m0110;

  /// Source text: az étel össztömege főzés vagy sütés után
  ///
  /// In en, this message translates to:
  /// **'the total meal weight after cooking or baking'**
  String get m0111;

  /// Source text: Az étrendek általános iránymutatásként szolgálnak, és nem helyettesítik a dietetikus vagy orvos által összeállított személyre szabott étrendet. Egészségügyi állapot, allergia, várandósság vagy speciális cél esetén kérj szakembertől segítséget, és saját felelősséggel használd őket.
  ///
  /// In en, this message translates to:
  /// **'The meal plans are general guidance and do not replace a personalized plan created by a dietitian or doctor. If you have a medical condition, allergy, pregnancy, or a specific goal, ask a professional for help and use them at your own responsibility.'**
  String get m0112;

  /// Source text: Az összeget csak a 7. nap után vonjuk le · Bármikor lemondható
  ///
  /// In en, this message translates to:
  /// **'You are charged only after day 7 · Cancel anytime'**
  String get m0113;

  /// Source text: Bagel
  ///
  /// In en, this message translates to:
  /// **'Bagel'**
  String get m0114;

  /// Source text: Banán
  ///
  /// In en, this message translates to:
  /// **'Banana'**
  String get m0115;

  /// Source text: Banános kakaós falatok
  ///
  /// In en, this message translates to:
  /// **'Banana cocoa bites'**
  String get m0116;

  /// Source text: Banános mogyoróvajas smoothie
  ///
  /// In en, this message translates to:
  /// **'Banana peanut butter smoothie'**
  String get m0117;

  /// Source text: Bármikor lemondható
  ///
  /// In en, this message translates to:
  /// **'Cancel anytime'**
  String get m0118;

  /// Source text: Beállítások
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get m0119;

  /// Source text: Bevásárlás lista
  ///
  /// In en, this message translates to:
  /// **'Shopping list'**
  String get m0120;

  /// Source text: Bevásárlás+
  ///
  /// In en, this message translates to:
  /// **'Shopping+'**
  String get m0121;

  /// Source text: Bevásárlás+ listák
  ///
  /// In en, this message translates to:
  /// **'Shopping+ lists'**
  String get m0122;

  /// Source text: Bevásárláshoz adás
  ///
  /// In en, this message translates to:
  /// **'Add to shopping'**
  String get m0123;

  /// Source text: Bevásárlólista mentése
  ///
  /// In en, this message translates to:
  /// **'Save shopping list'**
  String get m0124;

  /// Source text: Bevásárlólista szerkesztése
  ///
  /// In en, this message translates to:
  /// **'Edit shopping list'**
  String get m0125;

  /// Source text: Bevásárlólista törlése
  ///
  /// In en, this message translates to:
  /// **'Delete shopping list'**
  String get m0126;

  /// Source text: Bezárás
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get m0127;

  /// Source text: Biztosan törlöd az összes rögzített súlyt?
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete all recorded weights?'**
  String get m0128;

  /// Source text: Biztosan törlöd ezt a bevásárlólistát?
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this shopping list?'**
  String get m0129;

  /// Source text: BMI
  ///
  /// In en, this message translates to:
  /// **'BMI'**
  String get m0130;

  /// Source text: BMI
  /// kalkulátor
  ///
  /// In en, this message translates to:
  /// **'BMI\ncalculator'**
  String get m0131;

  /// Source text: Bogyós gyümölcs
  ///
  /// In en, this message translates to:
  /// **'Berries'**
  String get m0132;

  /// Source text: Brokkoli
  ///
  /// In en, this message translates to:
  /// **'Broccoli'**
  String get m0133;

  /// Source text: Build today one meal at a time.
  ///
  /// In en, this message translates to:
  /// **'Build today one meal at a time.'**
  String get m0134;

  /// Source text: Bulgur
  ///
  /// In en, this message translates to:
  /// **'Bulgur'**
  String get m0135;

  /// Source text: Burgonya
  ///
  /// In en, this message translates to:
  /// **'Potato'**
  String get m0136;

  /// Source text: Burgur
  ///
  /// In en, this message translates to:
  /// **'Bulgur'**
  String get m0137;

  /// Source text: Candy
  ///
  /// In en, this message translates to:
  /// **'Candy'**
  String get m0138;

  /// Source text: Chia mag
  ///
  /// In en, this message translates to:
  /// **'Chia seeds'**
  String get m0139;

  /// Source text: Chili fűszer
  ///
  /// In en, this message translates to:
  /// **'Chili spice'**
  String get m0140;

  /// Source text: Chilis pulykával töltött paprika
  ///
  /// In en, this message translates to:
  /// **'Chili turkey stuffed peppers'**
  String get m0141;

  /// Source text: Citromlé
  ///
  /// In en, this message translates to:
  /// **'Lemon juice'**
  String get m0142;

  /// Source text: Close the day with care.
  ///
  /// In en, this message translates to:
  /// **'Close the day with care.'**
  String get m0143;

  /// Source text: Cottage cheese
  ///
  /// In en, this message translates to:
  /// **'Cottage cheese'**
  String get m0144;

  /// Source text: Cottage cheese zöldségtál
  ///
  /// In en, this message translates to:
  /// **'Cottage cheese vegetable plate'**
  String get m0145;

  /// Source text: Cream
  ///
  /// In en, this message translates to:
  /// **'Cream'**
  String get m0146;

  /// Source text: Csicseriborsó
  ///
  /// In en, this message translates to:
  /// **'Chickpeas'**
  String get m0147;

  /// Source text: Csicseriborsó curry rizzsel
  ///
  /// In en, this message translates to:
  /// **'Chickpea curry with rice'**
  String get m0148;

  /// Source text: Csicseriborsós ropogós doboz
  ///
  /// In en, this message translates to:
  /// **'Crunchy chickpea box'**
  String get m0149;

  /// Source text: csipet
  ///
  /// In en, this message translates to:
  /// **'pinch'**
  String get m0150;

  /// Source text: Csirkemell
  ///
  /// In en, this message translates to:
  /// **'Chicken breast'**
  String get m0151;

  /// Source text: Csirkés kuszkuszos doboz
  ///
  /// In en, this message translates to:
  /// **'Chicken couscous box'**
  String get m0152;

  /// Source text: Csirkés pita tál
  ///
  /// In en, this message translates to:
  /// **'Chicken pita bowl'**
  String get m0153;

  /// Source text: Csirkés rizses fit bowl
  ///
  /// In en, this message translates to:
  /// **'Chicken rice fit bowl'**
  String get m0154;

  /// Source text: Csirkés rizses fit bowl kisebb adagban
  ///
  /// In en, this message translates to:
  /// **'Chicken rice fit bowl, smaller portion'**
  String get m0155;

  /// Source text: Csirkés rizstészta leveses tál
  ///
  /// In en, this message translates to:
  /// **'Chicken rice noodle soup bowl'**
  String get m0156;

  /// Source text: csökkenhet vagy növekedhet
  ///
  /// In en, this message translates to:
  /// **'can decrease or increase'**
  String get m0157;

  /// Source text: Csökkenő
  ///
  /// In en, this message translates to:
  /// **'Decreasing'**
  String get m0158;

  /// Source text: Csökkenő trend ebben az időszakban
  ///
  /// In en, this message translates to:
  /// **'Trending down in this period'**
  String get m0159;

  /// Source text: Cukkini
  ///
  /// In en, this message translates to:
  /// **'Zucchini'**
  String get m0160;

  /// Source text: Cukkinispagettivel tálald.
  ///
  /// In en, this message translates to:
  /// **'Serve with zucchini noodles.'**
  String get m0161;

  /// Source text: Curry fűszer
  ///
  /// In en, this message translates to:
  /// **'Curry spice'**
  String get m0162;

  /// Source text: Darált csirkemell
  ///
  /// In en, this message translates to:
  /// **'Ground chicken breast'**
  String get m0163;

  /// Source text: Darált dió
  ///
  /// In en, this message translates to:
  /// **'Ground walnuts'**
  String get m0164;

  /// Source text: Darált pulykahús
  ///
  /// In en, this message translates to:
  /// **'Ground turkey'**
  String get m0165;

  /// Source text: db
  ///
  /// In en, this message translates to:
  /// **'pcs'**
  String get m0166;

  /// Source text: Dew
  ///
  /// In en, this message translates to:
  /// **'Dew'**
  String get m0167;

  /// Source text: Dió vagy mandula
  ///
  /// In en, this message translates to:
  /// **'Walnuts or almonds'**
  String get m0168;

  /// Source text: diófélék
  ///
  /// In en, this message translates to:
  /// **'tree nuts'**
  String get m0169;

  /// Source text: Dobozok
  ///
  /// In en, this message translates to:
  /// **'Boxes'**
  String get m0170;

  /// Source text: Dobozolós nap
  ///
  /// In en, this message translates to:
  /// **'Prep Box Day'**
  String get m0171;

  /// Source text: Dobozolt lendület nap
  ///
  /// In en, this message translates to:
  /// **'Boxed Momentum Day'**
  String get m0172;

  /// Source text: Easy
  ///
  /// In en, this message translates to:
  /// **'Easy'**
  String get m0173;

  /// Source text: Ebéd
  ///
  /// In en, this message translates to:
  /// **'Lunch'**
  String get m0174;

  /// Source text: Eddigi fogyás
  ///
  /// In en, this message translates to:
  /// **'Weight lost so far'**
  String get m0175;

  /// Source text: Eddigi változás
  ///
  /// In en, this message translates to:
  /// **'Total change so far'**
  String get m0176;

  /// Source text: Edzéshez és jobb teltségérzethez
  ///
  /// In en, this message translates to:
  /// **'For training and better satiety'**
  String get m0177;

  /// Source text: Egy adag nyers egyenértéke
  ///
  /// In en, this message translates to:
  /// **'Raw equivalent per portion'**
  String get m0178;

  /// Source text: Egy kiegyensúlyozott tányér stabilan tartja a napot.
  ///
  /// In en, this message translates to:
  /// **'A steady plate keeps the day steady.'**
  String get m0179;

  /// Source text: Egy kis előkészítés sokat számít.
  ///
  /// In en, this message translates to:
  /// **'A little prep goes a long way.'**
  String get m0180;

  /// Source text: Egyszerű lendület nap
  ///
  /// In en, this message translates to:
  /// **'Simple Momentum Day'**
  String get m0181;

  /// Source text: Egyszerű nap
  ///
  /// In en, this message translates to:
  /// **'Simple Day'**
  String get m0182;

  /// Source text: Egyszerű tempó nap
  ///
  /// In en, this message translates to:
  /// **'Simple Pace Day'**
  String get m0183;

  /// Source text: Egyszerűbb, olcsóbb alapanyagokkal
  ///
  /// In en, this message translates to:
  /// **'With simpler, cheaper ingredients'**
  String get m0184;

  /// Source text: Életkor
  ///
  /// In en, this message translates to:
  /// **'Age'**
  String get m0185;

  /// Source text: Elkészítés
  ///
  /// In en, this message translates to:
  /// **'Preparation'**
  String get m0186;

  /// Source text: Ellenőrizd az ideális testsúlyod és kövesd nyomon a változásokat. Mentve a profilodba.
  ///
  /// In en, this message translates to:
  /// **'Check your ideal weight and track changes. Saved to your profile.'**
  String get m0187;

  /// Source text: Elmentett listák
  ///
  /// In en, this message translates to:
  /// **'Saved lists'**
  String get m0188;

  /// Source text: Elmentett meal prep tervek
  ///
  /// In en, this message translates to:
  /// **'Saved Meal Prep Plans'**
  String get m0189;

  /// Source text: Előfizetés
  ///
  /// In en, this message translates to:
  /// **'Subscription'**
  String get m0190;

  /// Source text: Előkészített nap
  ///
  /// In en, this message translates to:
  /// **'Prepared Day'**
  String get m0191;

  /// Source text: Előre dobozolható napi menü
  ///
  /// In en, this message translates to:
  /// **'Daily menu you can prep ahead'**
  String get m0192;

  /// Source text: Előre főzős nap
  ///
  /// In en, this message translates to:
  /// **'Cook-Ahead Day'**
  String get m0193;

  /// Source text: Előre haladó nap
  ///
  /// In en, this message translates to:
  /// **'Prep-Ahead Day'**
  String get m0194;

  /// Source text: Először ments el egy ételt a meal prep tervezéshez.
  ///
  /// In en, this message translates to:
  /// **'Save a food first, then you can build a Meal Prep plan.'**
  String get m0195;

  /// Source text: előtt
  ///
  /// In en, this message translates to:
  /// **'before cooking'**
  String get m0196;

  /// Source text: Emelkedő
  ///
  /// In en, this message translates to:
  /// **'Increasing'**
  String get m0197;

  /// Source text: Emelkedő trend ebben az időszakban
  ///
  /// In en, this message translates to:
  /// **'Trending up in this period'**
  String get m0198;

  /// Source text: End the day full, not rushed.
  ///
  /// In en, this message translates to:
  /// **'End the day full, not rushed.'**
  String get m0199;

  /// Source text: Enyhén aktív (heti 1–3x)
  ///
  /// In en, this message translates to:
  /// **'Lightly active (1-3x/week)'**
  String get m0200;

  /// Source text: Eper
  ///
  /// In en, this message translates to:
  /// **'Strawberries'**
  String get m0201;

  /// Source text: Építsd fel a mai napot étkezésről étkezésre.
  ///
  /// In en, this message translates to:
  /// **'Build today one meal at a time.'**
  String get m0202;

  /// Source text: Erő plusz nap
  ///
  /// In en, this message translates to:
  /// **'Strength Plus Day'**
  String get m0203;

  /// Source text: Erős nap
  ///
  /// In en, this message translates to:
  /// **'Strong Day'**
  String get m0204;

  /// Source text: Erősen aktív (heti 6–7x)
  ///
  /// In en, this message translates to:
  /// **'Very active (6-7x/week)'**
  String get m0205;

  /// Source text: Értem, kezdjük el! →
  ///
  /// In en, this message translates to:
  /// **'Got it, let’s start! →'**
  String get m0206;

  /// Source text: Étel megosztás
  ///
  /// In en, this message translates to:
  /// **'Food sharing'**
  String get m0207;

  /// Source text: Étel neve
  ///
  /// In en, this message translates to:
  /// **'Food name'**
  String get m0208;

  /// Source text: Étel szerkesztése
  ///
  /// In en, this message translates to:
  /// **'Edit food'**
  String get m0209;

  /// Source text: Ételek
  ///
  /// In en, this message translates to:
  /// **'Meals'**
  String get m0210;

  /// Source text: étkezés
  ///
  /// In en, this message translates to:
  /// **'meals'**
  String get m0211;

  /// Source text: Étrend
  ///
  /// In en, this message translates to:
  /// **'Meal plan'**
  String get m0212;

  /// Source text: Étrend típus
  ///
  /// In en, this message translates to:
  /// **'Diet type'**
  String get m0213;

  /// Source text: Étrend típusok
  ///
  /// In en, this message translates to:
  /// **'Meal plan types'**
  String get m0214;

  /// Source text: étrendek
  ///
  /// In en, this message translates to:
  /// **'meal plans'**
  String get m0215;

  /// Source text: Étrendek
  ///
  /// In en, this message translates to:
  /// **'Meal plans'**
  String get m0216;

  /// Source text: év
  ///
  /// In en, this message translates to:
  /// **'yrs'**
  String get m0217;

  /// Source text: Éves csomag −50% kedvezménnyel
  ///
  /// In en, this message translates to:
  /// **'Yearly plan with −50% discount'**
  String get m0218;

  /// Source text: Éves előfizetés
  ///
  /// In en, this message translates to:
  /// **'Yearly subscription'**
  String get m0219;

  /// Source text: Extrém aktív
  ///
  /// In en, this message translates to:
  /// **'Extremely active'**
  String get m0220;

  /// Source text: Ezekből számolja az app a BMI értéket, a napi kalória célt és a profil alapadatait.
  ///
  /// In en, this message translates to:
  /// **'The app uses these to calculate your BMI, daily calorie target, and profile basics.'**
  String get m0221;

  /// Source text: Fahéj
  ///
  /// In en, this message translates to:
  /// **'Cinnamon'**
  String get m0222;

  /// Source text: Fehér halfilé
  ///
  /// In en, this message translates to:
  /// **'White fish fillet'**
  String get m0223;

  /// Source text: Fehérje fókusz nap
  ///
  /// In en, this message translates to:
  /// **'Protein Focus Day'**
  String get m0224;

  /// Source text: Fehérjepor
  ///
  /// In en, this message translates to:
  /// **'Protein powder'**
  String get m0225;

  /// Source text: Fehérjés puding
  ///
  /// In en, this message translates to:
  /// **'Protein pudding'**
  String get m0226;

  /// Source text: Fehérjés puding fél adag gyümölccsel
  ///
  /// In en, this message translates to:
  /// **'Half protein pudding with fruit'**
  String get m0227;

  /// Source text: Férfi
  ///
  /// In en, this message translates to:
  /// **'Male'**
  String get m0228;

  /// Source text: Feta sajt
  ///
  /// In en, this message translates to:
  /// **'Feta cheese'**
  String get m0229;

  /// Source text: Fetás bulgur reggeli tál
  ///
  /// In en, this message translates to:
  /// **'Feta bulgur breakfast bowl'**
  String get m0230;

  /// Source text: Fetás paradicsomos abonett
  ///
  /// In en, this message translates to:
  /// **'Feta tomato crispbread'**
  String get m0231;

  /// Source text: Fit lendület nap
  ///
  /// In en, this message translates to:
  /// **'Fit Momentum Day'**
  String get m0232;

  /// Source text: Fitt nap
  ///
  /// In en, this message translates to:
  /// **'Fit Day'**
  String get m0233;

  /// Source text: Fix adagméret
  ///
  /// In en, this message translates to:
  /// **'Fixed portion size'**
  String get m0234;

  /// Source text: Főétel
  ///
  /// In en, this message translates to:
  /// **'Main dish'**
  String get m0235;

  /// Source text: Főétel adag / doboz
  ///
  /// In en, this message translates to:
  /// **'Main portion / box'**
  String get m0236;

  /// Source text: Főétel g / adag
  ///
  /// In en, this message translates to:
  /// **'Main g / portion'**
  String get m0237;

  /// Source text: Főétel mentés
  ///
  /// In en, this message translates to:
  /// **'Main dish saving'**
  String get m0238;

  /// Source text: Főétel recept szorzó
  ///
  /// In en, this message translates to:
  /// **'Main recipe multiplier'**
  String get m0239;

  /// Source text: Főételek
  ///
  /// In en, this message translates to:
  /// **'Main dishes'**
  String get m0240;

  /// Source text: Fogyás statisztika
  ///
  /// In en, this message translates to:
  /// **'Weight loss statistics'**
  String get m0241;

  /// Source text: Fogyáshoz
  ///
  /// In en, this message translates to:
  /// **'For fat loss'**
  String get m0242;

  /// Source text: Fogyáshoz:
  ///
  /// In en, this message translates to:
  /// **'For fat loss: '**
  String get m0243;

  /// Source text: földimogyoró
  ///
  /// In en, this message translates to:
  /// **'peanut'**
  String get m0244;

  /// Source text: Forgasd össze a zöldségekkel, tésztával és szójaszósszal.
  ///
  /// In en, this message translates to:
  /// **'Toss with the vegetables, noodles, and soy sauce.'**
  String get m0245;

  /// Source text: Formázz falatokat és hűtsd 20 percig.
  ///
  /// In en, this message translates to:
  /// **'Shape into bites and chill for 20 minutes.'**
  String get m0246;

  /// Source text: Főtt lencse
  ///
  /// In en, this message translates to:
  /// **'Cooked lentils'**
  String get m0247;

  /// Source text: Főtt rizs
  ///
  /// In en, this message translates to:
  /// **'Cooked rice'**
  String get m0248;

  /// Source text: Főtt tojás avokádóval
  ///
  /// In en, this message translates to:
  /// **'Boiled eggs with avocado'**
  String get m0249;

  /// Source text: Főzd össze sűrű raguvá.
  ///
  /// In en, this message translates to:
  /// **'Cook into a thick stew.'**
  String get m0250;

  /// Source text: Főzés során az étel
  ///
  /// In en, this message translates to:
  /// **'During cooking, food '**
  String get m0251;

  /// Source text: Főzés során az étel tömege
  ///
  /// In en, this message translates to:
  /// **'During cooking, food weight '**
  String get m0252;

  /// Source text: főzés után mérd le az egész elkészült ételt, például 760 g.
  ///
  /// In en, this message translates to:
  /// **'after cooking, weigh the finished meal, for example 760 g.'**
  String get m0253;

  /// Source text: Friss mentes nap
  ///
  /// In en, this message translates to:
  /// **'Fresh Free-From Day'**
  String get m0254;

  /// Source text: Friss nap
  ///
  /// In en, this message translates to:
  /// **'Fresh Day'**
  String get m0255;

  /// Source text: Friss zöld nap
  ///
  /// In en, this message translates to:
  /// **'Fresh Green Day'**
  String get m0256;

  /// Source text: Friss zöldség
  ///
  /// In en, this message translates to:
  /// **'Fresh vegetables'**
  String get m0257;

  /// Source text: Fuel the morning with intention.
  ///
  /// In en, this message translates to:
  /// **'Fuel the morning with intention.'**
  String get m0258;

  /// Source text: FUNKCIÓ
  ///
  /// In en, this message translates to:
  /// **'FEATURE'**
  String get m0259;

  /// Source text: Füstölt lazac
  ///
  /// In en, this message translates to:
  /// **'Smoked salmon'**
  String get m0260;

  /// Source text: Fűszerkeverék
  ///
  /// In en, this message translates to:
  /// **'Spice mix'**
  String get m0261;

  /// Source text: g / adag
  ///
  /// In en, this message translates to:
  /// **'g / portion'**
  String get m0262;

  /// Source text: Garnéla
  ///
  /// In en, this message translates to:
  /// **'Shrimp'**
  String get m0263;

  /// Source text: Garnélás cottage saláta
  ///
  /// In en, this message translates to:
  /// **'Shrimp cottage salad'**
  String get m0264;

  /// Source text: Garnélás quinoa bowl
  ///
  /// In en, this message translates to:
  /// **'Shrimp quinoa bowl'**
  String get m0265;

  /// Source text: Garnélás rizstészta wok
  ///
  /// In en, this message translates to:
  /// **'Shrimp rice noodle wok'**
  String get m0266;

  /// Source text: Give your evening a head start.
  ///
  /// In en, this message translates to:
  /// **'Give your evening a head start.'**
  String get m0267;

  /// Source text: glutén
  ///
  /// In en, this message translates to:
  /// **'gluten'**
  String get m0268;

  /// Source text: Gluténmentes
  ///
  /// In en, this message translates to:
  /// **'Gluten-free'**
  String get m0269;

  /// Source text: Glutént tartalmazó alapanyagok nélkül
  ///
  /// In en, this message translates to:
  /// **'Without ingredients containing gluten'**
  String get m0270;

  /// Source text: Good afternoon
  ///
  /// In en, this message translates to:
  /// **'Good afternoon'**
  String get m0271;

  /// Source text: Good day
  ///
  /// In en, this message translates to:
  /// **'Good day'**
  String get m0272;

  /// Source text: Good evening
  ///
  /// In en, this message translates to:
  /// **'Good evening'**
  String get m0273;

  /// Source text: Good morning
  ///
  /// In en, this message translates to:
  /// **'Good morning'**
  String get m0274;

  /// Source text: Görög csirkés tányér
  ///
  /// In en, this message translates to:
  /// **'Greek chicken plate'**
  String get m0275;

  /// Source text: Görög joghurt
  ///
  /// In en, this message translates to:
  /// **'Greek yogurt'**
  String get m0276;

  /// Source text: Görög joghurtos granola pohár
  ///
  /// In en, this message translates to:
  /// **'Greek yogurt granola cup'**
  String get m0277;

  /// Source text: Görög joghurtos granola pohár gluténmentes granolával
  ///
  /// In en, this message translates to:
  /// **'Greek yogurt granola cup with gluten-free granola'**
  String get m0278;

  /// Source text: Görög lazacos quinoa tál
  ///
  /// In en, this message translates to:
  /// **'Greek salmon quinoa bowl'**
  String get m0279;

  /// Source text: Granola
  ///
  /// In en, this message translates to:
  /// **'Granola'**
  String get m0280;

  /// Source text: Gyors
  ///
  /// In en, this message translates to:
  /// **'Quick'**
  String get m0281;

  /// Source text: Gyors fókusz nap
  ///
  /// In en, this message translates to:
  /// **'Quick Focus Day'**
  String get m0282;

  /// Source text: Gyors rutin nap
  ///
  /// In en, this message translates to:
  /// **'Quick Routine Day'**
  String get m0283;

  /// Source text: ha a dobozodba 250 g kerül, a Mealful kiszámolja, hogy ez kb. 313 g nyers alapanyagnak felel meg.
  ///
  /// In en, this message translates to:
  /// **'if 250 g goes into your container, Mealful calculates that it equals about 313 g of raw ingredients.'**
  String get m0284;

  /// Source text: Ha csak rizst, bulgurt vagy tésztát főzöl köretnek, ugyanígy működik: nyers rizs 300 g, kész rizs 820 g, kimért adag 180 g. Az app megadja a nyers rizs egyenértékét.
  ///
  /// In en, this message translates to:
  /// **'If you cook only rice, bulgur, or pasta as a side, it works the same way: raw rice 300 g, cooked rice 820 g, served portion 180 g. The app gives the raw rice equivalent.'**
  String get m0285;

  /// Source text: Ha enni szeretnél, mérd le a tányérodra kerülő adagot és írd be – megkapod a
  ///
  /// In en, this message translates to:
  /// **'When you want to eat, measure the portion on your plate and enter it - you get the '**
  String get m0286;

  /// Source text: Ha megfőzted vagy megsütötted az ételt, mérd le az
  ///
  /// In en, this message translates to:
  /// **'After cooking or baking the meal, measure the '**
  String get m0287;

  /// Source text: Ha sűrűbb állagot szeretnél, adj hozzá jeget vagy kevesebb folyadékot.
  ///
  /// In en, this message translates to:
  /// **'For a thicker texture, add ice or use less liquid.'**
  String get m0288;

  /// Source text: Hagyd állni 5 percig, hogy a zab felvegye a nedvességet.
  ///
  /// In en, this message translates to:
  /// **'Let it rest for 5 minutes so the oats absorb the moisture.'**
  String get m0289;

  /// Source text: Hajtsd félbe és frissen tálald.
  ///
  /// In en, this message translates to:
  /// **'Fold in half and serve fresh.'**
  String get m0290;

  /// Source text: hal
  ///
  /// In en, this message translates to:
  /// **'fish'**
  String get m0291;

  /// Source text: Hamarosan
  ///
  /// In en, this message translates to:
  /// **'Soon'**
  String get m0292;

  /// Source text: Havi előfizetés
  ///
  /// In en, this message translates to:
  /// **'Monthly subscription'**
  String get m0293;

  /// Source text: Helyezd rá a halfilét, fűszerezd és locsold meg olajjal.
  ///
  /// In en, this message translates to:
  /// **'Place the fish fillet on top, season, and drizzle with oil.'**
  String get m0294;

  /// Source text: hét
  ///
  /// In en, this message translates to:
  /// **'week'**
  String get m0295;

  /// Source text: Heti átlag
  ///
  /// In en, this message translates to:
  /// **'Weekly average'**
  String get m0296;

  /// Source text: Heti doboz nap
  ///
  /// In en, this message translates to:
  /// **'Weekly Box Day'**
  String get m0297;

  /// Source text: Heti ritmus nap
  ///
  /// In en, this message translates to:
  /// **'Weekly Rhythm Day'**
  String get m0298;

  /// Source text: Heti táplálkozási pillanatkép
  ///
  /// In en, this message translates to:
  /// **'Weekly nutrition snapshot'**
  String get m0299;

  /// Source text: HOGYAN HASZNÁLD?
  ///
  /// In en, this message translates to:
  /// **'HOW TO USE IT?'**
  String get m0300;

  /// Source text: Hogyan működik?
  ///
  /// In en, this message translates to:
  /// **'How does it work?'**
  String get m0301;

  /// Source text: HOGYAN SEGÍT A MEALFUL?
  ///
  /// In en, this message translates to:
  /// **'HOW DOES MEALFUL HELP?'**
  String get m0302;

  /// Source text: Hozzáadás
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get m0303;

  /// Source text: Hozzáadva
  ///
  /// In en, this message translates to:
  /// **'Added'**
  String get m0304;

  /// Source text: Hozzávaló
  ///
  /// In en, this message translates to:
  /// **'Ingredient'**
  String get m0305;

  /// Source text: Hozzávalók
  ///
  /// In en, this message translates to:
  /// **'Ingredients'**
  String get m0306;

  /// Source text: Hummusz
  ///
  /// In en, this message translates to:
  /// **'Hummus'**
  String get m0307;

  /// Source text: Hummuszos rizsszelet torony
  ///
  /// In en, this message translates to:
  /// **'Hummus rice cake stack'**
  String get m0308;

  /// Source text: Hummuszos tojásos pita
  ///
  /// In en, this message translates to:
  /// **'Hummus egg pita'**
  String get m0309;

  /// Source text: Hummuszos zöldségdoboz
  ///
  /// In en, this message translates to:
  /// **'Hummus vegetable box'**
  String get m0310;

  /// Source text: Húsmentes lendület nap
  ///
  /// In en, this message translates to:
  /// **'Meat-Free Momentum Day'**
  String get m0311;

  /// Source text: Húsmentes napi étrend
  ///
  /// In en, this message translates to:
  /// **'Meat-free daily plan'**
  String get m0312;

  /// Source text: Ideális testsúly
  ///
  /// In en, this message translates to:
  /// **'Ideal weight'**
  String get m0313;

  /// Source text: Így pontosabban tudod vezetni a kalóriákat, és a meal prep adagolás sem lesz találgatás.
  ///
  /// In en, this message translates to:
  /// **'This makes calorie tracking more accurate, and Meal Prep portions stop being guesswork.'**
  String get m0314;

  /// Source text: Indítsd tudatosan a reggelt.
  ///
  /// In en, this message translates to:
  /// **'Fuel the morning with intention.'**
  String get m0315;

  /// Source text: Indulhat
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get m0316;

  /// Source text: Ingyenes
  ///
  /// In en, this message translates to:
  /// **'Free'**
  String get m0317;

  /// Source text: Ingyenes alapok
  ///
  /// In en, this message translates to:
  /// **'Free basics'**
  String get m0318;

  /// Source text: Ingyenes módban 1 meal prep tervet menthetsz. A további tervekhez Pro szükséges.
  ///
  /// In en, this message translates to:
  /// **'Free includes 1 saved Meal Prep plan. Upgrade to save more.'**
  String get m0319;

  /// Source text: Irányadó cél
  ///
  /// In en, this message translates to:
  /// **'Guidance target'**
  String get m0320;

  /// Source text: Iránymutató – 2–4 hétig kövesd, majd a tényleges változás alapján igazítsd.
  ///
  /// In en, this message translates to:
  /// **'Use as a guide for 2-4 weeks, then adjust based on actual progress.'**
  String get m0321;

  /// Source text: Írj receptet, tippet vagy emlékeztetőt...
  ///
  /// In en, this message translates to:
  /// **'Write a recipe, tip, or reminder...'**
  String get m0322;

  /// Source text: Ízlés szerint sózd, borsozd.
  ///
  /// In en, this message translates to:
  /// **'Season with salt and pepper to taste.'**
  String get m0323;

  /// Source text: Izmos nap
  ///
  /// In en, this message translates to:
  /// **'Muscle Day'**
  String get m0324;

  /// Source text: Jegyzet
  ///
  /// In en, this message translates to:
  /// **'Note'**
  String get m0325;

  /// Source text: Jó délutánt
  ///
  /// In en, this message translates to:
  /// **'Good afternoon'**
  String get m0326;

  /// Source text: Jó estét
  ///
  /// In en, this message translates to:
  /// **'Good evening'**
  String get m0327;

  /// Source text: Jó reggelt
  ///
  /// In en, this message translates to:
  /// **'Good morning'**
  String get m0328;

  /// Source text: Joghurt
  ///
  /// In en, this message translates to:
  /// **'Yogurt'**
  String get m0329;

  /// Source text: Joghurtos öntet
  ///
  /// In en, this message translates to:
  /// **'Yogurt dressing'**
  String get m0330;

  /// Source text: Joghurtos szósz
  ///
  /// In en, this message translates to:
  /// **'Yogurt sauce'**
  String get m0331;

  /// Source text: Juharszirup
  ///
  /// In en, this message translates to:
  /// **'Maple syrup'**
  String get m0332;

  /// Source text: Kakaópor
  ///
  /// In en, this message translates to:
  /// **'Cocoa powder'**
  String get m0333;

  /// Source text: Kakaós chia zabpohár
  ///
  /// In en, this message translates to:
  /// **'Cocoa chia oat cup'**
  String get m0334;

  /// Source text: Kakaós skyr ropogóssal
  ///
  /// In en, this message translates to:
  /// **'Cocoa skyr with crunch'**
  String get m0335;

  /// Source text: Kaliforniai paprika
  ///
  /// In en, this message translates to:
  /// **'Bell pepper'**
  String get m0336;

  /// Source text: Kalkulátorból beállítva
  ///
  /// In en, this message translates to:
  /// **'Set from calculator'**
  String get m0337;

  /// Source text: Kalória
  ///
  /// In en, this message translates to:
  /// **'Calories'**
  String get m0338;

  /// Source text: Kalória
  /// kalkulátor
  ///
  /// In en, this message translates to:
  /// **'Calorie\ncalculator'**
  String get m0339;

  /// Source text: Kalória cél
  ///
  /// In en, this message translates to:
  /// **'Calorie goal'**
  String get m0340;

  /// Source text: Kalória kalkulátor
  ///
  /// In en, this message translates to:
  /// **'Calorie calculator'**
  String get m0341;

  /// Source text: Kanalazd kekszekre, uborkával tálald.
  ///
  /// In en, this message translates to:
  /// **'Spoon onto crackers and serve with cucumber.'**
  String get m0342;

  /// Source text: Kanalazd mellé a tzatzikit, és tálald a quinoa-zöldség alappal.
  ///
  /// In en, this message translates to:
  /// **'Spoon the tzatziki alongside and serve with the quinoa-vegetable base.'**
  String get m0343;

  /// Source text: kcal / nap
  ///
  /// In en, this message translates to:
  /// **'kcal / day'**
  String get m0344;

  /// Source text: Kedvencek
  ///
  /// In en, this message translates to:
  /// **'Favorites'**
  String get m0345;

  /// Source text: Keep the afternoon light and useful.
  ///
  /// In en, this message translates to:
  /// **'Keep the afternoon light and useful.'**
  String get m0346;

  /// Source text: Keep your meals on track.
  ///
  /// In en, this message translates to:
  /// **'Keep your meals on track.'**
  String get m0347;

  /// Source text: Kend meg krémsajttal, majd tedd rá a lazacot és uborkát.
  ///
  /// In en, this message translates to:
  /// **'Spread with cream cheese, then add salmon and cucumber.'**
  String get m0348;

  /// Source text: Kend meg vékonyan mogyoróvajjal és szórd meg fahéjjal.
  ///
  /// In en, this message translates to:
  /// **'Spread thinly with peanut butter and sprinkle with cinnamon.'**
  String get m0349;

  /// Source text: Képlet:
  ///
  /// In en, this message translates to:
  /// **'Formula: '**
  String get m0350;

  /// Source text: Keresés receptek között
  ///
  /// In en, this message translates to:
  /// **'Search recipes'**
  String get m0351;

  /// Source text: Kert nap
  ///
  /// In en, this message translates to:
  /// **'Garden Day'**
  String get m0352;

  /// Source text: Kész doboz nap
  ///
  /// In en, this message translates to:
  /// **'Ready Box Day'**
  String get m0353;

  /// Source text: Kész étel
  ///
  /// In en, this message translates to:
  /// **'Cooked meal'**
  String get m0354;

  /// Source text: Kész étel súlya
  ///
  /// In en, this message translates to:
  /// **'Cooked meal weight'**
  String get m0355;

  /// Source text: Kész g
  ///
  /// In en, this message translates to:
  /// **'Cooked g'**
  String get m0356;

  /// Source text: Kész súly
  ///
  /// In en, this message translates to:
  /// **'Cooked weight'**
  String get m0357;

  /// Source text: Készíts lágy rántottát a tojásból.
  ///
  /// In en, this message translates to:
  /// **'Make soft scrambled eggs.'**
  String get m0358;

  /// Source text: Készítsd elő, ami később könnyít.
  ///
  /// In en, this message translates to:
  /// **'Prep what makes later easier.'**
  String get m0359;

  /// Source text: Keverd bele a fehérjeport, majd hagyd pár percig sűrűsödni.
  ///
  /// In en, this message translates to:
  /// **'Stir in the protein powder, then let it thicken for a few minutes.'**
  String get m0360;

  /// Source text: Keverd hozzá a bulgurt és a paradicsompürét, majd főzd össze.
  ///
  /// In en, this message translates to:
  /// **'Stir in the bulgur and tomato paste, then cook together.'**
  String get m0361;

  /// Source text: Keverd hozzá a juharszirupot, majd hagyd pár percig sűrűsödni.
  ///
  /// In en, this message translates to:
  /// **'Stir in the maple syrup, then let it thicken for a few minutes.'**
  String get m0362;

  /// Source text: Keverd hozzá a paradicsompürét, és főzd 3-4 percig sűrű raguvá.
  ///
  /// In en, this message translates to:
  /// **'Stir in the tomato paste and cook for 3-4 minutes into a thick stew.'**
  String get m0363;

  /// Source text: Keverd hozzá a zabot, kakaót és juharszirupot.
  ///
  /// In en, this message translates to:
  /// **'Mix in the oats, cocoa, and maple syrup.'**
  String get m0364;

  /// Source text: Keverd hozzá a zabot, kakaót és mogyoróvajat.
  ///
  /// In en, this message translates to:
  /// **'Mix in the oats, cocoa, and peanut butter.'**
  String get m0365;

  /// Source text: Keverd össze a burgonyát a tzatzikivel, majd tálald uborkával és pulykasonkával.
  ///
  /// In en, this message translates to:
  /// **'Mix the potatoes with the tzatziki, then serve with cucumber and turkey ham.'**
  String get m0366;

  /// Source text: Keverd össze a joghurtot a fehérjeporral.
  ///
  /// In en, this message translates to:
  /// **'Mix the yogurt with the protein powder.'**
  String get m0367;

  /// Source text: Keverd össze a kifőtt tésztával, és adagold sajttal megszórva.
  ///
  /// In en, this message translates to:
  /// **'Mix with the cooked pasta and portion with grated cheese.'**
  String get m0368;

  /// Source text: Keverd össze a lencsével és morzsolt fetával.
  ///
  /// In en, this message translates to:
  /// **'Mix with lentils and crumbled feta.'**
  String get m0369;

  /// Source text: Keverd össze a tonhalat a babbal, burgonyával és joghurtos öntettel.
  ///
  /// In en, this message translates to:
  /// **'Mix the tuna with the beans, potatoes, and yogurt dressing.'**
  String get m0370;

  /// Source text: Keverd össze a zabot, joghurtot, folyadékot és fahéjat.
  ///
  /// In en, this message translates to:
  /// **'Mix the oats, yogurt, liquid, and cinnamon.'**
  String get m0371;

  /// Source text: Keverd össze a zabot, tejet vagy növényi italt, chia magot és kakaóport.
  ///
  /// In en, this message translates to:
  /// **'Mix the oats, milk or plant drink, chia seeds, and cocoa powder.'**
  String get m0372;

  /// Source text: Keverd össze spenóttal és paradicsommal.
  ///
  /// In en, this message translates to:
  /// **'Mix with spinach and tomatoes.'**
  String get m0373;

  /// Source text: Keverd össze tonhallal, kukoricával és joghurttal.
  ///
  /// In en, this message translates to:
  /// **'Mix with tuna, corn, and yogurt.'**
  String get m0374;

  /// Source text: Keverd simára a hozzávalókat.
  ///
  /// In en, this message translates to:
  /// **'Mix the ingredients until smooth.'**
  String get m0375;

  /// Source text: Keverd simára a joghurtot fehérjeporral és kakaóval.
  ///
  /// In en, this message translates to:
  /// **'Mix the yogurt with protein powder and cocoa until smooth.'**
  String get m0376;

  /// Source text: Keverj mustárt a joghurtos öntetbe, majd locsold a kuszkuszos salátára.
  ///
  /// In en, this message translates to:
  /// **'Mix mustard into the yogurt dressing, then drizzle it over the couscous salad.'**
  String get m0377;

  /// Source text: Kevés citromlével frissítsd, majd azonnal tálald.
  ///
  /// In en, this message translates to:
  /// **'Freshen with a little lemon juice and serve immediately.'**
  String get m0378;

  /// Source text: Kevés olajon párold át őket, majd öntsd rá a felvert tojást.
  ///
  /// In en, this message translates to:
  /// **'Soften them in a little oil, then pour over the beaten eggs.'**
  String get m0379;

  /// Source text: Kevesebb mutatása
  ///
  /// In en, this message translates to:
  /// **'Show less'**
  String get m0380;

  /// Source text: Kezdd az első súlyméréssel.
  ///
  /// In en, this message translates to:
  /// **'Start with your first weight entry.'**
  String get m0381;

  /// Source text: Kezdés ingyenesen
  ///
  /// In en, this message translates to:
  /// **'Start free'**
  String get m0382;

  /// Source text: Kezdj egyszerűen, maradj következetes.
  ///
  /// In en, this message translates to:
  /// **'Start simple, stay steady.'**
  String get m0383;

  /// Source text: Kezdjük egyszerűen.
  ///
  /// In en, this message translates to:
  /// **'Let’s keep it simple.'**
  String get m0384;

  /// Source text: Kiadós alap nap
  ///
  /// In en, this message translates to:
  /// **'Filling Basics Day'**
  String get m0385;

  /// Source text: Kihagyás
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get m0386;

  /// Source text: Kímélő nap
  ///
  /// In en, this message translates to:
  /// **'Gentle Day'**
  String get m0387;

  /// Source text: Kimért adag
  ///
  /// In en, this message translates to:
  /// **'Served amount'**
  String get m0388;

  /// Source text: Kimért g
  ///
  /// In en, this message translates to:
  /// **'Serving g'**
  String get m0389;

  /// Source text: Kipipált tételek törlése
  ///
  /// In en, this message translates to:
  /// **'Clear checked items'**
  String get m0390;

  /// Source text: Kis döntések, stabil lendület.
  ///
  /// In en, this message translates to:
  /// **'Small choices, solid momentum.'**
  String get m0391;

  /// Source text: Koktélparadicsom
  ///
  /// In en, this message translates to:
  /// **'Cherry tomatoes'**
  String get m0392;

  /// Source text: Kókusztej
  ///
  /// In en, this message translates to:
  /// **'Coconut milk'**
  String get m0393;

  /// Source text: Könnyed nap
  ///
  /// In en, this message translates to:
  /// **'Easy Day'**
  String get m0394;

  /// Source text: Könnyű babos chili
  ///
  /// In en, this message translates to:
  /// **'Light bean chili'**
  String get m0395;

  /// Source text: Könnyű csirkés saláta
  ///
  /// In en, this message translates to:
  /// **'Light chicken salad'**
  String get m0396;

  /// Source text: Könnyű nap
  ///
  /// In en, this message translates to:
  /// **'Light Day'**
  String get m0397;

  /// Source text: Köret
  ///
  /// In en, this message translates to:
  /// **'Side'**
  String get m0398;

  /// Source text: Köret adag / doboz
  ///
  /// In en, this message translates to:
  /// **'Side portion / box'**
  String get m0399;

  /// Source text: Köret g / adag
  ///
  /// In en, this message translates to:
  /// **'Side g / portion'**
  String get m0400;

  /// Source text: Köret hozzáadása
  ///
  /// In en, this message translates to:
  /// **'Add side'**
  String get m0401;

  /// Source text: Köret külön vezetve
  ///
  /// In en, this message translates to:
  /// **'Tracking sides separately'**
  String get m0402;

  /// Source text: Köret mentés
  ///
  /// In en, this message translates to:
  /// **'Side saving'**
  String get m0403;

  /// Source text: Köret nyers egyenértéke
  ///
  /// In en, this message translates to:
  /// **'Side raw equivalent'**
  String get m0404;

  /// Source text: Köret recept szorzó
  ///
  /// In en, this message translates to:
  /// **'Side recipe multiplier'**
  String get m0405;

  /// Source text: Köretek
  ///
  /// In en, this message translates to:
  /// **'Sides'**
  String get m0406;

  /// Source text: Korlátlan
  ///
  /// In en, this message translates to:
  /// **'Unlimited'**
  String get m0407;

  /// Source text: Korlátlan étel és meal prep mentés
  ///
  /// In en, this message translates to:
  /// **'Unlimited meals and Meal Prep plans'**
  String get m0408;

  /// Source text: Korlátlan mentés és extra funkciók
  ///
  /// In en, this message translates to:
  /// **'Unlimited saves and premium tools'**
  String get m0409;

  /// Source text: Közepesen aktív (heti 3–5x)
  ///
  /// In en, this message translates to:
  /// **'Moderately active (3-5x/week)'**
  String get m0410;

  /// Source text: Krémsajt
  ///
  /// In en, this message translates to:
  /// **'Cream cheese'**
  String get m0411;

  /// Source text: Kukorica
  ///
  /// In en, this message translates to:
  /// **'Corn'**
  String get m0412;

  /// Source text: Külön köretnél is ugyanígy működik: ha a nyers alapanyag főzés közben vizet vesz fel, a kész tömeg több lehet, de ettől nem lesz több benne a kalória. A Mealful ilyenkor is a nyers egyenértéket számolja ki.
  ///
  /// In en, this message translates to:
  /// **'It works the same for separate sides: if a raw ingredient absorbs water while cooking, the cooked weight can be higher, but that does not add calories. Mealful still calculates the raw equivalent.'**
  String get m0413;

  /// Source text: Kuszkusz
  ///
  /// In en, this message translates to:
  /// **'Couscous'**
  String get m0414;

  /// Source text: Lassíts, egyél jól, pihenj könnyen.
  ///
  /// In en, this message translates to:
  /// **'Slow down, eat well, rest easy.'**
  String get m0415;

  /// Source text: Lassú tűzön süsd készre, amíg a közepe is megszilárdul.
  ///
  /// In en, this message translates to:
  /// **'Cook on low heat until the center sets.'**
  String get m0416;

  /// Source text: Laza mentes nap
  ///
  /// In en, this message translates to:
  /// **'Easy Free-From Day'**
  String get m0417;

  /// Source text: Lazacfilé
  ///
  /// In en, this message translates to:
  /// **'Salmon fillet'**
  String get m0418;

  /// Source text: Lazacos burgonyás ebéd
  ///
  /// In en, this message translates to:
  /// **'Salmon potato lunch'**
  String get m0419;

  /// Source text: Lazacos krémsajtos bagel
  ///
  /// In en, this message translates to:
  /// **'Salmon cream cheese bagel'**
  String get m0420;

  /// Source text: Lazacos spenótos omlett tányér
  ///
  /// In en, this message translates to:
  /// **'Salmon spinach omelette plate'**
  String get m0421;

  /// Source text: Lazacos uborkás falatok
  ///
  /// In en, this message translates to:
  /// **'Salmon cucumber bites'**
  String get m0422;

  /// Source text: Lazacos zöldbabos vacsora
  ///
  /// In en, this message translates to:
  /// **'Salmon green bean dinner'**
  String get m0423;

  /// Source text: Legalacsonyabb
  ///
  /// In en, this message translates to:
  /// **'Lowest'**
  String get m0424;

  /// Source text: Legyen a délután könnyű és hasznos.
  ///
  /// In en, this message translates to:
  /// **'Keep the afternoon light and useful.'**
  String get m0425;

  /// Source text: Legyen az első döntés könnyű.
  ///
  /// In en, this message translates to:
  /// **'Make the first choice an easy one.'**
  String get m0426;

  /// Source text: Legyen egyszerű a következő étkezés.
  ///
  /// In en, this message translates to:
  /// **'Make the next meal easy.'**
  String get m0427;

  /// Source text: Lejár:
  ///
  /// In en, this message translates to:
  /// **'Expires: '**
  String get m0428;

  /// Source text: Lencsés feta saláta
  ///
  /// In en, this message translates to:
  /// **'Lentil feta salad'**
  String get m0429;

  /// Source text: Lencsés zöldséges rizses egytál
  ///
  /// In en, this message translates to:
  /// **'Lentil vegetable rice pot'**
  String get m0430;

  /// Source text: Light sajt
  ///
  /// In en, this message translates to:
  /// **'Light cheese'**
  String get m0431;

  /// Source text: Lilahagyma
  ///
  /// In en, this message translates to:
  /// **'Red onion'**
  String get m0432;

  /// Source text: Lista
  ///
  /// In en, this message translates to:
  /// **'List'**
  String get m0433;

  /// Source text: Lista neve
  ///
  /// In en, this message translates to:
  /// **'List name'**
  String get m0434;

  /// Source text: Locsold meg kevés mézzel, majd szórd meg dióval vagy mandulával.
  ///
  /// In en, this message translates to:
  /// **'Drizzle with a little honey, then sprinkle with walnuts or almonds.'**
  String get m0435;

  /// Source text: Locsold meg kevés mézzel, majd szórd meg mandulával.
  ///
  /// In en, this message translates to:
  /// **'Drizzle with a little honey, then sprinkle with almonds.'**
  String get m0436;

  /// Source text: Locsold meg olívaolajjal, majd hűtve vagy frissen tálald.
  ///
  /// In en, this message translates to:
  /// **'Drizzle with olive oil and serve chilled or fresh.'**
  String get m0437;

  /// Source text: Ma
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get m0438;

  /// Source text: Magas fehérje
  ///
  /// In en, this message translates to:
  /// **'High protein'**
  String get m0439;

  /// Source text: Magasság
  ///
  /// In en, this message translates to:
  /// **'Height'**
  String get m0440;

  /// Source text: Magasság (cm)
  ///
  /// In en, this message translates to:
  /// **'Height (cm)'**
  String get m0441;

  /// Source text: Make the first choice an easy one.
  ///
  /// In en, this message translates to:
  /// **'Make the first choice an easy one.'**
  String get m0442;

  /// Source text: Make the next meal easy.
  ///
  /// In en, this message translates to:
  /// **'Make the next meal easy.'**
  String get m0443;

  /// Source text: Makrók megoszlása
  ///
  /// In en, this message translates to:
  /// **'Macro split'**
  String get m0444;

  /// Source text: Mandula
  ///
  /// In en, this message translates to:
  /// **'Almonds'**
  String get m0445;

  /// Source text: Maradj feltöltve és fókuszban.
  ///
  /// In en, this message translates to:
  /// **'Stay fueled and focused.'**
  String get m0446;

  /// Source text: Marhahúsos bulgur serpenyő
  ///
  /// In en, this message translates to:
  /// **'Beef bulgur skillet'**
  String get m0447;

  /// Source text: Marhahúsos pita ebéd
  ///
  /// In en, this message translates to:
  /// **'Beef pita lunch'**
  String get m0448;

  /// Source text: Marhás cukkinis rizs
  ///
  /// In en, this message translates to:
  /// **'Beef zucchini rice'**
  String get m0449;

  /// Source text: Meal prep alapú
  ///
  /// In en, this message translates to:
  /// **'Meal Prep based'**
  String get m0450;

  /// Source text: Meal prep terv szerkesztése
  ///
  /// In en, this message translates to:
  /// **'Edit Meal Prep plan'**
  String get m0451;

  /// Source text: Meal Prep tervező
  ///
  /// In en, this message translates to:
  /// **'Meal Prep planner'**
  String get m0452;

  /// Source text: Meal Prep+
  ///
  /// In en, this message translates to:
  /// **'Meal Prep+'**
  String get m0453;

  /// Source text: Meal preppelés
  ///
  /// In en, this message translates to:
  /// **'Meal Prepping'**
  String get m0454;

  /// Source text: Mealful Pro
  ///
  /// In en, this message translates to:
  /// **'Mealful Pro'**
  String get m0455;

  /// Source text: Mediterrán pulykás bulgur
  ///
  /// In en, this message translates to:
  /// **'Mediterranean turkey bulgur'**
  String get m0456;

  /// Source text: Medium
  ///
  /// In en, this message translates to:
  /// **'Medium'**
  String get m0457;

  /// Source text: Még nincs elmentett bevásárlólistád.
  ///
  /// In en, this message translates to:
  /// **'Shopping lists you create will appear here.'**
  String get m0458;

  /// Source text: Még nincs elmentett meal prep terved.
  ///
  /// In en, this message translates to:
  /// **'Saved Meal Prep plans will appear here.'**
  String get m0459;

  /// Source text: Még nincs főétel hozzáadva.
  ///
  /// In en, this message translates to:
  /// **'Your main dishes will appear here.'**
  String get m0460;

  /// Source text: Még nincs köret hozzáadva.
  ///
  /// In en, this message translates to:
  /// **'Your sides will appear here.'**
  String get m0461;

  /// Source text: Megjegyzés
  ///
  /// In en, this message translates to:
  /// **'Note'**
  String get m0462;

  /// Source text: Megjelenés
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get m0463;

  /// Source text: Megjelenés módja
  ///
  /// In en, this message translates to:
  /// **'Appearance mode'**
  String get m0464;

  /// Source text: Meglévő listához adás
  ///
  /// In en, this message translates to:
  /// **'Add to existing list'**
  String get m0465;

  /// Source text: Megosztás
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get m0466;

  /// Source text: Mégse
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get m0467;

  /// Source text: Meleg banános zabfalatok
  ///
  /// In en, this message translates to:
  /// **'Warm banana oat bites'**
  String get m0468;

  /// Source text: Meleg lencsés feta tányér
  ///
  /// In en, this message translates to:
  /// **'Warm lentil feta plate'**
  String get m0469;

  /// Source text: Melegítsd át a tortillát, majd tedd rá a sonkát, sajtot és zöldséget.
  ///
  /// In en, this message translates to:
  /// **'Warm the tortilla, then add the ham, cheese, and vegetables.'**
  String get m0470;

  /// Source text: Mentés
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get m0471;

  /// Source text: Mentes lendület nap
  ///
  /// In en, this message translates to:
  /// **'Free-From Momentum Day'**
  String get m0472;

  /// Source text: Mentés profilba · a Kalória cél frissítése
  ///
  /// In en, this message translates to:
  /// **'Save to profile · update calorie goal'**
  String get m0473;

  /// Source text: Mentés új listaként
  ///
  /// In en, this message translates to:
  /// **'Save as new list'**
  String get m0474;

  /// Source text: Mentett étel
  ///
  /// In en, this message translates to:
  /// **'Saved food'**
  String get m0475;

  /// Source text: Mentve
  ///
  /// In en, this message translates to:
  /// **'Saved'**
  String get m0476;

  /// Source text: Mentve a profilba · legközelebb automatikusan kitöltve
  ///
  /// In en, this message translates to:
  /// **'Saved to profile · prefilled next time'**
  String get m0477;

  /// Source text: Mentve a profilba.
  ///
  /// In en, this message translates to:
  /// **'Saved to profile.'**
  String get m0478;

  /// Source text: mérd le főzés előtt az alapanyagokat, például csirke + rizs + zöldség összesen 950 g.
  ///
  /// In en, this message translates to:
  /// **'weigh the ingredients before cooking, for example chicken + rice + vegetables totaling 950 g.'**
  String get m0479;

  /// Source text: Mérések
  ///
  /// In en, this message translates to:
  /// **'Entries'**
  String get m0480;

  /// Source text: Méz
  ///
  /// In en, this message translates to:
  /// **'Honey'**
  String get m0481;

  /// Source text: MI A PROBLÉMA?
  ///
  /// In en, this message translates to:
  /// **'WHAT IS THE PROBLEM?'**
  String get m0482;

  /// Source text: MIÉRT HASZNOS?
  ///
  /// In en, this message translates to:
  /// **'WHY IS IT USEFUL?'**
  String get m0483;

  /// Source text: Mind
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get m0484;

  /// Source text: MINDEN EGYBEN
  ///
  /// In en, this message translates to:
  /// **'ALL IN ONE'**
  String get m0485;

  /// Source text: Minden hozzávalót tegyél turmixgépbe.
  ///
  /// In en, this message translates to:
  /// **'Put all ingredients into a blender.'**
  String get m0486;

  /// Source text: Mini burgonyás tzatziki doboz
  ///
  /// In en, this message translates to:
  /// **'Mini potato tzatziki box'**
  String get m0487;

  /// Source text: Mini csirkés wrap
  ///
  /// In en, this message translates to:
  /// **'Mini chicken wrap'**
  String get m0488;

  /// Source text: Mini tortilla
  ///
  /// In en, this message translates to:
  /// **'Mini tortilla'**
  String get m0489;

  /// Source text: Mogyoróvaj
  ///
  /// In en, this message translates to:
  /// **'Peanut butter'**
  String get m0490;

  /// Source text: Morzsold rá a fetát, és frissen tálald.
  ///
  /// In en, this message translates to:
  /// **'Crumble the feta on top and serve fresh.'**
  String get m0491;

  /// Source text: Morzsold rá a fetát, és tálald a zöldséges bulgurral.
  ///
  /// In en, this message translates to:
  /// **'Crumble the feta on top and serve with the vegetable bulgur.'**
  String get m0492;

  /// Source text: mustár
  ///
  /// In en, this message translates to:
  /// **'mustard'**
  String get m0493;

  /// Source text: Mustár
  ///
  /// In en, this message translates to:
  /// **'Mustard'**
  String get m0494;

  /// Source text: Mustáros sertésszűz burgonyával
  ///
  /// In en, this message translates to:
  /// **'Mustard pork tenderloin with potatoes'**
  String get m0495;

  /// Source text: nap
  ///
  /// In en, this message translates to:
  /// **'days'**
  String get m0496;

  /// Source text: Napi aktivitás
  ///
  /// In en, this message translates to:
  /// **'Daily activity'**
  String get m0497;

  /// Source text: Napi bontás
  ///
  /// In en, this message translates to:
  /// **'Daily breakdown'**
  String get m0498;

  /// Source text: NAPI SZINTENTARTÓ KALÓRIA
  ///
  /// In en, this message translates to:
  /// **'DAILY MAINTENANCE CALORIES'**
  String get m0499;

  /// Source text: Nasi
  ///
  /// In en, this message translates to:
  /// **'Snack'**
  String get m0500;

  /// Source text: Nehézség
  ///
  /// In en, this message translates to:
  /// **'Difficulty'**
  String get m0501;

  /// Source text: Nem
  ///
  /// In en, this message translates to:
  /// **'Gender'**
  String get m0502;

  /// Source text: nem a kalóriájából.
  ///
  /// In en, this message translates to:
  /// **'not its calories.'**
  String get m0503;

  /// Source text: Nem csak mérlegelés: egy app a kajás rutinodhoz.
  ///
  /// In en, this message translates to:
  /// **'Not just weighing: one app for your food routine.'**
  String get m0504;

  /// Source text: nem változik a kalóriája.
  ///
  /// In en, this message translates to:
  /// **'does not change its calories.'**
  String get m0505;

  /// Source text: Nevezd el és add hozzá a tételeket
  ///
  /// In en, this message translates to:
  /// **'Name it and add the items'**
  String get m0506;

  /// Source text: Névjegy
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get m0507;

  /// Source text: Nincs aktív előfizetés
  ///
  /// In en, this message translates to:
  /// **'No active subscription'**
  String get m0508;

  /// Source text: nincs kiemelt allergén
  ///
  /// In en, this message translates to:
  /// **'no highlighted allergen'**
  String get m0509;

  /// Source text: Nincs köret
  ///
  /// In en, this message translates to:
  /// **'No side'**
  String get m0510;

  /// Source text: Nincs mentett étel
  ///
  /// In en, this message translates to:
  /// **'No saved food'**
  String get m0511;

  /// Source text: Nincs találat.
  ///
  /// In en, this message translates to:
  /// **'No recipes match this search.'**
  String get m0512;

  /// Source text: Nincs változás a kezdő súlyhoz képest
  ///
  /// In en, this message translates to:
  /// **'No change compared with starting weight'**
  String get m0513;

  /// Source text: Nő
  ///
  /// In en, this message translates to:
  /// **'Female'**
  String get m0514;

  /// Source text: Normál
  ///
  /// In en, this message translates to:
  /// **'Normal'**
  String get m0515;

  /// Source text: Normál receptek
  ///
  /// In en, this message translates to:
  /// **'Normal'**
  String get m0516;

  /// Source text: Normál súly
  ///
  /// In en, this message translates to:
  /// **'Normal weight'**
  String get m0517;

  /// Source text: Növényi nap
  ///
  /// In en, this message translates to:
  /// **'Plant Day'**
  String get m0518;

  /// Source text: Növényi ritmus nap
  ///
  /// In en, this message translates to:
  /// **'Plant Rhythm Day'**
  String get m0519;

  /// Source text: Nyelv
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get m0520;

  /// Source text: Nyelv, téma, mód és verzió
  ///
  /// In en, this message translates to:
  /// **'Language, theme, mode, and version'**
  String get m0521;

  /// Source text: nyers ÷ kész × kimért =
  /// nyers egyenérték
  ///
  ///
  /// In en, this message translates to:
  /// **'raw ÷ cooked × served =\nraw equivalent\n'**
  String get m0522;

  /// Source text: Nyers adag
  ///
  /// In en, this message translates to:
  /// **'Raw amount'**
  String get m0523;

  /// Source text: Nyers egyenérték
  ///
  /// In en, this message translates to:
  /// **'Raw equivalent'**
  String get m0524;

  /// Source text: nyers egyenértéket
  ///
  /// In en, this message translates to:
  /// **'raw equivalent'**
  String get m0525;

  /// Source text: nyers egyenértéket.
  ///
  /// In en, this message translates to:
  /// **'raw equivalent.'**
  String get m0526;

  /// Source text: Nyers g
  ///
  /// In en, this message translates to:
  /// **'Raw g'**
  String get m0527;

  /// Source text: Nyers súly kalkulátor
  ///
  /// In en, this message translates to:
  /// **'Raw weight calculator'**
  String get m0528;

  /// Source text: nyersen
  ///
  /// In en, this message translates to:
  /// **'raw'**
  String get m0529;

  /// Source text: Nyisd meg újra a bevezetőt
  ///
  /// In en, this message translates to:
  /// **'Open the intro again'**
  String get m0530;

  /// Source text: Nyugodt energia nap
  ///
  /// In en, this message translates to:
  /// **'Calm Energy Day'**
  String get m0531;

  /// Source text: Nyugodt, praktikus eszköz a pontosabb étkezési rutinhoz.
  ///
  /// In en, this message translates to:
  /// **'A calm, practical tool for a more accurate eating routine.'**
  String get m0532;

  /// Source text: Obezitás
  ///
  /// In en, this message translates to:
  /// **'Obesity'**
  String get m0533;

  /// Source text: Okos kosár nap
  ///
  /// In en, this message translates to:
  /// **'Smart Basket Day'**
  String get m0534;

  /// Source text: Okos nap
  ///
  /// In en, this message translates to:
  /// **'Smart Day'**
  String get m0535;

  /// Source text: Olcsó okos nap
  ///
  /// In en, this message translates to:
  /// **'Smart Budget Day'**
  String get m0536;

  /// Source text: Olívaolaj
  ///
  /// In en, this message translates to:
  /// **'Olive oil'**
  String get m0537;

  /// Source text: Onboarding újraindítása
  ///
  /// In en, this message translates to:
  /// **'Restart onboarding'**
  String get m0538;

  /// Source text: Összes
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get m0539;

  /// Source text: Összes kalória
  ///
  /// In en, this message translates to:
  /// **'Total calories'**
  String get m0540;

  /// Source text: össztömeget
  ///
  /// In en, this message translates to:
  /// **'total weight'**
  String get m0541;

  /// Source text: Oszd dobozokra a kuszkuszt, csirkét és brokkolit.
  ///
  /// In en, this message translates to:
  /// **'Divide the couscous, chicken, and broccoli into boxes.'**
  String get m0542;

  /// Source text: Oszd dobozokra a rizst, csirkét és brokkolit.
  ///
  /// In en, this message translates to:
  /// **'Divide the rice, chicken, and broccoli into boxes.'**
  String get m0543;

  /// Source text: Overnight oats előre bekészítve
  ///
  /// In en, this message translates to:
  /// **'Overnight oats prepped ahead'**
  String get m0544;

  /// Source text: Paprika
  ///
  /// In en, this message translates to:
  /// **'Pepper'**
  String get m0545;

  /// Source text: Paradicsom
  ///
  /// In en, this message translates to:
  /// **'Tomato'**
  String get m0546;

  /// Source text: Paradicsompüré
  ///
  /// In en, this message translates to:
  /// **'Tomato paste'**
  String get m0547;

  /// Source text: Paradicsomszósszal és sajttal süsd készre.
  ///
  /// In en, this message translates to:
  /// **'Bake with tomato sauce and cheese until done.'**
  String get m0548;

  /// Source text: Paradicsomszósz
  ///
  /// In en, this message translates to:
  /// **'Tomato sauce'**
  String get m0549;

  /// Source text: Pénztárca plusz nap
  ///
  /// In en, this message translates to:
  /// **'Wallet Plus Day'**
  String get m0550;

  /// Source text: Pénztárcabarát
  ///
  /// In en, this message translates to:
  /// **'Budget-friendly'**
  String get m0551;

  /// Source text: perc
  ///
  /// In en, this message translates to:
  /// **'min'**
  String get m0552;

  /// Source text: Pirítsd meg a kenyeret.
  ///
  /// In en, this message translates to:
  /// **'Toast the bread.'**
  String get m0553;

  /// Source text: Pl. Hétvégi főzés
  ///
  /// In en, this message translates to:
  /// **'E.g. Weekend cooking'**
  String get m0554;

  /// Source text: Plan a calm, strong day.
  ///
  /// In en, this message translates to:
  /// **'Plan a calm, strong day.'**
  String get m0555;

  /// Source text: Pörgős nap
  ///
  /// In en, this message translates to:
  /// **'Busy Day'**
  String get m0556;

  /// Source text: Praktikus nap
  ///
  /// In en, this message translates to:
  /// **'Practical Day'**
  String get m0557;

  /// Source text: Prep what makes later easier.
  ///
  /// In en, this message translates to:
  /// **'Prep what makes later easier.'**
  String get m0558;

  /// Source text: Pro
  ///
  /// In en, this message translates to:
  /// **'Pro'**
  String get m0559;

  /// Source text: Pro mód teszt
  ///
  /// In en, this message translates to:
  /// **'Pro mode test'**
  String get m0560;

  /// Source text: Pro statisztika
  ///
  /// In en, this message translates to:
  /// **'Pro statistics'**
  String get m0561;

  /// Source text: Pro-val feloldható extrák
  ///
  /// In en, this message translates to:
  /// **'Unlocked with Pro'**
  String get m0562;

  /// Source text: Próbáld ki ingyen 7 napig
  ///
  /// In en, this message translates to:
  /// **'Try free for 7 days'**
  String get m0563;

  /// Source text: Profil
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get m0564;

  /// Source text: Progresszió törlése
  ///
  /// In en, this message translates to:
  /// **'Delete progress'**
  String get m0565;

  /// Source text: Protein joghurt pohár
  ///
  /// In en, this message translates to:
  /// **'Protein yogurt cup'**
  String get m0566;

  /// Source text: Protein zabkása bogyós gyümölccsel
  ///
  /// In en, this message translates to:
  /// **'Protein oatmeal with berries'**
  String get m0567;

  /// Source text: Pulykagolyók cukkinispagettivel
  ///
  /// In en, this message translates to:
  /// **'Turkey meatballs with zucchini noodles'**
  String get m0568;

  /// Source text: Pulykamell sonka
  ///
  /// In en, this message translates to:
  /// **'Turkey breast ham'**
  String get m0569;

  /// Source text: Pulykás bolognai tészta
  ///
  /// In en, this message translates to:
  /// **'Turkey bolognese pasta'**
  String get m0570;

  /// Source text: Pulykás bolognai tészta light adagban
  ///
  /// In en, this message translates to:
  /// **'Turkey bolognese pasta, light portion'**
  String get m0571;

  /// Source text: Pulykás cottage reggeli doboz
  ///
  /// In en, this message translates to:
  /// **'Turkey cottage breakfast box'**
  String get m0572;

  /// Source text: Pulykás sajtos tekercsek
  ///
  /// In en, this message translates to:
  /// **'Turkey cheese rolls'**
  String get m0573;

  /// Source text: Pulykás tojásos wrap
  ///
  /// In en, this message translates to:
  /// **'Turkey egg wrap'**
  String get m0574;

  /// Source text: Pulykasonka
  ///
  /// In en, this message translates to:
  /// **'Turkey ham'**
  String get m0575;

  /// Source text: Pulykával töltött cukkini
  ///
  /// In en, this message translates to:
  /// **'Turkey stuffed zucchini'**
  String get m0576;

  /// Source text: Quinoa
  ///
  /// In en, this message translates to:
  /// **'Quinoa'**
  String get m0577;

  /// Source text: Quinoás bogyós snack pohár
  ///
  /// In en, this message translates to:
  /// **'Quinoa berry snack cup'**
  String get m0578;

  /// Source text: Quinoás joghurtos reggeli
  ///
  /// In en, this message translates to:
  /// **'Quinoa yogurt breakfast'**
  String get m0579;

  /// Source text: rákfélék
  ///
  /// In en, this message translates to:
  /// **'crustaceans'**
  String get m0580;

  /// Source text: Recept
  ///
  /// In en, this message translates to:
  /// **'Recipe'**
  String get m0581;

  /// Source text: Recept szorzó
  ///
  /// In en, this message translates to:
  /// **'Recipe multiplier'**
  String get m0582;

  /// Source text: Receptek
  ///
  /// In en, this message translates to:
  /// **'Recipes'**
  String get m0583;

  /// Source text: Reggeli
  ///
  /// In en, this message translates to:
  /// **'Breakfast'**
  String get m0584;

  /// Source text: Rendezett doboz nap
  ///
  /// In en, this message translates to:
  /// **'Organized Box Day'**
  String get m0585;

  /// Source text: Rendszer
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get m0586;

  /// Source text: Rendszeres használathoz
  ///
  /// In en, this message translates to:
  /// **'For everyday prep'**
  String get m0587;

  /// Source text: Répa
  ///
  /// In en, this message translates to:
  /// **'Carrot'**
  String get m0588;

  /// Source text: Reszeld vagy kockázd bele az almát.
  ///
  /// In en, this message translates to:
  /// **'Grate or dice the apple into it.'**
  String get m0589;

  /// Source text: Reszelt sajt
  ///
  /// In en, this message translates to:
  /// **'Grated cheese'**
  String get m0590;

  /// Source text: Részletek
  ///
  /// In en, this message translates to:
  /// **'Details'**
  String get m0591;

  /// Source text: Rétegezd rá a granolát és a szeletelt banánt.
  ///
  /// In en, this message translates to:
  /// **'Layer the granola and sliced banana on top.'**
  String get m0592;

  /// Source text: Rizs
  ///
  /// In en, this message translates to:
  /// **'Rice'**
  String get m0593;

  /// Source text: Rizsszelet
  ///
  /// In en, this message translates to:
  /// **'Rice cake'**
  String get m0594;

  /// Source text: Rizsszelet cottage cheese-zel
  ///
  /// In en, this message translates to:
  /// **'Rice cakes with cottage cheese'**
  String get m0595;

  /// Source text: Rizstészta
  ///
  /// In en, this message translates to:
  /// **'Rice noodles'**
  String get m0596;

  /// Source text: Rögzítés
  ///
  /// In en, this message translates to:
  /// **'Record'**
  String get m0597;

  /// Source text: Rögzített súlyok
  ///
  /// In en, this message translates to:
  /// **'Recorded weights'**
  String get m0598;

  /// Source text: Rögzíts még egy mérést a trend megjelenítéséhez.
  ///
  /// In en, this message translates to:
  /// **'Add one more entry to see your trend.'**
  String get m0599;

  /// Source text: Rövid elkészítési idejű ételekkel
  ///
  /// In en, this message translates to:
  /// **'With meals that are quick to prepare'**
  String get m0600;

  /// Source text: Rövid konyha nap
  ///
  /// In en, this message translates to:
  /// **'Short Kitchen Day'**
  String get m0601;

  /// Source text: Saláta
  ///
  /// In en, this message translates to:
  /// **'Lettuce'**
  String get m0602;

  /// Source text: Saláta mix
  ///
  /// In en, this message translates to:
  /// **'Salad mix'**
  String get m0603;

  /// Source text: Serpenyőben süsd össze sonkával, sajttal és spenóttal.
  ///
  /// In en, this message translates to:
  /// **'Cook in a pan with ham, cheese, and spinach.'**
  String get m0604;

  /// Source text: Sertésszűz
  ///
  /// In en, this message translates to:
  /// **'Pork tenderloin'**
  String get m0605;

  /// Source text: Sertésszűz kuszkusszal
  ///
  /// In en, this message translates to:
  /// **'Pork tenderloin with couscous'**
  String get m0606;

  /// Source text: Sertésszűz kuszkusz salátával
  ///
  /// In en, this message translates to:
  /// **'Pork tenderloin with couscous salad'**
  String get m0607;

  /// Source text: Set up dinner before the rush.
  ///
  /// In en, this message translates to:
  /// **'Set up dinner before the rush.'**
  String get m0608;

  /// Source text: Shakshuka reggeli tál
  ///
  /// In en, this message translates to:
  /// **'Shakshuka breakfast bowl'**
  String get m0609;

  /// Source text: Sietős lendület nap
  ///
  /// In en, this message translates to:
  /// **'Busy Momentum Day'**
  String get m0610;

  /// Source text: Sietős nap
  ///
  /// In en, this message translates to:
  /// **'Fast Day'**
  String get m0611;

  /// Source text: Skyr vagy görög joghurt
  ///
  /// In en, this message translates to:
  /// **'Skyr or Greek yogurt'**
  String get m0612;

  /// Source text: Slow down, eat well, rest easy.
  ///
  /// In en, this message translates to:
  /// **'Slow down, eat well, rest easy.'**
  String get m0613;

  /// Source text: Small choices, solid momentum.
  ///
  /// In en, this message translates to:
  /// **'Small choices, solid momentum.'**
  String get m0614;

  /// Source text: Só, bors
  ///
  /// In en, this message translates to:
  /// **'Salt, pepper'**
  String get m0615;

  /// Source text: Sonkás sajtos omlett
  ///
  /// In en, this message translates to:
  /// **'Ham and cheese omelette'**
  String get m0616;

  /// Source text: Sonkás tojásos abonett tál
  ///
  /// In en, this message translates to:
  /// **'Ham egg crispbread plate'**
  String get m0617;

  /// Source text: Sós cottage cheese tál
  ///
  /// In en, this message translates to:
  /// **'Savory cottage cheese bowl'**
  String get m0618;

  /// Source text: Sötét
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get m0619;

  /// Source text: Sötét mód
  ///
  /// In en, this message translates to:
  /// **'Dark mode'**
  String get m0620;

  /// Source text: Sovány
  ///
  /// In en, this message translates to:
  /// **'Underweight'**
  String get m0621;

  /// Source text: Sovány marhahús
  ///
  /// In en, this message translates to:
  /// **'Lean beef'**
  String get m0622;

  /// Source text: Spenót
  ///
  /// In en, this message translates to:
  /// **'Spinach'**
  String get m0623;

  /// Source text: Spenótos kókuszos csicseriborsó
  ///
  /// In en, this message translates to:
  /// **'Spinach coconut chickpeas'**
  String get m0624;

  /// Source text: Spinach
  ///
  /// In en, this message translates to:
  /// **'Spinach'**
  String get m0625;

  /// Source text: Sportos nap
  ///
  /// In en, this message translates to:
  /// **'Sporty Day'**
  String get m0626;

  /// Source text: Stabil erő nap
  ///
  /// In en, this message translates to:
  /// **'Steady Strength Day'**
  String get m0627;

  /// Source text: Stabil ezen az időszakon
  ///
  /// In en, this message translates to:
  /// **'Stable in this period'**
  String get m0628;

  /// Source text: Stagnál
  ///
  /// In en, this message translates to:
  /// **'Stable'**
  String get m0629;

  /// Source text: Start simple, stay steady.
  ///
  /// In en, this message translates to:
  /// **'Start simple, stay steady.'**
  String get m0630;

  /// Source text: Stay fueled and focused.
  ///
  /// In en, this message translates to:
  /// **'Stay fueled and focused.'**
  String get m0631;

  /// Source text: Sült csirkemell
  ///
  /// In en, this message translates to:
  /// **'Roasted chicken breast'**
  String get m0632;

  /// Source text: Sült hal zöldségágyon
  ///
  /// In en, this message translates to:
  /// **'Baked fish on vegetables'**
  String get m0633;

  /// Source text: Súly
  ///
  /// In en, this message translates to:
  /// **'Weight'**
  String get m0634;

  /// Source text: Súly (kg)
  ///
  /// In en, this message translates to:
  /// **'Weight (kg)'**
  String get m0635;

  /// Source text: Súly követés
  ///
  /// In en, this message translates to:
  /// **'Weight tracking'**
  String get m0636;

  /// Source text: Súly progresszió
  ///
  /// In en, this message translates to:
  /// **'Weight progress'**
  String get m0637;

  /// Source text: Súly szerkesztése
  ///
  /// In en, this message translates to:
  /// **'Edit weight'**
  String get m0638;

  /// Source text: Súlykövetés
  ///
  /// In en, this message translates to:
  /// **'Weight tracking'**
  String get m0639;

  /// Source text: Súlykövetés diagram
  ///
  /// In en, this message translates to:
  /// **'Weight tracking chart'**
  String get m0640;

  /// Source text: Súlynapló szerkesztés
  ///
  /// In en, this message translates to:
  /// **'Weight log editing'**
  String get m0641;

  /// Source text: Süsd készre, amíg a hal omlós lesz.
  ///
  /// In en, this message translates to:
  /// **'Bake until the fish is tender and flaky.'**
  String get m0642;

  /// Source text: Süsd vagy párold készre paradicsomszószban.
  ///
  /// In en, this message translates to:
  /// **'Bake or simmer in tomato sauce until done.'**
  String get m0643;

  /// Source text: Sütőpor
  ///
  /// In en, this message translates to:
  /// **'Baking powder'**
  String get m0644;

  /// Source text: Számold ki a napi szintentartó kalóriádat életkor, súly, magasság és aktivitás alapján.
  ///
  /// In en, this message translates to:
  /// **'Calculate your daily maintenance calories from age, weight, height, and activity.'**
  String get m0645;

  /// Source text: Személyes adatok
  ///
  /// In en, this message translates to:
  /// **'Personal data'**
  String get m0646;

  /// Source text: SZEMÉLYES ALAPOK
  ///
  /// In en, this message translates to:
  /// **'PERSONAL BASICS'**
  String get m0647;

  /// Source text: Szép napot
  ///
  /// In en, this message translates to:
  /// **'Good day'**
  String get m0648;

  /// Source text: Szerkesztés
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get m0649;

  /// Source text: szezám
  ///
  /// In en, this message translates to:
  /// **'sesame'**
  String get m0650;

  /// Source text: Szezámmag
  ///
  /// In en, this message translates to:
  /// **'Sesame seeds'**
  String get m0651;

  /// Source text: szója
  ///
  /// In en, this message translates to:
  /// **'soy'**
  String get m0652;

  /// Source text: Szójagranulátum
  ///
  /// In en, this message translates to:
  /// **'Soy granules'**
  String get m0653;

  /// Source text: Szójaszósszal ízesítsd, majd süsd össze.
  ///
  /// In en, this message translates to:
  /// **'Season with soy sauce, then cook together.'**
  String get m0654;

  /// Source text: Szójaszósz
  ///
  /// In en, this message translates to:
  /// **'Soy sauce'**
  String get m0655;

  /// Source text: Szórd meg tökmaggal, majd ízlés szerint sózd, borsozd.
  ///
  /// In en, this message translates to:
  /// **'Sprinkle with pumpkin seeds, then season to taste.'**
  String get m0656;

  /// Source text: Szükséges kész étel
  ///
  /// In en, this message translates to:
  /// **'Cooked food needed'**
  String get m0657;

  /// Source text: Szükséges kész főétel
  ///
  /// In en, this message translates to:
  /// **'Cooked main needed'**
  String get m0658;

  /// Source text: Szükséges kész köret
  ///
  /// In en, this message translates to:
  /// **'Cooked side needed'**
  String get m0659;

  /// Source text: Szükséges nyers alapanyag
  ///
  /// In en, this message translates to:
  /// **'Raw ingredients needed'**
  String get m0660;

  /// Source text: Szükséges nyers főétel
  ///
  /// In en, this message translates to:
  /// **'Raw main needed'**
  String get m0661;

  /// Source text: Szükséges nyers köret
  ///
  /// In en, this message translates to:
  /// **'Raw side needed'**
  String get m0662;

  /// Source text: Takarékos nap
  ///
  /// In en, this message translates to:
  /// **'Saver Day'**
  String get m0663;

  /// Source text: Tálald a curry alapot rizzsel.
  ///
  /// In en, this message translates to:
  /// **'Serve the curry base with rice.'**
  String get m0664;

  /// Source text: Tálald bogyós gyümölccsel és chia maggal.
  ///
  /// In en, this message translates to:
  /// **'Serve with berries and chia seeds.'**
  String get m0665;

  /// Source text: Tálald bogyós gyümölccsel.
  ///
  /// In en, this message translates to:
  /// **'Serve with berries.'**
  String get m0666;

  /// Source text: Tálald cottage cheese-zel, abonettel és tökmaggal.
  ///
  /// In en, this message translates to:
  /// **'Serve with cottage cheese, crispbread, and pumpkin seeds.'**
  String get m0667;

  /// Source text: Tálald fetával és tzatzikivel.
  ///
  /// In en, this message translates to:
  /// **'Serve with feta and tzatziki.'**
  String get m0668;

  /// Source text: Tálald gyümölccsel.
  ///
  /// In en, this message translates to:
  /// **'Serve with fruit.'**
  String get m0669;

  /// Source text: Tálald pitával, salátával és joghurtos szósszal.
  ///
  /// In en, this message translates to:
  /// **'Serve with pita, salad, and yogurt sauce.'**
  String get m0670;

  /// Source text: Tálald salátával és joghurtos öntettel.
  ///
  /// In en, this message translates to:
  /// **'Serve with salad and yogurt dressing.'**
  String get m0671;

  /// Source text: Tálald zöldbabbal és kevés mustáros szósszal.
  ///
  /// In en, this message translates to:
  /// **'Serve with green beans and a little mustard sauce.'**
  String get m0672;

  /// Source text: Tapadásmentes serpenyőben süsd ki kisebb palacsintáknak.
  ///
  /// In en, this message translates to:
  /// **'Cook small pancakes in a non-stick pan.'**
  String get m0673;

  /// Source text: Tartsd kézben az étkezéseidet.
  ///
  /// In en, this message translates to:
  /// **'Keep your meals on track.'**
  String get m0674;

  /// Source text: Te adod meg, hány gramm kerüljön egy adagba.
  ///
  /// In en, this message translates to:
  /// **'You set how many grams go into each portion.'**
  String get m0675;

  /// Source text: Tedd dobozba hummusszal együtt.
  ///
  /// In en, this message translates to:
  /// **'Pack them into a box with hummus.'**
  String get m0676;

  /// Source text: Tedd hűtőbe éjszakára, reggel keverd át és fogyaszd.
  ///
  /// In en, this message translates to:
  /// **'Refrigerate overnight, then stir and eat in the morning.'**
  String get m0677;

  /// Source text: Tedd rá a csirkét és az öntetet.
  ///
  /// In en, this message translates to:
  /// **'Add the chicken and dressing on top.'**
  String get m0678;

  /// Source text: Tedd rá a gyümölcsöt, mézet és diót.
  ///
  /// In en, this message translates to:
  /// **'Top with fruit, honey, and walnuts.'**
  String get m0679;

  /// Source text: Tedd rá a paradicsomot és szórd meg tökmaggal.
  ///
  /// In en, this message translates to:
  /// **'Add the tomato and sprinkle with pumpkin seeds.'**
  String get m0680;

  /// Source text: Tedd rá a tojást és frissen tálald.
  ///
  /// In en, this message translates to:
  /// **'Top with the egg and serve fresh.'**
  String get m0681;

  /// Source text: Tedd rá az epret és a mandulát.
  ///
  /// In en, this message translates to:
  /// **'Top with strawberries and almonds.'**
  String get m0682;

  /// Source text: Tegnap
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get m0683;

  /// Source text: Tej
  ///
  /// In en, this message translates to:
  /// **'Milk'**
  String get m0684;

  /// Source text: Tej vagy növényi ital
  ///
  /// In en, this message translates to:
  /// **'Milk or plant drink'**
  String get m0685;

  /// Source text: tejfehérje
  ///
  /// In en, this message translates to:
  /// **'milk protein'**
  String get m0686;

  /// Source text: Tekerd fel és vágd félbe.
  ///
  /// In en, this message translates to:
  /// **'Roll it up and cut in half.'**
  String get m0687;

  /// Source text: Teljes kiőrlésű abonett
  ///
  /// In en, this message translates to:
  /// **'Wholegrain crispbread'**
  String get m0688;

  /// Source text: Teljes kiőrlésű keksz
  ///
  /// In en, this message translates to:
  /// **'Wholegrain crackers'**
  String get m0689;

  /// Source text: Teljes kiőrlésű kenyér
  ///
  /// In en, this message translates to:
  /// **'Wholegrain bread'**
  String get m0690;

  /// Source text: Teljes kiőrlésű pita
  ///
  /// In en, this message translates to:
  /// **'Wholegrain pita'**
  String get m0691;

  /// Source text: Teljes kiőrlésű tészta
  ///
  /// In en, this message translates to:
  /// **'Wholegrain pasta'**
  String get m0692;

  /// Source text: Teljes kiőrlésű tortilla
  ///
  /// In en, this message translates to:
  /// **'Wholegrain tortilla'**
  String get m0693;

  /// Source text: Teljes mennyiség elosztása
  ///
  /// In en, this message translates to:
  /// **'Split total amount'**
  String get m0694;

  /// Source text: Teljesítmény nap
  ///
  /// In en, this message translates to:
  /// **'Performance Day'**
  String get m0695;

  /// Source text: Téma
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get m0696;

  /// Source text: Téma választása
  ///
  /// In en, this message translates to:
  /// **'Choose theme'**
  String get m0697;

  /// Source text: Témák (6 db)
  ///
  /// In en, this message translates to:
  /// **'Themes (6)'**
  String get m0698;

  /// Source text: Tempós nap
  ///
  /// In en, this message translates to:
  /// **'Quick Day'**
  String get m0699;

  /// Source text: Tempós tál nap
  ///
  /// In en, this message translates to:
  /// **'Fast Bowl Day'**
  String get m0700;

  /// Source text: Terv neve
  ///
  /// In en, this message translates to:
  /// **'Plan name'**
  String get m0701;

  /// Source text: Tervezd meg a vacsorát még a rohanás előtt.
  ///
  /// In en, this message translates to:
  /// **'Set up dinner before the rush.'**
  String get m0702;

  /// Source text: Tervezett nap
  ///
  /// In en, this message translates to:
  /// **'Planned Day'**
  String get m0703;

  /// Source text: Tervezz egy nyugodt, erős napot.
  ///
  /// In en, this message translates to:
  /// **'Plan a calm, strong day.'**
  String get m0704;

  /// Source text: Tervezz, főzz, kövess okosabban
  ///
  /// In en, this message translates to:
  /// **'Plan, cook, track smarter'**
  String get m0705;

  /// Source text: TESTTÖMEG INDEX (BMI)
  ///
  /// In en, this message translates to:
  /// **'BODY MASS INDEX (BMI)'**
  String get m0706;

  /// Source text: Tészta
  ///
  /// In en, this message translates to:
  /// **'Pasta'**
  String get m0707;

  /// Source text: tétel
  ///
  /// In en, this message translates to:
  /// **'items'**
  String get m0708;

  /// Source text: Tétel hozzáadása
  ///
  /// In en, this message translates to:
  /// **'Add item'**
  String get m0709;

  /// Source text: téves értéket kapsz.
  ///
  /// In en, this message translates to:
  /// **'you get an incorrect value.'**
  String get m0710;

  /// Source text: Tiszta energia nap
  ///
  /// In en, this message translates to:
  /// **'Clean Energy Day'**
  String get m0711;

  /// Source text: Tiszta nap
  ///
  /// In en, this message translates to:
  /// **'Clean Day'**
  String get m0712;

  /// Source text: Tiszta ritmus nap
  ///
  /// In en, this message translates to:
  /// **'Clean Rhythm Day'**
  String get m0713;

  /// Source text: Toast
  ///
  /// In en, this message translates to:
  /// **'Toast'**
  String get m0714;

  /// Source text: Több mentés, bevásárlólisták, súlykövetés extrák
  ///
  /// In en, this message translates to:
  /// **'Unlimited meals, Shopping+, themes, and tracking'**
  String get m0715;

  /// Source text: Tofu
  ///
  /// In en, this message translates to:
  /// **'Tofu'**
  String get m0716;

  /// Source text: Tofus csicseriborsó curry
  ///
  /// In en, this message translates to:
  /// **'Tofu chickpea curry'**
  String get m0717;

  /// Source text: Tofus quinoás vacsoratál
  ///
  /// In en, this message translates to:
  /// **'Tofu quinoa dinner bowl'**
  String get m0718;

  /// Source text: Tofus zöldséges noodle box
  ///
  /// In en, this message translates to:
  /// **'Tofu vegetable noodle box'**
  String get m0719;

  /// Source text: tojás
  ///
  /// In en, this message translates to:
  /// **'egg'**
  String get m0720;

  /// Source text: Tojás
  ///
  /// In en, this message translates to:
  /// **'Egg'**
  String get m0721;

  /// Source text: Tojásos avokádós pirítós
  ///
  /// In en, this message translates to:
  /// **'Egg avocado toast'**
  String get m0722;

  /// Source text: Tojásos rizses reggeli serpenyő
  ///
  /// In en, this message translates to:
  /// **'Egg rice breakfast skillet'**
  String get m0723;

  /// Source text: Tojásos zöldséges rizs
  ///
  /// In en, this message translates to:
  /// **'Egg vegetable rice'**
  String get m0724;

  /// Source text: Tökmag
  ///
  /// In en, this message translates to:
  /// **'Pumpkin seeds'**
  String get m0725;

  /// Source text: Töltött paprika light módra
  ///
  /// In en, this message translates to:
  /// **'Light stuffed peppers'**
  String get m0726;

  /// Source text: Töltsd meg csirkével és salátával.
  ///
  /// In en, this message translates to:
  /// **'Fill with chicken and lettuce.'**
  String get m0727;

  /// Source text: Töltsd meg húsos-rizses keverékkel.
  ///
  /// In en, this message translates to:
  /// **'Fill with the meat and rice mixture.'**
  String get m0728;

  /// Source text: Töltsd meg pulykás-babos keverékkel.
  ///
  /// In en, this message translates to:
  /// **'Fill with the turkey and bean mixture.'**
  String get m0729;

  /// Source text: Tömegnövelés
  ///
  /// In en, this message translates to:
  /// **'For gaining'**
  String get m0730;

  /// Source text: Tömegnöveléshez:
  ///
  /// In en, this message translates to:
  /// **'For gaining: '**
  String get m0731;

  /// Source text: Tomorrow starts with tonight’s prep.
  ///
  /// In en, this message translates to:
  /// **'Tomorrow starts with tonight’s prep.'**
  String get m0732;

  /// Source text: Tonhal
  ///
  /// In en, this message translates to:
  /// **'Tuna'**
  String get m0733;

  /// Source text: Tonhalas babos burgonyasaláta
  ///
  /// In en, this message translates to:
  /// **'Tuna bean potato salad'**
  String get m0734;

  /// Source text: Tonhalas kukoricás tésztasaláta
  ///
  /// In en, this message translates to:
  /// **'Tuna corn pasta salad'**
  String get m0735;

  /// Source text: Tonhalas reggeli pirítós
  ///
  /// In en, this message translates to:
  /// **'Tuna breakfast toast'**
  String get m0736;

  /// Source text: Tonhalas ropogós falatok
  ///
  /// In en, this message translates to:
  /// **'Crunchy tuna bites'**
  String get m0737;

  /// Source text: Törlés
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get m0738;

  /// Source text: Tovább
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get m0739;

  /// Source text: További rögzítések
  ///
  /// In en, this message translates to:
  /// **'Show more records'**
  String get m0740;

  /// Source text: Trend
  ///
  /// In en, this message translates to:
  /// **'Trend'**
  String get m0741;

  /// Source text: Túlsúly
  ///
  /// In en, this message translates to:
  /// **'Overweight'**
  String get m0742;

  /// Source text: Túlsúlyos
  ///
  /// In en, this message translates to:
  /// **'Overweight'**
  String get m0743;

  /// Source text: Turmixold krémesre 30-60 másodperc alatt.
  ///
  /// In en, this message translates to:
  /// **'Blend until creamy for 30-60 seconds.'**
  String get m0744;

  /// Source text: Túró
  ///
  /// In en, this message translates to:
  /// **'Curd cheese'**
  String get m0745;

  /// Source text: Túrós bogyós tál
  ///
  /// In en, this message translates to:
  /// **'Cottage cheese berry bowl'**
  String get m0746;

  /// Source text: Túrós zabpalacsinta
  ///
  /// In en, this message translates to:
  /// **'Cottage cheese oat pancakes'**
  String get m0747;

  /// Source text: Túrós zabpalacsinta előre sütve
  ///
  /// In en, this message translates to:
  /// **'Cottage cheese oat pancakes cooked ahead'**
  String get m0748;

  /// Source text: Tzatziki
  ///
  /// In en, this message translates to:
  /// **'Tzatziki'**
  String get m0749;

  /// Source text: Uborka
  ///
  /// In en, this message translates to:
  /// **'Cucumber'**
  String get m0750;

  /// Source text: ÜDV A MEALFUL-BEN
  ///
  /// In en, this message translates to:
  /// **'WELCOME TO MEALFUL'**
  String get m0751;

  /// Source text: Új
  ///
  /// In en, this message translates to:
  /// **'New'**
  String get m0752;

  /// Source text: Új bevásárlólista
  ///
  /// In en, this message translates to:
  /// **'New shopping list'**
  String get m0753;

  /// Source text: Új étel
  ///
  /// In en, this message translates to:
  /// **'New food'**
  String get m0754;

  /// Source text: Új étel hozzáadása
  ///
  /// In en, this message translates to:
  /// **'Add new food'**
  String get m0755;

  /// Source text: Új lista neve
  ///
  /// In en, this message translates to:
  /// **'New list name'**
  String get m0756;

  /// Source text: Új meal prep terv
  ///
  /// In en, this message translates to:
  /// **'New Meal Prep plan'**
  String get m0757;

  /// Source text: Új mérés
  ///
  /// In en, this message translates to:
  /// **'New measurement'**
  String get m0758;

  /// Source text: Ülő életmód
  ///
  /// In en, this message translates to:
  /// **'Sedentary'**
  String get m0759;

  /// Source text: Vacsora
  ///
  /// In en, this message translates to:
  /// **'Dinner'**
  String get m0760;

  /// Source text: Vágd félbe és pirítsd meg a bagelt.
  ///
  /// In en, this message translates to:
  /// **'Cut the bagel in half and toast it.'**
  String get m0761;

  /// Source text: Válassz egy típust, majd nézd meg a hozzá tartozó napi étrendeket.
  ///
  /// In en, this message translates to:
  /// **'Choose a type, then view its daily meal plans.'**
  String get m0762;

  /// Source text: Válassz ételt és adagold dobozokra
  ///
  /// In en, this message translates to:
  /// **'Choose a food and split it into boxes'**
  String get m0763;

  /// Source text: Válassz étrend típust
  ///
  /// In en, this message translates to:
  /// **'Choose a meal plan type'**
  String get m0764;

  /// Source text: Válassz főételt, köretet és adagold dobozokra
  ///
  /// In en, this message translates to:
  /// **'Choose a main dish, side, and split into boxes'**
  String get m0765;

  /// Source text: Vegán
  ///
  /// In en, this message translates to:
  /// **'Vegan'**
  String get m0766;

  /// Source text: Vegetáriánus
  ///
  /// In en, this message translates to:
  /// **'Vegetarian'**
  String get m0767;

  /// Source text: Veggie erő nap
  ///
  /// In en, this message translates to:
  /// **'Veggie Strength Day'**
  String get m0768;

  /// Source text: Verzió 1.0.0
  ///
  /// In en, this message translates to:
  /// **'Version 1.0.0'**
  String get m0769;

  /// Source text: veszít a tömegéből
  ///
  /// In en, this message translates to:
  /// **'loses weight'**
  String get m0770;

  /// Source text: Világos
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get m0771;

  /// Source text: Villám nap
  ///
  /// In en, this message translates to:
  /// **'Lightning Day'**
  String get m0772;

  /// Source text: vonj le 300–500 kcal-t. Napi 500 kcal deficit ≈ heti 0,5 kg fogyás.
  ///
  ///
  ///
  /// In en, this message translates to:
  /// **'subtract 300-500 kcal. A daily 500 kcal deficit is about 0.5 kg loss per week.\n\n'**
  String get m0773;

  /// Source text: Vörösbab
  ///
  /// In en, this message translates to:
  /// **'Red beans'**
  String get m0774;

  /// Source text: Wok zöldség
  ///
  /// In en, this message translates to:
  /// **'Wok vegetables'**
  String get m0775;

  /// Source text: Wrap up with something nourishing.
  ///
  /// In en, this message translates to:
  /// **'Wrap up with something nourishing.'**
  String get m0776;

  /// Source text: Zabpehely
  ///
  /// In en, this message translates to:
  /// **'Oats'**
  String get m0777;

  /// Source text: Zabpehelyliszt
  ///
  /// In en, this message translates to:
  /// **'Oat flour'**
  String get m0778;

  /// Source text: Zárd a napot jóllakottan, nem rohanva.
  ///
  /// In en, this message translates to:
  /// **'End the day full, not rushed.'**
  String get m0779;

  /// Source text: Zárd a napot valami táplálóval.
  ///
  /// In en, this message translates to:
  /// **'Wrap up with something nourishing.'**
  String get m0780;

  /// Source text: Zárd gondoskodással a napot.
  ///
  /// In en, this message translates to:
  /// **'Close the day with care.'**
  String get m0781;

  /// Source text: Zöld fókusz nap
  ///
  /// In en, this message translates to:
  /// **'Green Focus Day'**
  String get m0782;

  /// Source text: Zöld lendület nap
  ///
  /// In en, this message translates to:
  /// **'Green Boost Day'**
  String get m0783;

  /// Source text: Zöld nap
  ///
  /// In en, this message translates to:
  /// **'Green Day'**
  String get m0784;

  /// Source text: Zöldbab
  ///
  /// In en, this message translates to:
  /// **'Green beans'**
  String get m0785;

  /// Source text: Zöldborsó
  ///
  /// In en, this message translates to:
  /// **'Green peas'**
  String get m0786;

  /// Source text: Zöldsaláta
  ///
  /// In en, this message translates to:
  /// **'Green salad'**
  String get m0787;

  /// Source text: Zöldséges omlett
  ///
  /// In en, this message translates to:
  /// **'Vegetable omelette'**
  String get m0788;

  /// Source text: Zsemlemorzsa
  ///
  /// In en, this message translates to:
  /// **'Breadcrumbs'**
  String get m0789;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['de', 'en', 'es', 'hu'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'hu':
      return AppLocalizationsHu();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
