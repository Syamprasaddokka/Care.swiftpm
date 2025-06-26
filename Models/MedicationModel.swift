import Foundation

struct Medication: Identifiable, Codable {
    var id: UUID
    var diagnosis: String
    var doctorName: String
    var hospitalName: String
    var date: Date
    var notes: String
    var medicationNames: [String]
}
