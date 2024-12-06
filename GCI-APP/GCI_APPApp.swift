//
//  GCI_APPApp.swift
//  GCI-APP
//
//  Created by David on 10/24/24.
//

import SwiftUI
import ConfettiSwiftUI

@main
struct GCI_APPApp: App {
    var body: some Scene {
        WindowGroup {
            MainView()
        }
    }
}

struct MainView: View {
    @State private var selectedTab = 1
    @State private var isTimerActive = false
    
    var body: some View {
        TabView(selection: $selectedTab) {
            GachaScreen(isTimerActive: $isTimerActive)
                .tag(0)
            
            ContentView(isTimerActive: $isTimerActive)
                .tag(1)
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
        .ignoresSafeArea()
        .grayscale(isTimerActive ? 1 : 0)
        .animation(.easeInOut, value: isTimerActive)
        // Removed the disabled modifier to allow navigation while timer is active
    }
}

struct ContentView: View {
    @Binding var isTimerActive: Bool
    @State private var showingTimerSetup = false
    @State private var showingTimer = false
    @State private var showingCompletionInput = false
    @State private var timerLength = 0
    @State private var taskNumber = ""
    @State private var completionNumber = ""
    @State private var timeRemaining = 0
    @State private var timer: Timer?
    @State private var pomodoroInterval = "25-5"
    @State private var isBreak = false
    @AppStorage("points") private var points = 0
    
    let backgroundTaskIdentifier = "com.focusapp.timer"
    
    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            
            VStack {
                HStack {
                    Text("Focus")
                        .font(.custom("Helvetica-Thin", size: 24))
                        .foregroundColor(.white)
                    Spacer()
                    Text("Points: \(points)")
                        .font(.custom("Helvetica", size: 18))
                        .foregroundColor(.white)
                }
                .padding()
                
                Spacer()
                
                if showingTimer {
                    TimerView(timeRemaining: $timeRemaining, isBreak: $isBreak, isTimerActive: $isTimerActive, onTimerComplete: {
                        showingTimer = false
                        showingCompletionInput = true
                        isTimerActive = false
                    })
                } else {
                    Button(action: {
                        showingTimerSetup = true
                    }) {
                        Text("START")
                            .font(.custom("Helvetica-Thin", size: 24))
                            .foregroundColor(.black)
                            .frame(width: 200, height: 200)
                            .background(Color.white)
                    }
                }
                
                Spacer()
            }
        }
        .sheet(isPresented: $showingTimerSetup) {
            TimerSetupView(timerLength: $timerLength, taskNumber: $taskNumber, pomodoroInterval: $pomodoroInterval, onConfirm: {
                showingTimerSetup = false
                timeRemaining = timerLength
                showingTimer = true
                isTimerActive = true
                startTimer()
            })
        }
        .sheet(isPresented: $showingCompletionInput) {
            CompletionInputView(completionNumber: $completionNumber, maxTasks: Int(taskNumber) ?? 0, onConfirm: {
                showingCompletionInput = false
                updatePoints()
                resetApp()
            })
        }
        .onAppear {
            setupBackgroundTask()
        }
    }
    
    func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if timeRemaining > 0 {
                timeRemaining -= 1
                updatePomodoroState()
            } else {
                timer?.invalidate()
                showingTimer = false
                showingCompletionInput = true
                isTimerActive = false
            }
        }
    }
    
    func updatePomodoroState() {
        let (workDuration, breakDuration) = pomodoroInterval == "25-5" ? (25 * 60, 5 * 60) : (50 * 60, 10 * 60)
        let totalCycleDuration = workDuration + breakDuration
        let timeInCurrentCycle = timerLength - timeRemaining
        isBreak = (timeInCurrentCycle % totalCycleDuration) >= workDuration
    }
    
    func resetApp() {
        timerLength = 0
        taskNumber = ""
        completionNumber = ""
        timeRemaining = 0
        timer?.invalidate()
        timer = nil
        isBreak = false
        isTimerActive = false
    }
    
    func updatePoints() {
        if let completedTasks = Int(completionNumber) {
            points += completedTasks
        }
    }
    
    func setupBackgroundTask() {
        UIApplication.shared.beginBackgroundTask(withName: backgroundTaskIdentifier) {
            UIApplication.shared.endBackgroundTask(UIBackgroundTaskIdentifier.invalid)
        }
    }
}

struct TimerSetupView: View {
    @Binding var timerLength: Int
    @Binding var taskNumber: String
    @Binding var pomodoroInterval: String
    let onConfirm: () -> Void
    @Environment(\.presentationMode) var presentationMode
    
    @State private var hours = 0
    @State private var minutes = 0
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Timer Setup").font(.custom("Helvetica", size: 18))) {
                    HStack {
                        Picker("Hours", selection: $hours) {
                            ForEach(0..<24) { hour in
                                Text("\(hour) h").tag(hour)
                            }
                        }
                        .pickerStyle(WheelPickerStyle())
                        .frame(width: 100)
                        .clipped()
                        
                        Picker("Minutes", selection: $minutes) {
                            ForEach(0..<60) { minute in
                                Text("\(minute) m").tag(minute)
                            }
                        }
                        .pickerStyle(WheelPickerStyle())
                        .frame(width: 100)
                        .clipped()
                    }
                    .font(.custom("Helvetica", size: 16))
                    
                    TextField("Task Number", text: $taskNumber)
                        .keyboardType(.numberPad)
                        .font(.custom("Helvetica", size: 16))
                    
                    Picker("Pomodoro Interval", selection: $pomodoroInterval) {
                        Text("25-5").tag("25-5")
                        Text("50-10").tag("50-10")
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .font(.custom("Helvetica", size: 16))
                }
            }
            .navigationBarTitle("Set Timer", displayMode: .inline)
            .navigationBarItems(
                leading: Button("Cancel") {
                    presentationMode.wrappedValue.dismiss()
                },
                trailing: Button("Confirm") {
                    timerLength = (hours * 3600) + (minutes * 60)
                    onConfirm()
                    presentationMode.wrappedValue.dismiss()
                }
            )
        }
    }
}

struct CompletionInputView: View {
    @Binding var completionNumber: String
    let maxTasks: Int
    let onConfirm: () -> Void
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Completion Input").font(.custom("Helvetica", size: 18))) {
                    Picker("Completed Tasks", selection: $completionNumber) {
                        ForEach(0...maxTasks, id: \.self) { number in
                            Text("\(number)").tag("\(number)")
                        }
                    }
                    .pickerStyle(WheelPickerStyle())
                    .font(.custom("Helvetica", size: 16))
                }
            }
            .navigationBarTitle("Enter Completion", displayMode: .inline)
            .navigationBarItems(trailing: Button("Confirm") {
                onConfirm()
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
}

struct TimerView: View {
    @Binding var timeRemaining: Int
    @Binding var isBreak: Bool
    @Binding var isTimerActive: Bool
    let onTimerComplete: () -> Void
    
    var body: some View {
        ZStack {
            Color(isBreak ? .white : .black).edgesIgnoringSafeArea(.all)
            Text(timeString(from: timeRemaining))
                .font(.custom("Helvetica", size: 70))
                .foregroundColor(isBreak ? .black : .white)
        }
        .onAppear {
            isTimerActive = true
            if timeRemaining == 0 {
                onTimerComplete()
            }
        }
        .onDisappear {
            isTimerActive = false
        }
    }
    
    func timeString(from seconds: Int) -> String {
        let minutes = seconds / 60
        let remainingSeconds = seconds % 60
        return String(format: "%02d:%02d", minutes, remainingSeconds)
    }
}

struct GachaScreen: View {
    @Binding var isTimerActive: Bool
    @State private var inventory: [(shape: String, color: Color)] = []
    @State private var itemShape: String = ""
    @State private var showPopup: Bool = false
    @State private var shapeColor: Color = .clear
    @State private var shapeType: String = ""
    @State private var confettiCounter = 0
    @State private var moveComponentsOffScreen = false
    @State private var boxPosition: CGFloat = UIScreen.main.bounds.height
    @AppStorage("points") private var userPoints: Int = 0
    let rollCost: Int = 5
    
    func rollGacha() {
        let randomRoll = Int.random(in: 1...100)
        var newShape = (shape: "", color: Color.clear)
        
        if randomRoll <= 50 {
            newShape = (shape: "square", color: .blue)
            itemShape = "You rolled a Notebook!"
        } else if randomRoll <= 80 {
            newShape = (shape: "triangle", color: .yellow)
            itemShape = "You rolled a Plant Pot!"
        } else {
            newShape = (shape: "circle", color: .red)
            itemShape = "You rolled a Computer!"
        }
        
        shapeColor = newShape.color
        shapeType = newShape.shape
        
        if userPoints >= rollCost {
            userPoints -= rollCost
            inventory.append(newShape)
        }
        
        withAnimation(.easeOut(duration: 1.0)) {
            moveComponentsOffScreen = true
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            confettiCounter += 1
            showPopup = true
        }
    }
    
    var body: some View {
        ScrollView {
            ZStack {
                VStack {
                    HStack {
                        Spacer()
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
                    .offset(x: moveComponentsOffScreen ? 1000 : 0)
                    
                    Spacer()
                    
                    Text("Gacha Roll")
                        .font(.largeTitle)
                        .padding()
                        .offset(x: moveComponentsOffScreen ? -1000 : 0)
                    
                    Button(action: {
                        if userPoints >= rollCost {
                            rollGacha()
                        }
                    }) {
                        Text("Roll for an Item - \(rollCost) points")
                            .font(.headline)
                            .padding()
                            .background(userPoints >= rollCost ? Color.blue : Color.gray)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .disabled(userPoints < rollCost)
                    .offset(x: moveComponentsOffScreen ? -1000 : 0)
                    
                    Spacer()
                    
                    inventoryView
                }
                
                ConfettiCannon(counter: $confettiCounter, num: 30,
                               colors: [.blue, .yellow, .red],
                               confettiSize: 20,
                               rainHeight: 500,
                               radius: 200)
                
                if showPopup {
                    ZStack {
                        Color.black.opacity(0.4)
                            .edgesIgnoringSafeArea(.all)
                        VStack {
                            Text(itemShape)
                                .font(.headline)
                                .padding()
                            
                            renderShape(shape: shapeType, color: shapeColor)
                            
                            Button("Close") {
                                showPopup = false
                                withAnimation {
                                    moveComponentsOffScreen = false
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
        }
        .buttonStyle(BorderedProminentButtonStyle())
    }
    
    var inventoryView: some View {
        VStack {
            if inventory.isEmpty {
                Text("Your inventory is empty")
                    .font(.headline)
            } else {
                Text("Your Inventory:")
                    .font(.headline)
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))], spacing: 20) {
                    ForEach(inventory.indices, id: \.self) { index in
                        renderShape(shape: inventory[index].shape, color: inventory[index].color)
                    }
                }
            }
        }
        .padding()
    }
    
    @ViewBuilder
    private func renderShape(shape: String, color: Color) -> some View {
        switch shape {
        case "square":
            Rectangle()
                .fill(color)
                .frame(width: 100, height: 100)
        case "circle":
            Circle()
                .fill(color)
                .frame(width: 100, height: 100)
        case "triangle":
            CustomTriangle()
                .fill(color)
                .frame(width: 100, height: 100)
        default:
            EmptyView()
        }
    }
}

struct CustomTriangle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.closeSubpath()
        return path
    }
}

#Preview {
    MainView()
}
