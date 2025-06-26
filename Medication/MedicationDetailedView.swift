import SwiftUI

struct MedicationDetailView: View {
    var medication: Medication
    var onDelete: (IndexSet) -> Void
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                HStack {
                    Text("Doctor: ")
                        .bold()
                        .font(.headline)
                    Spacer()
                    Text("\(medication.doctorName)")
                        .accessibilityLabel("Doctor's Name")
                        .accessibilityValue(medication.doctorName)
                }
                Divider()
                
                HStack {
                    Text("Hospital: ")
                        .bold()
                        .font(.headline)
                    Spacer()
                    Text("\(medication.hospitalName)")
                        .accessibilityLabel("Hospital Name")
                        .accessibilityValue(medication.hospitalName)
                }
                Divider()
                
                HStack {
                    Text("Date: ")
                        .bold()
                        .font(.headline)
                    Spacer()
                    Text("\(medication.date, style: .date)")
                        .accessibilityLabel("Date of Medication")
                        .accessibilityValue("\(medication.date, style: .date)")
                }
                Divider()
                
                HStack {
                    Text("Notes: ")
                        .bold()
                        .font(.headline)
                    Spacer()
                    Text("\(medication.notes)")
                        .accessibilityLabel("Notes")
                        .accessibilityValue(medication.notes)
                }
                Divider()
                
                VStack(alignment: .leading) {
                    Text("Medications:")
                        .bold()
                        .font(.title3)
                        .padding(.top)
                        .accessibilityLabel("List of Medications")
                    
                    ForEach(medication.medicationNames, id: \.self) { med in
                        Text(med)
                            .font(.subheadline)
                            .padding(2)
                            .accessibilityLabel("Medication Name")
                            .accessibilityValue(med)
                    }
                }
                
                Spacer()
            }
            .padding()
            .navigationBarTitle("\(medication.diagnosis)", displayMode: .inline)
            .navigationBarItems(trailing: Button(action: {
                if let index = MedicationDataManager.shared.loadMedications().firstIndex(where: { $0.id == medication.id }) {
                    onDelete(IndexSet([index]))
                    dismiss()
                }
            }) {
                Image(systemName: "trash")
                    .accessibilityLabel("Delete Medication")
                    .accessibilityHint("Deletes this medication record")
            })
        }
        .padding(.top)
    }
}
