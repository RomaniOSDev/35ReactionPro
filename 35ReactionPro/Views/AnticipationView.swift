//
//  AnticipationView.swift
//  35ReactionPro
//
//  Created by Роман Главацкий on 24.12.2025.
//

import SwiftUI

struct AnticipationView: View {
    let test: ReactionTest
    @Environment(\.dismiss) var dismiss
    @State private var ballPosition: CGPoint = .zero
    @State private var targetPosition: CGPoint = .zero
    @State private var isMoving = false
    @State private var score = 0
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color.appBackground
                
                // Target area
                Circle()
                    .stroke(Color.accentGreen, lineWidth: 3)
                    .frame(width: 100, height: 100)
                    .position(targetPosition)
                
                // Moving ball
                Circle()
                    .fill(Color.signalBlue)
                    .frame(width: 40, height: 40)
                    .position(ballPosition)
                    .shadow(color: .signalBlue.opacity(0.8), radius: 10)
                
                VStack {
                    Text("Score: \(score)")
                        .font(.title2)
                        .foregroundColor(.accentGreen)
                        .padding()
                    
                    Spacer()
                }
            }
            .contentShape(Rectangle())
            .onTapGesture { location in
                checkAnticipation(at: location)
            }
            .onAppear {
                setupPositions(in: geometry.size)
            }
        }
    }
    
    private func setupPositions(in size: CGSize) {
        targetPosition = CGPoint(x: size.width * 0.8, y: size.height * 0.5)
        ballPosition = CGPoint(x: size.width * 0.2, y: size.height * 0.5)
        startMovement(in: size)
    }
    
    private func startMovement(in size: CGSize) {
        isMoving = true
        
        withAnimation(.linear(duration: 2.0)) {
            ballPosition = targetPosition
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            isMoving = false
            setupPositions(in: size)
        }
    }
    
    private func checkAnticipation(at location: CGPoint) {
        let distance = sqrt(pow(location.x - targetPosition.x, 2) + pow(location.y - targetPosition.y, 2))
        if distance < 100 {
            score += 1
        }
    }
}

#Preview {
    AnticipationView(test: DefaultTests.tests[0])
}

