# Firebase Setup Guide for Fresh Catering

## 📋 Overview
This guide will help you set up Firebase for the Fresh Catering website.

---

## 🔥 Step 1: Create Firebase Project

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Click "Add Project"
3. Enter project name: `fresh-catering`
4. Enable Google Analytics (recommended)
5. Click "Create Project"

---

## 🌐 Step 2: Add Web App

1. In Firebase console, click "Add app" (Web icon `</>`)
2. Register app nickname: `Fresh Catering Web`
3. Check "Also set up Firebase Hosting"
4. Click "Register app"
5. Copy the Firebase configuration

---

## ⚙️ Step 3: Configure Flutter App

1. Install FlutterFire CLI:
```bash
dart pub global activate flutterfire_cli
```

2. Configure Firebase in your project:
```bash
flutterfire configure
```

3. Select your Firebase project
4. Select platforms: **Web only** for now
5. This will generate `lib/firebase_options.dart`

---

## 🗄️ Step 4: Create Firestore Database

1. In Firebase console, go to **Firestore Database**
2. Click "Create database"
3. Start in **Production mode**
4. Choose location closest to your users:
   - For UAE: `asia-south1` (Mumbai)
   - For Pakistan: `asia-south1` (Mumbai)
5. Click "Enable"

---

## 📁 Step 5: Create Collections & Sample Data

### Collection 1: `menus`

Create structure:
```
menus (collection)
  └── pk (document)
      └── items (collection)
          └── biryani_platter_001 (document)
  └── ae (document)
      └── items (collection)
          └── shawarma_platter_001 (document)
```

#### Sample Menu Item (Pakistan):
```json
{
  "name": "Special Chicken Biryani Platter",
  "description": "Aromatic Pakistani biryani with tender chicken, served with raita, salad, and chutney",
  "category": "Main Course",
  "imageUrl": "https://images.unsplash.com/photo-1563379091339-03b21ab4a4f8?w=800",
  "prices": {
    "PK": 5000,
    "AE": 0
  },
  "available": true,
  "regions": ["PK"],
  "servings": "10-12 people",
  "dietaryInfo": ["Halal", "Dairy"]
}
```

#### Sample Menu Item (UAE):
```json
{
  "name": "Arabic Shawarma Platter",
  "description": "Premium chicken shawarma with tahini sauce, hummus, and fresh vegetables",
  "category": "Main Course",
  "imageUrl": "https://images.unsplash.com/photo-1529042410759-befb1204b468?w=800",
  "prices": {
    "PK": 0,
    "AE": 150
  },
  "available": true,
  "regions": ["AE"],
  "servings": "8-10 people",
  "dietaryInfo": ["Halal", "Dairy-Free Option"]
}
```

---

### Collection 2: `services`

#### Sample Service:
```json
{
  "title": "Corporate Events Catering",
  "description": "Elevate your corporate events with our professional catering service. Perfect for conferences, seminars, product launches, and business meetings.",
  "shortDescription": "Professional catering for business events",
  "imageUrl": "https://images.unsplash.com/photo-1511578314322-379afb476865?w=800",
  "features": [
    "Customizable menu options",
    "Professional setup and service",
    "Dietary requirement accommodation",
    "Timely delivery and setup",
    "Post-event cleanup"
  ],
  "regions": ["PK", "AE"],
  "isActive": true,
  "displayOrder": 1,
  "pricing": {
    "PK": {
      "starting": 15000,
      "unit": "per event"
    },
    "AE": {
      "starting": 500,
      "unit": "per event"
    }
  }
}
```

Add more services:
- Wedding Catering
- Birthday Parties
- Social Gatherings
- Daily Office Meals
- Premium Gourmet Events

---

### Collection 3: `testimonials`

#### Sample Testimonial:
```json
{
  "clientName": "Ahmed Hassan",
  "clientTitle": "CEO, Tech Solutions Inc.",
  "rating": 5,
  "comment": "Fresh Catering made our corporate event a huge success! The food was exceptional and the service was impeccable. Highly recommended!",
  "eventType": "Corporate Event",
  "imageUrl": "https://i.pravatar.cc/150?img=12",
  "region": "AE",
  "isApproved": true,
  "createdAt": "2026-01-01T10:00:00Z"
}
```

Add 5-10 testimonials with mix of PK and AE regions.

---

### Collection 4: `locations`

#### Sample Locations (UAE):
```json
{
  "name": "Dubai Marina",
  "region": "AE",
  "coordinates": {
    "_latitude": 25.0757,
    "_longitude": 55.1395
  },
  "isActive": true,
  "description": "Serving Dubai Marina and surrounding areas"
}
```

Add more locations:
- **UAE**: JBR, Downtown Dubai, Business Bay, DIFC, JLT
- **Pakistan**: DHA Karachi, Clifton, Gulshan, North Nazimabad

---

### Collection 5: `gallery` (Optional)

```json
{
  "imageUrl": "https://images.unsplash.com/photo-1414235077428-338989a2e8c0?w=800",
  "title": "Corporate Lunch Setup",
  "category": "Corporate",
  "region": "AE",
  "featured": true,
  "order": 1
}
```

---

## 🔒 Step 6: Security Rules

Go to **Firestore > Rules** and paste:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    
    // Allow read access to menus for all users
    match /menus/{region}/items/{itemId} {
      allow read: if true;
      allow write: if request.auth != null && request.auth.token.admin == true;
    }
    
    // Allow read access to services
    match /services/{serviceId} {
      allow read: if true;
      allow write: if request.auth != null && request.auth.token.admin == true;
    }
    
    // Allow anyone to submit quotes, but only admins to read
    match /quotes/{quoteId} {
      allow create: if true;
      allow read, update, delete: if request.auth != null && request.auth.token.admin == true;
    }
    
    // Allow reading approved testimonials only
    match /testimonials/{testimonialId} {
      allow read: if resource.data.isApproved == true;
      allow write: if request.auth != null && request.auth.token.admin == true;
    }
    
    // Allow read access to locations
    match /locations/{locationId} {
      allow read: if true;
      allow write: if request.auth != null && request.auth.token.admin == true;
    }
    
    // Allow read access to gallery
    match /gallery/{imageId} {
      allow read: if true;
      allow write: if request.auth != null && request.auth.token.admin == true;
    }
  }
}
```

Click **Publish**

---

## 📊 Step 7: Setup Firebase Analytics

1. Go to **Analytics > Dashboard**
2. Enable Google Analytics if not already done
3. Note your Measurement ID

In your Flutter app, analytics will auto-track:
- Screen views
- User engagement
- Region selections
- Quote submissions

---

## 🗄️ Step 8: Setup Firebase Storage

1. Go to **Storage**
2. Click "Get Started"
3. Start in **Production mode**
4. Use same location as Firestore

### Storage Rules:
```javascript
rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {
    match /images/{allPaths=**} {
      allow read: if true;
      allow write: if request.auth != null;
    }
    
    match /videos/{allPaths=**} {
      allow read: if true;
      allow write: if request.auth != null;
    }
  }
}
```

### Folder Structure:
```
storage/
├── images/
│   ├── menu/
│   ├── services/
│   ├── gallery/
│   └── testimonials/
└── videos/
    ├── hero/
    └── about/
```

---

## 🚀 Step 9: Setup Firebase Hosting

1. Install Firebase CLI:
```bash
npm install -g firebase-tools
```

2. Login to Firebase:
```bash
firebase login
```

3. Initialize hosting in your project:
```bash
firebase init hosting
```

Select:
- Use existing project: `fresh-catering`
- Public directory: `build/web`
- Configure as single-page app: **Yes**
- Set up automatic builds with GitHub: **No** (for now)

4. Build and deploy:
```bash
# Build Flutter web
flutter build web --release

# Deploy to Firebase
firebase deploy --only hosting
```

Your site will be live at:
`https://fresh-catering.web.app`

---

## 🔧 Step 10: Environment Configuration

Create `.env` file in project root:
```env
FIREBASE_API_KEY=your_api_key
FIREBASE_PROJECT_ID=fresh-catering
FIREBASE_APP_ID=your_app_id
FIREBASE_MESSAGING_SENDER_ID=your_sender_id

WHATSAPP_PK=923051340042
WHATSAPP_UAE=971522186060

CONTACT_EMAIL=info@freshcatering.com
```

---

## ✅ Verification Checklist

- [ ] Firebase project created
- [ ] Web app registered
- [ ] Firestore database created
- [ ] Collections created with sample data
- [ ] Security rules published
- [ ] Storage configured
- [ ] Hosting initialized
- [ ] App successfully builds and deploys
- [ ] Analytics tracking works
- [ ] Can read data from Firestore
- [ ] Can submit quotes

---

## 🆘 Troubleshooting

### Issue: "Firebase not initialized"
**Solution**: Make sure you call `await Firebase.initializeApp()` in `main.dart`

### Issue: "Permission denied" when reading Firestore
**Solution**: Check security rules - make sure read is allowed

### Issue: "CORS error" when loading images
**Solution**: Use https://cors-anywhere.herokuapp.com/ as proxy or configure Firebase Storage CORS

### Issue: Deployment fails
**Solution**: 
```bash
flutter clean
flutter pub get
flutter build web --release
firebase deploy --only hosting
```

---

## 📚 Additional Resources

- [Firebase Documentation](https://firebase.google.com/docs)
- [FlutterFire Documentation](https://firebase.flutter.dev/)
- [Firestore Data Modeling](https://firebase.google.com/docs/firestore/data-model)
- [Firebase Security Rules](https://firebase.google.com/docs/firestore/security/get-started)

---

## 🎯 Next Steps

1. Populate more menu items (aim for 20-30 items per region)
2. Add all services (6-8 services)
3. Add testimonials (10-15 testimonials)
4. Upload images to Storage
5. Test data retrieval in app
6. Enable backups (Firestore > Settings > Backups)

---

**Setup Time**: ~30 minutes
**Difficulty**: Beginner-Intermediate

Good luck! 🚀
