import SwiftUI

struct HomeView: View {
    @EnvironmentObject var manager: HealthManager

    var body: some View {
        VStack(spacing: 20) {
            // Weight and BMI Card
            WeightCard(weight: manager.weight, bmi: manager.bmi) // Updated to use dynamic values from HealthManager

            // Activity Cards Grid
            LazyVGrid(
                columns: Array(repeating: GridItem(spacing: 20), count: 2),
                spacing: 20
            ) {
                ActivityCard(
                    activity: Activity(
                        id: 1,
                        title: "Steps Walked",
                        value: manager.stepsWalked, // Updated to use dynamic value
                        image: "figure.walk",
                        progress: 75
                    ),
                    onTap: {
                        // Navigate to Steps Graph
                    }
                )
                ActivityCard(
                    activity: Activity(
                        id: 2,
                        title: "Calories Burned",
                        value: manager.caloriesBurned, // Updated to use dynamic value
                        image: "flame",
                        progress: 60
                    ),
                    onTap: {
                        // Navigate to Calories Graph
                    }
                )
                ActivityCard(
                    activity: Activity(
                        id: 3,
                        title: "Sleep Hours",
                        value: manager.sleepDuration, // Updated to use dynamic value
                        image: "bed.double.fill",
                        progress: 90
                    ),
                    onTap: {
                        // Navigate to Sleep Graph
                    }
                )
            }
            .padding()
        }
        .onAppear {
            manager.fetchData()
        }
    }
}
