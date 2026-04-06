import SwiftUI

public struct CoachView: View {
    @State private var inputPrompt: String = ""
    @State private var messages: [ChatMessage] = []
    @State private var isTyping: Bool = false
    @Environment(\.dismiss) private var dismiss
    
    struct ChatMessage: Identifiable {
        let id = UUID()
        let isUser: Bool
        let text: String
    }
    
    public init() {}
    
    public var body: some View {
        ZStack {
            SparkBackground().ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header
                HStack {
                    Button(action: { 
                        HapticManager.shared.triggerSelection()
                        dismiss() 
                    }) {
                        HStack(spacing: 8) {
                            Image(systemName: "chevron.left")
                                .font(.title3.bold())
                            Text("BACK")
                                .font(.system(size: 10, weight: .bold, design: .monospaced)) // Using safe font directly or Typography micro equivalent
                                .tracking(2)
                        }
                        .foregroundColor(.white)
                        .padding(.vertical, 8)
                        .padding(.trailing, 16)
                        .contentShape(Rectangle())
                    }
                    
                    Spacer()
                    
                    HStack {
                        Image(systemName: "brain.head.profile")
                            .foregroundColor(SparkTheme.Colors.xpElectric)
                            .symbolEffect(.pulse)
                        Text("NEXUS COACH")
                            .font(.system(size: 18, weight: .black, design: .rounded))
                            .foregroundColor(.white)
                            .tracking(2)
                    }
                    
                    Spacer()
                    
                    // placeholder for balance
                    Image(systemName: "chevron.left").opacity(0)
                }
                .padding(.horizontal, 24)
                .padding(.top, 20)
                .padding(.bottom, 10)
                
                // Chat Area
                ScrollViewReader { proxy in
                    ScrollView {
                        VStack(spacing: 16) {
                            if messages.isEmpty {
                                VStack(spacing: 20) {
                                    Image(systemName: "sparkles")
                                        .font(.system(size: 40))
                                        .foregroundColor(SparkTheme.Colors.xpElectric.opacity(0.5))
                                    Text("How can I challenge your assumptions today?")
                                        .font(SparkTheme.Typography.body)
                                        .foregroundColor(.white.opacity(0.6))
                                }
                                .padding(.top, 100)
                            }
                            
                            ForEach(messages) { msg in
                                ChatBubble(message: msg)
                            }
                            
                            if isTyping {
                                HStack {
                                    ProgressView().tint(SparkTheme.Colors.xpElectric)
                                        .padding()
                                    Spacer()
                                }
                                .padding(.horizontal, 16)
                                .id("typing")
                            }
                            
                            // Bottom padding
                            Color.clear.frame(height: 20).id("bottom")
                        }
                        .padding(.vertical, 20)
                    }
                    .onChange(of: messages.count) {
                        withAnimation {
                            proxy.scrollTo("bottom", anchor: .bottom)
                        }
                    }
                    .onChange(of: isTyping) {
                        if isTyping {
                            withAnimation { proxy.scrollTo("typing", anchor: .bottom) }
                        }
                    }
                }
                
                // Input Area
                HStack(alignment: .bottom, spacing: 12) {
                    TextField("Ask Nexus...", text: $inputPrompt, axis: .vertical)
                        .padding(14)
                        .background(Color.white.opacity(0.05))
                        .cornerRadius(20)
                        .foregroundColor(.white)
                        .lineLimit(1...5)
                    
                    Button(action: sendMessage) {
                        Image(systemName: "arrow.up")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.black)
                            .frame(width: 44, height: 44)
                            .background(Circle().fill(inputPrompt.isEmpty ? Color.gray : SparkTheme.Colors.xpElectric))
                    }
                    .disabled(inputPrompt.isEmpty || isTyping)
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 12)
                .background(.ultraThinMaterial)
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            if messages.isEmpty {
                messages.append(ChatMessage(isUser: false, text: "I am SPARK. Define your current metabolic friction."))
            }
        }
    }
    
    private func sendMessage() {
        guard !inputPrompt.isEmpty else { return }
        let userMsg = inputPrompt
        inputPrompt = ""
        
        withAnimation {
            messages.append(ChatMessage(isUser: true, text: userMsg))
            isTyping = true
        }
        
        HapticManager.shared.triggerImpact(1)
        
        Task {
            // Using logic built in AIService but we don't have a generic completion exposed publically.
            // Wait, we DO. I will expose it or rewrite a custom call here.
            // Oh, I will just add a `chat` function to AIService.
            let response = await AIService.shared.coachChat(userMsg)
            
            await MainActor.run {
                withAnimation {
                    isTyping = false
                    messages.append(ChatMessage(isUser: false, text: response))
                }
                HapticManager.shared.triggerSuccess()
            }
        }
    }
}

struct ChatBubble: View {
    let message: CoachView.ChatMessage
    
    var body: some View {
        HStack {
            if message.isUser { Spacer() }
            
            Text(message.text)
                .font(SparkTheme.Typography.body)
                .foregroundColor(message.isUser ? .black : .white)
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(message.isUser ? SparkTheme.Colors.xpElectric : Color.white.opacity(0.1))
                )
            
            if !message.isUser { Spacer() }
        }
        .padding(.horizontal, 16)
    }
}
