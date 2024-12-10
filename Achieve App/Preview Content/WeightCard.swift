import SwiftUI

struct WeightCard: View {
    let weight: String
    let bmi: String

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Weight")
                .font(.headline)
            Text(weight)
                .font(.largeTitle)
                .bold()

            Text("BMI")
                .font(.headline)
            Text(bmi)
                .font(.largeTitle)
                .bold()
        }
        .padding()
        .background(Color(uiColor: .systemGray6))
        .cornerRadius(15)
    }
}
