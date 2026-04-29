# News App

A modern, high-performance Flutter news application that provides real-time headlines and category-based news with a premium dark-themed UI.

## Features and Functionality

- **Top Headlines**: Stay updated with the latest news from across the globe.
- **Category Navigation**: Filter news by categories such as Business, Technology, Science, Sports, Health, Entertainment, and General.
- **Global Search**: Find specific articles using the built-in search functionality.
- **Local Bookmarks**: Save your favorite articles for offline access using Hive local storage.
- **Detailed Article View**: Read article summaries and access the full story via an external browser link.
- **Pull-to-Refresh**: Easily update the news feed with the latest content.

## Folder Structure

```text
lib/
├── features/
│   ├── articles/          # News feed and article details
│   │   ├── controller/    # Riverpod providers and logic
│   │   ├── model/         # Article and Source models
│   │   ├── services/      # API and Caching services
│   │   ├── view/          # Main news pages
│   │   └── widgets/       # Reusable article components
│   ├── bookmarks/         # Saved articles feature
│   ├── btm_navbar/        # Bottom navigation implementation
│   └── search/            # Article search functionality
├── utils/                 # Helpers and custom route transitions
├── main.dart              # App entry point
└── hive_registrar.g.dart  # Generated Hive adapters
```

## Animation Highlights

The app features smooth, subtle animations to enhance the user experience:
- **Staggered Entrance**: News feed items fade in and slide up from 20px below with a sequential delay (50ms per item), creating a professional "unfolding" effect.
- **Custom Page Transition**: Navigating to article details uses a custom `FadeSlidePageRoute` that combines a fade-in effect with a slight upward slide (300ms duration), providing a smoother feel than standard OS transitions.
- **Hero Transitions**: Images transition seamlessly between the grid view and the detail screen.

## Screenshots / Screen Recordings

| News Feed | Article Details | Bookmarks |
| :---: | :---: | :---: |
| ![News Feed Placeholder](https://via.placeholder.com/300x600?text=News+Feed) | ![Details Placeholder](https://via.placeholder.com/300x600?text=Article+Details) | ![Bookmarks Placeholder](https://via.placeholder.com/300x600?text=Bookmarks) |

> [!TIP]
> Add your own screenshots or GIFs here to showcase the app's UI and animations!

## APIs Used

This app is powered by the **[NewsAPI.org](https://newsapi.org/)** API.
- **Top Headlines Endpoint**: Used for the main feed and category filtering.
- **Everything Endpoint**: Used for the search functionality.

## Architecture and Dependencies

### Architecture
The app follows a **Feature-first Architecture** combined with the **Controller-Model-View** pattern using Riverpod:
- **Features**: Code is organized by feature (articles, bookmarks, search) for better scalability.
- **State Management**: [Riverpod](https://riverpod.dev/) handles asynchronous data fetching, category switching, and bookmark state.
- **Local Persistence**: [Hive](https://docs.hivedb.dev/) is used for fast, efficient local storage of bookmarked articles.

### Core Dependencies
- **[flutter_riverpod](https://pub.dev/packages/flutter_riverpod)**: Robust state management.
- **[dio](https://pub.dev/packages/dio)**: Powerful HTTP client for API requests.
- **[hive_ce](https://pub.dev/packages/hive_ce)**: Lightweight and fast NoSQL database for bookmarks.
- **[flutter_dotenv](https://pub.dev/packages/flutter_dotenv)**: Secure management of API keys.
- **[url_launcher](https://pub.dev/packages/url_launcher)**: External link handling for full articles.
- **[intl](https://pub.dev/packages/intl)**: Sophisticated date and time formatting.

---

## Getting Started

1.  Clone the repository.
2.  Get a free API key from [NewsAPI.org](https://newsapi.org/).
3.  Create a `.env` file in the root directory and add:
    ```env
    API_KEY=your_api_key_here
    ```
4.  Run `flutter pub get`.
5.  Run the app using `flutter run`.
