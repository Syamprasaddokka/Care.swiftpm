import Foundation

struct Appointment: Identifiable, Codable {
    var id: UUID
    var appointmentType: String
    var doctorName: String
    var hospitalName: String
    var appointmentDate: Date
    var appointmentTime: Date
    var notes: String
}
