import SwiftUI

struct AppointmentDetailView: View {
    var appointment: Appointment
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
                    Text("\(appointment.doctorName)")
                        .accessibilityLabel("Doctor's Name")
                        .accessibilityValue(appointment.doctorName)
                }
                Divider()
                    .accessibility(hidden: true)

                HStack {
                    Text("Hospital: ")
                        .bold()
                        .font(.headline)
                    Spacer()
                    Text("\(appointment.hospitalName)")
                        .accessibilityLabel("Hospital Name")
                        .accessibilityValue(appointment.hospitalName)
                }
                Divider()
                    .accessibility(hidden: true)
                HStack {
                    Text("Date: ")
                        .bold()
                        .font(.headline)
                    Spacer()
                    Text("\(appointment.appointmentDate, style: .date)")
                        .accessibilityLabel("Appointment Date")
                        .accessibilityValue("\(appointment.appointmentDate, style: .date)")
                }
                Divider()
                    .accessibility(hidden: true)

                HStack {
                    Text("Time: ")
                        .bold()
                        .font(.headline)
                    Spacer()
                    Text("\(appointment.appointmentTime, style: .time)")
                        .accessibilityLabel("Appointment Time")
                        .accessibilityValue("\(appointment.appointmentTime, style: .time)")
                }
                Divider()
                    .accessibility(hidden: true)
                    .padding(.bottom, 20)

                HStack {
                    Text("Notes: ")
                        .bold()
                        .font(.headline)
                    Spacer()
                    Text("\(appointment.notes)")
                        .accessibilityLabel("Appointment Notes")
                        .accessibilityValue(appointment.notes)
                }
                Spacer()
            }
            .padding()
            .navigationTitle("Appointment Details")
            .navigationBarItems(trailing: Button(action: {
                if let index = AppointmentDataManager.shared.loadAppointments().firstIndex(where: { $0.id == appointment.id }) {
                    onDelete(IndexSet([index]))
                    dismiss()
                }
            }) {
                Image(systemName: "trash")
                    .accessibilityLabel("Delete Appointment")
                    .accessibilityHint("Delete this appointment")
            })
        }
        .padding(.top)
    }
}
