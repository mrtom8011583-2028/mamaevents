# 🔥 FIREBASE SCHEMA - COMPLETE DATABASE STRUCTURE

## Premium Catering & Event Management Platform
**Multi-Region Support: Pakistan (PK) & UAE (AE)**

---

## 📊 **FIRESTORE COLLECTIONS**

### 1. **MENUS COLLECTION**
**Path:** `/menus/{region}/items/{menuItemId}`

```json
{
  "id": "string (auto-generated)",
  "name": "string (e.g., 'Mini Beef Sliders')",
  "nameArabic": "string | null (optional Arabic translation)",
  "category": "string (Appetizers | Main Courses | Live Stations | Beverages | Desserts)",
  "subcategory": "string | null (e.g., 'Arabic', 'International', 'Desi')",
  "cuisineType": "string | null (Middle Eastern | South Asian | International | Fusion)",
  "description": "string (full description for details page)",
  "shortDescription": "string (130 chars max for cards)",
  
  // Dietary & Tags
  "dietaryTags": ["string"] // ["Vegetarian", "Halal", "Gluten-Free", "Vegan", "Spicy"]
  "spiceLevel": "number (0-5) | null",
  "allergens": ["string"] // ["Nuts", "Dairy", "Gluten", etc.],
  
  // Pricing
  "prices": {
    "PK": "number (PKR) | 0 if not available",
    "AE": "number (AED) | 0 if not available"
  },
  "priceTier": "string (Budget | Standard | Premium | Luxury)",
  
  // Serving Information
  "servings": "string (e.g., '10-15 people')",
  "servingsCount": "number (for calculations)",
  "minimumOrder": "number | null",
  
  // Images
  "imageUrl": "string | '' // TODO: Insert high-resolution image URL",
  "thumbnailUrl": "string | '' // TODO: Insert thumbnail URL",
  "galleryImages": ["string"] // Array of additional image URLs
  
  // Availability
  "available": "boolean (true/false)",
  "regions": ["string"] // ["PK", "AE"] - which regions this item serves
  "seasonal": "boolean (false)",
  "popularityScore": "number (0-100 for ranking)",
  
  // Live Station Data
  "liveStation": "boolean",
  "stationType": "string | null (BBQ | Pasta | Shawarma | Wok | Dessert)",
  
  // Additional Info
  "preparationTime": "string | null (e.g., '30 minutes')",
  "ingredients": ["string"] // List of main ingredients
  "nutritionInfo": {
    "calories": "number | null",
    "protein": "number | null",
    "carbs": "number | null"
  },
  
  // Meta
  "displayOrder": "number (for sorting)",
  "featured": "boolean",
  "createdAt": "timestamp",
  "updatedAt": "timestamp"
}
```

**Example Menu Item:**
```json
{
  "id": "menu-001",
  "name": "Mini Beef Sliders",
  "category": "Appetizers",
  "subcategory": "International",
  "cuisineType": "International",
  "description": "Wagyu beef sliders with truffle mayo, caramelized onions, and aged cheddar on brioche buns.",
  "shortDescription": "Wagyu beef with truffle mayo on brioche buns",
  "dietaryTags": ["Halal"],
  "spiceLevel": 0,
  "allergens": ["Gluten", "Dairy"],
  "prices": {
    "PK": 3500,
    "AE": 120
  },
  "priceTier": "Premium",
  "servings": "10-12 people",
  "servingsCount": 24,
  "minimumOrder": null,
  "imageUrl": "",
  "thumbnailUrl": "",
  "galleryImages": [],
  "available": true,
  "regions": ["PK", "AE"],
  "seasonal": false,
  "popularityScore": 85,
  "liveStation": false,
  "stationType": null,
  "preparationTime": "20 minutes",
  "ingredients": ["Wagyu beef", "Truffle mayo", "Brioche buns", "Aged cheddar"],
  "nutritionInfo": {
    "calories": 320,
    "protein": 18,
    "carbs": 25
  },
  "displayOrder": 10,
  "featured": true,
  "createdAt": "2026-01-06T00:00:00Z",
  "updatedAt": "2026-01-06T00:00:00Z"
}
```

---

### 2. **SERVICES COLLECTION**
**Path:** `/services/{serviceId}`

```json
{
  "id": "string",
  "title": "string (e.g., 'Corporate & Contract Catering')",
  "titleArabic": "string | null",
  "category": "string (Corporate | Wedding | LiveStations | Infrastructure)",
  "description": "string (full description)",
  "shortDescription": "string (for cards)",
  
  // Features
  "features": ["string"] // List of key features
  "benefits": ["string"] // List of benefits
  
  // Images
  "imageUrl": "string | '' // TODO: Insert service image",
  "heroImage": "string | ''",
  "galleryImages": ["string"],
  
  // Pricing
  "pricing": {
    "PK": {
      "starting": "number | null",
      "perPerson": "number | null",
      "packagePrice": "number | null"
    },
    "AE": {
      "starting": "number | null",
      "perPerson": "number | null",
      "packagePrice": "number | null"
    }
  },
  "pricingTiers": ["Essential", "Heritage", "Signature", "Grand", "Sovereign"],
  
  // Availability
  "regions": ["string"], // ["PK", "AE"]
  "isActive": "boolean",
  "featured": "boolean",
  "displayOrder": "number",
  
  // SEO
  "icon": "string (icon name)",
  "color": "string (hex color)",
  "metaTitle": "string",
  "metaDescription": "string",
  "keywords": ["string"],
  
  // Meta
  "createdAt": "timestamp",
  "updatedAt": "timestamp"
}
```

---

### 3. **PACKAGES COLLECTION**
**Path:** `/packages/{packageId}`

```json
{
  "id": "string",
  "tier": "number (1-5)",
  "name": "string (e.g., 'The Heritage Classic')",
  "tagline": "string (e.g., 'Most Popular')",
  "description": "string",
  "idealFor": "string (e.g., 'Birthdays')",
  
  // Features
  "features": ["string"],
  "inclusions": ["string"],
  "exclusions": ["string"],
  
  // Pricing
  "pricing": {
    "PK": {
      "basePrice": "number | null",
      "perPersonPrice": "number | null",
      "minGuests": "number",
      "maxGuests": "number"
    },
    "AE": {
      "basePrice": "number | null",
      "perPersonPrice": "number | null",
      "minGuests": "number",
      "maxGuests": "number"
    }
  },
  
  // Images
  "imageUrl": "string | '' // TODO: Insert package image",
  "thumbnailUrl": "string | ''",
  
  // Flags
  "popular": "boolean",
  "bespoke": "boolean",
  "featured": "boolean",
  
  // Meta
  "displayOrder": "number",
  "regions": ["string"],
  "createdAt": "timestamp",
  "updatedAt": "timestamp"
}
```

---

### 4. **QUOTE REQUESTS / BOOKING INQUIRIES**
**Path:** `/quote_requests/{requestId}`

```json
{
  "id": "string (auto-generated)",
  "requestNumber": "string (e.g., 'QR-2026-001')",
  
  // Customer Info
  "customerInfo": {
    "name": "string",
    "email": "string",
    "phone": "string",
    "phonePrefix": "string (+92 or +971)",
    "preferredContact": "string (Email | Phone | WhatsApp)"
  },
  
  // Event Details
  "eventInfo": {
    "type": "string (Corporate | Wedding | Birthday | Engagement | Other)",
    "date": "timestamp",
    "time": "string",
    "duration": "string (hours)",
    "guestCount": "number",
    "venue": "string",
    "city": "string (from region-specific dropdown)",
    "address": "string | null"
  },
  
  // Service Selection
  "selectedPackage": "string | null (package ID)",
  "selectedServices": ["string"], // Array of service IDs
  "selectedMenuItems": ["string"], // Array of menu item IDs
  "liveStations": ["string"], // Array of station types
  
  // Special Requirements
  "dietaryRequirements": ["string"],
  "specialRequests": "string",
  "budget": {
    "min": "number | null",
    "max": "number | null",
    "currency": "string (PKR | AED)"
  },
  
  // Region & Source
  "region": "string (PK | AE)",
  "source": "string (Website | WhatsApp | Phone | Instagram)",
  
  // Status Tracking
  "status": "string (New | Contacted | Quoted | Confirmed | Cancelled)",
  "priority": "string (Low | Medium | High | Urgent)",
  "assignedTo": "string | null (staff member ID)",
  
  // Communication Log
  "notes": ["object"] // Array of timestamped notes
  /*
  {
    "timestamp": "timestamp",
    "author": "string (staff name)",
    "note": "string",
    "type": "string (Internal | CustomerFacing)"
  }
  */,
  
  // Quote Details
  "quote": {
    "subtotal": "number | null",
    "tax": "number | null",
    "total": "number | null",
    "currency": "string",
    "validUntil": "timestamp | null",
    "pdfUrl": "string | null"
  },
  
  // Meta
  "createdAt": "timestamp",
  "updatedAt": "timestamp",
  "lastContactedAt": "timestamp | null"
}
```

---

### 5. **TESTIMONIALS COLLECTION**
**Path:** `/testimonials/{testimonialId}`

```json
{
  "id": "string",
  "customerName": "string",
  "customerTitle": "string | null (e.g., 'CEO, ABC Corp')",
  "rating": "number (1-5)",
  "review": "string",
  "eventType": "string (Corporate | Wedding | etc.)",
  "location": "string (city)",
  "region": "string (PK | AE)",
  "eventDate": "timestamp",
  "imageUrl": "string | '' // Customer photo (with permission)",
  "verified": "boolean",
  "featured": "boolean",
  "displayOrder": "number",
  "createdAt": "timestamp"
}
```

---

### 6. **GALLERY COLLECTION**
**Path:** `/gallery/{imageId}`

```json
{
  "id": "string",
  "title": "string",
  "category": "string (Wedding | Corporate | Food | Decor | LiveStation)",
  "imageUrl": "string // TODO: Insert gallery image",
  "thumbnailUrl": "string",
  "description": "string | null",
  "eventType": "string",
  "location": "string",
  "region": "string (PK | AE)",
  "featured": "boolean",
  "displayOrder": "number",
  "tags": ["string"],
  "uploadedAt": "timestamp"
}
```

---

### 7. **BLOG/NEWS COLLECTION** (Optional)
**Path:** `/blog/{postId}`

```json
{
  "id": "string",
  "title": "string",
  "slug": "string (URL-friendly)",
  "excerpt": "string",
  "content": "string (markdown or HTML)",
  "author": "string",
  "category": "string (Tips | Recipes | Events | News)",
  "featuredImage": "string",
 "tags": ["string"],
  "region": "string (PK | AE | Both)",
  "published": "boolean",
  "publishedAt": "timestamp",
  "updatedAt": "timestamp",
  "views": "number",
  "seo": {
    "metaTitle": "string",
    "metaDescription": "string",
    "keywords": ["string"]
  }
}
```

---

## 🔐 **FIRESTORE SECURITY RULES**

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    
    // Public read for menus
    match /menus/{region}/items/{itemId} {
      allow read: if true;
      allow write: if request.auth != null && 
                      get(/databases/$(database)/documents/users/$(request.auth.uid)).data.role == 'admin';
    }
    
    // Public read for services
    match /services/{serviceId} {
      allow read: if true;
      allow write: if request.auth != null && 
                      get(/databases/$(database)/documents/users/$(request.auth.uid)).data.role == 'admin';
    }
    
    // Public read for packages
    match /packages/{packageId} {
      allow read: if true;
      allow write: if request.auth != null && 
                      get(/databases/$(database)/documents/users/$(request.auth.uid)).data.role == 'admin';
    }
    
    // Quote requests - anyone can create, only staff can read/update
    match /quote_requests/{requestId} {
      allow create: if true; // Anyone can submit a quote request
      allow read, update: if request.auth != null;
    }
    
    // Public read for testimonials
    match /testimonials/{testimonialId} {
      allow read: if resource.data.verified == true;
      allow write: if request.auth != null;
    }
    
    // Public read for gallery
    match /gallery/{imageId} {
      allow read: if true;
      allow write: if request.auth != null;
    }
  }
}
```

---

## 📱 **FIREBASE STORAGE STRUCTURE**

```
/storage
  /menus
    /PK
      /menu-001.jpg
      /menu-001-thumb.jpg
    /AE
      /menu-002.jpg
      /menu-002-thumb.jpg
  /services
    /corporate-catering.jpg
    /wedding-services.jpg
  /packages
    /essential-collection.jpg
    /heritage-classic.jpg
  /gallery
    /weddings
      /event-001-001.jpg
      /event-001-002.jpg
    /corporate
      /corp-001-001.jpg
  /testimonials
    /customer-001.jpg
  /quotes
    /quote-pdfs
      /QR-2026-001.pdf
```

---

## 🎯 **INDEXING REQUIREMENTS**

Create composite indexes for efficient queries:

### Menus
```
Collection: menus/{region}/items
Fields: category (Ascending), displayOrder (Ascending)
Fields: featured (Descending), popularityScore (Descending)
Fields: regions (Array), available (Ascending)
```

### Quote Requests
```
Collection: quote_requests
Fields: region (Ascending), status (Ascending), createdAt (Descending)
Fields: assignedTo (Ascending), priority (Descending)
```

---

## ✅ **INITIAL DATA SEEDING**

### Sample Firebase Console Commands:
```javascript
// Create a menu item
db.collection('menus').doc('PK').collection('items').add({
  name: 'Mini Beef Sliders',
  category: 'Appetizers',
  // ... rest of fields
});

// Create a package
db.collection('packages').add({
  tier: 2,
  name: 'The Heritage Classic',
  // ... rest of fields
});
```

---

**This schema provides a complete, scalable Firebase structure for the multi-region catering platform with proper organization, security, and query optimization.**
