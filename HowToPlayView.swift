import SwiftUI

struct HowToPlayView: View {
    var body: some View {
        NavigationStack {
            ZStack {
                // Background image
                Image("questionView")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()

                VStack(alignment: .center, spacing: 20) {
                    // Title
                    Text("How to Play")
                        .font(.system(size: 36, weight: .bold))
                        .foregroundColor(Color(red: 1.0, green: 0.6, blue: 0.8))
                        .shadow(color: Color(red: 1.0, green: 0.0, blue: 0.6).opacity(0.8), radius: 10)
                        .padding(.top, 50)
                        .padding(.bottom, 10)

                    // Instructions Blurb
                    Text("""
🎧 Welcome to TuneTrivia — the ultimate music quiz for true fans! 🎶

You’ll hear a short snippet from a song and be asked to guess either the **title**, **artist**, or **release year**. Choose the right answer from 4 options.

There are 10 questions per round. Each correct answer earns you 1 point.

Can you get a perfect 10/10?

Tap 'Play Again' to replay with new questions!
""")
                        .font(.body)
                        .foregroundColor(.white)
                        .shadow(color: Color.purple.opacity(0.5), radius: 4)
                        .padding(.horizontal)

                    Spacer()

                    // "Start Playing" Button
                    NavigationLink(destination: QuestionView()) {
                        Text("Start Playing")
                            .font(.system(size: 25, weight: .medium))
                            .foregroundColor(Color(red: 1.0, green: 0.0, blue: 0.6))
                            .padding(.vertical, 20)
                            .frame(width: 280)
                            .background(
                                LinearGradient(
                                    colors: [Color.white.opacity(0.9), Color.purple.opacity(0.4)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .clipShape(Capsule())
                            .shadow(color: Color.purple.opacity(0.3), radius: 8, x: 0, y: 5)
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.bottom, 40)
                }
                .padding()
            }
        }
    }
}

#Preview {
    HowToPlayView()
}

