# InfoShorts


**InfoShorts** is a SwiftUI-based iOS application designed to provide users with concise and insightful summaries of the latest news articles and information across various domains. By leveraging powerful APIs, the app fetches current topics and generates succinct summaries, enabling users to stay informed without the need to read lengthy articles.


## ✨ Features

- **Automatic Summarization:** Summaries are generated automatically when viewing an article, eliminating the need for manual intervention.
- **Toggle Summary Sizes:** Users can switch between a full summary and a concise version (approximately 20 lines) based on their preference.
- **Real-Time Information Fetching:** Fetches the latest news and information across various categories using the NewsAPI.
- **Bookmarking:** Save favorite articles for later reading.
- **Sharing:** Easily share articles through other applications.
- **User-Friendly UI:** Modern and intuitive interface with smooth animations and transitions.
- **Customization:** Choose from different accent colors to personalize the app's appearance.
- **Dark Mode Support:** Toggle between light and dark themes for comfortable reading in any environment.


## 🛠 Technologies Used

- **SwiftUI:** Building the user interface with declarative Swift syntax.
- **Combine:** Managing asynchronous events and data streams.
- **NewsAPI:** Fetching the latest news articles from various sources.
- **Hugging Face API:** Generating summaries of news articles using advanced NLP models.
- **UserDefaults:** Persisting user data such as bookmarks.
- **AsyncImage:** Loading images asynchronously for better performance.

## 🚀 Getting Started

Follow these instructions to set up and run the project on your local machine.

### 📝 Prerequisites

- **Xcode 14.0** or later
- **iOS 15.0** or later
- **Swift 5.5** or later
- Valid API keys for [NewsAPI](https://newsapi.org/) and [Hugging Face](https://huggingface.co/)

### 📥 Installation

1. **Clone the Repository**

   ```bash
   git clone https://github.com/yourusername/InfoShorts.git
2. **Navigate to the Project  Directory**
   ```bash
   cd InfoShorts
3. **Open the Project in Xcode**
   ```bash
   open InfoShorts.xcodeproj
🔑 API Keys Configuration
NewsAPI Key

Sign up at NewsAPI to obtain your API key.

Open NewsViewModel.swift and replace "YOUR_NEWSAPI_KEY" with your actual NewsAPI key.
```bash
request.setValue("Bearer YOUR_NEWSAPI_KEY", forHTTPHeaderField: "Authorization")
```
Hugging Face API Key

Sign up at Hugging Face to obtain your API key.

Open SummarizationViewModel.swift and replace "YOUR_HUGGINGFACE_API_KEY" with your actual Hugging Face API key.

```bash
request.setValue("Bearer YOUR_HUGGINGFACE_API_KEY", forHTTPHeaderField: "Authorization")
```
🎮 Usage
Launching the App

Run the app on a simulator or a physical device via Xcode.
Fetching News Articles

Upon launching, the app fetches the latest news articles across selected categories.
Use the search bar to find specific news topics.
Viewing Article Details

Tap on an article to view its details, including an automatically generated summary.
Toggle between full and concise summaries using the provided button.
Bookmarking Articles

Tap the bookmark icon to save articles for later reading.
Access your bookmarks from the "Bookmarks" tab.
Sharing Articles

Use the share button to share articles through other apps like Messages, Mail, or Social Media.
Customizing Appearance

Navigate to the "Settings" tab to choose your preferred accent color for the app.
🛠 Development Process
Developing InfoShorts involved several key steps and design decisions:

Project Setup

Initiated a SwiftUI project in Xcode.
Organized the project structure into Models, ViewModels, and Views for better maintainability.
Integrating NewsAPI

Utilized NewsAPI to fetch the latest news articles.
Implemented NewsViewModel to handle API requests and manage the fetched data.
Implementing Summarization

Leveraged Hugging Face's NLP models to generate summaries of news articles.
Developed SummarizationViewModel to manage the summarization process, including handling different summary lengths.
Designing the UI

Crafted a modern and intuitive user interface using SwiftUI components.
Incorporated smooth animations and transitions to enhance user experience.
Bookmarking and Sharing

Implemented bookmarking functionality using UserDefaults for data persistence.
Enabled sharing of articles through native iOS sharing options.
Error Handling and User Feedback

Ensured robust error handling for network requests and API responses.
Provided user feedback through alerts and loading indicators during data fetching and summarization.
Customization Features

Added options for users to customize the app's appearance by selecting different accent colors.
Testing and Debugging

Performed extensive testing on various simulators and devices to ensure smooth functionality.
Resolved compilation errors and optimized code for performance.
🤝 Contributing
Contributions are welcome! Please follow these steps to contribute to InfoShorts:

Fork the Repository

Click the "Fork" button at the top right corner of the repository page.

Clone Your Fork

```bash
git clone https://github.com/musab-sheikh/InfoShorts.git
```
Create a New Branch

```bash
git checkout -b feature/YourFeatureName
```
Make Your Changes

Implement your feature or fix the issue.
Ensure your code follows the project's coding standards.
Commit Your Changes

```bash
git commit -m "Add feature: YourFeatureName"
```
Push to Your Fork

```bash
git push origin feature/YourFeatureName
```
Create a Pull Request

Navigate to the original repository and click "Compare & pull request".
Provide a clear description of your changes and submit the pull request.
📝 License
This project is licensed under the MIT License. You are free to use, modify, and distribute this code as per the license terms.

📫 Contact
For any inquiries, suggestions, or feedback, feel free to reach out:

Email: faizanmusab54@gmail.com
GitHub: @musab-sheikh
LinkedIn: https://www.linkedin.com/in/mirza-musab-baig-ab66a4214/
