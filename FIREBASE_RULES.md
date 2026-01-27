# Firebase Security Rules

## 1. Realtime Database Rules
Copy and paste this **Clean Version** (without comments) into the **Realtime Database** -> **Rules** tab. The previous version may have caused parse errors due to comments in strict JSON mode.

```json
{
  "rules": {
    "events": {
      ".read": true,
      ".write": "auth != null"
    },
    "live_stations": {
      ".read": true,
      ".write": "auth != null"
    },
    "menu_items": {
      ".read": true,
      ".write": "auth != null"
    },
    "orders": {
      ".read": "auth != null",
      ".indexOn": ["status"],
      "$order_id": {
        ".write": "!data.exists() || auth != null",
        ".validate": "newData.hasChildren(['contactName', 'contactNumber', 'totalAmount'])"
      }
    }
  }
}
```

## 2. Storage Rules
Copy and paste these rules into the **Storage** -> **Rules** tab in your Firebase Console.

```service
service firebase.storage {
  match /b/{bucket}/o {
    match /{allPaths=**} {
      allow read: if true;
      allow write: if request.auth != null;
    }
  }
}
```

### 🔐 How to Verify
1.  **Login as Admin**: Go to `/admin/login` and log in.
2.  **Modify Content**: Change a package price or name in the Admin Panel.
3.  **Check User App**: Open the User App (`/menu`) in a separate window/tab. The change should appear instantly.
4.  **Submit Order**: Submit a booking request from the User App.
5.  **Check Admin**: The "Booking Requests" count in the Admin Dashboard should increase instantly.
