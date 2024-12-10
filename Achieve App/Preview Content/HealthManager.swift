import Foundation
import HealthKit

class HealthManager: ObservableObject {
    @Published var stepsWalked: String = "0"
    @Published var caloriesBurned: String = "0 kcal"
    @Published var sleepDuration: String = "0h"
    @Published var weight: String = "0 kg" // Added weight property
    @Published var bmi: String = "0"      // Added BMI property
    @Published var stepsTrend: [Double] = []
    @Published var caloriesTrend: [Double] = []
    @Published var sleepTrend: [Double] = []

    private let healthStore = HKHealthStore()

    init() {
        requestAuthorization()
    }

    /// Request HealthKit authorization for steps, calories, sleep, and weight data.
    func requestAuthorization() {
        let typesToRead: Set<HKObjectType> = [
            HKQuantityType.quantityType(forIdentifier: .stepCount)!,
            HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned)!,
            HKCategoryType.categoryType(forIdentifier: .sleepAnalysis)!,
            HKQuantityType.quantityType(forIdentifier: .bodyMass)! // Added weight data type
        ]

        healthStore.requestAuthorization(toShare: [], read: typesToRead) { success, error in
            if !success {
                print("HealthKit authorization failed: \(String(describing: error))")
            }
        }
    }

    /// Fetch all data (Steps, Calories, Sleep, Weight, BMI)
    func fetchData() {
        fetchSteps()
        fetchCalories()
        fetchSleep()
        fetchWeightAndBMI() // New method to fetch weight and BMI
    }

    /// Fetch Steps Walked
    private func fetchSteps() {
        guard let stepType = HKQuantityType.quantityType(forIdentifier: .stepCount) else { return }
        let now = Date()
        let startOfDay = Calendar.current.startOfDay(for: now)

        let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: now, options: .strictStartDate)
        let query = HKStatisticsQuery(quantityType: stepType, quantitySamplePredicate: predicate, options: .cumulativeSum) { [weak self] _, result, _ in
            guard let result = result, let sum = result.sumQuantity() else { return }
            let steps = sum.doubleValue(for: HKUnit.count())
            DispatchQueue.main.async {
                self?.stepsWalked = "\(Int(steps)) steps"
                self?.stepsTrend.append(steps)
                if let count = self?.stepsTrend.count, count > 7 {
                    self?.stepsTrend.removeFirst()
                }
            }
        }
        healthStore.execute(query)
    }

    /// Fetch Calories Burned
    private func fetchCalories() {
        guard let caloriesType = HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned) else { return }
        let now = Date()
        let startOfDay = Calendar.current.startOfDay(for: now)

        let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: now, options: .strictStartDate)
        let query = HKStatisticsQuery(quantityType: caloriesType, quantitySamplePredicate: predicate, options: .cumulativeSum) { [weak self] _, result, _ in
            guard let result = result, let sum = result.sumQuantity() else { return }
            let calories = sum.doubleValue(for: HKUnit.kilocalorie())
            DispatchQueue.main.async {
                self?.caloriesBurned = "\(Int(calories)) kcal"
                self?.caloriesTrend.append(calories)
                if let count = self?.caloriesTrend.count, count > 7 {
                    self?.caloriesTrend.removeFirst()
                }
            }
        }
        healthStore.execute(query)
    }

    /// Fetch Sleep Duration
    private func fetchSleep() {
        guard let sleepType = HKCategoryType.categoryType(forIdentifier: .sleepAnalysis) else { return }
        let now = Date()
        let startOfDay = Calendar.current.startOfDay(for: now)

        let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: now, options: .strictStartDate)
        let query = HKSampleQuery(sampleType: sleepType, predicate: predicate, limit: 0, sortDescriptors: nil) { [weak self] _, results, _ in
            guard let results = results as? [HKCategorySample] else { return }

            let totalSleep = results
                .filter { $0.value == HKCategoryValueSleepAnalysis.asleepUnspecified.rawValue }
                .reduce(0.0) { $0 + $1.endDate.timeIntervalSince($1.startDate) }

            let hours = totalSleep / 3600.0
            DispatchQueue.main.async {
                self?.sleepDuration = String(format: "%.1f h", hours)
                self?.sleepTrend.append(hours)
                if let count = self?.sleepTrend.count, count > 7 {
                    self?.sleepTrend.removeFirst()
                }
            }
        }
        healthStore.execute(query)
    }

    /// Fetch Weight and Calculate BMI
    private func fetchWeightAndBMI() {
        guard let weightType = HKQuantityType.quantityType(forIdentifier: .bodyMass) else { return }
        let now = Date()
        let startOfDay = Calendar.current.startOfDay(for: now)

        let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: now, options: .strictStartDate)
        let query = HKStatisticsQuery(quantityType: weightType, quantitySamplePredicate: predicate, options: .discreteAverage) { [weak self] _, result, _ in
            guard let result = result, let avgWeight = result.averageQuantity() else { return }
            let weightInKg = avgWeight.doubleValue(for: HKUnit.gramUnit(with: .kilo))
            DispatchQueue.main.async {
                self?.weight = String(format: "%.1f kg", weightInKg)
                // Example BMI calculation, assuming height in meters is 1.75
                let heightInMeters: Double = 1.75
                let bmiValue = weightInKg / (heightInMeters * heightInMeters)
                self?.bmi = String(format: "%.1f", bmiValue)
            }
        }
        healthStore.execute(query)
    }
}
