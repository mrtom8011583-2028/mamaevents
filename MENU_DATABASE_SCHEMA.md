# 🍽️ Fresh Catering - Menu Database Schema

## 🗄️ Firestore Collections Structure

### **Collection: `menus/{region}/items`**

Each menu item document should have the following fields:

```javascript
{
  // BASIC INFO
  "id": "lamb_ouzi_001",                    // Unique identifier
  "name": "Lamb Ouzi with Oriental Rice",   // Item name
  "nameArabic": "لحم أوزي مع أرز شرقي",      // Arabic translation (optional)
  
  // CATEGORIZATION
  "category": "Main Course",                 // Appetizers | Main Course | Desserts | Beverages
  "subcategory": "Middle Eastern",           // Middle Eastern | Desi/South Asian | International
  "cuisineType": "Middle Eastern",           // Cuisine classification
  
  // DESCRIPTION
  "description": "Slow-cooked lamb with aromatic oriental rice, garnished with nuts and raisins",
  "shortDescription": "Slow-cooked lamb with oriental rice", // For cards
  
  // DIETARY & TAGS
  "dietaryTags": ["Halal", "Dairy-Free"],   // Halal | Vegetarian | Vegan | Gluten-Free | Dairy-Free
  "spiceLevel": "medium",                    // mild | medium | hot | none
  "allergens": ["nuts"],                     // List of allergens
  
  // PRICING
  "prices": {
    "PK": 8500,                              // Price in PKR
    "AE": 220                                // Price in AED
  },
  "priceTier": "premium",                    // budget | standard | premium | luxury
  "servings": "6-8 people",                  // Serving size description
  "minimumOrder": 10,                        // Minimum quantity for orders
  
  // IMAGES (Leave commented in code, user will add later)
  "imageUrl": "",                            // Main image URL - LEAVE BLANK
  "thumbnailUrl": "",                        // Thumbnail - LEAVE BLANK
  "galleryImages": [],                       // Additional images - LEAVE BLANK
  
  // AVAILABILITY
  "available": true,                         // Is item currently available
  "regions": ["PK", "AE"],                   // Which regions serve this item
  "seasonal": false,                         // Is this a seasonal item
  "popularityScore": 85,                     // For sorting popular items (0-100)
  
  // CHEF STATIONS
  "liveStation": false,                      // Is this a live chef station item
  "stationType": "",                         // Shawarma | Pasta | BBQ | Sushi | None
  
  // METADATA
  "preparationTime": "45 minutes",           // Cooking time
  "ingredients": ["lamb", "rice", "nuts"],   // Key ingredients
  "nutritionInfo": {                         // Optional nutrition data
    "calories": 650,
    "protein": "35g",
    "carbs": "45g"
  },
  
  // ADMIN
  "displayOrder": 1,                         // Sort order in listings
  "featured": true,                          // Show on homepage
  "createdAt": "2026-01-06T00:00:00Z",
  "updatedAt": "2026-01-06T00:00:00Z"
}
```

---

## 📊 **Services Schema**

### **Collection: `services`**

```javascript
{
  // BASIC INFO
  "id": "corporate_catering",
  "title": "Corporate Catering",
  "titleArabic": "خدمات الشركات",
  
  // DESCRIPTION
  "description": "High-end boardroom lunches, coffee breaks, and annual gala dinners...",
  "shortDescription": "Professional catering for business events",
  "features": [
    "Boardroom Lunches",
    "Coffee Breaks & Refreshments",
    "Annual Gala Dinners",
    "Product Launch Events",
    "Conference Catering"
  ],
  
  // IMAGES (Leave commented, user adds later)
  "imageUrl": "",                            // LEAVE BLANK
  "heroImage": "",                           // LEAVE BLANK
  "galleryImages": [],                       // LEAVE BLANK
  
  // PRICING
  "pricing": {
    "PK": {
      "starting": 25000,
      "unit": "per event",
      "description": "Starting from PKR 25,000"
    },
    "AE": {
      "starting": 800,
      "unit": "per event",
      "description": "Starting from AED 800"
    }
  },
  "pricingTiers": [
    {
      "name": "Basic Package",
      "price": { "PK": 25000, "AE": 800 },
      "includes": ["Menu planning", "Setup", "Service staff"]
    },
    {
      "name": "Premium Package",
      "price": { "PK": 50000, "AE": 1500 },
      "includes": ["Full event management", "Custom menu", "Decor"]
    }
  ],
  
  // METADATA
  "regions": ["PK", "AE"],
  "isActive": true,
  "featured": true,
  "displayOrder": 1,
  "icon": "business",                       // Icon identifier
  "color": "#1B5E20",                       // Brand color for this service
  
  // SEO
  "metaTitle": "Corporate Catering Services - Fresh Catering",
  "metaDescription": "Professional corporate catering...",
  "keywords": ["corporate catering", "business lunch", "gala dinner"]
}
```

---

## 🎯 **Menu Categories Structure**

### **Main Categories:**
1. **Appetizers** (المقبلات)
2. **Main Courses** (الأطباق الرئيسية)
   - Middle Eastern (شرق أوسطي)
   - Desi/South Asian (هندي باكستاني)
   - International (عالمي)
3. **Desserts** (الحلويات)
4. **Beverages** (المشروبات)
5. **Live Stations** (محطات الطهي المباشر)

### **Dietary Tags:**
- ✅ Halal (حلال)
- 🥗 Vegetarian (نباتي)
- 🌱 Vegan (نباتي صرف)
- 🌾 Gluten-Free (خالي من الجلوتين)
- 🥛 Dairy-Free (خالي من الألبان)

---

## 🔍 **Search & Filter Fields**

Users should be able to filter by:
- Category
- Cuisine Type
- Dietary Tags
- Price Tier
- Spice Level
- Region
- Live Station availability

---

## 📈 **Sample Queries**

```dart
// Get all appetizers
firestore.collection('menus/ae/items')
  .where('category', isEqualTo: 'Appetizers')
  .get();

// Get vegetarian main courses
firestore.collection('menus/ae/items')
  .where('category', isEqualTo: 'Main Course')
  .where('dietaryTags', arrayContains: 'Vegetarian')
  .get();

// Get featured items
firestore.collection('menus/ae/items')
  .where('featured', isEqualTo: true)
  .orderBy('popularityScore', descending: true)
  .limit(6)
  .get();

// Get live station items
firestore.collection('menus/ae/items')
  .where('liveStation', isEqualTo: true)
  .get();
```

---

## 🎨 **UI Display Recommendations**

### **Menu Cards should show:**
- Image placeholder (with comment to add image)
- Item name (English & Arabic)
- Short description
- Dietary tags (icons)
- Price (region-specific)
- Spice level indicator
- "View Details" button

### **Live Stations - Special Display:**
- **Interactive Chef Icon** 👨‍🍳
- **Special Badge**: "Live Station"
- **Video/GIF placeholder** (commented)
- **Description**: "Prepared fresh by our chefs"
- **Highlight color**: Gold (#C6A869)

---

**This schema supports:**
✅ Multi-region pricing
✅ Multi-language support
✅ Dietary preferences
✅ Live chef stations
✅ Image placeholders (to be added)
✅ SEO optimization
✅ Advanced filtering
