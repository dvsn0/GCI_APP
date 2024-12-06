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

## CONTENTS OF PROJECT FILES

### 1. **Main.swift**
- Entry point of the application.
- Manages navigation between primary screens: Pomodoro timer, gacha system, and settings.

### 2. **PomodoroTimer.swift**
- Implements the customizable Pomodoro timer.
- Allows users to set work/break intervals and tracks progress.

### 3. **GachaSystem.swift**
- Implements gamified reward mechanics.
- Handles random item generation and user inventory updates.

### 4. **InventoryView.swift**
- Displays the user's collection of rewards in an intuitive interface.
- Includes sorting and filtering options for better usability.

### 5. **GrayscaleMode.swift**
- Adds a grayscale feature to enhance focus and reduce distractions.
- Provides toggle functionality for enabling/disabling grayscale mode.

### 6. **README.txt**
- Comprehensive project documentation.
- Includes author info, project description, file summaries, and running instructions.

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
