import SwiftUI

struct AppointmentListView: View {
    @State private var appointments: [Appointment] = AppointmentDataManager.shared.loadAppointments()
    
    var body: some View {
        NavigationView {
            List {
                ForEach(appointments) { appointment in
                    NavigationLink(destination: AppointmentDetailView(appointment: appointment, onDelete: deleteAppointment)) {
                        VStack(alignment: .leading) {
                            Text(appointment.appointmentType)
                                .fontWeight(.bold)
                                .font(.headline)
                                .accessibilityLabel("Appointment Type")
                                .accessibilityValue(appointment.appointmentType)
                            
                            Text("\(appointment.doctorName)")
                                .font(.caption)
                                .accessibilityLabel("Doctor's Name")
                                .accessibilityValue(appointment.doctorName)
                            
                            Text(appointment.appointmentDate, style: .date)
                                .font(.caption2)
                                .accessibilityLabel("Appointment Date")
                                .accessibilityValue("\(appointment.appointmentDate, style: .date)")
                            
                            Text(appointment.appointmentTime, style: .time)
                                .font(.caption2)
                                .accessibilityLabel("Appointment Time")
                                .accessibilityValue("\(appointment.appointmentTime, style: .time)")
                        }
                        .accessibilityElement(children: .combine)  
                    }
                    .accessibilityLabel("Go to Appointment Details")
                    .accessibilityHint("Tap to view the details of this appointment")
                }
                .onDelete(perform: deleteAppointment)
                .accessibilityHint("Swipe to delete an appointment")
            }
            .padding(.top, 10)
            
        }.navigationTitle("Appointments")
            .navigationBarItems(trailing: NavigationLink(destination: AddAppointmentView(appointments: $appointments)) {
                Image(systemName: "plus")
                    .accessibilityLabel("Add Appointment")
                    .accessibilityHint("Tap to add a new appointment")
            })
    }
    
    private func deleteAppointment(at offsets: IndexSet) {
        appointments.remove(atOffsets: offsets)
        AppointmentDataManager.shared.saveAppointments(appointments)
    }
}
