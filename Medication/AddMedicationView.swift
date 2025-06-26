import SwiftUI

struct AddMedicationView: View {
    @Environment(\.dismiss) var dismiss
    @State private var diagnosis = ""
    @State private var doctorName = ""
    @State private var hospitalName = ""
    @State private var date = Date()
    @State private var notes = ""
    @State private var medicationNames: [String] = [""]
    
    var onSave: (Medication) -> Void
    
    var body: some View {
        Form {
            Section(header: Text("Diagnosis and Details")) {
                TextField("Diagnosis*", text: $diagnosis)
                    .accessibilityLabel("Diagnosis")
                    .accessibilityValue(diagnosis)
                
                TextField("Doctor Name*", text: $doctorName)
                    .accessibilityLabel("Doctor's Name")
                    .accessibilityValue(doctorName)
                
                TextField("Hospital Name*", text: $hospitalName)
                    .accessibilityLabel("Hospital Name")
                    .accessibilityValue(hospitalName)
                
                DatePicker("Date", selection: $date, displayedComponents: .date)
                    .accessibilityLabel("Date of Medication")
                    .accessibilityValue("\(date, style: .date)")
                
                TextField("Notes", text: $notes)
                    .accessibilityLabel("Notes")
                    .accessibilityValue(notes)
            }
            
            Section(header: Text("Medications")) {
                ForEach(medicationNames.indices, id: \.self) { index in
                    HStack {
                        TextField("Medication Name*", text: $medicationNames[index])
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.top, 4)
                            .accessibilityLabel("Medication Name")
                            .accessibilityValue(medicationNames[index])
                        
                        if medicationNames.count > 1 {
                            Button(action: {
                                medicationNames.remove(at: index)
                            }) {
                                Image(systemName: "minus.circle.fill")
                                    .foregroundColor(.red)
                            }
                            .accessibilityLabel("Remove Medication")
                            .accessibilityHint("Removes this medication from the list")
                        }
                    }
                }
                
                Button(action: {
                    medicationNames.append("")
                }) {
                    HStack(alignment:.center) {
                        Spacer()
                        Image(systemName: "plus.circle.fill")
                        Text("Add Medication")
                        Spacer()
                    }
                }
                .accessibilityLabel("Add Medication")
                .accessibilityHint("Tap to add a new medication to the list")
            }
            
            Button(action: {
                let newMedication = Medication(
                    id: UUID(),
                    diagnosis: diagnosis,
                    doctorName: doctorName,
                    hospitalName: hospitalName,
                    date: date,
                    notes: notes,
                    medicationNames: medicationNames
                )
                onSave(newMedication)
                dismiss()
            }) {
                Text("Save")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .foregroundColor(.white)
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            .disabled(diagnosis.isEmpty || doctorName.isEmpty || hospitalName.isEmpty || medicationNames.isEmpty || medicationNames.contains(where: { $0.isEmpty }))
            .buttonStyle(PlainButtonStyle())
            .accessibilityLabel("Save Medication")
            .accessibilityHint("Save the entered medication details")
        }
        .navigationBarTitle("Add Medication", displayMode: .inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button("Cancel") {
                    dismiss()
                }
                .foregroundColor(.red)
                .accessibilityLabel("Cancel")
                .accessibilityHint("Dismiss the view without saving")
            }
        }
        .background(Color.gray.opacity(0.1))
    }
}
