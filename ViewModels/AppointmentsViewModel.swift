import Foundation

class AppointmentDataManager {
    static let shared = AppointmentDataManager()
    
    private let fileURL: URL
    
    init() {
        let fileManager = FileManager.default
        let documentDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        fileURL = documentDirectory.appendingPathComponent("appointments.json")
        
        if !fileManager.fileExists(atPath: fileURL.path) {
            createDefaultFile()
        }
    }
    
    var appointmentCount: Int {
        let appointments = loadAppointments()
        return appointments.count
    }
    
    func loadAppointments() -> [Appointment] {
        do {
            let data = try Data(contentsOf: fileURL)
            let appointments = try JSONDecoder().decode([Appointment].self, from: data)
            return appointments
        } catch {
            print("Error loading appointments: \(error)")
            return []
        }
    }
    
    func saveAppointments(_ appointments: [Appointment]) {
        do {
            let data = try JSONEncoder().encode(appointments)
            try data.write(to: fileURL)
        } catch {
            print("Error saving appointments: \(error)")
        }
    }
    
    private func createDefaultFile() {
        let defaultAppointments: [Appointment] = [
            Appointment(
                id: UUID(),
                appointmentType: "Consultation",
                doctorName: "Dr. Smith",
                hospitalName: "City Hospital",
                appointmentDate: Date(),
                appointmentTime: Date(),
                notes: "General check-up."
            ),
            Appointment(
                id: UUID(),
                appointmentType: "Follow-up",
                doctorName: "Dr. Johnson",
                hospitalName: "General Hospital",
                appointmentDate: Date(),
                appointmentTime: Date(),
                notes: "Follow-up on previous treatments."
            )
        ]
        
        do {
            let data = try JSONEncoder().encode(defaultAppointments)
            try data.write(to: fileURL)
            print("Created appointments.json with default data.")
        } catch {
            print("Error creating default appointments file: \(error)")
        }
    }
}
