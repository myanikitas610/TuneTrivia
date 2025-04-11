import SwiftUI

struct ResultView: View {
    let score: Int
    let total: Int

    var body: some View {
        VStack(spacing: 20) {
            Text("Quiz Finished!")
                .font(.largeTitle)
                .bold()

            Text("Your Score: \(score) / \(total)")
                .font(.title2)

            NavigationLink("Play Again", destination: ContentView())
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(12)
        }
        .padding()
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    ResultView(score:0 , total: 10)
}
