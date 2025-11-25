<!-- 88706f2b-d6be-4728-b2e7-738b25334b2b 842fac22-7389-4bd7-85bd-df8411cfd1b9 -->
# SceneSnap Implementation Plan

## 1. Project Structure & Architecture

### 1.1 Folder Structure

```
SceneSnap/
├── SceneSnap/
│   ├── App/
│   │   ├── SceneSnapApp.swift (main app entry)
│   │   └── AppState.swift (global app state management)
│   ├── Models/
│   │   ├── User.swift
│   │   ├── Post.swift
│   │   ├── Challenge.swift
│   │   ├── Comment.swift
│   │   └── LeaderboardEntry.swift
│   ├── Views/
│   │   ├── Authentication/
│   │   │   ├── LoginView.swift
│   │   │   ├── SignUpView.swift
│   │   │   └── AuthViewModel.swift
│   │   ├── Feed/
│   │   │   ├── FeedView.swift
│   │   │   ├── PostCardView.swift
│   │   │   └── FeedViewModel.swift
│   │   ├── Capture/
│   │   │   ├── CaptureView.swift
│   │   │   ├── CameraView.swift
│   │   │   └── CaptureViewModel.swift
│   │   ├── PostPreview/
│   │   │   ├── PostPreviewView.swift
│   │   │   └── PostPreviewViewModel.swift
│   │   ├── Leaderboard/
│   │   │   ├── LeaderboardView.swift
│   │   │   ├── LeaderboardRowView.swift
│   │   │   └── LeaderboardViewModel.swift
│   │   ├── Profile/
│   │   │   ├── ProfileView.swift
│   │   │   ├── EditProfileView.swift
│   │   │   └── ProfileViewModel.swift
│   │   └── Components/
│   │       ├── BottomNavBar.swift
│   │       ├── WeeklyChallengeBanner.swift
│   │       └── CommentSectionView.swift
│   ├── Services/
│   │   ├── AuthService.swift
│   │   ├── FirestoreService.swift
│   │   ├── StorageService.swift
│   │   ├── ChallengeService.swift
│   │   └── PostService.swift
│   ├── Utilities/
│   │   ├── Constants.swift
│   │   ├── Extensions/
│   │   │   ├── Date+Extensions.swift
│   │   │   └── View+Extensions.swift
│   │   └── Helpers/
│   │       ├── ImagePicker.swift
│   │       └── PermissionManager.swift
│   └── Resources/
│       ├── Assets.xcassets/
│       └── Colors.swift (theme colors)
```

### 1.2 Architecture Pattern

- **MVVM (Model-View-ViewModel)** pattern
- **ObservableObject** for ViewModels
- **@Published** properties for reactive UI updates
- Service layer for Firebase operations

## 2. Data Models

### 2.1 User Model (`Models/User.swift`)

```swift
struct User: Identifiable, Codable {
    let id: String // Firebase Auth UID
    var fullName: String
    var email: String
    var phoneNumber: String?
    var dateOfBirth: Date?
    var username: String
    var profileImageURL: String?
    var bio: String?
    var points: Int // Challenge participation points
    var totalLikes: Int
    var totalPosts: Int
    var createdAt: Date
    var updatedAt: Date
}
```

### 2.2 Post Model (`Models/Post.swift`)

```swift
struct Post: Identifiable, Codable {
    let id: String
    let userId: String
    var username: String
    var profileImageURL: String?
    var mediaURL: String // Firebase Storage URL - user's recreation
    var originalSceneURL: String? // Firebase Storage URL - original movie/TV scene
    var mediaType: MediaType // .video or .photo
    var originalMediaType: MediaType? // Type of original scene media
    var caption: String
    var challengeTag: String // Current weekly challenge name
    var challengeId: String? // Reference to Challenge document
    var location: String?
    var likes: [String] // Array of user IDs who liked
    var likeCount: Int
    var comments: [Comment]
    var commentCount: Int
    var createdAt: Date
    var updatedAt: Date
    
    enum MediaType: String, Codable {
        case video, photo
    }
}
```

### 2.3 Challenge Model (`Models/Challenge.swift`)

```swift
struct Challenge: Identifiable, Codable {
    let id: String
    var title: String
    var description: String
    var tag: String // Short tag for posts (e.g., "RomComWeek")
    var startDate: Date
    var endDate: Date
    var isActive: Bool
    var participantCount: Int
    var createdAt: Date
}
```

### 2.4 Comment Model (`Models/Comment.swift`)

```swift
struct Comment: Identifiable, Codable {
    let id: String
    let postId: String
    let userId: String
    var username: String
    var profileImageURL: String?
    var text: String
    var createdAt: Date
}
```

### 2.5 LeaderboardEntry Model (`Models/LeaderboardEntry.swift`)

```swift
struct LeaderboardEntry: Identifiable {
    let id: String // Post ID
    let userId: String
    var username: String
    var profileImageURL: String?
    var postMediaURL: String
    var likeCount: Int
    var postId: String
}
```

## 3. Firebase Backend Setup

### 3.1 Firebase Configuration

- Add `GoogleService-Info.plist` to project
- Initialize Firebase in `SceneSnapApp.swift`
- Configure Firebase Authentication (Email/Password + Google Sign-In)
- Set up Firestore database
- Configure Firebase Storage with rules

### 3.2 Firestore Collections Structure

```
users/
  {userId}/
  - User document fields

posts/
  {postId}/
  - Post document fields
  - comments/ (subcollection)
      {commentId}/
    - Comment document fields

challenges/
  {challengeId}/
  - Challenge document fields

leaderboard/
  {challengeId}/
  - Aggregated leaderboard entries (updated via Cloud Functions or client-side)
```

### 3.3 Firestore Security Rules

- Users can read all posts, but only edit/delete their own
- Users can read all challenges
- Users can create comments on any post
- Users can update their own profile
- Storage rules: Users can upload to their own folder, read all media

### 3.4 Storage Structure

```
storage/
  users/
    {userId}/
      profile/
        profile_image.jpg
      posts/
        {postId}/
          media.mp4 or media.jpg
```

## 4. UI Screens Implementation

### 4.1 Authentication Flow

#### LoginView (`Views/Authentication/LoginView.swift`)

- Email text field
- Password text field (secure)
- "Log in" button (yellow/primary color)
- Divider with "or" text
- "Continue with Google" button
- Link to SignUpView: "Don't have an account? Sign Up"
- Error message display area
- Loading state during authentication

#### SignUpView (`Views/Authentication/SignUpView.swift`)

- Full Name text field
- Email text field
- Date of Birth picker
- Phone Number text field
- Password text field (secure)
- "Register" button
- Link to LoginView: "Already have an account? Log in"
- Form validation (email format, password strength, required fields)
- Error message display

#### AuthViewModel (`Views/Authentication/AuthViewModel.swift`)

- `@Published var isAuthenticated: Bool`
- `@Published var currentUser: User?`
- `@Published var isLoading: Bool`
- `@Published var errorMessage: String?`
- Functions:
                                                                                                                                - `signIn(email:password:)`
                                                                                                                                - `signUp(userData:)`
                                                                                                                                - `signInWithGoogle()`
                                                                                                                                - `signOut()`
                                                                                                                                - `checkAuthState()`

### 4.2 Main Navigation

#### Root Navigation (`SceneSnapApp.swift`)

- Check authentication state on app launch
- Show LoginView if not authenticated
- Show MainTabView if authenticated
- Use `@StateObject` for AuthViewModel

#### MainTabView (`Views/MainTabView.swift` - new file)

- TabView with three tabs:
                                                                                                                                - Home (FeedView)
                                                                                                                                - Capture (CaptureView) - center button with + icon
                                                                                                                                - Profile (ProfileView)
- Custom tab bar styling (yellow accent color)
- Hide tab bar on specific screens if needed

### 4.3 Feed Screen

#### FeedView (`Views/Feed/FeedView.swift`)

- ScrollView with LazyVStack for posts
- Weekly Challenge banner at top (tappable, shows current challenge)
- Pull-to-refresh functionality
- Infinite scroll/pagination (load more posts)
- Empty state when no posts
- Navigation to post detail (if implemented)

#### PostCardView (`Views/Feed/PostCardView.swift`)

- Header: Profile picture (circular), username, challenge tag badge
- Media display: VideoPlayer or Image based on mediaType
- Caption text
- Interaction bar: Like button (heart icon), Comment button, Share button
- Like count display
- Comment count display
- Timestamp (relative: "2h ago")
- Tap username to navigate to profile
- Tap challenge tag to filter by challenge

#### FeedViewModel (`Views/Feed/FeedViewModel.swift`)

- `@Published var posts: [Post]`
- `@Published var isLoading: Bool`
- `@Published var currentChallenge: Challenge?`
- Functions:
                                                                                                                                - `fetchPosts(limit:lastDocument:)`
                                                                                                                                - `fetchCurrentChallenge()`
                                                                                                                                - `likePost(postId:)`
                                                                                                                                - `unlikePost(postId:)`
                                                                                                                                - `refreshFeed()`

### 4.4 Capture Screen

#### CaptureView (`Views/Capture/CaptureView.swift`)

- Title: "Recreate your scene"
- Camera preview area (full screen)
- Record button (red circle, center-bottom)
- Camera flip button (circular arrow icon)
- "Continue" button (yellow, bottom-left) - enabled after recording
- "Upload from gallery" button (yellow, bottom-right)
- Permission request UI if camera not authorized
- Recording indicator (red dot with timer)

#### CameraView (`Views/Capture/CameraView.swift`)

- AVFoundation camera setup
- Preview layer
- Video recording functionality
- Photo capture functionality
- Camera switching (front/back)
- Flash control
- Recording timer display

#### CaptureViewModel (`Views/Capture/CaptureViewModel.swift`)

- `@Published var recordedVideoURL: URL?`
- `@Published var selectedImage: UIImage?`
- `@Published var isRecording: Bool`
- `@Published var recordingDuration: TimeInterval`
- `@Published var hasPermission: Bool`
- Functions:
                                                                                                                                - `requestCameraPermission()`
                                                                                                                                - `startRecording()`
                                                                                                                                - `stopRecording()`
                                                                                                                                - `switchCamera()`
                                                                                                                                - `pickFromGallery()`
                                                                                                                                - `clearMedia()`

### 4.5 Post Preview Screen

#### PostPreviewView (`Views/PostPreview/PostPreviewView.swift`)

- Title: "Post preview"
- User info section: Profile picture, username, location (editable)
- Media preview: Video player or image viewer
- Caption text field (multiline, light blue background)
- Challenge tag/name text field (light blue background, with suggestions)
- "Post" button (yellow, bottom center)
- Loading overlay during upload
- Cancel/back button

#### PostPreviewViewModel (`Views/PostPreview/PostPreviewViewModel.swift`)

- `@Published var caption: String`
- `@Published var challengeTag: String`
- `@Published var location: String`
- `@Published var isUploading: Bool`
- `@Published var uploadProgress: Double`
- Functions:
                                                                                                                                - `uploadPost(mediaURL:mediaType:)`
                                                                                                                                - `getChallengeSuggestions()`
                                                                                                                                - `validatePost()`

### 4.6 Leaderboard Screen

#### LeaderboardView (`Views/Leaderboard/LeaderboardView.swift`)

- Title: "Leaderboard"
- Current challenge title display
- Scrollable list of leaderboard entries
- Empty state if no entries
- Pull-to-refresh
- "Join Challenge" button (yellow, bottom center) - navigates to CaptureView

#### LeaderboardRowView (`Views/Leaderboard/LeaderboardRowView.swift`)

- Rank number (1, 2, 3...)
- Profile picture (circular)
- Username
- Like count with heart icon
- Optional: Thumbnail of post
- Tap to view post detail

#### LeaderboardViewModel (`Views/Leaderboard/LeaderboardViewModel.swift`)

- `@Published var entries: [LeaderboardEntry]`
- `@Published var currentChallenge: Challenge?`
- `@Published var isLoading: Bool`
- Functions:
                                                                                                                                - `fetchLeaderboard(challengeId:)`
                                                                                                                                - `fetchCurrentChallenge()`
                                                                                                                                - `refreshLeaderboard()`

### 4.7 Profile Screen

#### ProfileView (`Views/Profile/ProfileView.swift`)

- Title: "Profile Page"
- Profile header: Profile picture (circular, large), username
- User details section:
                                                                                                                                - Email
                                                                                                                                - Phone number
                                                                                                                                - Date of birth
- Stats section:
                                                                                                                                - Points (based on challenges)
                                                                                                                                - Total likes received
                                                                                                                                - Total posts
- "Update Bio" button (yellow, bottom center)
- Logout button (top-right or bottom)
- User's posts grid (optional: show user's posts)

#### EditProfileView (`Views/Profile/EditProfileView.swift`)

- Editable fields: Bio, username, profile picture
- Save button
- Cancel button

#### ProfileViewModel (`Views/Profile/ProfileViewModel.swift`)

- `@Published var user: User?`
- `@Published var userPosts: [Post]`
- `@Published var isLoading: Bool`
- Functions:
                                                                                                                                - `fetchUserProfile(userId:)`
                                                                                                                                - `updateProfile(updates:)`
                                                                                                                                - `uploadProfileImage(image:)`
                                                                                                                                - `fetchUserPosts(userId:)`

## 5. Services Layer

### 5.1 AuthService (`Services/AuthService.swift`)

- Firebase Auth wrapper
- `signIn(email:password:) -> Result<User, Error>`
- `signUp(email:password:userData:) -> Result<User, Error>`
- `signInWithGoogle() -> Result<User, Error>`
- `signOut() -> Void`
- `getCurrentUser() -> User?`
- `observeAuthState() -> AnyPublisher<User?, Never>`

### 5.2 FirestoreService (`Services/FirestoreService.swift`)

- Generic Firestore operations
- `createDocument(collection:data:) -> String?`
- `fetchDocument(collection:id:) -> T?`
- `updateDocument(collection:id:data:) -> Bool`
- `deleteDocument(collection:id:) -> Bool`
- `fetchCollection(collection:query:) -> [T]`
- `listenToCollection(collection:query:) -> AnyPublisher<[T], Error>`

### 5.3 StorageService (`Services/StorageService.swift`)

- `uploadMedia(fileURL:userId:postId:completion:) -> String?` (returns download URL)
- `uploadProfileImage(image:userId:completion:) -> String?`
- `deleteMedia(path:) -> Bool`
- Progress tracking for uploads

### 5.4 PostService (`Services/PostService.swift`)

- `createPost(post:mediaURL:completion:)`
- `fetchPosts(limit:lastDocument:completion:)`
- `fetchPostById(id:completion:)`
- `likePost(postId:userId:)`
- `unlikePost(postId:userId:)`
- `addComment(postId:comment:completion:)`
- `fetchComments(postId:completion:)`
- `deletePost(postId:)`

### 5.5 ChallengeService (`Services/ChallengeService.swift`)

- `fetchCurrentChallenge(completion:)`
- `fetchChallengeById(id:completion:)`
- `fetchAllChallenges(completion:)`
- `createChallenge(challenge:completion:)` (admin only)
- `updateChallenge(id:updates:completion:)` (admin only)

## 6. Utilities & Helpers

### 6.1 PermissionManager (`Utilities/Helpers/PermissionManager.swift`)

- `requestCameraPermission(completion:)`
- `requestMicrophonePermission(completion:)`
- `requestPhotoLibraryPermission(completion:)`
- `checkPermissionStatus(type:) -> PermissionStatus`

### 6.2 ImagePicker (`Utilities/Helpers/ImagePicker.swift`)

- UIImagePickerController wrapper for SwiftUI
- Photo library access
- Video selection from gallery

### 6.3 Constants (`Utilities/Constants.swift`)

- App-wide constants:
                                                                                                                                - `MAX_VIDEO_DURATION = 60.0` (seconds)
                                                                                                                                - `MAX_CAPTION_LENGTH = 500`
                                                                                                                                - `POSTS_PER_PAGE = 20`
                                                                                                                                - Firebase collection names
                                                                                                                                - Storage paths

### 6.4 Theme Colors (`Resources/Colors.swift`)

- Primary yellow color
- Accent colors
- Background colors
- Text colors

## 7. Navigation Flow

### 7.1 App Launch Flow

1. App starts → Check Firebase Auth state
2. If authenticated → Fetch user data → Show MainTabView
3. If not authenticated → Show LoginView

### 7.2 Authentication Flow

1. LoginView → User enters credentials → AuthService.signIn() → On success → MainTabView
2. LoginView → "Sign Up" link → SignUpView
3. SignUpView → User fills form → AuthService.signUp() → Create user document in Firestore → MainTabView

### 7.3 Post Creation Flow

1. MainTabView → Tap "+" (Capture tab) → CaptureView
2. CaptureView → Record video or select from gallery → "Continue" → PostPreviewView
3. PostPreviewView → User adds caption/challenge tag → "Post" → Upload to Storage → Create Firestore document → Navigate to FeedView

### 7.4 Feed Interaction Flow

1. FeedView → Scroll through posts → Tap like → Update Firestore → Update UI
2. FeedView → Tap comment → Show comment section → Add comment → Update Firestore
3. FeedView → Tap challenge banner → LeaderboardView
4. FeedView → Tap username → ProfileView (that user's profile)

### 7.5 Leaderboard Flow

1. LeaderboardView → Shows top posts for current challenge → Tap "Join Challenge" → CaptureView

## 8. Key Features Implementation Details

### 8.1 Weekly Challenges

- Challenge document in Firestore with startDate and endDate
- Query posts by challengeId and createdAt within date range
- Leaderboard aggregates likes for posts in current challenge
- Challenge banner on FeedView shows current challenge title
- Auto-update when new challenge starts (check on app launch and feed refresh)

### 8.2 Like System

- Store array of user IDs in Post document's `likes` field
- Update `likeCount` field (can be computed or stored)
- Real-time listener on posts for like updates
- Optimistic UI updates (update immediately, rollback on error)

### 8.3 Comment System

- Comments stored as subcollection under each post
- Fetch comments on-demand (lazy load)
- Real-time listener for new comments
- Display comment count on post card

### 8.4 Points System

- Award points when user posts to a challenge (e.g., 10 points)
- Award bonus points for top 3 leaderboard positions (e.g., 50, 30, 20)
- Update user's points field in Firestore
- Display points on ProfileView

### 8.5 Media Handling

- Video: Use AVFoundation for recording, AVPlayer for playback
- Photo: Use UIImagePickerController or PHPickerViewController
- Compression: Compress videos before upload (reduce file size)
- Thumbnail generation: Generate thumbnail for videos
- Storage: Upload to Firebase Storage, get download URL, store URL in Firestore

## 9. Dependencies & Packages

### 9.1 Swift Package Manager Dependencies

- `firebase-ios-sdk` (Authentication, Firestore, Storage)
- `GoogleSignIn` (for Google authentication)
- `SDWebImageSwiftUI` (for async image loading) - optional
- `AVFoundation` (built-in, for camera)

### 9.2 Podfile (if using CocoaPods)

- Firebase/Auth
- Firebase/Firestore
- Firebase/Storage
- GoogleSignIn

## 10. Testing Considerations

### 10.1 Unit Tests

- ViewModel logic
- Service layer methods
- Data model encoding/decoding

### 10.2 UI Tests

- Authentication flow
- Post creation flow
- Navigation between screens

### 10.3 Manual Testing Checklist

- Camera permissions
- Video recording and playback
- Image upload from gallery
- Firebase connectivity
- Offline behavior
- Error handling (network errors, invalid credentials)

## 11. Performance Optimizations

### 11.1 Media Optimization

- Compress videos before upload
- Generate thumbnails for videos
- Lazy load images/videos in feed
- Cache profile pictures

### 11.2 Firestore Optimization

- Use pagination for feed (limit queries)
- Index frequently queried fields (challengeId, createdAt, likeCount)
- Use listeners only when necessary
- Batch writes when possible

### 11.3 UI Optimization

- Use LazyVStack for feed
- Implement image caching
- Debounce search/filter operations
- Optimize video player memory usage

## 12. Security Considerations

### 12.1 Authentication

- Enforce strong password requirements
- Validate email format
- Secure token storage (Firebase handles this)

### 12.2 Data Validation

- Validate all user inputs
- Sanitize text inputs (prevent injection)
- Validate file types and sizes before upload

### 12.3 Firestore Rules

- Users can only edit their own posts
- Users can only delete their own comments
- Read access for public content (posts, challenges)
- Write access restricted to authenticated users

## 13. Deployment Checklist

### 13.1 Pre-Deployment

- [ ] Configure Firebase project for production
- [ ] Set up proper Firestore security rules
- [ ] Configure Storage security rules
- [ ] Test on physical devices (iOS)
- [ ] Test camera and microphone permissions
- [ ] Verify Google Sign-In configuration
- [ ] Test offline scenarios
- [ ] Performance testing with large datasets

### 13.2 App Store Preparation

- [ ] App icon and launch screen
- [ ] Privacy policy (required for camera/microphone)
- [ ] App Store description
- [ ] Screenshots
- [ ] TestFlight beta testing

## 14. Future Enhancements (Out of Scope for MVP)

- Side-by-side comparison feature (original scene + recreation)
- Video editing tools (filters, trim, effects)
- Push notifications for likes/comments
- Direct messaging between users
- Follow/unfollow system
- Hashtag system
- Search functionality
- Report/flag inappropriate content
- Admin panel for challenge management