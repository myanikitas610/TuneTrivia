import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            ZStack {
                // Background Image
                Image("contentView")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()

                
                VStack {
                    // Neon Title
                    VStack(spacing: 0) {
                        glowingText("TUNE")
                        glowingText("TRIVIA")
                    }
                    .frame(maxHeight: .infinity, alignment: .top)
                    .padding(.top, 65)

                    Spacer()

                    // Start Button
                    NavigationLink(destination: QuestionView()) {
                   
                    let hotPink = Color(red: 1.0, green: 0.0, blue: 0.6)

                        Text("START")
                            .font(.system(size: 35, weight: .medium))
                            .fontWeight(.semibold)
                            .foregroundColor(hotPink)
                            .padding(.vertical, 20)
                            .frame(width: 310)
                            .background(
                                LinearGradient(
                                    colors: [Color.white.opacity(0.9), Color.purple.opacity(0.4)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .clipShape(Capsule())
                            .shadow(color: Color.purple.opacity(0.9), radius: 8, x: 0, y: 5)
                    }
                    .padding(.bottom, 50)
                    
                    
                    // How to Play
                    NavigationLink(destination: HowToPlayView()) {
                        Text("How to Play")
                            .font(.title)
                            .fontWeight(.semibold)
                            .foregroundColor(.white.opacity(0.9))
                            .padding(.horizontal, 100)
                            .padding(.vertical, 10)
                            .overlay(
                                    RoundedRectangle(cornerRadius: 20)
                                        .stroke(.purple, lineWidth: 5)
                                )
                    }
                    .padding(.bottom)
                }
            }
            .navigationBarBackButtonHidden(true)
        }
    }

    // Glowy Neon Text
    @ViewBuilder
    func glowingText(_ text: String) -> some View {
        let glowColor = Color(red: 1.0, green: 0.0, blue: 0.6)         // #FF0099
        let innerColor = Color(red: 1.0, green: 0.6, blue: 0.8)        // light pink fill

        Text(text)
            .font(.system(size: 80, weight: .bold))
            .foregroundColor(innerColor)
            .shadow(color: glowColor.opacity(0.8), radius: 20)
            .shadow(color: glowColor.opacity(0.5), radius: 40)
    }
}

#Preview {
    ContentView()
}

