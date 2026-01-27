# 🚀 Quick Reference Guide - Fresh Catering

## 📌 Essential Commands

```bash
# Development
flutter run -d chrome                    # Run in Chrome
flutter run -d chrome --web-port=5000   # Run on specific port
flutter pub get                          # Install dependencies
flutter pub upgrade                      # Update packages
flutter clean                            # Clean build cache

# Building
flutter build web --release              # Production build
flutter build web --release --web-renderer html  # HTML renderer

# Deployment  
firebase deploy --only hosting           # Deploy to Firebase
firebase deploy --only firestore:rules   # Update Firestore rules

# Testing
flutter test                             # Run all tests
flutter analyze                          # Code analysis
flutter pub outdated                     # Check for updates
```

---

## 📁 File Locations Cheat Sheet

| What                    | Location                                  |
|-------------------------|-------------------------------------------|
| **Models**              | `lib/core/models/`                       |
| **Services**            | `lib/core/services/`                     |
| **Utilities**           | `lib/core/utils/`                        |
| **Theme**               | `lib/config/theme/`                      |
| **Constants**           | `lib/config/constants/`                  |
| **Buttons**             | `lib/shared/widgets/buttons/`            |
| **Animations**          | `lib/shared/widgets/animations/`         |
| **Home Widgets**        | `lib/features/home/widgets/`             |
| **Providers**           | `lib/providers/`                         |
| **Assets**              | `assets/` and `lib/assets/`              |

---

## 🎨 Theme Access

```dart
// Colors
import 'package:fresh_catering/config/theme/colors.dart';

AppColors.luxuryBlack
AppColors.luxuryGold
AppColors.freshGreen
AppColors.freshOrange
AppColors.videoOverlayDark

// Theme
import 'package:fresh_catering/config/theme/app_theme.dart';

MaterialApp(
  theme: AppTheme.lightTheme,
  // ...
)
```

---

## 🗺️ Region Usage

```dart
import 'package:fresh_catering/core/models/region.dart';

// Get current region from provider
final region = Provider.of<RegionProvider>(context).currentRegion;

// Format price
final price = region.formatPrice(5000);  // "Rs 5000" or "AED 150.00"

// Get WhatsApp link
final whatsappLink = region.getWhatsAppLink(
  message: 'Hi, I would like to inquire...'
);

// Check region
if (region.isPakistan) { ... }
if (region.isUAE) { ... }

// Switch region
Provider.of<RegionProvider>(context, listen: false)
  .setRegion(Region.pakistan);
```

---

## 🔘 Button Usage

```dart
import 'package:fresh_catering/shared/widgets/buttons/primary_button.dart';
import 'package:fresh_catering/shared/widgets/buttons/secondary_button.dart';
import 'package:fresh_catering/shared/widgets/buttons/whatsapp_button.dart';

// Primary Button
PrimaryButton(
  text: 'Get Quote',
  onPressed: () { },
  icon: Icons.send,
  isLoading: false,
)

// Secondary Button
SecondaryButton(
  text: 'Learn More',
  onPressed: () { },
)

// WhatsApp Button
WhatsAppButton(
  region: region,
  buttonText: 'Chat with us',
  customMessage: 'I want to inquire about...',
)
```

---

## ✨ Animation Usage

```dart
import 'package:fresh_catering/shared/widgets/animations/fade_in_animation.dart';
import 'package:fresh_catering/shared/widgets/animations/slide_up_animation.dart';
import 'package:fresh_catering/shared/widgets/animations/scale_animation.dart';

// Fade In
FadeInAnimation(
  duration: Duration(milliseconds: 600),
  delay: Duration(milliseconds: 200),
  child: YourWidget(),
)

// Slide Up
SlideUpAnimation(
  offset: 50.0,
  child: YourWidget(),
)

// Scale
ScaleAnimation(
  initialScale: 0.8,
  child: YourWidget(),
)
```

---

## 🔌 Service Usage

```dart
import 'package:fresh_catering/core/services/menu_service.dart';
import 'package:fresh_catering/core/services/quote_service.dart';
import 'package:fresh_catering/core/services/analytics_service.dart';

// Menu Service
final menuService = MenuService();
final items = await menuService.getMenuByRegion(region);
final categories = await menuService.getCategories(region);

// Quote Service
final quoteService = QuoteService();
await quoteService.submitQuote(quoteRequest);

// Analytics
final analytics = AnalyticsService();
await analytics.trackScreenView('home_screen');
await analytics.trackQuoteSubmission(
  serviceType: 'wedding',
  region: region,
  guests: 100,
);
```

---

## 📱 Responsive Design

```dart
import 'package:fresh_catering/core/utils/responsive_helper.dart';

// Check device type
final isMobile = ResponsiveHelper.isMobile(context);
final isTablet = ResponsiveHelper.isTablet(context);
final isDesktop = ResponsiveHelper.isDesktop(context);

// Get responsive value
final columns = ResponsiveHelper.getResponsiveValue(
  context,
  mobile: 1,
  tablet: 2,
  desktop: 3,
);

// Get responsive padding
final padding = ResponsiveHelper.getHorizontalPadding(context);

// Get grid columns
final crossAxisCount = ResponsiveHelper.getGridCrossAxisCount(
  context,
  mobileColumns: 1,
);
```

---

## ✅ Validation

```dart
import 'package:fresh_catering/core/utils/validators.dart';

// In TextFormField
TextFormField(
  validator: Validators.validateEmail,
  // or
  validator: (value) => Validators.validatePhone(value, regionCode: 'PK'),
)

// Available validators
Validators.validateEmail(value)
Validators.validatePhone(value, regionCode: 'PK')
Validators.validateName(value)
Validators.validateRequired(value, 'Field Name')
Validators.validateNumber(value, min: 1, max: 100)
Validators.validateGuests(value)
Validators.validateMessage(value, minLength: 10)
```

---

## 💰 Currency Formatting

```dart
import 'package:fresh_catering/core/utils/currency_formatter.dart';

// Format price
final formatted = CurrencyFormatter.formatPrice(5000, region);

// Format range
final range = CurrencyFormatter.formatPriceRange(1000, 5000, region);

// With separators
final separated = CurrencyFormatter.formatWithSeparators(100000, region);
// Pakistan: "1.00 Lac"
```

---

## 🔗 URL Launcher

```dart
import 'package:fresh_catering/core/utils/url_launcher_helper.dart';

// WhatsApp
await UrlLauncherHelper.openWhatsApp(
  region,
  customMessage: 'Hi, I want to book...',
);

// Email
await UrlLauncherHelper.openEmail(
  emailAddress: 'info@freshcatering.com',
  subject: 'Inquiry about catering',
  body: 'Hello, I would like to...',
);

// Phone
await UrlLauncherHelper.makePhoneCall('+971585178182');

// Website
await UrlLauncherHelper.openWebsite('https://freshcatering.com');
```

---

## 🔥 Firebase Operations

```dart
// Initialize (already in main.dart)
await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
);

// Firestore instance
final firestore = FirebaseFirestore.instance;

// Get collection
final snapshot = await firestore
  .collection('menus')
  .doc('pk')
  .collection('items')
  .get();

// Add document
await firestore.collection('quotes').add({
  'name': 'John',
  'email': 'john@example.com',
  // ...
});

// Real-time listener
firestore.collection('menus')
  .snapshots()
  .listen((snapshot) {
    // Handle updates
  });
```

---

## 🎯 Provider Pattern

```dart
// Access provider (read-only)
final region = context.read<RegionProvider>().currentRegion;

// Watch for changes
final region = context.watch<RegionProvider>().currentRegion;

// Access without rebuild
Provider.of<RegionProvider>(context, listen: false).setRegion(Region.uae);

// Consumer pattern
Consumer<RegionProvider>(
  builder: (context, provider, child) {
    return Text(provider.currentRegion.name);
  },
)
```

---

## 📊 Common Patterns

### Loading State
```dart
bool _isLoading = false;

void _loadData() async {
  setState(() => _isLoading = true);
  try {
    final data = await fetchData();
    // Handle data
  } finally {
    setState(() => _isLoading = false);
  }
}

// In build
if (_isLoading) {
  return CircularProgressIndicator();
}
```

### Error Handling
```dart
try {
  await submitForm();
  // Show success
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text('Success!')),
  );
} catch (e) {
  // Show error
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text('Error: $e'),
      backgroundColor: Colors.red,
    ),
  );
}
```

---

## 🎨 Common Layouts

### Centered Container
```dart
Center(
  child: Container(
    constraints: BoxConstraints(
      maxWidth: ResponsiveHelper.getMaxContentWidth(context),
    ),
    padding: EdgeInsets.symmetric(
      horizontal: ResponsiveHelper.getHorizontalPadding(context),
    ),
    child: YourContent(),
  ),
)
```

### Grid Layout
```dart
GridView.builder(
  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: ResponsiveHelper.getGridCrossAxisCount(context),
    crossAxisSpacing: 16,
    mainAxisSpacing: 16,
  ),
  itemBuilder: (context, index) => YourCard(),
)
```

---

## 🐛 Debugging Tips

```dart
// Print in debug mode only
if (kDebugMode) {
  print('Debug: $value');
}

// Assert in debug
assert(value != null, 'Value should not be null');

// Debugger breakpoint
debugger();

// Inspector
debugDumpApp();  // Print widget tree
debugPaintSizeEnabled = true;  // Show layout borders
```

---

## ⚡ Performance Tips

1. **Use `const` constructors**
   ```dart
   const Text('Hello')  // ✅
   Text('Hello')        // ❌
   ```

2. **Avoid rebuilds**
   ```dart
   // ✅ Extract to separate widget
   class MyWidget extends StatelessWidget { }
   
   // ❌ Building in build method
   build() => Column(children: [...])
   ```

3. **Lazy load images**
   ```dart
   CachedNetworkImage(
     imageUrl: url,
     placeholder: (context, url) => CircularProgressIndicator(),
   )
   ```

---

## 🎯 Quick Navigation

| Need to...                | Go to...                                    |
|---------------------------|---------------------------------------------|
| Change colors             | `lib/config/theme/colors.dart`             |
| Add new model             | `lib/core/models/`                         |
| Create service            | `lib/core/services/`                       |
| Add validation            | `lib/core/utils/validators.dart`           |
| Create reusable widget    | `lib/shared/widgets/`                      |
| Add new screen            | `lib/features/{feature}/screens/`          |
| Update region logic       | `lib/providers/region_provider.dart`       |

---

## 📞 Emergency Fixes

### App won't run
```bash
flutter clean
flutter pub get
flutter run -d chrome
```

### Build errors
```bash
flutter clean
rm -rf build/
flutter pub get
flutter run
```

### Firebase errors
```bash
# Re-initialize
flutterfire configure
```

---

**Keep this handy while developing!** 🚀
