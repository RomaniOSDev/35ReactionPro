//
//  ProgressAnalyticsView.swift
//  35ReactionPro
//
//  Created by Роман Главацкий on 24.12.2025.
//

import SwiftUI

struct ProgressAnalyticsView: View {
    @StateObject private var viewModel = ProgressViewModel()
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.appBackground.ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 20) {
                        if viewModel.metrics.isEmpty {
                            emptyState
                        } else {
                            statsOverview
                            progressChart
                            recentSessions
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("Progress")
            .foregroundColor(.textPrimary)
            .onAppear {
                viewModel.loadData()
            }
        }
    }
    
    private var emptyState: some View {
        VStack(spacing: 20) {
            Image(systemName: "chart.line.uptrend.xyaxis")
                .font(.system(size: 60))
                .foregroundColor(.textSecondary)
            
            Text("No data yet")
                .font(.title2)
                .foregroundColor(.textPrimary)
            
            Text("Complete some tests to see your progress")
                .font(.body)
                .foregroundColor(.textSecondary)
                .multilineTextAlignment(.center)
        }
        .padding()
    }
    
    private var statsOverview: some View {
        VStack(spacing: 15) {
            Text("Overview")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.textPrimary)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            if let latestSession = viewModel.sessions.last,
               let avgTime = latestSession.results.averageReactionTime {
                HStack(spacing: 20) {
                    statCard(title: "Avg Time", value: "\(Int(avgTime))ms", color: .accentGreen)
                    statCard(title: "Accuracy", value: "\(Int(latestSession.results.accuracy))%", color: .signalBlue)
                }
            }
        }
    }
    
    private func statCard(title: String, value: String, color: Color) -> some View {
        VStack(spacing: 10) {
            Text(title)
                .font(.caption)
                .foregroundColor(.textSecondary)
            
            Text(value)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(color)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(Color.neutralGray.opacity(0.2))
        )
    }
    
    private var progressChart: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Reaction Time Trend")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.textPrimary)
            
            if !viewModel.metrics.isEmpty {
                simpleLineChart
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.neutralGray.opacity(0.2))
        )
    }
    
    private var simpleLineChart: some View {
        GeometryReader { geometry in
            let maxTime = viewModel.metrics.map { $0.averageReactionTime }.max() ?? 500
            let minTime = viewModel.metrics.map { $0.averageReactionTime }.min() ?? 0
            let range = maxTime - minTime
            
            Path { path in
                for (index, metric) in viewModel.metrics.enumerated() {
                    let x = CGFloat(index) / CGFloat(max(viewModel.metrics.count - 1, 1)) * geometry.size.width
                    let normalizedTime = range > 0 ? (metric.averageReactionTime - minTime) / range : 0.5
                    let y = geometry.size.height - (CGFloat(normalizedTime) * geometry.size.height)
                    
                    if index == 0 {
                        path.move(to: CGPoint(x: x, y: y))
                    } else {
                        path.addLine(to: CGPoint(x: x, y: y))
                    }
                }
            }
            .stroke(Color.accentGreen, lineWidth: 2)
        }
        .frame(height: 200)
    }
    
    private var recentSessions: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Recent Sessions")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.textPrimary)
            
            ForEach(viewModel.sessions.suffix(5).reversed()) { session in
                sessionRow(session: session)
            }
        }
    }
    
    private func sessionRow(session: ReactionSession) -> some View {
        HStack {
            VStack(alignment: .leading) {
                Text(session.startTime, style: .date)
                    .font(.headline)
                    .foregroundColor(.textPrimary)
                
                if let avgTime = session.results.averageReactionTime {
                    Text("\(Int(avgTime))ms")
                        .font(.caption)
                        .foregroundColor(.textSecondary)
                }
            }
            
            Spacer()
            
            Text("\(Int(session.results.accuracy))%")
                .font(.headline)
                .foregroundColor(.accentGreen)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(Color.neutralGray.opacity(0.2))
        )
    }
}

#Preview {
    ProgressAnalyticsView()
}


