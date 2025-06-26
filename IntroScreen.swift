import SwiftUI

struct IntroScreen: View {
    
    @AppStorage("showIntroView") private var showIntroView: Bool = true
    
    var body: some View {
        VStack(spacing: 15) {
            Text("Hello, I'm care")
                .font(.largeTitle)
                .bold()
                .multilineTextAlignment(.center)
                .padding(.top, 65)
                
            Text("Your new medical data manager.")
                .padding(.bottom, 50)
            ScrollView{
                VStack(alignment: .leading, spacing: 30) {
                    HStack(spacing: 15) {
                        Image(systemName: "scanner")
                            .font(.largeTitle)
                            .foregroundStyle(.yellow.gradient)
                        
                        VStack(alignment: .leading, spacing: 6) {
                            Text("Scan Medical Records")
                                .font(.title3)
                                .fontWeight(.semibold)
                            
                            Text("Scan and store any medical document with ease")
                                .font(.callout )
                                .backgroundStyle(.gray)
                        }
                    }
                    HStack(spacing: 15) {
                        Image(systemName: "person.circle.fill")
                            .font(.largeTitle)
                            .foregroundStyle(.blue.gradient)
                        
                        VStack(alignment: .leading, spacing: 6) {
                            Text("A complete Medcal Profile")
                                .font(.title3)
                                .fontWeight(.semibold)
                            
                            Text("Collection of medical profiling in one place.")
                                .font(.callout )
                                .backgroundStyle(.gray)
                        }
                    }
                    HStack(spacing: 15) {
                        Image(systemName: "tray.full.fill")
                            .font(.largeTitle)
                            .foregroundStyle(.green.gradient)
                        
                        VStack(alignment: .leading, spacing: 6) {
                            Text("Medication & Appointmenta")
                                .font(.title3)
                                .fontWeight(.semibold)
                            
                            Text("Manage Medical Visits and Appointments")
                                .font(.callout )
                                .backgroundStyle(.gray)
                        }
                    }
                }.padding(.horizontal, 25)
            }
            
            Spacer()
            Button {
                showIntroView = false
            } label: {
                Text("Explore")
                    .fontWeight(.bold)
                    .foregroundStyle(.white)
                    .padding()
                    .frame(width:130)
                    .background(.blue.gradient)
                    .cornerRadius(10)
            }
        }
        .padding(15)
        .preferredColorScheme(.light)
    }
}

#Preview {
    IntroScreen()
}
