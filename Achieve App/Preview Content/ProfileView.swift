import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var manager: HealthManager

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Profile Picture and Name
                VStack {
                    Image(systemName: "person.crop.circle.fill")
                        .resizable()
                        .frame(width: 100, height: 100)
                        .foregroundColor(.gray)
                        .padding(.bottom, 10)

                    Text("John Doe")
                        .font(.title)
                        .fontWeight(.semibold)

                    Text("johndoe@example.com")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }

                // Dynamic Statistics Section
                HStack(spacing: 30) {
                    VStack {
                        Text(manager.stepsWalked)
                            .font(.headline)
                        Text("Steps")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    VStack {
                        Text(manager.caloriesBurned)
                            .font(.headline)
                        Text("Calories")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    VStack {
                        Text(manager.sleepDuration)
                            .font(.headline)
                        Text("Sleep")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                }
                .padding()
                .background(Color(uiColor: .systemGray6))
                .cornerRadius(15)

                Spacer()
            }
            .padding()
        }
        .onAppear {
            manager.fetchData()
        }
        .navigationTitle("Profile")
    }
}
