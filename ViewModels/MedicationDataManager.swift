import Foundation

class MedicationDataManager {
    static let shared = MedicationDataManager()
    
    private let fileURL: URL
    
    init() {
        let fileManager = FileManager.default
        let documentDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        fileURL = documentDirectory.appendingPathComponent("medications.json")
        
        if !fileManager.fileExists(atPath: fileURL.path) {
            createDefaultFile()
        }
    }
    

    var medicationCount: Int {
        let medications = loadMedications()
        return medications.reduce(0) { $0 + $1.medicationNames.count }
    }
    
    func loadMedications() -> [Medication] {
        do {
            let data = try Data(contentsOf: fileURL)
            let medications = try JSONDecoder().decode([Medication].self, from: data)
            return medications
        } catch {
            print("Error loading medications: \(error)")
            return []
        }
    }
    
    func saveMedications(_ medications: [Medication]) {
        do {
            let data = try JSONEncoder().encode(medications)
            try data.write(to: fileURL)
        } catch {
            print("Error saving medications: \(error)")
        }
    }
    
    private func createDefaultFile() {
        let defaultMedications: [Medication] = [
            Medication(
                id: UUID(),
                diagnosis: "Hypertension",
                doctorName: "Dr. Smith",
                hospitalName: "City Hospital",
                date: Date(),
                notes: "Take medication after meals.",
                medicationNames: ["Aspirin", "Lisinopril"]
            ),
            Medication(
                id: UUID(),
                diagnosis: "Diabetes",
                doctorName: "Dr. Johnson",
                hospitalName: "General Hospital",
                date: Date(),
                notes: "Monitor blood sugar levels regularly.",
                medicationNames: ["Metformin", "Insulin"]
            )
        ]
        
        do {
            let data = try JSONEncoder().encode(defaultMedications)
            try data.write(to: fileURL)
            print("Created medications.json with default data.")
        } catch {
            print("Error creating default medications file: \(error)")
        }
    }
}
