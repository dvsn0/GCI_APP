## AUTHOR INFO
- **Team Members:**
  - **Brent Matthew Ortizo**  
    - Student ID: 2452997  
    - Email: ortizo@chapman.edu  
  - **David Sohn**  
    - Student ID: 2456258  
    - Email: josohn@chapman.edu  
  - **Ethan Lopez**  
    - Student ID: 2425516  
    - Email: etlopez@chapman.edu  
  - **Johny Dabbous**  
    - Student ID: 2445313  
    - Email: jdabbous@chapman.edu  
- **Course Number & Section:** GCI-200-03  
- **Project Name:** PomoGach (Pomodoro + Gacha System)  

---

## PROJECT DESCRIPTION
This app addresses social media overuse through productivity tools like a Pomodoro timer, gamification via a gacha reward system, and a grayscale mode to enhance focus.

---

## CONTENTS OF PROJECT FILES'S KEY FUNCTIONS WITHIN GCI_APPApp.swift

### **MainView**
- Acts as the primary hub of the application, managing navigation between the **Pomodoro Timer** and **Gacha System**.
- Uses a **TabView** for seamless transitions between features, providing an intuitive user interface.
- Integrates a **grayscale functionality** triggered when the Pomodoro Timer is active, creating a distraction-free environment for improved focus.
- Includes smooth **UI animations** for transitioning between active and inactive timer states, enhancing the user experience.

---

### **ContentView**
- Implements the core **Pomodoro Timer** functionality, allowing users to:
  - Set up and manage work and break intervals.
  - Track time remaining in a session and whether the user is in a work or break period.
  - Monitor the number of completed tasks and total points earned.
- Provides a **task setup interface**, enabling users to define session duration, task goals, and preferred Pomodoro intervals (e.g., 25-5 or 50-10).
- Features a **completion input system** to log completed tasks after each session, ensuring users receive appropriate rewards in points.

---

### **TimerSetupView**
- Offers a user-friendly interface for customizing the Pomodoro Timer:
  - **Hours and Minutes:** Allows users to select session duration using picker wheels.
  - **Task Goals:** Enables input of the total number of tasks planned for the session.
  - **Pomodoro Intervals:** Provides predefined cycles such as 25-5 or 50-10 for work and break durations.
- Features a clean and simple design using **SwiftUI Form** and **Picker** components.
- Includes intuitive navigation options with **Cancel** and **Confirm** buttons for effortless interaction.

---

### **TimerView**
- Displays a live countdown timer for active Pomodoro sessions.
- Dynamically updates the interface based on the current session state:
  - **Work Period:** Displays a black background with white text.
  - **Break Period:** Displays a white background with black text.
- Automatically transitions between work and break intervals based on the selected Pomodoro cycle.
- Alerts the user when the timer completes and transitions to the **CompletionInputView** for task verification.

---

### **CompletionInputView**
- Collects user input to log the number of completed tasks after a Pomodoro session.
- Features a **picker interface** for selecting the number of completed tasks.
- Updates the **point total** based on completed tasks, rewarding productivity and reinforcing user engagement.
- Includes an accessible design to ensure a smooth transition back to the main view after task input.

---

### **GachaScreen**
- Implements a **gamified reward system** to motivate users by converting earned points into virtual rewards.
- Features:
  - **Roll Mechanic:** Users spend points to receive randomized items like "Notebook," "Plant Pot," or "Computer," represented by different shapes and colors.
  - **Inventory Management:** Displays the user's earned items in a visually appealing grid layout.
  - **Animations:** Includes confetti effects and interactive pop-ups for successful rolls.
  - **Point Deduction:** Deducts points for each roll, maintaining fairness and consistency.
- Designed to encourage ongoing app use by linking productivity to enjoyable, gamified rewards.

---

### **Utility Functions**
- **`startTimer`**:  
  - Initializes and manages the countdown for active Pomodoro sessions.
  - Uses Swift’s **Timer** class to decrement time and transition between work and break states automatically.

- **`updatePomodoroState`**:  
  - Determines whether the user is in a work or break period based on the elapsed time and selected Pomodoro interval.
  - Ensures smooth transitions to maintain focus and motivation.

- **`resetApp`**:  
  - Resets session-related variables, such as timer length, task numbers, and session progress.
  - Prepares the app for a new session without retaining data from previous ones.

- **`rollGacha`**:  
  - Implements the logic for the Gacha System, generating random rewards based on predefined probabilities.
  - Updates the user’s inventory and triggers animations and visual effects for successful rolls.

---

## FEATURES COMPLETED
- Functional Pomodoro timer for task management.
- Fully implemented gacha system for rewarding productivity.
- Interactive inventory for managing virtual items.
- Grayscale mode to support focused usage.

---

## DEPENDENCIES
This project requires the following dependencies:

1. **Swift/SwiftUI**  
   - Ensure XCode is updated to the latest version, which includes Swift/SwiftUI support.

2. **ConfettiSwiftUI**  
   - Install via Swift Package Manager by adding the following URL to your project:  
     ```
     https://github.com/simibac/ConfettiSwiftUI
     ```
   - **License:** MIT License  
     - Copyright (c) 2020 Simon Bachmann  
     - Permission is granted to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the software. The original copyright notice and permission text must be included in all copies or substantial portions of the software.  
     - The software is provided "as is," without warranty of any kind.  

---

## KNOWN LIMITATIONS
- Integration of Apple’s Screen Time and Accessibility APIs is pending.
- Firebase backend features (user authentication, friend lists) will be added in GCI-250.
- UI/UX elements require further refinement (animations, graphics).

---

## SOURCES
- [Swift Language Overview](https://developer.apple.com/swift/)
- [Swift Documentation](https://developer.apple.com/documentation/swift/)
- [Swift Programming Basics](https://docs.swift.org/swift-book/documentation/the-swift-programming-language/thebasics/)
- [ConfettiSwiftUI GitHub Repository](https://github.com/simibac/ConfettiSwiftUI/)

---

## RUNNING INSTRUCTIONS
1. Open the project in **XCode**.
2. Ensure all dependencies are installed:
   - Install Swift/SwiftUI.
   - Install ConfettiSwiftUI via Swift Package Manager.
3. Build and run the app by selecting a target simulator and pressing **Cmd + R**.

---

## FUTURE GOALS
- Integrate Firebase for backend functionality in GCI-250.
- Complete advanced productivity features using Apple’s APIs.
- Refine UI/UX design with animations, graphics, and improved usability.
- Prepare the app for deployment on the Apple App Store, ensuring compliance with all regulations.

---
