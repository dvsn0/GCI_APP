//
//  GachaScreen.swift
//  GCI-APP
//
//  Created by Brent Matthew Ortizo on 10/26/24.
//

import SwiftUI
import ConfettiSwiftUI

struct GachaScreen: View {
    @Environment(\.presentationMode) var presentationMode // For dismissing the view

    // State to hold the shape and the item description
    @State private var itemShape: String = ""
    @State private var showPopup: Bool = false
    @State private var shapeColor: Color = .clear
    @State private var shapeType: String = ""
    
    // Confetti variables
    @State private var confettiCounter = 0
    
    // Animation variables
    @State private var isBoxOpening = false
    @State private var boxScale: CGFloat = 1.0
    @State private var moveComponentsOffScreen = false // Track if text, button, and points should move
    @State private var boxPosition: CGFloat = UIScreen.main.bounds.height // Initial position off-screen

    // User's points
    @State private var userPoints: Int = 1581
    let rollCost: Int = 500

    // Function to simulate gacha roll
    func rollGacha() {
        let randomRoll = Int.random(in: 1...100)
        if randomRoll <= 50 {
            // 50% chance to get a notebook (Blue Square)
            itemShape = "You rolled a Notebook!"
            shapeColor = .blue
            shapeType = "square"
        } else if randomRoll <= 80 {
            // 30% chance to get a plant pot (Yellow Triangle)
            itemShape = "You rolled a Plant Pot!"
            shapeColor = .yellow
            shapeType = "triangle"
        } else {
            // 10% chance to get a computer (Red Circle)
            itemShape = "You rolled a Computer!"
            shapeColor = .red
            shapeType = "circle"
        }
        
        // Deduct points when rolling
        if userPoints >= rollCost {
            userPoints -= rollCost
        }

        // Move text, button, and points out of the screen
        withAnimation(.easeOut(duration: 1.0)) {
            moveComponentsOffScreen = true
        }

        // Move the box up from the bottom of the screen
        withAnimation(.easeInOut(duration: 1.0).delay(1.0)) {
            boxPosition = UIScreen.main.bounds.height / 2 // Move to middle
        }
        
        // Trigger confetti after a delay (to sync with animation)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            confettiCounter += 1
            showPopup = true // Show popup after the box "opens"
        }

        // Start box opening animation
        withAnimation(.easeIn(duration: 1.0).delay(1.0)) {
            isBoxOpening = true
            boxScale = 1.5 // Scale up the box
        }
        
        // Reset animation and restore the UI after the popup is dismissed
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.2) {
            withAnimation {
                isBoxOpening = false
                boxScale = 1.0 // Reset scale
            }
        }
    }

    var body: some View {
        ZStack {
            // Main VStack to hold the UI elements
            VStack {
                // Top HStack for the "Go Back" button and the points display
                HStack {
                    // Go Back button
                    Button(action: {
                        // Dismiss the current view and go back
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        HStack(spacing: 5) {
                            Image(systemName: "house.fill")
                            Text("Go Back")
                                .font(.headline)
                        }
                        .padding(8)
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(25)
                    }
                    .padding(.leading, 20)

                    Spacer()

                    // User points display in top right, moves off screen when rolling
                    HStack(spacing: 5) {
                        ZStack {
                            Circle()
                                .fill(Color.yellow.opacity(0.9))
                                .frame(width: 25, height: 25)
                            
                            Circle()
                                .fill(Color.yellow.opacity(0.6))
                                .frame(width: 15, height: 15)
                        }
                        
                        Text("\(userPoints)")
                            .font(.headline)
                            .foregroundColor(.black)
                    }
                    .padding(8)
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(25)
                    .padding(.trailing, 20)
                }
                .offset(x: moveComponentsOffScreen ? 1000 : 0) // Moves right out of screen
                
                Spacer()

                Text("Gacha Roll")
                    .font(.largeTitle)
                    .padding()
                    .offset(x: moveComponentsOffScreen ? -1000 : 0) // Moves left out of screen
                
                Button(action: {
                    // Only roll if the user has enough points
                    if userPoints >= rollCost {
                        rollGacha() // Trigger the gacha roll
                    }
                }) {
                    Text("Roll for an Item - \(rollCost) points")
                        .font(.headline)
                        .padding()
                        .background(userPoints >= rollCost ? Color.blue : Color.gray)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .disabled(userPoints < rollCost) // Disable if not enough points
                .offset(x: moveComponentsOffScreen ? -1000 : 0) // Moves left out of screen

                Spacer()
            }

            // Box that opens during the roll, moves up from the bottom to the middle
            RoundedRectangle(cornerRadius: 15)
                .fill(isBoxOpening ? Color.green : Color.gray)
                .frame(width: 150, height: 150)
                .scaleEffect(boxScale)
                .position(x: UIScreen.main.bounds.width / 2, y: boxPosition) // Position to control box movement

            // Confetti cannon overlay to ensure it appears on top of the popup
            ConfettiCannon(counter: $confettiCounter, num: 30, colors: [.blue, .yellow, .red], confettiSize: 20, rainHeight: 500, radius: 200)
            // Array for the shapes
            var Shapes = [String]()
            // Custom popup to show the shape after the roll
            if showPopup {
                ZStack {
                    Color.black.opacity(0.4) // Dim background
                        .edgesIgnoringSafeArea(.all)
                    
                    VStack {
                        Text(itemShape)
                            .font(.headline)
                            .padding()
                        
                        // Display the shape
                        if shapeType == "square" {
                            Shapes.append("square")
                            Rectangle()
                                .fill(shapeColor)
                                .frame(width: 100, height: 100)
                        } else if shapeType == "triangle" {
                            Shapes.append("triangle")
                            CustomTriangle()
                                .fill(shapeColor)
                                .frame(width: 100, height: 100)
                        } else if shapeType == "circle" {
                            Shapes.append("Circle")
                            Circle()
                                .fill(shapeColor)
                                .frame(width: 100, height: 100)
                        }
                        
                        Button("Close") {
                            showPopup = false
                            withAnimation {
                                moveComponentsOffScreen = false // Bring the components back to original positions
                                boxPosition = UIScreen.main.bounds.height // Move box off screen again
                            }
                        }
                        .padding()
                        .background(Color.gray)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(15)
                    .shadow(radius: 20)
                }
            }
        }
        .navigationBarBackButtonHidden(true) // Hide the default back button
        NavigationView {
            VStack {
                NavigationLink(destination: GachaItems()){
                    Text("Go To Items")
                    .font(.headline)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
            }
            
        }
        .buttonStyle(.borderProminent)
    }
}

// Custom shape for triangle
struct CustomTriangle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.minY)) // top point
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY)) // bottom-left point
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY)) // bottom-right point
        path.closeSubpath()
        return path
    }
}

#Preview {
    GachaScreen()
}
