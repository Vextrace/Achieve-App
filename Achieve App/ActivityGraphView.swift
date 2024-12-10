import SwiftUI
import Charts

struct ActivityGraphView: View {
    let activityTitle: String
    let data: [Double] // Weekly data for the graph

    var body: some View {
        VStack {
            Text("\(activityTitle) - Weekly Trend")
                .font(.title2)
                .fontWeight(.semibold)
                .padding()

            Chart {
                ForEach(Array(data.enumerated()), id: \.offset) { index, value in
                    LineMark(
                        x: .value("Day", "Day \(index + 1)"),
                        y: .value("Value", value)
                    )
                    .foregroundStyle(Color.blue)
                }
            }
            .frame(height: 300)
            .padding()

            Spacer()
        }
        .padding()
        .navigationTitle(activityTitle)
        .navigationBarTitleDisplayMode(.inline)
    }
}
