### Overview
  ChefBot is an iOS application that generates recipes and helps you create delicious meals based on the ingredients you have available. Powered by OpenAI's advanced model GPT-4.1, ChefBot generates creative recipes and cooking ideas tailored to your specific ingredients and preferences.


### Features
  -Ingredient-Based Recipe Generation: Input whatever ingredients you have on hand, and ChefBot will suggest suitable meal ideas.
  -Smart Recommendations: Get personalized meal ideas based on your available ingredients.
  -Recipe Customization: Modify generated recipes to suit your taste preferences.
  -Save Favorites: Save your favorite recipes to revisit later in the history screen.
  -User-Friendly Interface: Built with SwiftUI for a smooth and intuitive experience.


### Requirements
1. macOS (for development)
2. Xcode 14.0 or later
3. iOS 17.0 or later
4. OpenAI API key
5. Any iPhone iOS 17+ (in case testing on real device)

### Installation & Setup
  # Option 1: Download/Clone from GitHub
  1. Visit the repository at https://github.com/longnguyen39/ChefBot
  2. Click on the "Code" button and select "Download ZIP" (or copy the url and clone it on Xcode)
  3. Extract the ZIP file to your preferred location
  4. Open the project in Xcode by double-clicking the ChefBot.xcodeproj file

  # Option 2: Using the Attached ZIP File
  1. Extract the attached ZIP file to your preferred location
  2. Open the project in Xcode by double-clicking the ChefBot.xcodeproj file


### Building and Running the App
1. Select your target device (iPhone simulator or connect to physical device)
2. Click the "Run" button in Xcode or press Cmd + R
3. Wait for the build process to complete and the app to launch


### How to Use
1. Launch the App: Open ChefBot on your iOS device
2. You will be greeted with the Onboarding screen, asking you to input your name. Then you will be taken to the Home screen
3. Input Ingredients: Enter the ingredients you have available in the label "Add more +"
4. Generate Ideas: Tap the "Generate meals" button to get recipe suggestions
5. Customize: Modify the suggestions according to your preferences. You will be greeted with a Chat screen and an answer from GPT-4
6. Modify recipes: You can type in the text box of the Chat screen whatever you want to modify the recipe, and get a solid answer
7. Save favorite answers: Tap the "Save this answer" button in the bottom ofthe answer to store recipes in your history
8. View History: Access your saved recipes by navigating to the History tab on the top right corner

### Troubleshooting

API Connection Issues: Sometimes the simulator does not work with the API, you can delete the app and run again, or run on real iphone
Build Errors: Make sure you're using the latest Xcode version compatible with the project
Simulator Issues: Delete the app and run it again. Best recommendation is to test on real iphone, as it is less prone to error and more beautiful


### Acknowledgments
  -OpenAI for providing the API that powers the recipe generation
  -The SwiftUI community for resources and inspiration
  -Apple for always making the UI sleek and elegant

### Contact
  -Long Nguyen - longnguyen39ios@gmail.com
  -Project Link: https://github.com/longnguyen39/ChefBot
