import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            VStack {
                Text("Welcome to Tune Trivia!")
                    .font(.largeTitle)
                    .padding()

                NavigationLink(destination: QuestionView()) {
                    Text("Play")
                        .font(.title2)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                .padding()
                .navigationBarBackButtonHidden(true)
            }
        }
    }
}


#Preview {
    ContentView()
}
