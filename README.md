# Newsroom Live Wire

A premium, high-performance news application built with Flutter that delivers real-time global headlines with a sophisticated dark-themed interface. Designed for seamless performance across Mobile, Tablet, and Desktop platforms.

---

## 📱 App Overview

**Newsroom Live Wire** is more than just a news aggregator. It's a modern information hub that combines sleek aesthetics with powerful functionality. Whether you're tracking breaking news on your phone or deep-diving into articles on your desktop, the app adapts perfectly to your workflow.

### Core Features
- **Real-time Headlines**: Instant access to the latest stories worldwide via NewsAPI.
- **Dynamic Categorization**: Filter news by Business, Technology, Science, Sports, Health, Entertainment, and more.
- **Smart Search**: Find exactly what you're looking for with a robust global search engine.
- **Offline Bookmarks**: Save essential articles to your local library using Hive's high-speed NoSQL storage.
- **Interactive Detail View**: Read summaries and launch full articles in a single tap.
- **Pull-to-Refresh**: Keep your finger on the pulse with effortless feed updates.

---

## 🚀 Getting Started

### Prerequisites
- [Flutter SDK](https://docs.flutter.dev/get-started/install) (Latest stable version)
- A free API Key from [NewsAPI.org](https://newsapi.org/)

### Installation

1.  **Clone the repository:**
    ```bash
    git clone https://github.com/MujahidAmin1/News-App.git
    cd News-App
    ```

2.  **Configure Environment Variables:**
    There are two ways to provide your API Key:

    **Option A: Using a `.env` file (Local Development)**
    Create a `.env` file in the `assets/` directory (this ensures it doesn't break CI builds):
    ```env
    API_KEY=your_news_api_key_here
    ```

    **Option B: Using `--dart-define` (Recommended for CI/CD)**
    Pass the key directly during the build or run command (no file needed):
    ```bash
    flutter run --dart-define=API_KEY=your_news_api_key_here
    ```

3.  **Install Dependencies:**
    ```bash
    flutter pub get
    ```

4.  **Run the Application:**
    ```bash
    flutter run
    ```

---

## 🖥️ Platform Adaptation & Support

The app features a **Responsive Architecture** that ensures a premium experience regardless of the device.

### Mobile, Tablet & Web
- **Adaptive Layout**: Transitions between a Bottom Navigation Bar on mobile and a fixed Sidebar on tablets/web screens.
- **Touch-Optimized**: High-performance scrolling and gesture-based navigation.


### Desktop (Windows, macOS, Linux)
- **Keyboard Shortcuts**: Power-user features like `Ctrl+1/2/3` for navigation and `Ctrl+R` to refresh.
- **Native Experience**: Integrated system menu bars (native desktop only) and optimized multi-column layouts.
- **Large Screen Optimization**: Content is intelligently spaced and organized to utilize available screen real estate.

---

## 🎨 Visual Experience

### Screenshots
| News Feed | Article Search | Bookmarks |
| :---: | :---: | :---: |
| [IMAGE_INDICATOR: mobile_feed_screenshot] | [IMAGE_INDICATOR: mobile_search_screenshot] | [IMAGE_INDICATOR: mobile_bookmarks_screenshot] |

| Desktop Layout |
| :---: |
| [IMAGE_INDICATOR: desktop_layout_screenshot] |

### 🎬 Video Demo
[VIDEO_INDICATOR: app_walkthrough_demo]

---

## 🔗 Live Links & Downloads

Experience the app across different platforms:

- **🌐 Live Web Demo**: [LINK_INDICATOR: live_url]
- **📱 Appetize (Virtual Mobile)**: [LINK_INDICATOR: appetize_link]
- **☁️ Cloud Drive (Build Downloads)**: [LINK_INDICATOR: cloud_drive_link]

---

## 🛠️ Technology Stack

- **State Management**: [Riverpod](https://riverpod.dev/) (AsyncNotifier, ProviderScope)
- **Local Storage**: [Hive](https://docs.hivedb.dev/) (High-performance NoSQL for bookmarks)
- **Networking**: [Dio](https://pub.dev/packages/dio) (Robust HTTP client)
- **Architecture**: Feature-first structure (Articles, Search, Bookmarks, Nav)
- **Responsive System**: Custom `LayoutBuilder` with tailored Desktop and Mobile implementations.

---

