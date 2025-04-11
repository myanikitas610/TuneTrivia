import SwiftUI
import AVFoundation

struct Question: Identifiable, Codable {
    var id: UUID?
    let audioURL: URL
    let startTime: Double
    let endTime: Double
    let questionText: String
    let options: [String]
    let correctAnswer: String
    
    enum CodingKeys: String, CodingKey {
        case audioURL, startTime, endTime, questionText, options, correctAnswer
    }
}

struct QuestionView: View {
    @State private var questions: [Question] = []
    @State private var currentQuestionIndex = 0
    @State private var score = 0
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var goToResults = false
    @State private var player: AVPlayer?

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                if !questions.isEmpty {
                    Text("Score: \(score)")
                        .font(.headline)

                    Text("Question \(currentQuestionIndex + 1) of \(questions.count)")
                        .font(.subheadline)

                    Button("Play Audio Snippet") {
                        playAudioSnippet()
                    }
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)

                    Text(questions[currentQuestionIndex].questionText)
                        .font(.title2)
                        .multilineTextAlignment(.center)
                        .padding()

                    ForEach(questions[currentQuestionIndex].options, id: \.self) { option in
                        Button(action: {
                            checkAnswer(selected: option)
                        }) {
                            Text(option)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.gray.opacity(0.2))
                                .cornerRadius(8)
                        }
                    }

                    Spacer()
                } else {
                    Text("Loading Questions...")
                        .onAppear {
                            loadQuestionsFromJSON()
                        }
                }
            }
            .padding()
            .navigationBarBackButtonHidden(true)
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text(alertMessage),
                    dismissButton: .default(Text("Next")) {
                        goToNextQuestion()
                    }
                )
            }
            .navigationDestination(isPresented: $goToResults) {
                ResultView(score: score, total: questions.count)
            }
        }
    }

    func playAudioSnippet() {
        let question = questions[currentQuestionIndex]
        let start = CMTime(seconds: question.startTime, preferredTimescale: 1)
        let duration = question.endTime - question.startTime

        let playerItem = AVPlayerItem(url: question.audioURL)
        player = AVPlayer(playerItem: playerItem)

        let observer = playerItem.observe(\.status, options: [.initial, .new]) { item, _ in
            if item.status == .readyToPlay {
                player?.seek(to: start) { _ in
                    player?.play()
                    DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
                        player?.pause()
                    }
                }
            } else if item.status == .failed {
                print("Audio load failed")
            }
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            observer.invalidate()
        }
    }

    func stopAudio() {
        player?.pause()
        player = nil  
    }

    func checkAnswer(selected: String) {
        let correct = questions[currentQuestionIndex].correctAnswer
        if selected == correct {
            score += 1
            alertMessage = "Correct!"
        } else {
            alertMessage = "Wrong. The correct answer was \(correct)."
        }
        
        stopAudio()
        showAlert = true
    }

    func goToNextQuestion() {
        if currentQuestionIndex < questions.count - 1 {
            currentQuestionIndex += 1
        } else {
            goToResults = true
        }
    }

    func loadQuestionsFromJSON() {
        guard let url = Bundle.main.url(forResource: "questions", withExtension: "json") else {
            print("Failed to find questions.json")
            return
        }
        
        do {
            let data = try Data(contentsOf: url)
            var decodedQuestions = try JSONDecoder().decode([Question].self, from: data)
            decodedQuestions.shuffle()
            questions = Array(decodedQuestions.prefix(10))
        } catch {
            print("Failed to load questions: \(error)")
        }
    }
}

#Preview {
    QuestionView()
}

