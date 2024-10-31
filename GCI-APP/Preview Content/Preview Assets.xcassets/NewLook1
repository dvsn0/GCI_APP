// Font Changes and Rounded Buttons
// Updated by Ethan on 10/31/24

import SwiftUI

struct ContentView: View {
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
                        .font(.custom("Helvetica-Thin", size: 45))
                        .foregroundColor(.white)
                    Spacer()
                    Text("Points: \(points)")
                        .font(.custom("Helvetica", size: 25))
                        .foregroundColor(.white)
                }
                .padding()
                
                Spacer()
                
                if showingTimer {
                    TimerView(timeRemaining: $timeRemaining, isBreak: $isBreak, onTimerComplete: {
                        showingTimer = false
                        showingCompletionInput = true
                    })
                } else {
                    Button(action: {
                        showingTimerSetup = true
                    }) {
                        Text("START")
                            .font(.custom("Helvetica-Thin", size: 35))
                            .foregroundColor(.green)
                            .frame(width: 200, height: 200)
                            .background(Color.white)
                            .cornerRadius(30)
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
    }
    
    func updatePoints() {
        if let completedTasks = Int(completionNumber) {
            points += completedTasks
        }
    }
    
    func setupBackgroundTask() {
        UIApplication.shared.beginBackgroundTask(withName: backgroundTaskIdentifier) {
            // End the task if time expires
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
                Section(header: Text("Timer Setup").font(.custom("Helvetica", size: 25)).fontWeight(.regular)) {
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
                        .font(.custom("Helvetica", size: 18))
                    
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
    let onTimerComplete: () -> Void
    
    var body: some View {
        ZStack {
            Color(isBreak ? .white : .black).edgesIgnoringSafeArea(.all)
            Text(timeString(from: timeRemaining))
                .font(.custom("Helvetica", size: 70))
                .foregroundColor(isBreak ? .black : .white)
        }
        .onAppear {
            if timeRemaining == 0 {
                onTimerComplete()
            }
        }
    }
    
    func timeString(from seconds: Int) -> String {
        let minutes = seconds / 60
        let remainingSeconds = seconds % 60
        return String(format: "%02d:%02d", minutes, remainingSeconds)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
