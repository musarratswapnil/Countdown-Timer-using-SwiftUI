import SwiftUI

struct ContentView: View {
    @State private var isRunning = false
    @State private var timeElapsed: Double = 0
    @State private var showResetAlert = false
    
    var body: some View {
        VStack(spacing: 50) {
            // Title
            Text("Stopwatch")
                .font(.largeTitle)
                .fontWeight(.semibold)
                .foregroundColor(.white)
                .padding(.top, 50)
                .shadow(radius: 10)
            
            // Stopwatch Timer Display
            GeometryReader { geometry in
                Text(formatTime(seconds: timeElapsed))
                    .font(.system(size: 70, weight: .bold, design: .monospaced))
                    .frame(width: geometry.size.width * 1, height: 120)
                    .background(LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]), startPoint: .topLeading, endPoint: .bottomTrailing))
                    .cornerRadius(20)
                    .foregroundColor(.white)
                    .padding(.bottom, 40)
                    .shadow(radius: 15)
            }
            
            // Control Buttons
            HStack(spacing: 40) {
                // Start/Stop Button
                Button(action: {
                    isRunning.toggle()
                }) {
                    Text(isRunning ? "Stop" : "Start")
                        .font(.title2)
                        .frame(width: 140, height: 60)
                        .background(isRunning ? Color.red : Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(15)
                        .shadow(radius: 8)
                        .scaleEffect(isRunning ? 1.05 : 1)
                        .animation(.easeInOut(duration: 0.2), value: isRunning)
                }
                
                // Reset Button
                Button(action: {
                    showResetAlert = true
                }) {
                    Text("Reset")
                        .font(.title2)
                        .frame(width: 140, height: 60)
                        .background(Color.orange)
                        .foregroundColor(.white)
                        .cornerRadius(15)
                        .shadow(radius: 8)
                        .scaleEffect(1.05)
                        .animation(.easeInOut(duration: 0.2))
                }
                .alert(isPresented: $showResetAlert) {
                    Alert(
                        title: Text("Reset Timer"),
                        message: Text("Are you sure you want to reset the timer?"),
                        primaryButton: .destructive(Text("Reset")) {
                            resetTimer()
                        },
                        secondaryButton: .cancel()
                    )
                }
            }
            .padding(.bottom, 50)
        }
        .padding()
        .background(LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]), startPoint: .topLeading, endPoint: .bottomTrailing))
        .edgesIgnoringSafeArea(.all)
        .onReceive(timer) { _ in
            if isRunning {
                timeElapsed += 0.1  // Increment by 0.1 seconds
            }
        }
    }
    
    // Timer updates every 0.1 second (to make it more responsive)
    let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    
    // Reset the timer
    private func resetTimer() {
        timeElapsed = 0
        isRunning = false
    }
    
    // Format seconds to display as hours:minutes:seconds (HH:MM:SS)
    private func formatTime(seconds: Double) -> String {
        let hours = Int(seconds) / 3600
        let minutes = (Int(seconds) % 3600) / 60
        let secondsPart = Int(seconds) % 60
        
        return String(format: "%02d:%02d:%02d", hours, minutes, secondsPart)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewDevice("iPhone 14 Pro")
    }
}

