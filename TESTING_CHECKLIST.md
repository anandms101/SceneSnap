# SceneSnap Local Testing Checklist

## Pre-Build Checks ✅

### 1. Open Project in Xcode
```bash
open SceneSnap.xcodeproj
```

### 2. Build the Project
- Press `Cmd + B` to build
- Check for any compilation errors in the Issue Navigator (⌘5)

### 3. Common Issues to Check

#### Import Issues
- ✅ All models (User, Post, Comment, Challenge, LeaderboardEntry) are in the Models folder
- ✅ All ViewModels import necessary modules (Foundation, SwiftUI, Combine)
- ✅ AppState imports Foundation and Combine

#### Navigation Issues
- ✅ NavigationStack is used (iOS 16+)
- ✅ All navigation destinations are properly set up
- ✅ Sheet presentations use proper bindings

#### Data Flow Issues
- ✅ AppState.shared is properly initialized
- ✅ ViewModels use @StateObject or @ObservedObject correctly
- ✅ Published properties are used for reactive updates

## Testing Flow

### 1. Authentication Flow
- [ ] Launch app → Should show LoginView
- [ ] Test login with credentials: email="test", password="test"
- [ ] Should navigate to MainTabView after login
- [ ] Test "Don't have an account? Sign Up" link
- [ ] Test sign up flow
- [ ] Test navigation back to login from sign up

### 2. Main Tab Navigation
- [ ] Home tab shows FeedView
- [ ] Capture tab shows CaptureView
- [ ] Profile tab shows ProfileView
- [ ] Tab switching works correctly

### 3. Feed Screen
- [ ] FeedView displays correctly
- [ ] Weekly Challenge Banner appears (if challenge exists)
- [ ] Tapping banner navigates to LeaderboardView
- [ ] Posts display (even if empty state)
- [ ] Pull-to-refresh works
- [ ] Tapping username navigates to ProfileView

### 4. Capture Screen
- [ ] CaptureView displays correctly
- [ ] Camera preview area shows
- [ ] Buttons are visible and functional
- [ ] "Continue" button is disabled until media is selected
- [ ] Tapping "Continue" navigates to PostPreviewView
- [ ] Cancel button dismisses view (if presented modally)

### 5. Post Preview Screen
- [ ] PostPreviewView displays media preview
- [ ] Caption field is editable
- [ ] Challenge tag field is editable
- [ ] Location field is editable
- [ ] Post button is disabled until required fields are filled
- [ ] Cancel button dismisses view

### 6. Profile Screen
- [ ] ProfileView displays user information
- [ ] Stats section shows points, likes, posts
- [ ] "Update Bio" button opens EditProfileView
- [ ] Logout button appears (for current user only)
- [ ] Logout clears authentication state

### 7. Leaderboard Screen
- [ ] LeaderboardView displays correctly
- [ ] Challenge title appears
- [ ] Leaderboard entries display (or empty state)
- [ ] "Join Challenge" button navigates to CaptureView
- [ ] Back button dismisses view

### 8. Navigation Tests
- [ ] Feed → Leaderboard (via banner)
- [ ] Feed → Profile (via username tap)
- [ ] Leaderboard → Capture (via Join Challenge)
- [ ] Capture → PostPreview (via Continue)
- [ ] Profile → EditProfile (via Update Bio)
- [ ] All back/cancel buttons work

## Known Limitations (Before DB Connection)

1. **Authentication**: Uses test credentials (email="test", password="test")
2. **Data**: No real data from Firebase yet
3. **Media**: Camera/gallery picker not fully implemented
4. **Upload**: Post upload is stubbed (doesn't actually upload)

## Next Steps After Local Testing

1. ✅ Fix any compilation errors
2. ✅ Test all navigation flows
3. ✅ Verify UI displays correctly
4. 🔄 Connect to Firebase (Auth, Firestore, Storage)
5. 🔄 Implement actual data fetching
6. 🔄 Test with real data
7. 🔄 Commit and push to GitHub

## Build Command (if needed)

```bash
# Build for simulator
xcodebuild -project SceneSnap.xcodeproj -scheme SceneSnap -sdk iphonesimulator build

# Or open in Xcode and build there
open SceneSnap.xcodeproj
```

