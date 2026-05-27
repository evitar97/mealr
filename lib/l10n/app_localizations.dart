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
  /// **'Mealr'**
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

  /// Source text: A Mealr abban segít, hogy főzés, adagolás és meal prep közben ne kelljen fejben számolgatnod. Pár rövid lépésben megmutatjuk, hogyan hozd ki belőle a legtöbbet.
  ///
  /// In en, this message translates to:
  /// **'Mealr helps you avoid mental math while cooking, portioning, and meal prepping. In a few short steps, we’ll show you how to get the most out of it.'**
  String get m0041;

  /// Source text: A Mealr azért kell, hogy ne kelljen fejben számolgatnod, amikor főzés után kevesebb vagy több lesz az étel tömege. Beírod a nyers, kész és kimért súlyt, az app pedig megmondja, mennyi nyers alapanyagnak felel meg az adag.
  ///
  /// In en, this message translates to:
  /// **'Mealr saves you from mental math when food weighs less or more after cooking. Enter raw, cooked, and served weight, and the app tells you the raw ingredient equivalent of your portion.'**
  String get m0042;

  /// Source text: A Mealr egy helyre gyűjti a főzéshez, adagoláshoz és célkövetéshez hasznos eszközöket, hogy ne több app között kelljen ugrálnod.
  ///
  /// In en, this message translates to:
  /// **'Mealr brings cooking, portioning, and goal-tracking tools into one place so you do not have to jump between apps.'**
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

  /// Source text: Burgur
  ///
  /// In en, this message translates to:
  /// **'Bulgur'**
  String get m0136;

  /// Source text: Candy
  ///
  /// In en, this message translates to:
  /// **'Candy'**
  String get m0137;

  /// Source text: Chia mag
  ///
  /// In en, this message translates to:
  /// **'Chia seeds'**
<<<<<<< HEAD
  String get m0139;
=======
  String get m0138;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Chili fűszer
  ///
  /// In en, this message translates to:
  /// **'Chili spice'**
<<<<<<< HEAD
  String get m0140;
=======
  String get m0139;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Chilis pulykával töltött paprika
  ///
  /// In en, this message translates to:
  /// **'Chili turkey stuffed peppers'**
<<<<<<< HEAD
  String get m0141;
=======
  String get m0140;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Citromlé
  ///
  /// In en, this message translates to:
  /// **'Lemon juice'**
<<<<<<< HEAD
  String get m0142;
=======
  String get m0141;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Close the day with care.
  ///
  /// In en, this message translates to:
  /// **'Close the day with care.'**
<<<<<<< HEAD
  String get m0143;
=======
  String get m0142;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Cottage cheese
  ///
  /// In en, this message translates to:
  /// **'Cottage cheese'**
<<<<<<< HEAD
  String get m0144;
=======
  String get m0143;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Cottage cheese zöldségtál
  ///
  /// In en, this message translates to:
  /// **'Cottage cheese vegetable plate'**
<<<<<<< HEAD
  String get m0145;
=======
  String get m0144;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Cream
  ///
  /// In en, this message translates to:
  /// **'Cream'**
<<<<<<< HEAD
  String get m0146;
=======
  String get m0145;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Csicseriborsó
  ///
  /// In en, this message translates to:
  /// **'Chickpeas'**
<<<<<<< HEAD
  String get m0147;
=======
  String get m0146;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Csicseriborsó curry rizzsel
  ///
  /// In en, this message translates to:
  /// **'Chickpea curry with rice'**
<<<<<<< HEAD
  String get m0148;
=======
  String get m0147;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Csicseriborsós ropogós doboz
  ///
  /// In en, this message translates to:
  /// **'Crunchy chickpea box'**
<<<<<<< HEAD
  String get m0149;
=======
  String get m0148;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: csipet
  ///
  /// In en, this message translates to:
  /// **'pinch'**
<<<<<<< HEAD
  String get m0150;
=======
  String get m0149;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Csirkemell
  ///
  /// In en, this message translates to:
  /// **'Chicken breast'**
<<<<<<< HEAD
  String get m0151;
=======
  String get m0150;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Csirkés kuszkuszos doboz
  ///
  /// In en, this message translates to:
  /// **'Chicken couscous box'**
<<<<<<< HEAD
  String get m0152;
=======
  String get m0151;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Csirkés pita tál
  ///
  /// In en, this message translates to:
  /// **'Chicken pita bowl'**
<<<<<<< HEAD
  String get m0153;
=======
  String get m0152;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Csirkés rizses fit bowl
  ///
  /// In en, this message translates to:
  /// **'Chicken rice fit bowl'**
<<<<<<< HEAD
  String get m0154;
=======
  String get m0153;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Csirkés rizses fit bowl kisebb adagban
  ///
  /// In en, this message translates to:
  /// **'Chicken rice fit bowl, smaller portion'**
<<<<<<< HEAD
  String get m0155;
=======
  String get m0154;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Csirkés rizstészta leveses tál
  ///
  /// In en, this message translates to:
  /// **'Chicken rice noodle soup bowl'**
<<<<<<< HEAD
  String get m0156;
=======
  String get m0155;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: csökkenhet vagy növekedhet
  ///
  /// In en, this message translates to:
  /// **'can decrease or increase'**
<<<<<<< HEAD
  String get m0157;
=======
  String get m0156;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Csökkenő
  ///
  /// In en, this message translates to:
  /// **'Decreasing'**
<<<<<<< HEAD
  String get m0158;

  /// Source text: Csökkenő trend ebben az időszakban
  ///
  /// In en, this message translates to:
  /// **'Trending down in this period'**
  String get m0159;
=======
  String get m0157;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Cukkini
  ///
  /// In en, this message translates to:
  /// **'Zucchini'**
<<<<<<< HEAD
  String get m0160;
=======
  String get m0158;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Cukkinispagettivel tálald.
  ///
  /// In en, this message translates to:
  /// **'Serve with zucchini noodles.'**
<<<<<<< HEAD
  String get m0161;
=======
  String get m0159;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Curry fűszer
  ///
  /// In en, this message translates to:
  /// **'Curry spice'**
<<<<<<< HEAD
  String get m0162;
=======
  String get m0160;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Darált csirkemell
  ///
  /// In en, this message translates to:
  /// **'Ground chicken breast'**
<<<<<<< HEAD
  String get m0163;
=======
  String get m0161;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Darált dió
  ///
  /// In en, this message translates to:
  /// **'Ground walnuts'**
<<<<<<< HEAD
  String get m0164;
=======
  String get m0162;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Darált pulykahús
  ///
  /// In en, this message translates to:
  /// **'Ground turkey'**
<<<<<<< HEAD
  String get m0165;
=======
  String get m0163;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: db
  ///
  /// In en, this message translates to:
  /// **'pcs'**
<<<<<<< HEAD
  String get m0166;
=======
  String get m0164;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Dew
  ///
  /// In en, this message translates to:
  /// **'Dew'**
<<<<<<< HEAD
  String get m0167;
=======
  String get m0165;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Dió vagy mandula
  ///
  /// In en, this message translates to:
  /// **'Walnuts or almonds'**
<<<<<<< HEAD
  String get m0168;
=======
  String get m0166;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: diófélék
  ///
  /// In en, this message translates to:
  /// **'tree nuts'**
<<<<<<< HEAD
  String get m0169;
=======
  String get m0167;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Dobozok
  ///
  /// In en, this message translates to:
  /// **'Boxes'**
<<<<<<< HEAD
  String get m0170;
=======
  String get m0168;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Dobozolós nap
  ///
  /// In en, this message translates to:
  /// **'Prep Box Day'**
<<<<<<< HEAD
  String get m0171;
=======
  String get m0169;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Dobozolt lendület nap
  ///
  /// In en, this message translates to:
  /// **'Boxed Momentum Day'**
<<<<<<< HEAD
  String get m0172;
=======
  String get m0170;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Easy
  ///
  /// In en, this message translates to:
  /// **'Easy'**
<<<<<<< HEAD
  String get m0173;
=======
  String get m0171;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Ebéd
  ///
  /// In en, this message translates to:
  /// **'Lunch'**
<<<<<<< HEAD
  String get m0174;
=======
  String get m0172;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Eddigi fogyás
  ///
  /// In en, this message translates to:
  /// **'Weight lost so far'**
<<<<<<< HEAD
  String get m0175;
=======
  String get m0173;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Eddigi változás
  ///
  /// In en, this message translates to:
  /// **'Total change so far'**
<<<<<<< HEAD
  String get m0176;
=======
  String get m0174;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Edzéshez és jobb teltségérzethez
  ///
  /// In en, this message translates to:
  /// **'For training and better satiety'**
<<<<<<< HEAD
  String get m0177;
=======
  String get m0175;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Egy adag nyers egyenértéke
  ///
  /// In en, this message translates to:
  /// **'Raw equivalent per portion'**
<<<<<<< HEAD
  String get m0178;
=======
  String get m0176;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Egy kiegyensúlyozott tányér stabilan tartja a napot.
  ///
  /// In en, this message translates to:
  /// **'A steady plate keeps the day steady.'**
<<<<<<< HEAD
  String get m0179;
=======
  String get m0177;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Egy kis előkészítés sokat számít.
  ///
  /// In en, this message translates to:
  /// **'A little prep goes a long way.'**
<<<<<<< HEAD
  String get m0180;
=======
  String get m0178;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Egyszerű lendület nap
  ///
  /// In en, this message translates to:
  /// **'Simple Momentum Day'**
<<<<<<< HEAD
  String get m0181;
=======
  String get m0179;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Egyszerű nap
  ///
  /// In en, this message translates to:
  /// **'Simple Day'**
<<<<<<< HEAD
  String get m0182;
=======
  String get m0180;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Egyszerű tempó nap
  ///
  /// In en, this message translates to:
  /// **'Simple Pace Day'**
<<<<<<< HEAD
  String get m0183;
=======
  String get m0181;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Egyszerűbb, olcsóbb alapanyagokkal
  ///
  /// In en, this message translates to:
  /// **'With simpler, cheaper ingredients'**
<<<<<<< HEAD
  String get m0184;
=======
  String get m0182;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Életkor
  ///
  /// In en, this message translates to:
  /// **'Age'**
<<<<<<< HEAD
  String get m0185;
=======
  String get m0183;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Elkészítés
  ///
  /// In en, this message translates to:
  /// **'Preparation'**
<<<<<<< HEAD
  String get m0186;
=======
  String get m0184;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Ellenőrizd az ideális testsúlyod és kövesd nyomon a változásokat. Mentve a profilodba.
  ///
  /// In en, this message translates to:
  /// **'Check your ideal weight and track changes. Saved to your profile.'**
<<<<<<< HEAD
  String get m0187;
=======
  String get m0185;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Elmentett listák
  ///
  /// In en, this message translates to:
  /// **'Saved lists'**
<<<<<<< HEAD
  String get m0188;
=======
  String get m0186;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Elmentett meal prep tervek
  ///
  /// In en, this message translates to:
  /// **'Saved Meal Prep Plans'**
<<<<<<< HEAD
  String get m0189;
=======
  String get m0187;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Előfizetés
  ///
  /// In en, this message translates to:
  /// **'Subscription'**
<<<<<<< HEAD
  String get m0190;
=======
  String get m0188;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Előkészített nap
  ///
  /// In en, this message translates to:
  /// **'Prepared Day'**
<<<<<<< HEAD
  String get m0191;
=======
  String get m0189;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Előre dobozolható napi menü
  ///
  /// In en, this message translates to:
  /// **'Daily menu you can prep ahead'**
<<<<<<< HEAD
  String get m0192;
=======
  String get m0190;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Előre főzős nap
  ///
  /// In en, this message translates to:
  /// **'Cook-Ahead Day'**
<<<<<<< HEAD
  String get m0193;
=======
  String get m0191;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Előre haladó nap
  ///
  /// In en, this message translates to:
  /// **'Prep-Ahead Day'**
<<<<<<< HEAD
  String get m0194;
=======
  String get m0192;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Először ments el egy ételt a meal prep tervezéshez.
  ///
  /// In en, this message translates to:
  /// **'Save a food first, then you can build a Meal Prep plan.'**
<<<<<<< HEAD
  String get m0195;
=======
  String get m0193;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: előtt
  ///
  /// In en, this message translates to:
  /// **'before cooking'**
<<<<<<< HEAD
  String get m0196;
=======
  String get m0194;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Emelkedő
  ///
  /// In en, this message translates to:
  /// **'Increasing'**
<<<<<<< HEAD
  String get m0197;

  /// Source text: Emelkedő trend ebben az időszakban
  ///
  /// In en, this message translates to:
  /// **'Trending up in this period'**
  String get m0198;
=======
  String get m0195;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: End the day full, not rushed.
  ///
  /// In en, this message translates to:
  /// **'End the day full, not rushed.'**
<<<<<<< HEAD
  String get m0199;
=======
  String get m0196;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Enyhén aktív (heti 1–3x)
  ///
  /// In en, this message translates to:
  /// **'Lightly active (1-3x/week)'**
<<<<<<< HEAD
  String get m0200;
=======
  String get m0197;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Eper
  ///
  /// In en, this message translates to:
  /// **'Strawberries'**
<<<<<<< HEAD
  String get m0201;
=======
  String get m0198;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Építsd fel a mai napot étkezésről étkezésre.
  ///
  /// In en, this message translates to:
  /// **'Build today one meal at a time.'**
<<<<<<< HEAD
  String get m0202;
=======
  String get m0199;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Erő plusz nap
  ///
  /// In en, this message translates to:
  /// **'Strength Plus Day'**
<<<<<<< HEAD
  String get m0203;
=======
  String get m0200;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Erős nap
  ///
  /// In en, this message translates to:
  /// **'Strong Day'**
<<<<<<< HEAD
  String get m0204;
=======
  String get m0201;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Erősen aktív (heti 6–7x)
  ///
  /// In en, this message translates to:
  /// **'Very active (6-7x/week)'**
<<<<<<< HEAD
  String get m0205;
=======
  String get m0202;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Értem, kezdjük el! →
  ///
  /// In en, this message translates to:
  /// **'Got it, let’s start! →'**
<<<<<<< HEAD
  String get m0206;
=======
  String get m0203;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Étel megosztás
  ///
  /// In en, this message translates to:
  /// **'Food sharing'**
<<<<<<< HEAD
  String get m0207;
=======
  String get m0204;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Étel neve
  ///
  /// In en, this message translates to:
  /// **'Food name'**
<<<<<<< HEAD
  String get m0208;
=======
  String get m0205;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Étel szerkesztése
  ///
  /// In en, this message translates to:
  /// **'Edit food'**
<<<<<<< HEAD
  String get m0209;
=======
  String get m0206;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Ételek
  ///
  /// In en, this message translates to:
  /// **'Meals'**
<<<<<<< HEAD
  String get m0210;
=======
  String get m0207;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: étkezés
  ///
  /// In en, this message translates to:
  /// **'meals'**
<<<<<<< HEAD
  String get m0211;
=======
  String get m0208;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Étrend
  ///
  /// In en, this message translates to:
  /// **'Meal plan'**
<<<<<<< HEAD
  String get m0212;
=======
  String get m0209;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Étrend típus
  ///
  /// In en, this message translates to:
  /// **'Diet type'**
<<<<<<< HEAD
  String get m0213;
=======
  String get m0210;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Étrend típusok
  ///
  /// In en, this message translates to:
  /// **'Meal plan types'**
<<<<<<< HEAD
  String get m0214;
=======
  String get m0211;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: étrendek
  ///
  /// In en, this message translates to:
  /// **'meal plans'**
<<<<<<< HEAD
  String get m0215;
=======
  String get m0212;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Étrendek
  ///
  /// In en, this message translates to:
  /// **'Meal plans'**
<<<<<<< HEAD
  String get m0216;
=======
  String get m0213;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: év
  ///
  /// In en, this message translates to:
  /// **'yrs'**
<<<<<<< HEAD
  String get m0217;
=======
  String get m0214;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Éves csomag −50% kedvezménnyel
  ///
  /// In en, this message translates to:
  /// **'Yearly plan with −50% discount'**
<<<<<<< HEAD
  String get m0218;
=======
  String get m0215;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Éves előfizetés
  ///
  /// In en, this message translates to:
  /// **'Yearly subscription'**
<<<<<<< HEAD
  String get m0219;
=======
  String get m0216;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Extrém aktív
  ///
  /// In en, this message translates to:
  /// **'Extremely active'**
<<<<<<< HEAD
  String get m0220;
=======
  String get m0217;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Ezekből számolja az app a BMI értéket, a napi kalória célt és a profil alapadatait.
  ///
  /// In en, this message translates to:
  /// **'The app uses these to calculate your BMI, daily calorie target, and profile basics.'**
<<<<<<< HEAD
  String get m0221;
=======
  String get m0218;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Fahéj
  ///
  /// In en, this message translates to:
  /// **'Cinnamon'**
<<<<<<< HEAD
  String get m0222;
=======
  String get m0219;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Fehér halfilé
  ///
  /// In en, this message translates to:
  /// **'White fish fillet'**
<<<<<<< HEAD
  String get m0223;
=======
  String get m0220;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Fehérje fókusz nap
  ///
  /// In en, this message translates to:
  /// **'Protein Focus Day'**
<<<<<<< HEAD
  String get m0224;
=======
  String get m0221;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Fehérjepor
  ///
  /// In en, this message translates to:
  /// **'Protein powder'**
<<<<<<< HEAD
  String get m0225;
=======
  String get m0222;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Fehérjés puding
  ///
  /// In en, this message translates to:
  /// **'Protein pudding'**
<<<<<<< HEAD
  String get m0226;
=======
  String get m0223;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Fehérjés puding fél adag gyümölccsel
  ///
  /// In en, this message translates to:
  /// **'Half protein pudding with fruit'**
<<<<<<< HEAD
  String get m0227;
=======
  String get m0224;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Férfi
  ///
  /// In en, this message translates to:
  /// **'Male'**
<<<<<<< HEAD
  String get m0228;
=======
  String get m0225;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Feta sajt
  ///
  /// In en, this message translates to:
  /// **'Feta cheese'**
<<<<<<< HEAD
  String get m0229;
=======
  String get m0226;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Fetás bulgur reggeli tál
  ///
  /// In en, this message translates to:
  /// **'Feta bulgur breakfast bowl'**
<<<<<<< HEAD
  String get m0230;
=======
  String get m0227;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Fetás paradicsomos abonett
  ///
  /// In en, this message translates to:
  /// **'Feta tomato crispbread'**
<<<<<<< HEAD
  String get m0231;
=======
  String get m0228;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Fit lendület nap
  ///
  /// In en, this message translates to:
  /// **'Fit Momentum Day'**
<<<<<<< HEAD
  String get m0232;
=======
  String get m0229;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Fitt nap
  ///
  /// In en, this message translates to:
  /// **'Fit Day'**
<<<<<<< HEAD
  String get m0233;
=======
  String get m0230;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Fix adagméret
  ///
  /// In en, this message translates to:
  /// **'Fixed portion size'**
<<<<<<< HEAD
  String get m0234;
=======
  String get m0231;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Főétel
  ///
  /// In en, this message translates to:
  /// **'Main dish'**
<<<<<<< HEAD
  String get m0235;
=======
  String get m0232;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Főétel adag / doboz
  ///
  /// In en, this message translates to:
  /// **'Main portion / box'**
<<<<<<< HEAD
  String get m0236;
=======
  String get m0233;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Főétel g / adag
  ///
  /// In en, this message translates to:
  /// **'Main g / portion'**
<<<<<<< HEAD
  String get m0237;
=======
  String get m0234;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Főétel mentés
  ///
  /// In en, this message translates to:
  /// **'Main dish saving'**
<<<<<<< HEAD
  String get m0238;
=======
  String get m0235;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Főétel recept szorzó
  ///
  /// In en, this message translates to:
  /// **'Main recipe multiplier'**
<<<<<<< HEAD
  String get m0239;
=======
  String get m0236;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Főételek
  ///
  /// In en, this message translates to:
  /// **'Main dishes'**
<<<<<<< HEAD
  String get m0240;
=======
  String get m0237;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Fogyás statisztika
  ///
  /// In en, this message translates to:
  /// **'Weight loss statistics'**
<<<<<<< HEAD
  String get m0241;
=======
  String get m0238;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Fogyáshoz
  ///
  /// In en, this message translates to:
  /// **'For fat loss'**
<<<<<<< HEAD
  String get m0242;
=======
  String get m0239;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Fogyáshoz:
  ///
  /// In en, this message translates to:
  /// **'For fat loss: '**
<<<<<<< HEAD
  String get m0243;
=======
  String get m0240;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: földimogyoró
  ///
  /// In en, this message translates to:
  /// **'peanut'**
<<<<<<< HEAD
  String get m0244;
=======
  String get m0241;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Forgasd össze a zöldségekkel, tésztával és szójaszósszal.
  ///
  /// In en, this message translates to:
  /// **'Toss with the vegetables, noodles, and soy sauce.'**
<<<<<<< HEAD
  String get m0245;
=======
  String get m0242;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Formázz falatokat és hűtsd 20 percig.
  ///
  /// In en, this message translates to:
  /// **'Shape into bites and chill for 20 minutes.'**
<<<<<<< HEAD
  String get m0246;
=======
  String get m0243;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Főtt lencse
  ///
  /// In en, this message translates to:
  /// **'Cooked lentils'**
<<<<<<< HEAD
  String get m0247;
=======
  String get m0244;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Főtt rizs
  ///
  /// In en, this message translates to:
  /// **'Cooked rice'**
<<<<<<< HEAD
  String get m0248;
=======
  String get m0245;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Főtt tojás avokádóval
  ///
  /// In en, this message translates to:
  /// **'Boiled eggs with avocado'**
<<<<<<< HEAD
  String get m0249;
=======
  String get m0246;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Főzd össze sűrű raguvá.
  ///
  /// In en, this message translates to:
  /// **'Cook into a thick stew.'**
<<<<<<< HEAD
  String get m0250;
=======
  String get m0247;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Főzés során az étel
  ///
  /// In en, this message translates to:
  /// **'During cooking, food '**
<<<<<<< HEAD
  String get m0251;
=======
  String get m0248;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Főzés során az étel tömege
  ///
  /// In en, this message translates to:
  /// **'During cooking, food weight '**
<<<<<<< HEAD
  String get m0252;
=======
  String get m0249;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: főzés után mérd le az egész elkészült ételt, például 760 g.
  ///
  /// In en, this message translates to:
  /// **'after cooking, weigh the finished meal, for example 760 g.'**
<<<<<<< HEAD
  String get m0253;
=======
  String get m0250;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Friss mentes nap
  ///
  /// In en, this message translates to:
  /// **'Fresh Free-From Day'**
<<<<<<< HEAD
  String get m0254;
=======
  String get m0251;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Friss nap
  ///
  /// In en, this message translates to:
  /// **'Fresh Day'**
<<<<<<< HEAD
  String get m0255;
=======
  String get m0252;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Friss zöld nap
  ///
  /// In en, this message translates to:
  /// **'Fresh Green Day'**
<<<<<<< HEAD
  String get m0256;
=======
  String get m0253;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Friss zöldség
  ///
  /// In en, this message translates to:
  /// **'Fresh vegetables'**
<<<<<<< HEAD
  String get m0257;
=======
  String get m0254;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Fuel the morning with intention.
  ///
  /// In en, this message translates to:
  /// **'Fuel the morning with intention.'**
<<<<<<< HEAD
  String get m0258;
=======
  String get m0255;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: FUNKCIÓ
  ///
  /// In en, this message translates to:
  /// **'FEATURE'**
<<<<<<< HEAD
  String get m0259;
=======
  String get m0256;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Füstölt lazac
  ///
  /// In en, this message translates to:
  /// **'Smoked salmon'**
<<<<<<< HEAD
  String get m0260;
=======
  String get m0257;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Fűszerkeverék
  ///
  /// In en, this message translates to:
  /// **'Spice mix'**
<<<<<<< HEAD
  String get m0261;
=======
  String get m0258;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: g / adag
  ///
  /// In en, this message translates to:
  /// **'g / portion'**
<<<<<<< HEAD
  String get m0262;
=======
  String get m0259;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Garnéla
  ///
  /// In en, this message translates to:
  /// **'Shrimp'**
<<<<<<< HEAD
  String get m0263;
=======
  String get m0260;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Garnélás cottage saláta
  ///
  /// In en, this message translates to:
  /// **'Shrimp cottage salad'**
<<<<<<< HEAD
  String get m0264;
=======
  String get m0261;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Garnélás quinoa bowl
  ///
  /// In en, this message translates to:
  /// **'Shrimp quinoa bowl'**
<<<<<<< HEAD
  String get m0265;
=======
  String get m0262;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Garnélás rizstészta wok
  ///
  /// In en, this message translates to:
  /// **'Shrimp rice noodle wok'**
<<<<<<< HEAD
  String get m0266;
=======
  String get m0263;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Give your evening a head start.
  ///
  /// In en, this message translates to:
  /// **'Give your evening a head start.'**
<<<<<<< HEAD
  String get m0267;
=======
  String get m0264;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: glutén
  ///
  /// In en, this message translates to:
  /// **'gluten'**
<<<<<<< HEAD
  String get m0268;
=======
  String get m0265;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Gluténmentes
  ///
  /// In en, this message translates to:
  /// **'Gluten-free'**
<<<<<<< HEAD
  String get m0269;
=======
  String get m0266;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Glutént tartalmazó alapanyagok nélkül
  ///
  /// In en, this message translates to:
  /// **'Without ingredients containing gluten'**
<<<<<<< HEAD
  String get m0270;
=======
  String get m0267;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Good afternoon
  ///
  /// In en, this message translates to:
  /// **'Good afternoon'**
<<<<<<< HEAD
  String get m0271;
=======
  String get m0268;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Good day
  ///
  /// In en, this message translates to:
  /// **'Good day'**
<<<<<<< HEAD
  String get m0272;
=======
  String get m0269;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Good evening
  ///
  /// In en, this message translates to:
  /// **'Good evening'**
<<<<<<< HEAD
  String get m0273;
=======
  String get m0270;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Good morning
  ///
  /// In en, this message translates to:
  /// **'Good morning'**
<<<<<<< HEAD
  String get m0274;
=======
  String get m0271;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Görög csirkés tányér
  ///
  /// In en, this message translates to:
  /// **'Greek chicken plate'**
<<<<<<< HEAD
  String get m0275;
=======
  String get m0272;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Görög joghurt
  ///
  /// In en, this message translates to:
  /// **'Greek yogurt'**
<<<<<<< HEAD
  String get m0276;
=======
  String get m0273;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Görög joghurtos granola pohár
  ///
  /// In en, this message translates to:
  /// **'Greek yogurt granola cup'**
<<<<<<< HEAD
  String get m0277;
=======
  String get m0274;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Görög joghurtos granola pohár gluténmentes granolával
  ///
  /// In en, this message translates to:
  /// **'Greek yogurt granola cup with gluten-free granola'**
<<<<<<< HEAD
  String get m0278;
=======
  String get m0275;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Görög lazacos quinoa tál
  ///
  /// In en, this message translates to:
  /// **'Greek salmon quinoa bowl'**
<<<<<<< HEAD
  String get m0279;
=======
  String get m0276;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Granola
  ///
  /// In en, this message translates to:
  /// **'Granola'**
<<<<<<< HEAD
  String get m0280;
=======
  String get m0277;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Gyors
  ///
  /// In en, this message translates to:
  /// **'Quick'**
<<<<<<< HEAD
  String get m0281;
=======
  String get m0278;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Gyors fókusz nap
  ///
  /// In en, this message translates to:
  /// **'Quick Focus Day'**
<<<<<<< HEAD
  String get m0282;
=======
  String get m0279;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Gyors rutin nap
  ///
  /// In en, this message translates to:
  /// **'Quick Routine Day'**
<<<<<<< HEAD
  String get m0283;
=======
  String get m0280;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: ha a dobozodba 250 g kerül, a Mealr kiszámolja, hogy ez kb. 313 g nyers alapanyagnak felel meg.
  ///
  /// In en, this message translates to:
  /// **'if 250 g goes into your container, Mealr calculates that it equals about 313 g of raw ingredients.'**
<<<<<<< HEAD
  String get m0284;
=======
  String get m0281;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Ha csak rizst, bulgurt vagy tésztát főzöl köretnek, ugyanígy működik: nyers rizs 300 g, kész rizs 820 g, kimért adag 180 g. Az app megadja a nyers rizs egyenértékét.
  ///
  /// In en, this message translates to:
  /// **'If you cook only rice, bulgur, or pasta as a side, it works the same way: raw rice 300 g, cooked rice 820 g, served portion 180 g. The app gives the raw rice equivalent.'**
<<<<<<< HEAD
  String get m0285;
=======
  String get m0282;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Ha enni szeretnél, mérd le a tányérodra kerülő adagot és írd be – megkapod a
  ///
  /// In en, this message translates to:
  /// **'When you want to eat, measure the portion on your plate and enter it - you get the '**
<<<<<<< HEAD
  String get m0286;
=======
  String get m0283;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Ha megfőzted vagy megsütötted az ételt, mérd le az
  ///
  /// In en, this message translates to:
  /// **'After cooking or baking the meal, measure the '**
<<<<<<< HEAD
  String get m0287;
=======
  String get m0284;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Ha sűrűbb állagot szeretnél, adj hozzá jeget vagy kevesebb folyadékot.
  ///
  /// In en, this message translates to:
  /// **'For a thicker texture, add ice or use less liquid.'**
<<<<<<< HEAD
  String get m0288;
=======
  String get m0285;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Hagyd állni 5 percig, hogy a zab felvegye a nedvességet.
  ///
  /// In en, this message translates to:
  /// **'Let it rest for 5 minutes so the oats absorb the moisture.'**
<<<<<<< HEAD
  String get m0289;
=======
  String get m0286;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Hajtsd félbe és frissen tálald.
  ///
  /// In en, this message translates to:
  /// **'Fold in half and serve fresh.'**
<<<<<<< HEAD
  String get m0290;
=======
  String get m0287;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: hal
  ///
  /// In en, this message translates to:
  /// **'fish'**
<<<<<<< HEAD
  String get m0291;
=======
  String get m0288;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Hamarosan
  ///
  /// In en, this message translates to:
  /// **'Soon'**
<<<<<<< HEAD
  String get m0292;
=======
  String get m0289;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Havi előfizetés
  ///
  /// In en, this message translates to:
  /// **'Monthly subscription'**
<<<<<<< HEAD
  String get m0293;
=======
  String get m0290;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Helyezd rá a halfilét, fűszerezd és locsold meg olajjal.
  ///
  /// In en, this message translates to:
  /// **'Place the fish fillet on top, season, and drizzle with oil.'**
<<<<<<< HEAD
  String get m0294;
=======
  String get m0291;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: hét
  ///
  /// In en, this message translates to:
  /// **'week'**
<<<<<<< HEAD
  String get m0295;
=======
  String get m0292;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Heti átlag
  ///
  /// In en, this message translates to:
  /// **'Weekly average'**
<<<<<<< HEAD
  String get m0296;
=======
  String get m0293;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Heti doboz nap
  ///
  /// In en, this message translates to:
  /// **'Weekly Box Day'**
<<<<<<< HEAD
  String get m0297;
=======
  String get m0294;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Heti ritmus nap
  ///
  /// In en, this message translates to:
  /// **'Weekly Rhythm Day'**
<<<<<<< HEAD
  String get m0298;
=======
  String get m0295;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Heti táplálkozási pillanatkép
  ///
  /// In en, this message translates to:
  /// **'Weekly nutrition snapshot'**
<<<<<<< HEAD
  String get m0299;
=======
  String get m0296;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: HOGYAN HASZNÁLD?
  ///
  /// In en, this message translates to:
  /// **'HOW TO USE IT?'**
<<<<<<< HEAD
  String get m0300;
=======
  String get m0297;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Hogyan működik?
  ///
  /// In en, this message translates to:
  /// **'How does it work?'**
<<<<<<< HEAD
  String get m0301;
=======
  String get m0298;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: HOGYAN SEGÍT A MEALR?
  ///
  /// In en, this message translates to:
  /// **'HOW DOES MEALR HELP?'**
<<<<<<< HEAD
  String get m0302;
=======
  String get m0299;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Hozzáadás
  ///
  /// In en, this message translates to:
  /// **'Add'**
<<<<<<< HEAD
  String get m0303;
=======
  String get m0300;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Hozzáadva
  ///
  /// In en, this message translates to:
  /// **'Added'**
<<<<<<< HEAD
  String get m0304;
=======
  String get m0301;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Hozzávaló
  ///
  /// In en, this message translates to:
  /// **'Ingredient'**
<<<<<<< HEAD
  String get m0305;
=======
  String get m0302;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Hozzávalók
  ///
  /// In en, this message translates to:
  /// **'Ingredients'**
<<<<<<< HEAD
  String get m0306;
=======
  String get m0303;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Hummusz
  ///
  /// In en, this message translates to:
  /// **'Hummus'**
<<<<<<< HEAD
  String get m0307;
=======
  String get m0304;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Hummuszos rizsszelet torony
  ///
  /// In en, this message translates to:
  /// **'Hummus rice cake stack'**
<<<<<<< HEAD
  String get m0308;
=======
  String get m0305;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Hummuszos tojásos pita
  ///
  /// In en, this message translates to:
  /// **'Hummus egg pita'**
<<<<<<< HEAD
  String get m0309;
=======
  String get m0306;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Hummuszos zöldségdoboz
  ///
  /// In en, this message translates to:
  /// **'Hummus vegetable box'**
<<<<<<< HEAD
  String get m0310;
=======
  String get m0307;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Húsmentes lendület nap
  ///
  /// In en, this message translates to:
  /// **'Meat-Free Momentum Day'**
<<<<<<< HEAD
  String get m0311;
=======
  String get m0308;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Húsmentes napi étrend
  ///
  /// In en, this message translates to:
  /// **'Meat-free daily plan'**
<<<<<<< HEAD
  String get m0312;
=======
  String get m0309;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Ideális testsúly
  ///
  /// In en, this message translates to:
  /// **'Ideal weight'**
<<<<<<< HEAD
  String get m0313;
=======
  String get m0310;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Így pontosabban tudod vezetni a kalóriákat, és a meal prep adagolás sem lesz találgatás.
  ///
  /// In en, this message translates to:
  /// **'This makes calorie tracking more accurate, and Meal Prep portions stop being guesswork.'**
<<<<<<< HEAD
  String get m0314;
=======
  String get m0311;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Indítsd tudatosan a reggelt.
  ///
  /// In en, this message translates to:
  /// **'Fuel the morning with intention.'**
<<<<<<< HEAD
  String get m0315;
=======
  String get m0312;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Indulhat
  ///
  /// In en, this message translates to:
  /// **'Start'**
<<<<<<< HEAD
  String get m0316;
=======
  String get m0313;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Ingyenes
  ///
  /// In en, this message translates to:
  /// **'Free'**
<<<<<<< HEAD
  String get m0317;
=======
  String get m0314;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Ingyenes alapok
  ///
  /// In en, this message translates to:
  /// **'Free basics'**
<<<<<<< HEAD
  String get m0318;
=======
  String get m0315;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Ingyenes módban 1 meal prep tervet menthetsz. A további tervekhez Pro szükséges.
  ///
  /// In en, this message translates to:
  /// **'Free includes 1 saved Meal Prep plan. Upgrade to save more.'**
<<<<<<< HEAD
  String get m0319;

  /// Source text: Irányadó cél
  ///
  /// In en, this message translates to:
  /// **'Guidance target'**
  String get m0320;
=======
  String get m0316;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Iránymutató – 2–4 hétig kövesd, majd a tényleges változás alapján igazítsd.
  ///
  /// In en, this message translates to:
  /// **'Use as a guide for 2-4 weeks, then adjust based on actual progress.'**
<<<<<<< HEAD
  String get m0321;
=======
  String get m0317;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Írj receptet, tippet vagy emlékeztetőt...
  ///
  /// In en, this message translates to:
  /// **'Write a recipe, tip, or reminder...'**
<<<<<<< HEAD
  String get m0322;
=======
  String get m0318;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Ízlés szerint sózd, borsozd.
  ///
  /// In en, this message translates to:
  /// **'Season with salt and pepper to taste.'**
<<<<<<< HEAD
  String get m0323;
=======
  String get m0319;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Izmos nap
  ///
  /// In en, this message translates to:
  /// **'Muscle Day'**
<<<<<<< HEAD
  String get m0324;
=======
  String get m0320;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Jegyzet
  ///
  /// In en, this message translates to:
  /// **'Note'**
<<<<<<< HEAD
  String get m0325;
=======
  String get m0321;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Jó délutánt
  ///
  /// In en, this message translates to:
  /// **'Good afternoon'**
<<<<<<< HEAD
  String get m0326;
=======
  String get m0322;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Jó estét
  ///
  /// In en, this message translates to:
  /// **'Good evening'**
<<<<<<< HEAD
  String get m0327;
=======
  String get m0323;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Jó reggelt
  ///
  /// In en, this message translates to:
  /// **'Good morning'**
<<<<<<< HEAD
  String get m0328;
=======
  String get m0324;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Joghurt
  ///
  /// In en, this message translates to:
  /// **'Yogurt'**
<<<<<<< HEAD
  String get m0329;
=======
  String get m0325;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Joghurtos öntet
  ///
  /// In en, this message translates to:
  /// **'Yogurt dressing'**
<<<<<<< HEAD
  String get m0330;
=======
  String get m0326;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Joghurtos szósz
  ///
  /// In en, this message translates to:
  /// **'Yogurt sauce'**
<<<<<<< HEAD
  String get m0331;
=======
  String get m0327;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Juharszirup
  ///
  /// In en, this message translates to:
  /// **'Maple syrup'**
<<<<<<< HEAD
  String get m0332;
=======
  String get m0328;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Kakaópor
  ///
  /// In en, this message translates to:
  /// **'Cocoa powder'**
<<<<<<< HEAD
  String get m0333;
=======
  String get m0329;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Kakaós chia zabpohár
  ///
  /// In en, this message translates to:
  /// **'Cocoa chia oat cup'**
<<<<<<< HEAD
  String get m0334;
=======
  String get m0330;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Kakaós skyr ropogóssal
  ///
  /// In en, this message translates to:
  /// **'Cocoa skyr with crunch'**
<<<<<<< HEAD
  String get m0335;
=======
  String get m0331;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Kaliforniai paprika
  ///
  /// In en, this message translates to:
  /// **'Bell pepper'**
<<<<<<< HEAD
  String get m0336;
=======
  String get m0332;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Kalkulátorból beállítva
  ///
  /// In en, this message translates to:
  /// **'Set from calculator'**
<<<<<<< HEAD
  String get m0337;
=======
  String get m0333;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Kalória
  ///
  /// In en, this message translates to:
  /// **'Calories'**
<<<<<<< HEAD
  String get m0338;
=======
  String get m0334;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Kalória
  /// kalkulátor
  ///
  /// In en, this message translates to:
  /// **'Calorie\ncalculator'**
<<<<<<< HEAD
  String get m0339;
=======
  String get m0335;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Kalória cél
  ///
  /// In en, this message translates to:
  /// **'Calorie goal'**
<<<<<<< HEAD
  String get m0340;
=======
  String get m0336;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Kalória kalkulátor
  ///
  /// In en, this message translates to:
  /// **'Calorie calculator'**
<<<<<<< HEAD
  String get m0341;
=======
  String get m0337;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Kanalazd kekszekre, uborkával tálald.
  ///
  /// In en, this message translates to:
  /// **'Spoon onto crackers and serve with cucumber.'**
<<<<<<< HEAD
  String get m0342;
=======
  String get m0338;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Kanalazd mellé a tzatzikit, és tálald a quinoa-zöldség alappal.
  ///
  /// In en, this message translates to:
  /// **'Spoon the tzatziki alongside and serve with the quinoa-vegetable base.'**
<<<<<<< HEAD
  String get m0343;
=======
  String get m0339;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: kcal / nap
  ///
  /// In en, this message translates to:
  /// **'kcal / day'**
<<<<<<< HEAD
  String get m0344;
=======
  String get m0340;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Kedvencek
  ///
  /// In en, this message translates to:
  /// **'Favorites'**
<<<<<<< HEAD
  String get m0345;
=======
  String get m0341;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Keep the afternoon light and useful.
  ///
  /// In en, this message translates to:
  /// **'Keep the afternoon light and useful.'**
<<<<<<< HEAD
  String get m0346;
=======
  String get m0342;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Keep your meals on track.
  ///
  /// In en, this message translates to:
  /// **'Keep your meals on track.'**
<<<<<<< HEAD
  String get m0347;
=======
  String get m0343;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Kend meg krémsajttal, majd tedd rá a lazacot és uborkát.
  ///
  /// In en, this message translates to:
  /// **'Spread with cream cheese, then add salmon and cucumber.'**
<<<<<<< HEAD
  String get m0348;
=======
  String get m0344;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Kend meg vékonyan mogyoróvajjal és szórd meg fahéjjal.
  ///
  /// In en, this message translates to:
  /// **'Spread thinly with peanut butter and sprinkle with cinnamon.'**
<<<<<<< HEAD
  String get m0349;
=======
  String get m0345;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Képlet:
  ///
  /// In en, this message translates to:
  /// **'Formula: '**
<<<<<<< HEAD
  String get m0350;
=======
  String get m0346;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Keresés receptek között
  ///
  /// In en, this message translates to:
  /// **'Search recipes'**
<<<<<<< HEAD
  String get m0351;
=======
  String get m0347;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Kert nap
  ///
  /// In en, this message translates to:
  /// **'Garden Day'**
<<<<<<< HEAD
  String get m0352;
=======
  String get m0348;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Kész doboz nap
  ///
  /// In en, this message translates to:
  /// **'Ready Box Day'**
<<<<<<< HEAD
  String get m0353;
=======
  String get m0349;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Kész étel
  ///
  /// In en, this message translates to:
  /// **'Cooked meal'**
<<<<<<< HEAD
  String get m0354;
=======
  String get m0350;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Kész étel súlya
  ///
  /// In en, this message translates to:
  /// **'Cooked meal weight'**
<<<<<<< HEAD
  String get m0355;
=======
  String get m0351;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Kész g
  ///
  /// In en, this message translates to:
  /// **'Cooked g'**
<<<<<<< HEAD
  String get m0356;
=======
  String get m0352;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Kész súly
  ///
  /// In en, this message translates to:
  /// **'Cooked weight'**
<<<<<<< HEAD
  String get m0357;
=======
  String get m0353;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Készíts lágy rántottát a tojásból.
  ///
  /// In en, this message translates to:
  /// **'Make soft scrambled eggs.'**
<<<<<<< HEAD
  String get m0358;
=======
  String get m0354;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Készítsd elő, ami később könnyít.
  ///
  /// In en, this message translates to:
  /// **'Prep what makes later easier.'**
<<<<<<< HEAD
  String get m0359;
=======
  String get m0355;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Keverd bele a fehérjeport, majd hagyd pár percig sűrűsödni.
  ///
  /// In en, this message translates to:
  /// **'Stir in the protein powder, then let it thicken for a few minutes.'**
<<<<<<< HEAD
  String get m0360;
=======
  String get m0356;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Keverd hozzá a bulgurt és a paradicsompürét, majd főzd össze.
  ///
  /// In en, this message translates to:
  /// **'Stir in the bulgur and tomato paste, then cook together.'**
<<<<<<< HEAD
  String get m0361;
=======
  String get m0357;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Keverd hozzá a juharszirupot, majd hagyd pár percig sűrűsödni.
  ///
  /// In en, this message translates to:
  /// **'Stir in the maple syrup, then let it thicken for a few minutes.'**
<<<<<<< HEAD
  String get m0362;
=======
  String get m0358;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Keverd hozzá a paradicsompürét, és főzd 3-4 percig sűrű raguvá.
  ///
  /// In en, this message translates to:
  /// **'Stir in the tomato paste and cook for 3-4 minutes into a thick stew.'**
<<<<<<< HEAD
  String get m0363;
=======
  String get m0359;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Keverd hozzá a zabot, kakaót és juharszirupot.
  ///
  /// In en, this message translates to:
  /// **'Mix in the oats, cocoa, and maple syrup.'**
<<<<<<< HEAD
  String get m0364;
=======
  String get m0360;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Keverd hozzá a zabot, kakaót és mogyoróvajat.
  ///
  /// In en, this message translates to:
  /// **'Mix in the oats, cocoa, and peanut butter.'**
<<<<<<< HEAD
  String get m0365;
=======
  String get m0361;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Keverd össze a burgonyát a tzatzikivel, majd tálald uborkával és pulykasonkával.
  ///
  /// In en, this message translates to:
  /// **'Mix the potatoes with the tzatziki, then serve with cucumber and turkey ham.'**
<<<<<<< HEAD
  String get m0366;
=======
  String get m0362;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Keverd össze a joghurtot a fehérjeporral.
  ///
  /// In en, this message translates to:
  /// **'Mix the yogurt with the protein powder.'**
<<<<<<< HEAD
  String get m0367;
=======
  String get m0363;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Keverd össze a kifőtt tésztával, és adagold sajttal megszórva.
  ///
  /// In en, this message translates to:
  /// **'Mix with the cooked pasta and portion with grated cheese.'**
<<<<<<< HEAD
  String get m0368;
=======
  String get m0364;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Keverd össze a lencsével és morzsolt fetával.
  ///
  /// In en, this message translates to:
  /// **'Mix with lentils and crumbled feta.'**
<<<<<<< HEAD
  String get m0369;
=======
  String get m0365;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Keverd össze a tonhalat a babbal, burgonyával és joghurtos öntettel.
  ///
  /// In en, this message translates to:
  /// **'Mix the tuna with the beans, potatoes, and yogurt dressing.'**
<<<<<<< HEAD
  String get m0370;
=======
  String get m0366;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Keverd össze a zabot, joghurtot, folyadékot és fahéjat.
  ///
  /// In en, this message translates to:
  /// **'Mix the oats, yogurt, liquid, and cinnamon.'**
<<<<<<< HEAD
  String get m0371;
=======
  String get m0367;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Keverd össze a zabot, tejet vagy növényi italt, chia magot és kakaóport.
  ///
  /// In en, this message translates to:
  /// **'Mix the oats, milk or plant drink, chia seeds, and cocoa powder.'**
<<<<<<< HEAD
  String get m0372;
=======
  String get m0368;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Keverd össze spenóttal és paradicsommal.
  ///
  /// In en, this message translates to:
  /// **'Mix with spinach and tomatoes.'**
<<<<<<< HEAD
  String get m0373;
=======
  String get m0369;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Keverd össze tonhallal, kukoricával és joghurttal.
  ///
  /// In en, this message translates to:
  /// **'Mix with tuna, corn, and yogurt.'**
<<<<<<< HEAD
  String get m0374;
=======
  String get m0370;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Keverd simára a hozzávalókat.
  ///
  /// In en, this message translates to:
  /// **'Mix the ingredients until smooth.'**
<<<<<<< HEAD
  String get m0375;
=======
  String get m0371;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Keverd simára a joghurtot fehérjeporral és kakaóval.
  ///
  /// In en, this message translates to:
  /// **'Mix the yogurt with protein powder and cocoa until smooth.'**
<<<<<<< HEAD
  String get m0376;
=======
  String get m0372;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Keverj mustárt a joghurtos öntetbe, majd locsold a kuszkuszos salátára.
  ///
  /// In en, this message translates to:
  /// **'Mix mustard into the yogurt dressing, then drizzle it over the couscous salad.'**
<<<<<<< HEAD
  String get m0377;
=======
  String get m0373;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Kevés citromlével frissítsd, majd azonnal tálald.
  ///
  /// In en, this message translates to:
  /// **'Freshen with a little lemon juice and serve immediately.'**
<<<<<<< HEAD
  String get m0378;
=======
  String get m0374;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Kevés olajon párold át őket, majd öntsd rá a felvert tojást.
  ///
  /// In en, this message translates to:
  /// **'Soften them in a little oil, then pour over the beaten eggs.'**
<<<<<<< HEAD
  String get m0379;
=======
  String get m0375;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Kevesebb mutatása
  ///
  /// In en, this message translates to:
  /// **'Show less'**
<<<<<<< HEAD
  String get m0380;

  /// Source text: Kezdd az első súlyméréssel.
  ///
  /// In en, this message translates to:
  /// **'Start with your first weight entry.'**
  String get m0381;
=======
  String get m0376;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Kezdés ingyenesen
  ///
  /// In en, this message translates to:
  /// **'Start free'**
<<<<<<< HEAD
  String get m0382;
=======
  String get m0377;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Kezdj egyszerűen, maradj következetes.
  ///
  /// In en, this message translates to:
  /// **'Start simple, stay steady.'**
<<<<<<< HEAD
  String get m0383;
=======
  String get m0378;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Kezdjük egyszerűen.
  ///
  /// In en, this message translates to:
  /// **'Let’s keep it simple.'**
<<<<<<< HEAD
  String get m0384;
=======
  String get m0379;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Kiadós alap nap
  ///
  /// In en, this message translates to:
  /// **'Filling Basics Day'**
<<<<<<< HEAD
  String get m0385;
=======
  String get m0380;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Kihagyás
  ///
  /// In en, this message translates to:
  /// **'Skip'**
<<<<<<< HEAD
  String get m0386;
=======
  String get m0381;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Kímélő nap
  ///
  /// In en, this message translates to:
  /// **'Gentle Day'**
<<<<<<< HEAD
  String get m0387;
=======
  String get m0382;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Kimért adag
  ///
  /// In en, this message translates to:
  /// **'Served amount'**
<<<<<<< HEAD
  String get m0388;
=======
  String get m0383;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Kimért g
  ///
  /// In en, this message translates to:
  /// **'Serving g'**
<<<<<<< HEAD
  String get m0389;
=======
  String get m0384;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Kipipált tételek törlése
  ///
  /// In en, this message translates to:
  /// **'Clear checked items'**
<<<<<<< HEAD
  String get m0390;
=======
  String get m0385;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Kis döntések, stabil lendület.
  ///
  /// In en, this message translates to:
  /// **'Small choices, solid momentum.'**
<<<<<<< HEAD
  String get m0391;
=======
  String get m0386;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Koktélparadicsom
  ///
  /// In en, this message translates to:
  /// **'Cherry tomatoes'**
<<<<<<< HEAD
  String get m0392;
=======
  String get m0387;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Kókusztej
  ///
  /// In en, this message translates to:
  /// **'Coconut milk'**
<<<<<<< HEAD
  String get m0393;
=======
  String get m0388;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Könnyed nap
  ///
  /// In en, this message translates to:
  /// **'Easy Day'**
<<<<<<< HEAD
  String get m0394;
=======
  String get m0389;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Könnyű babos chili
  ///
  /// In en, this message translates to:
  /// **'Light bean chili'**
<<<<<<< HEAD
  String get m0395;
=======
  String get m0390;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Könnyű csirkés saláta
  ///
  /// In en, this message translates to:
  /// **'Light chicken salad'**
<<<<<<< HEAD
  String get m0396;
=======
  String get m0391;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Könnyű nap
  ///
  /// In en, this message translates to:
  /// **'Light Day'**
<<<<<<< HEAD
  String get m0397;
=======
  String get m0392;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Köret
  ///
  /// In en, this message translates to:
  /// **'Side'**
<<<<<<< HEAD
  String get m0398;
=======
  String get m0393;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Köret adag / doboz
  ///
  /// In en, this message translates to:
  /// **'Side portion / box'**
<<<<<<< HEAD
  String get m0399;
=======
  String get m0394;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Köret g / adag
  ///
  /// In en, this message translates to:
  /// **'Side g / portion'**
<<<<<<< HEAD
  String get m0400;
=======
  String get m0395;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Köret hozzáadása
  ///
  /// In en, this message translates to:
  /// **'Add side'**
<<<<<<< HEAD
  String get m0401;
=======
  String get m0396;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Köret külön vezetve
  ///
  /// In en, this message translates to:
  /// **'Tracking sides separately'**
<<<<<<< HEAD
  String get m0402;
=======
  String get m0397;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Köret mentés
  ///
  /// In en, this message translates to:
  /// **'Side saving'**
<<<<<<< HEAD
  String get m0403;
=======
  String get m0398;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Köret nyers egyenértéke
  ///
  /// In en, this message translates to:
  /// **'Side raw equivalent'**
<<<<<<< HEAD
  String get m0404;
=======
  String get m0399;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Köret recept szorzó
  ///
  /// In en, this message translates to:
  /// **'Side recipe multiplier'**
<<<<<<< HEAD
  String get m0405;
=======
  String get m0400;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Köretek
  ///
  /// In en, this message translates to:
  /// **'Sides'**
<<<<<<< HEAD
  String get m0406;
=======
  String get m0401;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Korlátlan
  ///
  /// In en, this message translates to:
  /// **'Unlimited'**
<<<<<<< HEAD
  String get m0407;
=======
  String get m0402;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Korlátlan étel és meal prep mentés
  ///
  /// In en, this message translates to:
  /// **'Unlimited meals and Meal Prep plans'**
<<<<<<< HEAD
  String get m0408;
=======
  String get m0403;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Korlátlan mentés és extra funkciók
  ///
  /// In en, this message translates to:
  /// **'Unlimited saves and premium tools'**
<<<<<<< HEAD
  String get m0409;
=======
  String get m0404;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Közepesen aktív (heti 3–5x)
  ///
  /// In en, this message translates to:
  /// **'Moderately active (3-5x/week)'**
<<<<<<< HEAD
  String get m0410;
=======
  String get m0405;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Krémsajt
  ///
  /// In en, this message translates to:
  /// **'Cream cheese'**
<<<<<<< HEAD
  String get m0411;
=======
  String get m0406;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Kukorica
  ///
  /// In en, this message translates to:
  /// **'Corn'**
<<<<<<< HEAD
  String get m0412;
=======
  String get m0407;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Külön köretnél is ugyanígy működik: ha a nyers alapanyag főzés közben vizet vesz fel, a kész tömeg több lehet, de ettől nem lesz több benne a kalória. A Mealr ilyenkor is a nyers egyenértéket számolja ki.
  ///
  /// In en, this message translates to:
  /// **'It works the same for separate sides: if a raw ingredient absorbs water while cooking, the cooked weight can be higher, but that does not add calories. Mealr still calculates the raw equivalent.'**
<<<<<<< HEAD
  String get m0413;
=======
  String get m0408;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Kuszkusz
  ///
  /// In en, this message translates to:
  /// **'Couscous'**
<<<<<<< HEAD
  String get m0414;
=======
  String get m0409;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Lassíts, egyél jól, pihenj könnyen.
  ///
  /// In en, this message translates to:
  /// **'Slow down, eat well, rest easy.'**
<<<<<<< HEAD
  String get m0415;
=======
  String get m0410;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Lassú tűzön süsd készre, amíg a közepe is megszilárdul.
  ///
  /// In en, this message translates to:
  /// **'Cook on low heat until the center sets.'**
<<<<<<< HEAD
  String get m0416;
=======
  String get m0411;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Laza mentes nap
  ///
  /// In en, this message translates to:
  /// **'Easy Free-From Day'**
<<<<<<< HEAD
  String get m0417;
=======
  String get m0412;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Lazacfilé
  ///
  /// In en, this message translates to:
  /// **'Salmon fillet'**
<<<<<<< HEAD
  String get m0418;
=======
  String get m0413;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Lazacos burgonyás ebéd
  ///
  /// In en, this message translates to:
  /// **'Salmon potato lunch'**
<<<<<<< HEAD
  String get m0419;
=======
  String get m0414;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Lazacos krémsajtos bagel
  ///
  /// In en, this message translates to:
  /// **'Salmon cream cheese bagel'**
<<<<<<< HEAD
  String get m0420;
=======
  String get m0415;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Lazacos spenótos omlett tányér
  ///
  /// In en, this message translates to:
  /// **'Salmon spinach omelette plate'**
<<<<<<< HEAD
  String get m0421;
=======
  String get m0416;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Lazacos uborkás falatok
  ///
  /// In en, this message translates to:
  /// **'Salmon cucumber bites'**
<<<<<<< HEAD
  String get m0422;
=======
  String get m0417;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Lazacos zöldbabos vacsora
  ///
  /// In en, this message translates to:
  /// **'Salmon green bean dinner'**
<<<<<<< HEAD
  String get m0423;
=======
  String get m0418;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Legalacsonyabb
  ///
  /// In en, this message translates to:
  /// **'Lowest'**
<<<<<<< HEAD
  String get m0424;
=======
  String get m0419;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Legyen a délután könnyű és hasznos.
  ///
  /// In en, this message translates to:
  /// **'Keep the afternoon light and useful.'**
<<<<<<< HEAD
  String get m0425;
=======
  String get m0420;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Legyen az első döntés könnyű.
  ///
  /// In en, this message translates to:
  /// **'Make the first choice an easy one.'**
<<<<<<< HEAD
  String get m0426;
=======
  String get m0421;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Legyen egyszerű a következő étkezés.
  ///
  /// In en, this message translates to:
  /// **'Make the next meal easy.'**
<<<<<<< HEAD
  String get m0427;
=======
  String get m0422;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Lejár:
  ///
  /// In en, this message translates to:
  /// **'Expires: '**
<<<<<<< HEAD
  String get m0428;
=======
  String get m0423;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Lencsés feta saláta
  ///
  /// In en, this message translates to:
  /// **'Lentil feta salad'**
<<<<<<< HEAD
  String get m0429;
=======
  String get m0424;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Lencsés zöldséges rizses egytál
  ///
  /// In en, this message translates to:
  /// **'Lentil vegetable rice pot'**
<<<<<<< HEAD
  String get m0430;
=======
  String get m0425;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Light sajt
  ///
  /// In en, this message translates to:
  /// **'Light cheese'**
<<<<<<< HEAD
  String get m0431;
=======
  String get m0426;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Lilahagyma
  ///
  /// In en, this message translates to:
  /// **'Red onion'**
<<<<<<< HEAD
  String get m0432;
=======
  String get m0427;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Lista
  ///
  /// In en, this message translates to:
  /// **'List'**
<<<<<<< HEAD
  String get m0433;
=======
  String get m0428;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Lista neve
  ///
  /// In en, this message translates to:
  /// **'List name'**
<<<<<<< HEAD
  String get m0434;
=======
  String get m0429;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Locsold meg kevés mézzel, majd szórd meg dióval vagy mandulával.
  ///
  /// In en, this message translates to:
  /// **'Drizzle with a little honey, then sprinkle with walnuts or almonds.'**
<<<<<<< HEAD
  String get m0435;
=======
  String get m0430;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Locsold meg kevés mézzel, majd szórd meg mandulával.
  ///
  /// In en, this message translates to:
  /// **'Drizzle with a little honey, then sprinkle with almonds.'**
<<<<<<< HEAD
  String get m0436;
=======
  String get m0431;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Locsold meg olívaolajjal, majd hűtve vagy frissen tálald.
  ///
  /// In en, this message translates to:
  /// **'Drizzle with olive oil and serve chilled or fresh.'**
<<<<<<< HEAD
  String get m0437;
=======
  String get m0432;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Ma
  ///
  /// In en, this message translates to:
  /// **'Today'**
<<<<<<< HEAD
  String get m0438;
=======
  String get m0433;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Magas fehérje
  ///
  /// In en, this message translates to:
  /// **'High protein'**
<<<<<<< HEAD
  String get m0439;
=======
  String get m0434;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Magasság
  ///
  /// In en, this message translates to:
  /// **'Height'**
<<<<<<< HEAD
  String get m0440;
=======
  String get m0435;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Magasság (cm)
  ///
  /// In en, this message translates to:
  /// **'Height (cm)'**
<<<<<<< HEAD
  String get m0441;
=======
  String get m0436;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Make the first choice an easy one.
  ///
  /// In en, this message translates to:
  /// **'Make the first choice an easy one.'**
<<<<<<< HEAD
  String get m0442;
=======
  String get m0437;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Make the next meal easy.
  ///
  /// In en, this message translates to:
  /// **'Make the next meal easy.'**
<<<<<<< HEAD
  String get m0443;
=======
  String get m0438;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Makrók megoszlása
  ///
  /// In en, this message translates to:
  /// **'Macro split'**
<<<<<<< HEAD
  String get m0444;
=======
  String get m0439;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Mandula
  ///
  /// In en, this message translates to:
  /// **'Almonds'**
<<<<<<< HEAD
  String get m0445;
=======
  String get m0440;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Maradj feltöltve és fókuszban.
  ///
  /// In en, this message translates to:
  /// **'Stay fueled and focused.'**
<<<<<<< HEAD
  String get m0446;
=======
  String get m0441;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Marhahúsos bulgur serpenyő
  ///
  /// In en, this message translates to:
  /// **'Beef bulgur skillet'**
<<<<<<< HEAD
  String get m0447;
=======
  String get m0442;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Marhahúsos pita ebéd
  ///
  /// In en, this message translates to:
  /// **'Beef pita lunch'**
<<<<<<< HEAD
  String get m0448;
=======
  String get m0443;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Marhás cukkinis rizs
  ///
  /// In en, this message translates to:
  /// **'Beef zucchini rice'**
<<<<<<< HEAD
  String get m0449;
=======
  String get m0444;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Meal prep alapú
  ///
  /// In en, this message translates to:
  /// **'Meal Prep based'**
<<<<<<< HEAD
  String get m0450;
=======
  String get m0445;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Meal prep terv szerkesztése
  ///
  /// In en, this message translates to:
  /// **'Edit Meal Prep plan'**
<<<<<<< HEAD
  String get m0451;
=======
  String get m0446;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Meal Prep tervező
  ///
  /// In en, this message translates to:
  /// **'Meal Prep planner'**
<<<<<<< HEAD
  String get m0452;
=======
  String get m0447;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Meal Prep+
  ///
  /// In en, this message translates to:
  /// **'Meal Prep+'**
<<<<<<< HEAD
  String get m0453;
=======
  String get m0448;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Meal preppelés
  ///
  /// In en, this message translates to:
  /// **'Meal Prepping'**
<<<<<<< HEAD
  String get m0454;
=======
  String get m0449;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Mealr Pro
  ///
  /// In en, this message translates to:
  /// **'Mealr Pro'**
<<<<<<< HEAD
  String get m0455;
=======
  String get m0450;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Mediterrán pulykás bulgur
  ///
  /// In en, this message translates to:
  /// **'Mediterranean turkey bulgur'**
<<<<<<< HEAD
  String get m0456;
=======
  String get m0451;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Medium
  ///
  /// In en, this message translates to:
  /// **'Medium'**
<<<<<<< HEAD
  String get m0457;
=======
  String get m0452;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Még nincs elmentett bevásárlólistád.
  ///
  /// In en, this message translates to:
  /// **'Shopping lists you create will appear here.'**
<<<<<<< HEAD
  String get m0458;
=======
  String get m0453;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Még nincs elmentett meal prep terved.
  ///
  /// In en, this message translates to:
  /// **'Saved Meal Prep plans will appear here.'**
<<<<<<< HEAD
  String get m0459;
=======
  String get m0454;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Még nincs főétel hozzáadva.
  ///
  /// In en, this message translates to:
  /// **'Your main dishes will appear here.'**
<<<<<<< HEAD
  String get m0460;
=======
  String get m0455;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Még nincs köret hozzáadva.
  ///
  /// In en, this message translates to:
  /// **'Your sides will appear here.'**
<<<<<<< HEAD
  String get m0461;
=======
  String get m0456;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Megjegyzés
  ///
  /// In en, this message translates to:
  /// **'Note'**
<<<<<<< HEAD
  String get m0462;
=======
  String get m0457;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Megjelenés
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
<<<<<<< HEAD
  String get m0463;
=======
  String get m0458;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Megjelenés módja
  ///
  /// In en, this message translates to:
  /// **'Appearance mode'**
<<<<<<< HEAD
  String get m0464;
=======
  String get m0459;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Meglévő listához adás
  ///
  /// In en, this message translates to:
  /// **'Add to existing list'**
<<<<<<< HEAD
  String get m0465;
=======
  String get m0460;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Megosztás
  ///
  /// In en, this message translates to:
  /// **'Share'**
<<<<<<< HEAD
  String get m0466;
=======
  String get m0461;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Mégse
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
<<<<<<< HEAD
  String get m0467;
=======
  String get m0462;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Meleg banános zabfalatok
  ///
  /// In en, this message translates to:
  /// **'Warm banana oat bites'**
<<<<<<< HEAD
  String get m0468;
=======
  String get m0463;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Meleg lencsés feta tányér
  ///
  /// In en, this message translates to:
  /// **'Warm lentil feta plate'**
<<<<<<< HEAD
  String get m0469;
=======
  String get m0464;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Melegítsd át a tortillát, majd tedd rá a sonkát, sajtot és zöldséget.
  ///
  /// In en, this message translates to:
  /// **'Warm the tortilla, then add the ham, cheese, and vegetables.'**
<<<<<<< HEAD
  String get m0470;
=======
  String get m0465;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Mentés
  ///
  /// In en, this message translates to:
  /// **'Save'**
<<<<<<< HEAD
  String get m0471;
=======
  String get m0466;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Mentes lendület nap
  ///
  /// In en, this message translates to:
  /// **'Free-From Momentum Day'**
<<<<<<< HEAD
  String get m0472;
=======
  String get m0467;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Mentés profilba · a Kalória cél frissítése
  ///
  /// In en, this message translates to:
  /// **'Save to profile · update calorie goal'**
<<<<<<< HEAD
  String get m0473;
=======
  String get m0468;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Mentés új listaként
  ///
  /// In en, this message translates to:
  /// **'Save as new list'**
<<<<<<< HEAD
  String get m0474;
=======
  String get m0469;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Mentett étel
  ///
  /// In en, this message translates to:
  /// **'Saved food'**
<<<<<<< HEAD
  String get m0475;
=======
  String get m0470;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Mentve
  ///
  /// In en, this message translates to:
  /// **'Saved'**
<<<<<<< HEAD
  String get m0476;
=======
  String get m0471;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Mentve a profilba · legközelebb automatikusan kitöltve
  ///
  /// In en, this message translates to:
  /// **'Saved to profile · prefilled next time'**
<<<<<<< HEAD
  String get m0477;
=======
  String get m0472;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Mentve a profilba.
  ///
  /// In en, this message translates to:
  /// **'Saved to profile.'**
<<<<<<< HEAD
  String get m0478;
=======
  String get m0473;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: mérd le főzés előtt az alapanyagokat, például csirke + rizs + zöldség összesen 950 g.
  ///
  /// In en, this message translates to:
  /// **'weigh the ingredients before cooking, for example chicken + rice + vegetables totaling 950 g.'**
<<<<<<< HEAD
  String get m0479;

  /// Source text: Mérések
  ///
  /// In en, this message translates to:
  /// **'Entries'**
  String get m0480;
=======
  String get m0474;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Méz
  ///
  /// In en, this message translates to:
  /// **'Honey'**
<<<<<<< HEAD
  String get m0481;
=======
  String get m0475;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: MI A PROBLÉMA?
  ///
  /// In en, this message translates to:
  /// **'WHAT IS THE PROBLEM?'**
<<<<<<< HEAD
  String get m0482;
=======
  String get m0476;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: MIÉRT HASZNOS?
  ///
  /// In en, this message translates to:
  /// **'WHY IS IT USEFUL?'**
<<<<<<< HEAD
  String get m0483;
=======
  String get m0477;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Mind
  ///
  /// In en, this message translates to:
  /// **'All'**
<<<<<<< HEAD
  String get m0484;
=======
  String get m0478;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: MINDEN EGYBEN
  ///
  /// In en, this message translates to:
  /// **'ALL IN ONE'**
<<<<<<< HEAD
  String get m0485;
=======
  String get m0479;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Minden hozzávalót tegyél turmixgépbe.
  ///
  /// In en, this message translates to:
  /// **'Put all ingredients into a blender.'**
<<<<<<< HEAD
  String get m0486;
=======
  String get m0480;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Mini burgonyás tzatziki doboz
  ///
  /// In en, this message translates to:
  /// **'Mini potato tzatziki box'**
<<<<<<< HEAD
  String get m0487;
=======
  String get m0481;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Mini csirkés wrap
  ///
  /// In en, this message translates to:
  /// **'Mini chicken wrap'**
<<<<<<< HEAD
  String get m0488;
=======
  String get m0482;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Mini tortilla
  ///
  /// In en, this message translates to:
  /// **'Mini tortilla'**
<<<<<<< HEAD
  String get m0489;
=======
  String get m0483;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Mogyoróvaj
  ///
  /// In en, this message translates to:
  /// **'Peanut butter'**
<<<<<<< HEAD
  String get m0490;
=======
  String get m0484;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Morzsold rá a fetát, és frissen tálald.
  ///
  /// In en, this message translates to:
  /// **'Crumble the feta on top and serve fresh.'**
<<<<<<< HEAD
  String get m0491;
=======
  String get m0485;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Morzsold rá a fetát, és tálald a zöldséges bulgurral.
  ///
  /// In en, this message translates to:
  /// **'Crumble the feta on top and serve with the vegetable bulgur.'**
<<<<<<< HEAD
  String get m0492;
=======
  String get m0486;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: mustár
  ///
  /// In en, this message translates to:
  /// **'mustard'**
<<<<<<< HEAD
  String get m0493;
=======
  String get m0487;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Mustár
  ///
  /// In en, this message translates to:
  /// **'Mustard'**
<<<<<<< HEAD
  String get m0494;
=======
  String get m0488;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Mustáros sertésszűz burgonyával
  ///
  /// In en, this message translates to:
  /// **'Mustard pork tenderloin with potatoes'**
<<<<<<< HEAD
  String get m0495;
=======
  String get m0489;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: nap
  ///
  /// In en, this message translates to:
  /// **'days'**
<<<<<<< HEAD
  String get m0496;
=======
  String get m0490;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Napi aktivitás
  ///
  /// In en, this message translates to:
  /// **'Daily activity'**
<<<<<<< HEAD
  String get m0497;
=======
  String get m0491;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Napi bontás
  ///
  /// In en, this message translates to:
  /// **'Daily breakdown'**
<<<<<<< HEAD
  String get m0498;
=======
  String get m0492;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: NAPI SZINTENTARTÓ KALÓRIA
  ///
  /// In en, this message translates to:
  /// **'DAILY MAINTENANCE CALORIES'**
<<<<<<< HEAD
  String get m0499;
=======
  String get m0493;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Nasi
  ///
  /// In en, this message translates to:
  /// **'Snack'**
<<<<<<< HEAD
  String get m0500;
=======
  String get m0494;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Nehézség
  ///
  /// In en, this message translates to:
  /// **'Difficulty'**
<<<<<<< HEAD
  String get m0501;
=======
  String get m0495;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Nem
  ///
  /// In en, this message translates to:
  /// **'Gender'**
<<<<<<< HEAD
  String get m0502;
=======
  String get m0496;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: nem a kalóriájából.
  ///
  /// In en, this message translates to:
  /// **'not its calories.'**
<<<<<<< HEAD
  String get m0503;
=======
  String get m0497;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Nem csak mérlegelés: egy app a kajás rutinodhoz.
  ///
  /// In en, this message translates to:
  /// **'Not just weighing: one app for your food routine.'**
<<<<<<< HEAD
  String get m0504;
=======
  String get m0498;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: nem változik a kalóriája.
  ///
  /// In en, this message translates to:
  /// **'does not change its calories.'**
<<<<<<< HEAD
  String get m0505;
=======
  String get m0499;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Nevezd el és add hozzá a tételeket
  ///
  /// In en, this message translates to:
  /// **'Name it and add the items'**
<<<<<<< HEAD
  String get m0506;
=======
  String get m0500;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Névjegy
  ///
  /// In en, this message translates to:
  /// **'About'**
<<<<<<< HEAD
  String get m0507;
=======
  String get m0501;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Nincs aktív előfizetés
  ///
  /// In en, this message translates to:
  /// **'No active subscription'**
<<<<<<< HEAD
  String get m0508;
=======
  String get m0502;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: nincs kiemelt allergén
  ///
  /// In en, this message translates to:
  /// **'no highlighted allergen'**
<<<<<<< HEAD
  String get m0509;
=======
  String get m0503;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Nincs köret
  ///
  /// In en, this message translates to:
  /// **'No side'**
<<<<<<< HEAD
  String get m0510;
=======
  String get m0504;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Nincs mentett étel
  ///
  /// In en, this message translates to:
  /// **'No saved food'**
<<<<<<< HEAD
  String get m0511;
=======
  String get m0505;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Nincs találat.
  ///
  /// In en, this message translates to:
  /// **'No recipes match this search.'**
<<<<<<< HEAD
  String get m0512;
=======
  String get m0506;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Nincs változás a kezdő súlyhoz képest
  ///
  /// In en, this message translates to:
  /// **'No change compared with starting weight'**
<<<<<<< HEAD
  String get m0513;
=======
  String get m0507;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Nő
  ///
  /// In en, this message translates to:
  /// **'Female'**
<<<<<<< HEAD
  String get m0514;
=======
  String get m0508;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Normál
  ///
  /// In en, this message translates to:
  /// **'Normal'**
<<<<<<< HEAD
  String get m0515;
=======
  String get m0509;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Normál receptek
  ///
  /// In en, this message translates to:
  /// **'Normal'**
<<<<<<< HEAD
  String get m0516;
=======
  String get m0510;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Normál súly
  ///
  /// In en, this message translates to:
  /// **'Normal weight'**
<<<<<<< HEAD
  String get m0517;
=======
  String get m0511;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Növényi nap
  ///
  /// In en, this message translates to:
  /// **'Plant Day'**
<<<<<<< HEAD
  String get m0518;
=======
  String get m0512;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Növényi ritmus nap
  ///
  /// In en, this message translates to:
  /// **'Plant Rhythm Day'**
<<<<<<< HEAD
  String get m0519;
=======
  String get m0513;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Nyelv
  ///
  /// In en, this message translates to:
  /// **'Language'**
<<<<<<< HEAD
  String get m0520;
=======
  String get m0514;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Nyelv, téma, mód és verzió
  ///
  /// In en, this message translates to:
  /// **'Language, theme, mode, and version'**
<<<<<<< HEAD
  String get m0521;
=======
  String get m0515;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: nyers ÷ kész × kimért =
  /// nyers egyenérték
  ///
  ///
  /// In en, this message translates to:
  /// **'raw ÷ cooked × served =\nraw equivalent\n'**
<<<<<<< HEAD
  String get m0522;
=======
  String get m0516;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Nyers adag
  ///
  /// In en, this message translates to:
  /// **'Raw amount'**
<<<<<<< HEAD
  String get m0523;
=======
  String get m0517;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Nyers egyenérték
  ///
  /// In en, this message translates to:
  /// **'Raw equivalent'**
<<<<<<< HEAD
  String get m0524;
=======
  String get m0518;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: nyers egyenértéket
  ///
  /// In en, this message translates to:
  /// **'raw equivalent'**
<<<<<<< HEAD
  String get m0525;
=======
  String get m0519;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: nyers egyenértéket.
  ///
  /// In en, this message translates to:
  /// **'raw equivalent.'**
<<<<<<< HEAD
  String get m0526;
=======
  String get m0520;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Nyers g
  ///
  /// In en, this message translates to:
  /// **'Raw g'**
<<<<<<< HEAD
  String get m0527;
=======
  String get m0521;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Nyers súly kalkulátor
  ///
  /// In en, this message translates to:
  /// **'Raw weight calculator'**
<<<<<<< HEAD
  String get m0528;
=======
  String get m0522;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: nyersen
  ///
  /// In en, this message translates to:
  /// **'raw'**
<<<<<<< HEAD
  String get m0529;
=======
  String get m0523;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Nyisd meg újra a bevezetőt
  ///
  /// In en, this message translates to:
  /// **'Open the intro again'**
<<<<<<< HEAD
  String get m0530;
=======
  String get m0524;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Nyugodt energia nap
  ///
  /// In en, this message translates to:
  /// **'Calm Energy Day'**
<<<<<<< HEAD
  String get m0531;
=======
  String get m0525;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Nyugodt, praktikus eszköz a pontosabb étkezési rutinhoz.
  ///
  /// In en, this message translates to:
  /// **'A calm, practical tool for a more accurate eating routine.'**
<<<<<<< HEAD
  String get m0532;
=======
  String get m0526;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Obezitás
  ///
  /// In en, this message translates to:
  /// **'Obesity'**
<<<<<<< HEAD
  String get m0533;
=======
  String get m0527;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Okos kosár nap
  ///
  /// In en, this message translates to:
  /// **'Smart Basket Day'**
<<<<<<< HEAD
  String get m0534;
=======
  String get m0528;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Okos nap
  ///
  /// In en, this message translates to:
  /// **'Smart Day'**
<<<<<<< HEAD
  String get m0535;
=======
  String get m0529;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Olcsó okos nap
  ///
  /// In en, this message translates to:
  /// **'Smart Budget Day'**
<<<<<<< HEAD
  String get m0536;
=======
  String get m0530;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Olívaolaj
  ///
  /// In en, this message translates to:
  /// **'Olive oil'**
<<<<<<< HEAD
  String get m0537;
=======
  String get m0531;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Onboarding újraindítása
  ///
  /// In en, this message translates to:
  /// **'Restart onboarding'**
<<<<<<< HEAD
  String get m0538;
=======
  String get m0532;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Összes
  ///
  /// In en, this message translates to:
  /// **'Total'**
<<<<<<< HEAD
  String get m0539;
=======
  String get m0533;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Összes kalória
  ///
  /// In en, this message translates to:
  /// **'Total calories'**
<<<<<<< HEAD
  String get m0540;
=======
  String get m0534;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: össztömeget
  ///
  /// In en, this message translates to:
  /// **'total weight'**
<<<<<<< HEAD
  String get m0541;
=======
  String get m0535;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Oszd dobozokra a kuszkuszt, csirkét és brokkolit.
  ///
  /// In en, this message translates to:
  /// **'Divide the couscous, chicken, and broccoli into boxes.'**
<<<<<<< HEAD
  String get m0542;
=======
  String get m0536;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Oszd dobozokra a rizst, csirkét és brokkolit.
  ///
  /// In en, this message translates to:
  /// **'Divide the rice, chicken, and broccoli into boxes.'**
<<<<<<< HEAD
  String get m0543;
=======
  String get m0537;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Overnight oats előre bekészítve
  ///
  /// In en, this message translates to:
  /// **'Overnight oats prepped ahead'**
<<<<<<< HEAD
  String get m0544;
=======
  String get m0538;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Paprika
  ///
  /// In en, this message translates to:
  /// **'Pepper'**
<<<<<<< HEAD
  String get m0545;
=======
  String get m0539;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Paradicsom
  ///
  /// In en, this message translates to:
  /// **'Tomato'**
<<<<<<< HEAD
  String get m0546;
=======
  String get m0540;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Paradicsompüré
  ///
  /// In en, this message translates to:
  /// **'Tomato paste'**
<<<<<<< HEAD
  String get m0547;
=======
  String get m0541;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Paradicsomszósszal és sajttal süsd készre.
  ///
  /// In en, this message translates to:
  /// **'Bake with tomato sauce and cheese until done.'**
<<<<<<< HEAD
  String get m0548;
=======
  String get m0542;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Paradicsomszósz
  ///
  /// In en, this message translates to:
  /// **'Tomato sauce'**
<<<<<<< HEAD
  String get m0549;
=======
  String get m0543;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Pénztárca plusz nap
  ///
  /// In en, this message translates to:
  /// **'Wallet Plus Day'**
<<<<<<< HEAD
  String get m0550;
=======
  String get m0544;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Pénztárcabarát
  ///
  /// In en, this message translates to:
  /// **'Budget-friendly'**
<<<<<<< HEAD
  String get m0551;
=======
  String get m0545;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: perc
  ///
  /// In en, this message translates to:
  /// **'min'**
<<<<<<< HEAD
  String get m0552;
=======
  String get m0546;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Pirítsd meg a kenyeret.
  ///
  /// In en, this message translates to:
  /// **'Toast the bread.'**
<<<<<<< HEAD
  String get m0553;
=======
  String get m0547;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Pl. Hétvégi főzés
  ///
  /// In en, this message translates to:
  /// **'E.g. Weekend cooking'**
<<<<<<< HEAD
  String get m0554;
=======
  String get m0548;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Plan a calm, strong day.
  ///
  /// In en, this message translates to:
  /// **'Plan a calm, strong day.'**
<<<<<<< HEAD
  String get m0555;
=======
  String get m0549;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Pörgős nap
  ///
  /// In en, this message translates to:
  /// **'Busy Day'**
<<<<<<< HEAD
  String get m0556;
=======
  String get m0550;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Praktikus nap
  ///
  /// In en, this message translates to:
  /// **'Practical Day'**
<<<<<<< HEAD
  String get m0557;
=======
  String get m0551;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Prep what makes later easier.
  ///
  /// In en, this message translates to:
  /// **'Prep what makes later easier.'**
<<<<<<< HEAD
  String get m0558;
=======
  String get m0552;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Pro
  ///
  /// In en, this message translates to:
  /// **'Pro'**
<<<<<<< HEAD
  String get m0559;
=======
  String get m0553;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Pro mód teszt
  ///
  /// In en, this message translates to:
  /// **'Pro mode test'**
<<<<<<< HEAD
  String get m0560;
=======
  String get m0554;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Pro statisztika
  ///
  /// In en, this message translates to:
  /// **'Pro statistics'**
<<<<<<< HEAD
  String get m0561;
=======
  String get m0555;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Pro-val feloldható extrák
  ///
  /// In en, this message translates to:
  /// **'Unlocked with Pro'**
<<<<<<< HEAD
  String get m0562;
=======
  String get m0556;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Próbáld ki ingyen 7 napig
  ///
  /// In en, this message translates to:
  /// **'Try free for 7 days'**
<<<<<<< HEAD
  String get m0563;
=======
  String get m0557;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Profil
  ///
  /// In en, this message translates to:
  /// **'Profile'**
<<<<<<< HEAD
  String get m0564;
=======
  String get m0558;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Progresszió törlése
  ///
  /// In en, this message translates to:
  /// **'Delete progress'**
<<<<<<< HEAD
  String get m0565;
=======
  String get m0559;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Protein joghurt pohár
  ///
  /// In en, this message translates to:
  /// **'Protein yogurt cup'**
<<<<<<< HEAD
  String get m0566;
=======
  String get m0560;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Protein zabkása bogyós gyümölccsel
  ///
  /// In en, this message translates to:
  /// **'Protein oatmeal with berries'**
<<<<<<< HEAD
  String get m0567;
=======
  String get m0561;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Pulykagolyók cukkinispagettivel
  ///
  /// In en, this message translates to:
  /// **'Turkey meatballs with zucchini noodles'**
<<<<<<< HEAD
  String get m0568;
=======
  String get m0562;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Pulykamell sonka
  ///
  /// In en, this message translates to:
  /// **'Turkey breast ham'**
<<<<<<< HEAD
  String get m0569;
=======
  String get m0563;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Pulykás bolognai tészta
  ///
  /// In en, this message translates to:
  /// **'Turkey bolognese pasta'**
<<<<<<< HEAD
  String get m0570;
=======
  String get m0564;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Pulykás bolognai tészta light adagban
  ///
  /// In en, this message translates to:
  /// **'Turkey bolognese pasta, light portion'**
<<<<<<< HEAD
  String get m0571;
=======
  String get m0565;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Pulykás cottage reggeli doboz
  ///
  /// In en, this message translates to:
  /// **'Turkey cottage breakfast box'**
<<<<<<< HEAD
  String get m0572;
=======
  String get m0566;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Pulykás sajtos tekercsek
  ///
  /// In en, this message translates to:
  /// **'Turkey cheese rolls'**
<<<<<<< HEAD
  String get m0573;
=======
  String get m0567;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Pulykás tojásos wrap
  ///
  /// In en, this message translates to:
  /// **'Turkey egg wrap'**
<<<<<<< HEAD
  String get m0574;
=======
  String get m0568;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Pulykasonka
  ///
  /// In en, this message translates to:
  /// **'Turkey ham'**
<<<<<<< HEAD
  String get m0575;
=======
  String get m0569;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Pulykával töltött cukkini
  ///
  /// In en, this message translates to:
  /// **'Turkey stuffed zucchini'**
<<<<<<< HEAD
  String get m0576;
=======
  String get m0570;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Quinoa
  ///
  /// In en, this message translates to:
  /// **'Quinoa'**
<<<<<<< HEAD
  String get m0577;
=======
  String get m0571;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Quinoás bogyós snack pohár
  ///
  /// In en, this message translates to:
  /// **'Quinoa berry snack cup'**
<<<<<<< HEAD
  String get m0578;
=======
  String get m0572;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Quinoás joghurtos reggeli
  ///
  /// In en, this message translates to:
  /// **'Quinoa yogurt breakfast'**
<<<<<<< HEAD
  String get m0579;
=======
  String get m0573;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: rákfélék
  ///
  /// In en, this message translates to:
  /// **'crustaceans'**
<<<<<<< HEAD
  String get m0580;
=======
  String get m0574;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Recept
  ///
  /// In en, this message translates to:
  /// **'Recipe'**
<<<<<<< HEAD
  String get m0581;
=======
  String get m0575;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Recept szorzó
  ///
  /// In en, this message translates to:
  /// **'Recipe multiplier'**
<<<<<<< HEAD
  String get m0582;
=======
  String get m0576;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Receptek
  ///
  /// In en, this message translates to:
  /// **'Recipes'**
<<<<<<< HEAD
  String get m0583;
=======
  String get m0577;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Reggeli
  ///
  /// In en, this message translates to:
  /// **'Breakfast'**
<<<<<<< HEAD
  String get m0584;
=======
  String get m0578;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Rendezett doboz nap
  ///
  /// In en, this message translates to:
  /// **'Organized Box Day'**
<<<<<<< HEAD
  String get m0585;
=======
  String get m0579;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Rendszer
  ///
  /// In en, this message translates to:
  /// **'System'**
<<<<<<< HEAD
  String get m0586;
=======
  String get m0580;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Rendszeres használathoz
  ///
  /// In en, this message translates to:
  /// **'For everyday prep'**
<<<<<<< HEAD
  String get m0587;
=======
  String get m0581;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Répa
  ///
  /// In en, this message translates to:
  /// **'Carrot'**
<<<<<<< HEAD
  String get m0588;
=======
  String get m0582;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Reszeld vagy kockázd bele az almát.
  ///
  /// In en, this message translates to:
  /// **'Grate or dice the apple into it.'**
<<<<<<< HEAD
  String get m0589;
=======
  String get m0583;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Reszelt sajt
  ///
  /// In en, this message translates to:
  /// **'Grated cheese'**
<<<<<<< HEAD
  String get m0590;
=======
  String get m0584;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Részletek
  ///
  /// In en, this message translates to:
  /// **'Details'**
<<<<<<< HEAD
  String get m0591;
=======
  String get m0585;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Rétegezd rá a granolát és a szeletelt banánt.
  ///
  /// In en, this message translates to:
  /// **'Layer the granola and sliced banana on top.'**
<<<<<<< HEAD
  String get m0592;
=======
  String get m0586;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Rizs
  ///
  /// In en, this message translates to:
  /// **'Rice'**
<<<<<<< HEAD
  String get m0593;
=======
  String get m0587;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Rizsszelet
  ///
  /// In en, this message translates to:
  /// **'Rice cake'**
<<<<<<< HEAD
  String get m0594;
=======
  String get m0588;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Rizsszelet cottage cheese-zel
  ///
  /// In en, this message translates to:
  /// **'Rice cakes with cottage cheese'**
<<<<<<< HEAD
  String get m0595;
=======
  String get m0589;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Rizstészta
  ///
  /// In en, this message translates to:
  /// **'Rice noodles'**
<<<<<<< HEAD
  String get m0596;

  /// Source text: Rögzítés
  ///
  /// In en, this message translates to:
  /// **'Record'**
  String get m0597;
=======
  String get m0590;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Rögzített súlyok
  ///
  /// In en, this message translates to:
  /// **'Recorded weights'**
<<<<<<< HEAD
  String get m0598;

  /// Source text: Rögzíts még egy mérést a trend megjelenítéséhez.
  ///
  /// In en, this message translates to:
  /// **'Add one more entry to see your trend.'**
  String get m0599;
=======
  String get m0591;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Rövid elkészítési idejű ételekkel
  ///
  /// In en, this message translates to:
  /// **'With meals that are quick to prepare'**
<<<<<<< HEAD
  String get m0600;
=======
  String get m0592;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Rövid konyha nap
  ///
  /// In en, this message translates to:
  /// **'Short Kitchen Day'**
<<<<<<< HEAD
  String get m0601;
=======
  String get m0593;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Saláta
  ///
  /// In en, this message translates to:
  /// **'Lettuce'**
<<<<<<< HEAD
  String get m0602;
=======
  String get m0594;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Saláta mix
  ///
  /// In en, this message translates to:
  /// **'Salad mix'**
<<<<<<< HEAD
  String get m0603;
=======
  String get m0595;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Serpenyőben süsd össze sonkával, sajttal és spenóttal.
  ///
  /// In en, this message translates to:
  /// **'Cook in a pan with ham, cheese, and spinach.'**
<<<<<<< HEAD
  String get m0604;
=======
  String get m0596;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Sertésszűz
  ///
  /// In en, this message translates to:
  /// **'Pork tenderloin'**
<<<<<<< HEAD
  String get m0605;
=======
  String get m0597;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Sertésszűz kuszkusszal
  ///
  /// In en, this message translates to:
  /// **'Pork tenderloin with couscous'**
<<<<<<< HEAD
  String get m0606;
=======
  String get m0598;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Sertésszűz kuszkusz salátával
  ///
  /// In en, this message translates to:
  /// **'Pork tenderloin with couscous salad'**
<<<<<<< HEAD
  String get m0607;
=======
  String get m0599;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Set up dinner before the rush.
  ///
  /// In en, this message translates to:
  /// **'Set up dinner before the rush.'**
<<<<<<< HEAD
  String get m0608;
=======
  String get m0600;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Shakshuka reggeli tál
  ///
  /// In en, this message translates to:
  /// **'Shakshuka breakfast bowl'**
<<<<<<< HEAD
  String get m0609;
=======
  String get m0601;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Sietős lendület nap
  ///
  /// In en, this message translates to:
  /// **'Busy Momentum Day'**
<<<<<<< HEAD
  String get m0610;
=======
  String get m0602;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Sietős nap
  ///
  /// In en, this message translates to:
  /// **'Fast Day'**
<<<<<<< HEAD
  String get m0611;
=======
  String get m0603;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Skyr vagy görög joghurt
  ///
  /// In en, this message translates to:
  /// **'Skyr or Greek yogurt'**
<<<<<<< HEAD
  String get m0612;
=======
  String get m0604;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Slow down, eat well, rest easy.
  ///
  /// In en, this message translates to:
  /// **'Slow down, eat well, rest easy.'**
<<<<<<< HEAD
  String get m0613;
=======
  String get m0605;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Small choices, solid momentum.
  ///
  /// In en, this message translates to:
  /// **'Small choices, solid momentum.'**
<<<<<<< HEAD
  String get m0614;
=======
  String get m0606;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Só, bors
  ///
  /// In en, this message translates to:
  /// **'Salt, pepper'**
<<<<<<< HEAD
  String get m0615;
=======
  String get m0607;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Sonkás sajtos omlett
  ///
  /// In en, this message translates to:
  /// **'Ham and cheese omelette'**
<<<<<<< HEAD
  String get m0616;
=======
  String get m0608;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Sonkás tojásos abonett tál
  ///
  /// In en, this message translates to:
  /// **'Ham egg crispbread plate'**
<<<<<<< HEAD
  String get m0617;
=======
  String get m0609;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Sós cottage cheese tál
  ///
  /// In en, this message translates to:
  /// **'Savory cottage cheese bowl'**
<<<<<<< HEAD
  String get m0618;
=======
  String get m0610;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Sötét
  ///
  /// In en, this message translates to:
  /// **'Dark'**
<<<<<<< HEAD
  String get m0619;
=======
  String get m0611;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Sötét mód
  ///
  /// In en, this message translates to:
  /// **'Dark mode'**
<<<<<<< HEAD
  String get m0620;
=======
  String get m0612;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Sovány
  ///
  /// In en, this message translates to:
  /// **'Underweight'**
<<<<<<< HEAD
  String get m0621;
=======
  String get m0613;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Sovány marhahús
  ///
  /// In en, this message translates to:
  /// **'Lean beef'**
<<<<<<< HEAD
  String get m0622;
=======
  String get m0614;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Spenót
  ///
  /// In en, this message translates to:
  /// **'Spinach'**
<<<<<<< HEAD
  String get m0623;
=======
  String get m0615;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Spenótos kókuszos csicseriborsó
  ///
  /// In en, this message translates to:
  /// **'Spinach coconut chickpeas'**
<<<<<<< HEAD
  String get m0624;
=======
  String get m0616;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Spinach
  ///
  /// In en, this message translates to:
  /// **'Spinach'**
<<<<<<< HEAD
  String get m0625;
=======
  String get m0617;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Sportos nap
  ///
  /// In en, this message translates to:
  /// **'Sporty Day'**
<<<<<<< HEAD
  String get m0626;
=======
  String get m0618;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Stabil erő nap
  ///
  /// In en, this message translates to:
  /// **'Steady Strength Day'**
<<<<<<< HEAD
  String get m0627;

  /// Source text: Stabil ezen az időszakon
  ///
  /// In en, this message translates to:
  /// **'Stable in this period'**
  String get m0628;
=======
  String get m0619;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Stagnál
  ///
  /// In en, this message translates to:
  /// **'Stable'**
<<<<<<< HEAD
  String get m0629;
=======
  String get m0620;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Start simple, stay steady.
  ///
  /// In en, this message translates to:
  /// **'Start simple, stay steady.'**
<<<<<<< HEAD
  String get m0630;
=======
  String get m0621;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Stay fueled and focused.
  ///
  /// In en, this message translates to:
  /// **'Stay fueled and focused.'**
<<<<<<< HEAD
  String get m0631;
=======
  String get m0622;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Sült csirkemell
  ///
  /// In en, this message translates to:
  /// **'Roasted chicken breast'**
<<<<<<< HEAD
  String get m0632;
=======
  String get m0623;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Sült hal zöldségágyon
  ///
  /// In en, this message translates to:
  /// **'Baked fish on vegetables'**
<<<<<<< HEAD
  String get m0633;
=======
  String get m0624;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Súly
  ///
  /// In en, this message translates to:
  /// **'Weight'**
<<<<<<< HEAD
  String get m0634;
=======
  String get m0625;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Súly (kg)
  ///
  /// In en, this message translates to:
  /// **'Weight (kg)'**
<<<<<<< HEAD
  String get m0635;
=======
  String get m0626;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Súly követés
  ///
  /// In en, this message translates to:
  /// **'Weight tracking'**
<<<<<<< HEAD
  String get m0636;
=======
  String get m0627;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Súly progresszió
  ///
  /// In en, this message translates to:
  /// **'Weight progress'**
<<<<<<< HEAD
  String get m0637;
=======
  String get m0628;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Súly szerkesztése
  ///
  /// In en, this message translates to:
  /// **'Edit weight'**
<<<<<<< HEAD
  String get m0638;
=======
  String get m0629;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Súlykövetés
  ///
  /// In en, this message translates to:
  /// **'Weight tracking'**
<<<<<<< HEAD
  String get m0639;
=======
  String get m0630;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Súlykövetés diagram
  ///
  /// In en, this message translates to:
  /// **'Weight tracking chart'**
<<<<<<< HEAD
  String get m0640;
=======
  String get m0631;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Súlynapló szerkesztés
  ///
  /// In en, this message translates to:
  /// **'Weight log editing'**
<<<<<<< HEAD
  String get m0641;
=======
  String get m0632;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Süsd készre, amíg a hal omlós lesz.
  ///
  /// In en, this message translates to:
  /// **'Bake until the fish is tender and flaky.'**
<<<<<<< HEAD
  String get m0642;
=======
  String get m0633;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Süsd vagy párold készre paradicsomszószban.
  ///
  /// In en, this message translates to:
  /// **'Bake or simmer in tomato sauce until done.'**
<<<<<<< HEAD
  String get m0643;
=======
  String get m0634;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Sütőpor
  ///
  /// In en, this message translates to:
  /// **'Baking powder'**
<<<<<<< HEAD
  String get m0644;
=======
  String get m0635;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Számold ki a napi szintentartó kalóriádat életkor, súly, magasság és aktivitás alapján.
  ///
  /// In en, this message translates to:
  /// **'Calculate your daily maintenance calories from age, weight, height, and activity.'**
<<<<<<< HEAD
  String get m0645;
=======
  String get m0636;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Személyes adatok
  ///
  /// In en, this message translates to:
  /// **'Personal data'**
<<<<<<< HEAD
  String get m0646;
=======
  String get m0637;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: SZEMÉLYES ALAPOK
  ///
  /// In en, this message translates to:
  /// **'PERSONAL BASICS'**
<<<<<<< HEAD
  String get m0647;
=======
  String get m0638;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Szép napot
  ///
  /// In en, this message translates to:
  /// **'Good day'**
<<<<<<< HEAD
  String get m0648;
=======
  String get m0639;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Szerkesztés
  ///
  /// In en, this message translates to:
  /// **'Edit'**
<<<<<<< HEAD
  String get m0649;
=======
  String get m0640;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: szezám
  ///
  /// In en, this message translates to:
  /// **'sesame'**
<<<<<<< HEAD
  String get m0650;
=======
  String get m0641;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Szezámmag
  ///
  /// In en, this message translates to:
  /// **'Sesame seeds'**
<<<<<<< HEAD
  String get m0651;
=======
  String get m0642;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: szója
  ///
  /// In en, this message translates to:
  /// **'soy'**
<<<<<<< HEAD
  String get m0652;
=======
  String get m0643;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Szójagranulátum
  ///
  /// In en, this message translates to:
  /// **'Soy granules'**
<<<<<<< HEAD
  String get m0653;
=======
  String get m0644;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Szójaszósszal ízesítsd, majd süsd össze.
  ///
  /// In en, this message translates to:
  /// **'Season with soy sauce, then cook together.'**
<<<<<<< HEAD
  String get m0654;
=======
  String get m0645;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Szójaszósz
  ///
  /// In en, this message translates to:
  /// **'Soy sauce'**
<<<<<<< HEAD
  String get m0655;
=======
  String get m0646;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Szórd meg tökmaggal, majd ízlés szerint sózd, borsozd.
  ///
  /// In en, this message translates to:
  /// **'Sprinkle with pumpkin seeds, then season to taste.'**
<<<<<<< HEAD
  String get m0656;
=======
  String get m0647;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Szükséges kész étel
  ///
  /// In en, this message translates to:
  /// **'Cooked food needed'**
<<<<<<< HEAD
  String get m0657;
=======
  String get m0648;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Szükséges kész főétel
  ///
  /// In en, this message translates to:
  /// **'Cooked main needed'**
<<<<<<< HEAD
  String get m0658;
=======
  String get m0649;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Szükséges kész köret
  ///
  /// In en, this message translates to:
  /// **'Cooked side needed'**
<<<<<<< HEAD
  String get m0659;
=======
  String get m0650;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Szükséges nyers alapanyag
  ///
  /// In en, this message translates to:
  /// **'Raw ingredients needed'**
<<<<<<< HEAD
  String get m0660;
=======
  String get m0651;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Szükséges nyers főétel
  ///
  /// In en, this message translates to:
  /// **'Raw main needed'**
<<<<<<< HEAD
  String get m0661;
=======
  String get m0652;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Szükséges nyers köret
  ///
  /// In en, this message translates to:
  /// **'Raw side needed'**
<<<<<<< HEAD
  String get m0662;
=======
  String get m0653;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Takarékos nap
  ///
  /// In en, this message translates to:
  /// **'Saver Day'**
<<<<<<< HEAD
  String get m0663;
=======
  String get m0654;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Tálald a curry alapot rizzsel.
  ///
  /// In en, this message translates to:
  /// **'Serve the curry base with rice.'**
<<<<<<< HEAD
  String get m0664;
=======
  String get m0655;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Tálald bogyós gyümölccsel és chia maggal.
  ///
  /// In en, this message translates to:
  /// **'Serve with berries and chia seeds.'**
<<<<<<< HEAD
  String get m0665;
=======
  String get m0656;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Tálald bogyós gyümölccsel.
  ///
  /// In en, this message translates to:
  /// **'Serve with berries.'**
<<<<<<< HEAD
  String get m0666;
=======
  String get m0657;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Tálald cottage cheese-zel, abonettel és tökmaggal.
  ///
  /// In en, this message translates to:
  /// **'Serve with cottage cheese, crispbread, and pumpkin seeds.'**
<<<<<<< HEAD
  String get m0667;
=======
  String get m0658;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Tálald fetával és tzatzikivel.
  ///
  /// In en, this message translates to:
  /// **'Serve with feta and tzatziki.'**
<<<<<<< HEAD
  String get m0668;
=======
  String get m0659;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Tálald gyümölccsel.
  ///
  /// In en, this message translates to:
  /// **'Serve with fruit.'**
<<<<<<< HEAD
  String get m0669;
=======
  String get m0660;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Tálald pitával, salátával és joghurtos szósszal.
  ///
  /// In en, this message translates to:
  /// **'Serve with pita, salad, and yogurt sauce.'**
<<<<<<< HEAD
  String get m0670;
=======
  String get m0661;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Tálald salátával és joghurtos öntettel.
  ///
  /// In en, this message translates to:
  /// **'Serve with salad and yogurt dressing.'**
<<<<<<< HEAD
  String get m0671;
=======
  String get m0662;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Tálald zöldbabbal és kevés mustáros szósszal.
  ///
  /// In en, this message translates to:
  /// **'Serve with green beans and a little mustard sauce.'**
<<<<<<< HEAD
  String get m0672;
=======
  String get m0663;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Tapadásmentes serpenyőben süsd ki kisebb palacsintáknak.
  ///
  /// In en, this message translates to:
  /// **'Cook small pancakes in a non-stick pan.'**
<<<<<<< HEAD
  String get m0673;
=======
  String get m0664;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Tartsd kézben az étkezéseidet.
  ///
  /// In en, this message translates to:
  /// **'Keep your meals on track.'**
<<<<<<< HEAD
  String get m0674;
=======
  String get m0665;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Te adod meg, hány gramm kerüljön egy adagba.
  ///
  /// In en, this message translates to:
  /// **'You set how many grams go into each portion.'**
<<<<<<< HEAD
  String get m0675;
=======
  String get m0666;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Tedd dobozba hummusszal együtt.
  ///
  /// In en, this message translates to:
  /// **'Pack them into a box with hummus.'**
<<<<<<< HEAD
  String get m0676;
=======
  String get m0667;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Tedd hűtőbe éjszakára, reggel keverd át és fogyaszd.
  ///
  /// In en, this message translates to:
  /// **'Refrigerate overnight, then stir and eat in the morning.'**
<<<<<<< HEAD
  String get m0677;
=======
  String get m0668;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Tedd rá a csirkét és az öntetet.
  ///
  /// In en, this message translates to:
  /// **'Add the chicken and dressing on top.'**
<<<<<<< HEAD
  String get m0678;
=======
  String get m0669;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Tedd rá a gyümölcsöt, mézet és diót.
  ///
  /// In en, this message translates to:
  /// **'Top with fruit, honey, and walnuts.'**
<<<<<<< HEAD
  String get m0679;
=======
  String get m0670;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Tedd rá a paradicsomot és szórd meg tökmaggal.
  ///
  /// In en, this message translates to:
  /// **'Add the tomato and sprinkle with pumpkin seeds.'**
<<<<<<< HEAD
  String get m0680;
=======
  String get m0671;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Tedd rá a tojást és frissen tálald.
  ///
  /// In en, this message translates to:
  /// **'Top with the egg and serve fresh.'**
<<<<<<< HEAD
  String get m0681;
=======
  String get m0672;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Tedd rá az epret és a mandulát.
  ///
  /// In en, this message translates to:
  /// **'Top with strawberries and almonds.'**
<<<<<<< HEAD
  String get m0682;
=======
  String get m0673;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Tegnap
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
<<<<<<< HEAD
  String get m0683;
=======
  String get m0674;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Tej
  ///
  /// In en, this message translates to:
  /// **'Milk'**
<<<<<<< HEAD
  String get m0684;
=======
  String get m0675;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Tej vagy növényi ital
  ///
  /// In en, this message translates to:
  /// **'Milk or plant drink'**
<<<<<<< HEAD
  String get m0685;
=======
  String get m0676;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: tejfehérje
  ///
  /// In en, this message translates to:
  /// **'milk protein'**
<<<<<<< HEAD
  String get m0686;
=======
  String get m0677;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Tekerd fel és vágd félbe.
  ///
  /// In en, this message translates to:
  /// **'Roll it up and cut in half.'**
<<<<<<< HEAD
  String get m0687;
=======
  String get m0678;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Teljes kiőrlésű abonett
  ///
  /// In en, this message translates to:
  /// **'Wholegrain crispbread'**
<<<<<<< HEAD
  String get m0688;
=======
  String get m0679;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Teljes kiőrlésű keksz
  ///
  /// In en, this message translates to:
  /// **'Wholegrain crackers'**
<<<<<<< HEAD
  String get m0689;
=======
  String get m0680;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Teljes kiőrlésű kenyér
  ///
  /// In en, this message translates to:
  /// **'Wholegrain bread'**
<<<<<<< HEAD
  String get m0690;
=======
  String get m0681;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Teljes kiőrlésű pita
  ///
  /// In en, this message translates to:
  /// **'Wholegrain pita'**
<<<<<<< HEAD
  String get m0691;
=======
  String get m0682;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Teljes kiőrlésű tészta
  ///
  /// In en, this message translates to:
  /// **'Wholegrain pasta'**
<<<<<<< HEAD
  String get m0692;
=======
  String get m0683;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Teljes kiőrlésű tortilla
  ///
  /// In en, this message translates to:
  /// **'Wholegrain tortilla'**
<<<<<<< HEAD
  String get m0693;
=======
  String get m0684;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Teljes mennyiség elosztása
  ///
  /// In en, this message translates to:
  /// **'Split total amount'**
<<<<<<< HEAD
  String get m0694;
=======
  String get m0685;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Teljesítmény nap
  ///
  /// In en, this message translates to:
  /// **'Performance Day'**
<<<<<<< HEAD
  String get m0695;
=======
  String get m0686;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Téma
  ///
  /// In en, this message translates to:
  /// **'Theme'**
<<<<<<< HEAD
  String get m0696;
=======
  String get m0687;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Téma választása
  ///
  /// In en, this message translates to:
  /// **'Choose theme'**
<<<<<<< HEAD
  String get m0697;
=======
  String get m0688;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Témák (6 db)
  ///
  /// In en, this message translates to:
  /// **'Themes (6)'**
<<<<<<< HEAD
  String get m0698;
=======
  String get m0689;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Tempós nap
  ///
  /// In en, this message translates to:
  /// **'Quick Day'**
<<<<<<< HEAD
  String get m0699;
=======
  String get m0690;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Tempós tál nap
  ///
  /// In en, this message translates to:
  /// **'Fast Bowl Day'**
<<<<<<< HEAD
  String get m0700;
=======
  String get m0691;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Terv neve
  ///
  /// In en, this message translates to:
  /// **'Plan name'**
<<<<<<< HEAD
  String get m0701;
=======
  String get m0692;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Tervezd meg a vacsorát még a rohanás előtt.
  ///
  /// In en, this message translates to:
  /// **'Set up dinner before the rush.'**
<<<<<<< HEAD
  String get m0702;
=======
  String get m0693;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Tervezett nap
  ///
  /// In en, this message translates to:
  /// **'Planned Day'**
<<<<<<< HEAD
  String get m0703;
=======
  String get m0694;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Tervezz egy nyugodt, erős napot.
  ///
  /// In en, this message translates to:
  /// **'Plan a calm, strong day.'**
<<<<<<< HEAD
  String get m0704;
=======
  String get m0695;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Tervezz, főzz, kövess okosabban
  ///
  /// In en, this message translates to:
  /// **'Plan, cook, track smarter'**
<<<<<<< HEAD
  String get m0705;
=======
  String get m0696;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: TESTTÖMEG INDEX (BMI)
  ///
  /// In en, this message translates to:
  /// **'BODY MASS INDEX (BMI)'**
<<<<<<< HEAD
  String get m0706;
=======
  String get m0697;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Tészta
  ///
  /// In en, this message translates to:
  /// **'Pasta'**
<<<<<<< HEAD
  String get m0707;
=======
  String get m0698;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: tétel
  ///
  /// In en, this message translates to:
  /// **'items'**
<<<<<<< HEAD
  String get m0708;
=======
  String get m0699;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Tétel hozzáadása
  ///
  /// In en, this message translates to:
  /// **'Add item'**
<<<<<<< HEAD
  String get m0709;
=======
  String get m0700;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: téves értéket kapsz.
  ///
  /// In en, this message translates to:
  /// **'you get an incorrect value.'**
<<<<<<< HEAD
  String get m0710;
=======
  String get m0701;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Tiszta energia nap
  ///
  /// In en, this message translates to:
  /// **'Clean Energy Day'**
<<<<<<< HEAD
  String get m0711;
=======
  String get m0702;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Tiszta nap
  ///
  /// In en, this message translates to:
  /// **'Clean Day'**
<<<<<<< HEAD
  String get m0712;
=======
  String get m0703;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Tiszta ritmus nap
  ///
  /// In en, this message translates to:
  /// **'Clean Rhythm Day'**
<<<<<<< HEAD
  String get m0713;
=======
  String get m0704;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Toast
  ///
  /// In en, this message translates to:
  /// **'Toast'**
<<<<<<< HEAD
  String get m0714;
=======
  String get m0705;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Több mentés, bevásárlólisták, súlykövetés extrák
  ///
  /// In en, this message translates to:
  /// **'Unlimited meals, Shopping+, themes, and tracking'**
<<<<<<< HEAD
  String get m0715;
=======
  String get m0706;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Tofu
  ///
  /// In en, this message translates to:
  /// **'Tofu'**
<<<<<<< HEAD
  String get m0716;
=======
  String get m0707;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Tofus csicseriborsó curry
  ///
  /// In en, this message translates to:
  /// **'Tofu chickpea curry'**
<<<<<<< HEAD
  String get m0717;
=======
  String get m0708;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Tofus quinoás vacsoratál
  ///
  /// In en, this message translates to:
  /// **'Tofu quinoa dinner bowl'**
<<<<<<< HEAD
  String get m0718;
=======
  String get m0709;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Tofus zöldséges noodle box
  ///
  /// In en, this message translates to:
  /// **'Tofu vegetable noodle box'**
<<<<<<< HEAD
  String get m0719;
=======
  String get m0710;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: tojás
  ///
  /// In en, this message translates to:
  /// **'egg'**
<<<<<<< HEAD
  String get m0720;
=======
  String get m0711;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Tojás
  ///
  /// In en, this message translates to:
  /// **'Egg'**
<<<<<<< HEAD
  String get m0721;
=======
  String get m0712;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Tojásos avokádós pirítós
  ///
  /// In en, this message translates to:
  /// **'Egg avocado toast'**
<<<<<<< HEAD
  String get m0722;
=======
  String get m0713;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Tojásos rizses reggeli serpenyő
  ///
  /// In en, this message translates to:
  /// **'Egg rice breakfast skillet'**
<<<<<<< HEAD
  String get m0723;
=======
  String get m0714;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Tojásos zöldséges rizs
  ///
  /// In en, this message translates to:
  /// **'Egg vegetable rice'**
<<<<<<< HEAD
  String get m0724;
=======
  String get m0715;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Tökmag
  ///
  /// In en, this message translates to:
  /// **'Pumpkin seeds'**
<<<<<<< HEAD
  String get m0725;
=======
  String get m0716;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Töltött paprika light módra
  ///
  /// In en, this message translates to:
  /// **'Light stuffed peppers'**
<<<<<<< HEAD
  String get m0726;
=======
  String get m0717;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Töltsd meg csirkével és salátával.
  ///
  /// In en, this message translates to:
  /// **'Fill with chicken and lettuce.'**
<<<<<<< HEAD
  String get m0727;
=======
  String get m0718;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Töltsd meg húsos-rizses keverékkel.
  ///
  /// In en, this message translates to:
  /// **'Fill with the meat and rice mixture.'**
<<<<<<< HEAD
  String get m0728;
=======
  String get m0719;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Töltsd meg pulykás-babos keverékkel.
  ///
  /// In en, this message translates to:
  /// **'Fill with the turkey and bean mixture.'**
<<<<<<< HEAD
  String get m0729;
=======
  String get m0720;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Tömegnövelés
  ///
  /// In en, this message translates to:
  /// **'For gaining'**
<<<<<<< HEAD
  String get m0730;
=======
  String get m0721;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Tömegnöveléshez:
  ///
  /// In en, this message translates to:
  /// **'For gaining: '**
<<<<<<< HEAD
  String get m0731;
=======
  String get m0722;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Tomorrow starts with tonight’s prep.
  ///
  /// In en, this message translates to:
  /// **'Tomorrow starts with tonight’s prep.'**
<<<<<<< HEAD
  String get m0732;
=======
  String get m0723;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Tonhal
  ///
  /// In en, this message translates to:
  /// **'Tuna'**
<<<<<<< HEAD
  String get m0733;
=======
  String get m0724;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Tonhalas babos burgonyasaláta
  ///
  /// In en, this message translates to:
  /// **'Tuna bean potato salad'**
<<<<<<< HEAD
  String get m0734;
=======
  String get m0725;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Tonhalas kukoricás tésztasaláta
  ///
  /// In en, this message translates to:
  /// **'Tuna corn pasta salad'**
<<<<<<< HEAD
  String get m0735;
=======
  String get m0726;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Tonhalas reggeli pirítós
  ///
  /// In en, this message translates to:
  /// **'Tuna breakfast toast'**
<<<<<<< HEAD
  String get m0736;
=======
  String get m0727;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Tonhalas ropogós falatok
  ///
  /// In en, this message translates to:
  /// **'Crunchy tuna bites'**
<<<<<<< HEAD
  String get m0737;
=======
  String get m0728;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Törlés
  ///
  /// In en, this message translates to:
  /// **'Delete'**
<<<<<<< HEAD
  String get m0738;
=======
  String get m0729;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Tovább
  ///
  /// In en, this message translates to:
  /// **'Next'**
<<<<<<< HEAD
  String get m0739;
=======
  String get m0730;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: További rögzítések
  ///
  /// In en, this message translates to:
  /// **'Show more records'**
<<<<<<< HEAD
  String get m0740;
=======
  String get m0731;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Trend
  ///
  /// In en, this message translates to:
  /// **'Trend'**
<<<<<<< HEAD
  String get m0741;
=======
  String get m0732;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Túlsúly
  ///
  /// In en, this message translates to:
  /// **'Overweight'**
<<<<<<< HEAD
  String get m0742;
=======
  String get m0733;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Túlsúlyos
  ///
  /// In en, this message translates to:
  /// **'Overweight'**
<<<<<<< HEAD
  String get m0743;
=======
  String get m0734;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Turmixold krémesre 30-60 másodperc alatt.
  ///
  /// In en, this message translates to:
  /// **'Blend until creamy for 30-60 seconds.'**
<<<<<<< HEAD
  String get m0744;
=======
  String get m0735;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Túró
  ///
  /// In en, this message translates to:
  /// **'Curd cheese'**
<<<<<<< HEAD
  String get m0745;
=======
  String get m0736;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Túrós bogyós tál
  ///
  /// In en, this message translates to:
  /// **'Cottage cheese berry bowl'**
<<<<<<< HEAD
  String get m0746;
=======
  String get m0737;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Túrós zabpalacsinta
  ///
  /// In en, this message translates to:
  /// **'Cottage cheese oat pancakes'**
<<<<<<< HEAD
  String get m0747;
=======
  String get m0738;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Túrós zabpalacsinta előre sütve
  ///
  /// In en, this message translates to:
  /// **'Cottage cheese oat pancakes cooked ahead'**
<<<<<<< HEAD
  String get m0748;
=======
  String get m0739;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Tzatziki
  ///
  /// In en, this message translates to:
  /// **'Tzatziki'**
<<<<<<< HEAD
  String get m0749;
=======
  String get m0740;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Uborka
  ///
  /// In en, this message translates to:
  /// **'Cucumber'**
<<<<<<< HEAD
  String get m0750;
=======
  String get m0741;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: ÜDV A MEALR-BEN
  ///
  /// In en, this message translates to:
  /// **'WELCOME TO MEALR'**
<<<<<<< HEAD
  String get m0751;
=======
  String get m0742;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Új
  ///
  /// In en, this message translates to:
  /// **'New'**
<<<<<<< HEAD
  String get m0752;
=======
  String get m0743;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Új bevásárlólista
  ///
  /// In en, this message translates to:
  /// **'New shopping list'**
<<<<<<< HEAD
  String get m0753;
=======
  String get m0744;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Új étel
  ///
  /// In en, this message translates to:
  /// **'New food'**
<<<<<<< HEAD
  String get m0754;
=======
  String get m0745;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Új étel hozzáadása
  ///
  /// In en, this message translates to:
  /// **'Add new food'**
<<<<<<< HEAD
  String get m0755;
=======
  String get m0746;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Új lista neve
  ///
  /// In en, this message translates to:
  /// **'New list name'**
<<<<<<< HEAD
  String get m0756;
=======
  String get m0747;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Új meal prep terv
  ///
  /// In en, this message translates to:
  /// **'New Meal Prep plan'**
<<<<<<< HEAD
  String get m0757;

  /// Source text: Új mérés
  ///
  /// In en, this message translates to:
  /// **'New measurement'**
  String get m0758;
=======
  String get m0748;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Ülő életmód
  ///
  /// In en, this message translates to:
  /// **'Sedentary'**
<<<<<<< HEAD
  String get m0759;
=======
  String get m0749;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Vacsora
  ///
  /// In en, this message translates to:
  /// **'Dinner'**
<<<<<<< HEAD
  String get m0760;
=======
  String get m0750;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Vágd félbe és pirítsd meg a bagelt.
  ///
  /// In en, this message translates to:
  /// **'Cut the bagel in half and toast it.'**
<<<<<<< HEAD
  String get m0761;
=======
  String get m0751;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Válassz egy típust, majd nézd meg a hozzá tartozó napi étrendeket.
  ///
  /// In en, this message translates to:
  /// **'Choose a type, then view its daily meal plans.'**
<<<<<<< HEAD
  String get m0762;
=======
  String get m0752;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Válassz ételt és adagold dobozokra
  ///
  /// In en, this message translates to:
  /// **'Choose a food and split it into boxes'**
<<<<<<< HEAD
  String get m0763;
=======
  String get m0753;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Válassz étrend típust
  ///
  /// In en, this message translates to:
  /// **'Choose a meal plan type'**
<<<<<<< HEAD
  String get m0764;
=======
  String get m0754;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Válassz főételt, köretet és adagold dobozokra
  ///
  /// In en, this message translates to:
  /// **'Choose a main dish, side, and split into boxes'**
<<<<<<< HEAD
  String get m0765;
=======
  String get m0755;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Vegán
  ///
  /// In en, this message translates to:
  /// **'Vegan'**
<<<<<<< HEAD
  String get m0766;
=======
  String get m0756;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Vegetáriánus
  ///
  /// In en, this message translates to:
  /// **'Vegetarian'**
<<<<<<< HEAD
  String get m0767;
=======
  String get m0757;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Veggie erő nap
  ///
  /// In en, this message translates to:
  /// **'Veggie Strength Day'**
<<<<<<< HEAD
  String get m0768;
=======
  String get m0758;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Verzió 1.0.0
  ///
  /// In en, this message translates to:
  /// **'Version 1.0.0'**
<<<<<<< HEAD
  String get m0769;
=======
  String get m0759;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: veszít a tömegéből
  ///
  /// In en, this message translates to:
  /// **'loses weight'**
<<<<<<< HEAD
  String get m0770;
=======
  String get m0760;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Világos
  ///
  /// In en, this message translates to:
  /// **'Light'**
<<<<<<< HEAD
  String get m0771;
=======
  String get m0761;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Villám nap
  ///
  /// In en, this message translates to:
  /// **'Lightning Day'**
<<<<<<< HEAD
  String get m0772;
=======
  String get m0762;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: vonj le 300–500 kcal-t. Napi 500 kcal deficit ≈ heti 0,5 kg fogyás.
  ///
  ///
  ///
  /// In en, this message translates to:
  /// **'subtract 300-500 kcal. A daily 500 kcal deficit is about 0.5 kg loss per week.\n\n'**
<<<<<<< HEAD
  String get m0773;
=======
  String get m0763;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Vörösbab
  ///
  /// In en, this message translates to:
  /// **'Red beans'**
<<<<<<< HEAD
  String get m0774;
=======
  String get m0764;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Wok zöldség
  ///
  /// In en, this message translates to:
  /// **'Wok vegetables'**
<<<<<<< HEAD
  String get m0775;
=======
  String get m0765;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Wrap up with something nourishing.
  ///
  /// In en, this message translates to:
  /// **'Wrap up with something nourishing.'**
<<<<<<< HEAD
  String get m0776;
=======
  String get m0766;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Zabpehely
  ///
  /// In en, this message translates to:
  /// **'Oats'**
<<<<<<< HEAD
  String get m0777;
=======
  String get m0767;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Zabpehelyliszt
  ///
  /// In en, this message translates to:
  /// **'Oat flour'**
<<<<<<< HEAD
  String get m0778;
=======
  String get m0768;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Zárd a napot jóllakottan, nem rohanva.
  ///
  /// In en, this message translates to:
  /// **'End the day full, not rushed.'**
<<<<<<< HEAD
  String get m0779;
=======
  String get m0769;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Zárd a napot valami táplálóval.
  ///
  /// In en, this message translates to:
  /// **'Wrap up with something nourishing.'**
<<<<<<< HEAD
  String get m0780;
=======
  String get m0770;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Zárd gondoskodással a napot.
  ///
  /// In en, this message translates to:
  /// **'Close the day with care.'**
<<<<<<< HEAD
  String get m0781;
=======
  String get m0771;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Zöld fókusz nap
  ///
  /// In en, this message translates to:
  /// **'Green Focus Day'**
<<<<<<< HEAD
  String get m0782;
=======
  String get m0772;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Zöld lendület nap
  ///
  /// In en, this message translates to:
  /// **'Green Boost Day'**
<<<<<<< HEAD
  String get m0783;
=======
  String get m0773;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Zöld nap
  ///
  /// In en, this message translates to:
  /// **'Green Day'**
<<<<<<< HEAD
  String get m0784;
=======
  String get m0774;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Zöldbab
  ///
  /// In en, this message translates to:
  /// **'Green beans'**
<<<<<<< HEAD
  String get m0785;
=======
  String get m0775;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Zöldborsó
  ///
  /// In en, this message translates to:
  /// **'Green peas'**
<<<<<<< HEAD
  String get m0786;
=======
  String get m0776;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Zöldsaláta
  ///
  /// In en, this message translates to:
  /// **'Green salad'**
<<<<<<< HEAD
  String get m0787;
=======
  String get m0777;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Zöldséges omlett
  ///
  /// In en, this message translates to:
  /// **'Vegetable omelette'**
<<<<<<< HEAD
  String get m0788;
=======
  String get m0778;
>>>>>>> 7ea53f7 (mehet55)

  /// Source text: Zsemlemorzsa
  ///
  /// In en, this message translates to:
  /// **'Breadcrumbs'**
<<<<<<< HEAD
  String get m0789;
=======
  String get m0779;
>>>>>>> 7ea53f7 (mehet55)
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
