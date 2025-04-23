import SwiftUI

struct ResultView: View {
    let score: Int
    let total: Int

    var body: some View {
        NavigationStack {
            ZStack {
                // Background Image
                Image("resultView")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                   

                let hotPink = Color(red: 1.0, green: 0.0, blue: 0.6)

                VStack(spacing: 30) {
                    Spacer()

                    // "YOUR SCORE"
                    Text("YOUR SCORE")
                        .font(.system(size: 40, weight: .bold))
                        .foregroundColor(.purple.opacity(0.9))

                    // Score value (e.g., 5/10)
                    Text("\(score)/\(total)")
                        .font(.system(size: 48, weight: .bold))
                        .foregroundColor(.white)

                    Spacer()

                    
                    // Play Again Button
                    NavigationLink(destination: ContentView()) {
                        Text("PLAY AGAIN")
                            .font(.system(size: 30, weight: .medium))
                        
                            .foregroundColor(hotPink)
                            .padding(.vertical, 18)
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
                    .padding(.bottom, 80)
                }
                .padding()
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    ResultView(score: 5, total: 10)
}
