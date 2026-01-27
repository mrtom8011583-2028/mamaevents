# 🍽️ MAMA EVENTS - Premium Multi-Region Website

A luxury catering website built with Flutter Web for **Pakistan** and **UAE/Dubai** with premium animations, video backgrounds, and dynamic menus.

---

## 📋 Project Status

### ✅ Completed
- [x] Project structure setup
- [x] Core models (Region, MenuItem, Service, Testimonial, Location, QuoteRequest)
- [x] Theme system (Colors, Typography, Components)
- [x] Utility services (CurrencyFormatter, Validators, UrlLauncher, ResponsiveHelper)
- [x] Core services (MenuService, QuoteService, RegionService, AnalyticsService, StorageService)
- [x] Shared widgets (Buttons: Primary, Secondary, WhatsApp)
- [x] Animation widgets (FadeIn, SlideUp, Scale)
- [x] Firebase configuration
- [x] Assets path configuration

### 🚧 In Progress / Pending
- [ ] Home screen hero section
- [ ] Custom App Bar with region selector
- [ ] Video background widget
- [ ] Footer component
- [ ] Menu screen and widgets
- [ ] Contact form (multi-step)
- [ ] Gallery screen
- [ ] Services screen
- [ ] Complete Firebase setup (collections, rules)

---

## 🏗️ Architecture

```
lib/
├── config/              # App configuration
│   ├── theme/          # Colors, themes, text styles
│   ├── routes/         # Navigation routes
│   └── constants/      # API, Images, Videos constants
│
├── core/               # Core business logic
│   ├── models/         # Data models
│   ├── services/       # API & backend services
│   └── utils/          # Utilities & helpers
│
├── features/           # Feature modules
│   ├── home/          # Homepage
│   ├── menu/          # Menu listing
│   ├── services/      # Services
│   ├── gallery/       # Gallery
│   ├── contact/       # Contact & quotes
│   ├── testimonials/  # Reviews
│   └── about/         # About page
│
├── shared/            # Shared components
│   ├── widgets/       # Reusable widgets
│   │   ├── app_bar/
│   │   ├── buttons/
│   │   ├── animations/
│   │   ├── media/
│   │   ├── cards/
│   │   ├── footer/
│   │   └── loading/
│   └── mixins/        # Reusable mixins
│
└── providers/         # State management
```

---

## 🚀 Quick Start

### Prerequisites
- Flutter SDK (3.9.2+)
- Firebase account
- Node.js & npm (for Firebase CLI)

### Installation

```bash
# 1. Clone/Navigate to project
cd CateringWeb

# 2. Install dependencies
flutter pub get

# 3. Setup Firebase (if not already done)
# - Create Firebase project at https://console.firebase.google.com
# - Add Web app to Firebase project
# - Copy configuration to lib/firebase_options.dart

# 4. Create .env file in root
# Add your environment variables:
FIREBASE_API_KEY=your_api_key
WHATSAPP_PK=+923001234567
WHATSAPP_UAE=+971585178182

# 5. Run in development
flutter run -d chrome

# 6. Build for production
flutter build web --release

# 7. Deploy to Firebase Hosting
firebase deploy --only hosting
```

---

## 🎨 Design System

### Colors
- **Luxury Black**: `#0B0B0B`
- **Luxury Gold**: `#C6A869`
- **Fresh Green**: `#1B5E20`
- **Fresh Orange**: `#FF6D00`
- **Soft White**: `#FAFAFA`

### Typography
- **Headings**: Google Fonts - Inter (Bold)
- **Body**: Google Fonts - Inter (Regular)

### Breakpoints
- Mobile: < 600px
- Tablet: 600px - 900px
- Desktop: 900px - 1200px
- Large Desktop: > 1200px

---

## 🔥 Firebase Setup

### Required Collections

#### 1. **menus** collection
```
menus/
  pk/
    items/
      {itemId}/
        - name: string
        - description: string
        - category: string
        - imageUrl: string
        - prices: { PK: number, AE: number }
        - available: boolean
        - regions: array
  ae/
    items/
      {itemId}/
        - (same structure)
```

#### 2. **services** collection
```
services/
  {serviceId}/
    - title: string
    - description: string
    - shortDescription: string
    - imageUrl: string
    - features: array
    - regions: array ['PK', 'AE']
    - isActive: boolean
```

#### 3. **quotes** collection
```
quotes/
  {quoteId}/
    - region: string
    - serviceType: string
    - name: string
    - email: string
    - phone: string
    - guests: number
    - eventDate: timestamp
    - status: string
    - createdAt: timestamp
```

#### 4. **testimonials** collection
```
testimonials/
  {testimonialId}/
    - clientName: string
    - clientTitle: string
    - rating: number
    - comment: string
    - eventType: string
    - region: string
    - isApproved: boolean
```

### Firestore Security Rules

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Menus - Read only
    match /menus/{region}/items/{itemId} {
      allow read: if true;
      allow write: if request.auth != null;
    }
    
    // Services - Read only
    match /services/{serviceId} {
      allow read: if true;
      allow write: if request.auth != null;
    }
    
    // Quotes - Anyone can create, only auth can read
    match /quotes/{quoteId} {
      allow create: if true;
      allow read, update, delete: if request.auth != null;
    }
    
    // Testimonials - Read approved only
    match /testimonials/{testimonialId} {
      allow read: if resource.data.isApproved == true;
      allow write: if request.auth != null;
    }
  }
}
```

---

## 📱 Features Implementation Checklist

### Phase 1: Core Setup ✅
- [x] Project structure
- [x] Models & Services
- [x] Theme system
- [x] Utilities

### Phase 2: Shared Components
- [x] Button components
- [x] Animation widgets  
- [ ] Custom App Bar
- [ ] Region selector
- [ ] Video background
- [ ] Footer
- [ ] Loading skeletons

### Phase 3: Homepage
- [ ] Hero section with video
- [ ] Stats section
- [ ] Our Story section
- [ ] Locations section
- [ ] CTA section
- [ ] Trusted by section

### Phase 4: Menu System
- [ ] Menu grid layout
- [ ] Category filters
- [ ] Menu item cards
- [ ] Menu detail dialog
- [ ] Region-specific pricing

### Phase 5: Forms & Contact
- [ ] Multi-step quote form
- [ ] Form validation
- [ ] Success animations
- [ ] WhatsApp integration
- [ ] Email service

### Phase 6: Additional Pages
- [ ] Services grid
- [ ] Service detail pages
- [ ] Gallery with lightbox
- [ ] Testimonials carousel
- [ ] About page

### Phase 7: Polish & Deploy
- [ ] SEO optimization
- [ ] Performance optimization
- [ ] Cross-browser testing
- [ ] Mobile responsiveness
- [ ] Firebase deployment

---

## 🛠️ Development Commands

```bash
# Run development server
flutter run -d chrome --web-port=5000

# Build for web
flutter build web --release

# Analyze code
flutter analyze

# Format code
flutter format lib/

# Run tests
flutter test

# Check outdated packages
flutter pub outdated

# Update packages
flutter pub upgrade
```

---

## 📦 Key Dependencies

| Package | Purpose |
|---------|---------|
| `provider` | State management |
| `firebase_core` | Firebase SDK |
| `cloud_firestore` | Database |
| `google_fonts` | Typography |
| `video_player` | Video backgrounds |
| `animated_text_kit` | Text animations |
| `visibility_detector` | Scroll animations |
| `url_launcher` | WhatsApp/Email links |
| `geolocator` | Region detection |
| `cached_network_image` | Image caching |

---

## 🎯 Next Steps

1. **Complete Video Background Widget**
   - Add video player with fallback image
   - Implement lazy loading
   - Add dark overlay support

2. **Build Custom App Bar**
   - Sticky header on scroll
   - Region selector dropdown
   - Mobile menu
   - Phone/WhatsApp quick links

3. **Implement Home Screen**
   - Hero section with video
   - Animated stats counters
   - Story section with parallax
   - Locations map integration

4. **Create Menu System**
   - Fetch menu from Firestore
   - Implement category filtering
   - Build menu item cards
   - Add detail popups

5. **Build Contact Form**
   - Multi-step wizard
   - Validation with error messages
   - Success animation
   - Firebase submission

---

## 📊 Performance Goals

- **Lighthouse Score**: > 90
- **First Contentful Paint**: < 1.5s
- **Time to Interactive**: < 3.5s
- **Total Bundle Size**: < 2MB

---

## 🌐 Multi-Region Support

The app automatically detects user location and suggests the appropriate region (Pakistan or UAE). Users can manually switch regions using the selector in the app bar.

### Region-Specific Features:
- ✅ Different menus per region
- ✅ Different pricing (PKR vs AED)
- ✅ Different WhatsApp numbers
- ✅ Different phone prefixes
- ✅ Currency formatting
- ✅ Service locations

---

## 📞 Contact

For development support or questions:
- **Email**: developer@freshcatering.com
- **WhatsApp (PK)**: +92 305 1340042
- **WhatsApp (UAE)**: +971 52 218 6060

---

## 📄 License

Proprietary - All rights reserved © 2026 Fresh Catering

---

**Built with ❤️ using Flutter** 🚀
