import SwiftUI
import AppKit  // For NSSound

struct SoundTesterView: View {
    
    // List of all system sound names available in macOS
    let soundNames = [
        "Basso", "Blow", "Bottle", "Frog", "Funk", "Glass",
        "Hero", "Morse", "Ping", "Pop", "Purr", "Sosumi",
        "Submarine", "Tink"
    ]
    
    var body: some View {
        VStack {
            Text("Click a sound to play:")
                .font(.headline)
                .padding()
            
            List(soundNames, id: \.self) { soundName in
                Button(action: {
                    playSound(named: soundName)
                }) {
                    Text(soundName)
                        .padding()
                }
            }
        }
        .frame(width: 300, height: 400)
    }
    
    // Function to play a system sound by name
    func playSound(named soundName: String) {
        if let sound = NSSound(named: NSSound.Name(soundName)) {
            sound.play()
        } else {
            print("Sound \(soundName) not found.")
        }
    }
}

#Preview {
  SoundTesterView()
}
