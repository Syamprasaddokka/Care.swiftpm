import SwiftUI

struct MedicationView: View {
    
    @State private var medications: [Medication] = []
    
    var body: some View {
        NavigationView {
            List {
                ForEach(medications) { medication in
                    NavigationLink(destination: MedicationDetailView(medication: medication, onDelete: deleteMedication)) {
                        VStack(alignment: .leading) {
                            Text(medication.diagnosis)
                                .fontWeight(.bold)
                                .font(.headline)
                                .accessibilityLabel("Diagnosis: \(medication.diagnosis)")
                            Text("\(medication.doctorName)")
                                .font(.caption)
                                .accessibilityLabel("Doctor: \(medication.doctorName)")
                            Text(medication.date, style: .date)
                                .font(.caption2)
                                .accessibilityLabel("Date: \(medication.date, formatter: dateFormatter)")
                        }
                    }
                }
                .onDelete(perform: deleteMedication)
            }
            .padding(.top, 10)
            .accessibilityElement(children: .contain)
        }
        .navigationBarTitle("Medications", displayMode: .large)
        .navigationBarItems(trailing: NavigationLink(destination: AddMedicationView(onSave: addMedication)) {
            Image(systemName: "plus")
                .accessibilityLabel("Add Medication")
        })
        .onAppear {
            medications = MedicationDataManager.shared.loadMedications().sorted { $0.date > $1.date }
        }
    }
    
    private func addMedication(_ medication: Medication) {
        medications.insert(medication, at: 0)
        MedicationDataManager.shared.saveMedications(medications)
    }
    
    private func deleteMedication(at offsets: IndexSet) {
        medications.remove(atOffsets: offsets)
        MedicationDataManager.shared.saveMedications(medications)
    }
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }()
}
