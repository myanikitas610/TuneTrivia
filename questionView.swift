import SwiftUI
import AVFoundation
import Foundation

// Struct to represent a question
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

// View for displaying a question with options
struct QuestionView: View {
    @State private var questions: [Question] = []  // List to hold questions
    @State private var currentQuestionIndex = 0  // Tracks the current question
    @State private var score = 0  // User's score
    @State private var showAlert = false  // Flag to show alert after answering
    @State private var alertMessage = ""  // Message to show in the alert
    @State private var goToResults = false  // Flag to navigate to results
    @State private var player: AVPlayer?  // Audio player

    var body: some View {
        NavigationStack {
            ZStack {
                // Set background image
                Image("questionView")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()

                if !questions.isEmpty {
                    // Display questions and options if available
                    VStack(spacing: 20) {
                        Spacer()

                        // Question Tracker: Display current question number and total questions
                        Text("Question \(currentQuestionIndex + 1) of \(questions.count)")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(Color.black.opacity(0.6))
                            .cornerRadius(10)
                            .frame(maxWidth: .infinity)
                            .multilineTextAlignment(.center)

                        // Quiz title
                        Text("Quiz Time")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .padding()
                            .foregroundColor(.white)
                            .background(Color(red: 206/255, green: 89/255, blue: 203/255))
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.purple, lineWidth: 3)
                            )
                            .cornerRadius(10)

                        VStack(spacing: 16) {
                            // Display the question text
                            Text(questions[currentQuestionIndex].questionText)
                                .font(.system(size: 28, weight: .bold))
                                .multilineTextAlignment(.center)
                                .foregroundColor(.white)
                                .padding()

                            // Button to play audio snippet for the current question
                            Button(action: {
                                playAudioSnippet()
                            }) {
                                Image(systemName: "play.circle.fill")
                                    .resizable()
                                    .frame(width: 60, height: 60)
                                    .foregroundColor(.white)
                            }
                            .padding(.bottom, 10)

                            // Display options as buttons
                            ForEach(questions[currentQuestionIndex].options, id: \.self) { option in
                                Button(action: {
                                    checkAnswer(selected: option)
                                }) {
                                    Text(option)
                                        .fontWeight(.bold)
                                        .frame(maxWidth: .infinity)
                                        .padding()
                                        .background(Color.black.opacity(0.8))
                                        .foregroundColor(.white)
                                        .cornerRadius(15)
                                }
                            }
                        }
                        .padding()
                        .background(Color(red: 203/255, green: 108/255, blue: 230/255).opacity(0.80))
                        .cornerRadius(25)
                        .padding(.horizontal, 30)

                        Spacer()
                    }
                } else {
                    Text("Loading Questions...")
                        .foregroundColor(.white)
                        .onAppear {
                            loadQuestionsFromJSON()  // Load questions when view appears
                        }
                }
            }
            .navigationBarBackButtonHidden(true)
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text(alertMessage),
                    dismissButton: .default(Text("Next")) {
                        goToNextQuestion()  // Go to the next question after alert is dismissed
                    }
                )
            }
            .navigationDestination(isPresented: $goToResults) {
                // Navigate to results view when all questions are answered
                ResultView(score: score, total: questions.count)
            }
        }
    }

    // Play the audio snippet for the current question
    func playAudioSnippet() {
        let question = questions[currentQuestionIndex]
        let start = CMTime(seconds: question.startTime, preferredTimescale: 1)
        let duration = question.endTime - question.startTime

        let playerItem = AVPlayerItem(url: question.audioURL)
        player = AVPlayer(playerItem: playerItem)

        // Observer to monitor the status of the audio player
        let observer = playerItem.observe(\.status, options: [.initial, .new]) { item, _ in
            if item.status == .readyToPlay {
                player?.seek(to: start) { _ in
                    player?.play()  // Start playing the audio from the specified start time
                    DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
                        player?.pause()  // Stop the audio after the duration
                    }
                }
            } else if item.status == .failed {
                print("Audio load failed")
            }
        }

        // Invalidate observer after 5 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            observer.invalidate()
        }
    }

    // Stop the audio if it's playing
    func stopAudio() {
        player?.pause()
        player = nil
    }

    // Check if the selected answer is correct
    func checkAnswer(selected: String) {
        let correct = questions[currentQuestionIndex].correctAnswer
        if selected == correct {
            score += 1
            alertMessage = "Correct!"
        } else {
            alertMessage = "Wrong. The correct answer was \(correct)."
        }
        stopAudio()  // Stop audio playback
        showAlert = true
    }

    // Move to the next question or go to the results if it's the last question
    func goToNextQuestion() {
        if currentQuestionIndex < questions.count - 1 {
            currentQuestionIndex += 1  // Go to the next question
        } else {
            goToResults = true  // Navigate to the results
        }
    }

    // Load questions from a JSON file
    func loadQuestionsFromJSON() {
        guard let url = Bundle.main.url(forResource: "questions", withExtension: "json") else {
            print("Failed to find questions.json")
            return
        }

        do {
            let data = try Data(contentsOf: url)
            var decodedQuestions = try JSONDecoder().decode([Question].self, from: data)
            decodedQuestions.shuffle()  // Shuffle the questions for random order
            questions = Array(decodedQuestions.prefix(10))  // Limit to 10 questions
        } catch {
            print("Failed to load questions: \(error)")
        }
    }
}

#Preview {
    QuestionView()
}
