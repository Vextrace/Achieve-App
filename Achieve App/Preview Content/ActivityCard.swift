import SwiftUI

struct Activity: Identifiable {
    let id: Int
    let title: String
    let value: String
    let image: String
    let progress: Int // Add this for percentage goals
}

struct ActivityCard: View {
    let activity: Activity
    let onTap: () -> Void // Add a tap action

    var body: some View {
        ZStack {
            // Background with rounded corners
            Color(uiColor: .systemGray5)
                .cornerRadius(15)

            // Card content
            VStack(alignment: .leading, spacing: 8) {
                // Title and Progress Indicator
                HStack {
                    Text(activity.title)
                        .font(.headline)

                    Spacer()

                    // Percentage Goal Indicator
                    Text("\(activity.progress)%")
                        .font(.caption)
                        .foregroundColor(.green)
                        .padding(5)
                        .background(Color.white)
                        .cornerRadius(5)
                }

                // Activity Value
                Text(activity.value)
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(.black)

                Spacer()

                // Activity Icon
                Image(systemName: activity.image)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 40)
                    .foregroundColor(.green)
            }
            .padding()
        }
        .frame(height: 150)
        .onTapGesture {
            onTap() // Trigger navigation to graph view
        }
    }
}
