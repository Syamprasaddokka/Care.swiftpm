import SwiftUI

struct AddAppointmentView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var appointments: [Appointment]
    
    @State private var appointmentType: String = "Consultation"
    @State private var doctorName: String = ""
    @State private var hospitalName: String = ""
    @State private var appointmentDate: Date = Date()
    @State private var appointmentTime: Date = Date()
    @State private var notes: String = ""
    
    let appointmentTypes = ["Consultation", "Follow-up", "Check-up", "Emergency"]
    
    var body: some View {
        Form {
            Section(header: Text("Appointment Information")) {
                
                Picker("Appointment Type", selection: $appointmentType) {
                    ForEach(appointmentTypes, id: \.self) { type in
                        Text(type)
                    }
                }
                .accessibilityLabel("Select Appointment Type")
                .accessibilityHint("Choose the type of appointment")
                
                TextField("Doctor's Name*", text: $doctorName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.top, 4)
                    .accessibilityLabel("Doctor's Name")
                    .accessibilityHint("Enter the doctor's name for the appointment")
                
                TextField("Hospital Name*", text: $hospitalName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.top, 4)
                    .accessibilityLabel("Hospital Name")
                    .accessibilityHint("Enter the name of the hospital")
                
                DatePicker("Appointment Date*", selection: $appointmentDate, displayedComponents: .date)
                    .padding(.top, 4)
                    .accessibilityLabel("Select Appointment Date")
                    .accessibilityHint("Pick the date for your appointment")
                
                DatePicker("Appointment Time", selection: $appointmentTime, displayedComponents: .hourAndMinute)
                    .padding(.top, 4)
                    .accessibilityLabel("Select Appointment Time")
                    .accessibilityHint("Pick the time for your appointment")
            }
            
            Section(header: Text("Notes")) {
                TextField("Enter any notes...", text: $notes)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .lineLimit(4)
                    .padding(.top, 4)
                    .accessibilityLabel("Additional Notes")
                    .accessibilityHint("Optionally add any additional notes")
            }
            
            Button(action: {
                let newAppointment = Appointment(
                    id: UUID(), appointmentType: appointmentType,
                    doctorName: doctorName,
                    hospitalName: hospitalName,
                    appointmentDate: appointmentDate,
                    appointmentTime: appointmentTime,
                    notes: notes
                )
                
                appointments.append(newAppointment)
                AppointmentDataManager.shared.saveAppointments(appointments)
                dismiss()
            }) {
                Text("Save Appointment")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .disabled(doctorName.isEmpty || hospitalName.isEmpty)
            .buttonStyle(PlainButtonStyle())
            .accessibilityLabel("Save Appointment")
            .accessibilityHint("Save the appointment details")
            .accessibilityValue(doctorName.isEmpty || hospitalName.isEmpty ? "Button disabled" : "Button enabled")
        }
        .navigationTitle("Add Appointment")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button("Cancel") {
                    dismiss()
                }
                .foregroundColor(.red)
                .accessibilityLabel("Cancel")
                .accessibilityHint("Dismiss without saving appointment")
            }
        }
        .background(Color.gray.opacity(0.1))
    }
}
