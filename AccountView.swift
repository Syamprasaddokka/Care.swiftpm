import SwiftUI

// Data model for user profile
struct UserProfile: Codable, Equatable {
    var firstName: String
    var lastName: String
    var email: String
    var address: String
    var emoji: String
    var lastUpdated: Date
    var bloodType: String
    var allergies: String
    var medicalConditions: String
    var emergencyContactName: String
    var emergencyContactPhone: String
    var age: Int
    var gender: String
    
    var fullName: String {
        return "\(firstName) \(lastName)"
    }
}

class UserProfileManager: ObservableObject {
    @Published var userProfile: UserProfile
    private let fileManager = FileManager.default
    private let docURL: URL
    
    init() {
        self.docURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            .appendingPathComponent("userProfile.json")
        
        if let data = try? Data(contentsOf: docURL),
           let loadedProfile = try? JSONDecoder().decode(UserProfile.self, from: data) {
            self.userProfile = loadedProfile
        } else {
            self.userProfile = UserProfile(
                firstName: "Sherlock",
                lastName: "Holmes",
                email: "SherlockHolmes@example.com",
                address: "221B, Backer Street, London",
                emoji: "🕵🏻‍♂️",
                lastUpdated: Date(),
                bloodType: "A+",
                allergies: "Peanuts",
                medicalConditions: "Asthma",
                emergencyContactName: "John Watson",
                emergencyContactPhone: "+91 80749*****",
                age: 30,
                gender: "Male"
            )
        }
    }
    
    // Save the profile to the file
    func saveProfile() {
        userProfile.lastUpdated = Date()
        if let encodedData = try? JSONEncoder().encode(userProfile) {
            do {
                try encodedData.write(to: docURL)
            } catch {
                print("Error saving profile: \(error)")
            }
        }
    }
}

struct AccountView: View {
    @StateObject private var profileManager = UserProfileManager()
    @State private var isEditing = false
    @State private var editedProfile = UserProfile(
        firstName: "",
        lastName: "",
        email: "",
        address: "",
        emoji: "😊",
        lastUpdated: Date(),
        bloodType: "",
        allergies: "",
        medicalConditions: "",
        emergencyContactName: "",
        emergencyContactPhone: "",
        age: 0,
        gender: ""
    )
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter
    }
    
    private let bloodTypes = ["A+", "A-", "B+", "B-", "AB+", "AB-", "O+", "O-"]
    private let genders = ["Male", "Female", "Other"]
    private let emojis = ["😊", "😀", "😄", "😁", "😆", "😅", "🤣", "😂", "🙂", "🤗", "🤔", "🫖", "🥹", "😎", "🥳", "🌈", "✨", "🌟", "💫", "💖", "❤️", "🔥", "🎉", "🎈", "🎊", "🎁"]
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Profile Emoji
                    VStack {
                        Text(isEditing ? editedProfile.emoji : profileManager.userProfile.emoji)
                            .font(.system(size: 80))
                            .frame(width: 120, height: 120)
                            .background(Color(.systemGray6))
                            .clipShape(Circle())
                        
                        if isEditing {
                            HStack {
                                Text("Select an Emoji")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                
                                Spacer()
                                
                                Text(editedProfile.emoji)
                                    .font(.system(size: 30))
                                    .padding(.trailing)
                            }
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 10) {
                                    ForEach(emojis, id: \.self) { emoji in
                                        Button(action: {
                                            editedProfile.emoji = emoji
                                        }) {
                                            Text(emoji)
                                                .font(.system(size: 30))
                                                .frame(width: 40, height: 40)
                                                .background(editedProfile.emoji == emoji ? Color.blue : Color.clear)
                                                .cornerRadius(10)
                                                .foregroundColor(editedProfile.emoji == emoji ? .white : .black)
                                        }
                                    }
                                }
                                .padding()
                            }
                            .background(Color(.systemGray6))
                            .cornerRadius(12)
                            .padding(.horizontal)
                        }
                    }
                    .padding(.top)
                    
                    VStack(spacing: 20) {
                        if isEditing {
                            fieldLabel("Name")
                            HStack(spacing: 12) {
                                TextField("First Name", text: $editedProfile.firstName)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .padding(.vertical, 8)
                                    .padding(.horizontal, 12)
                                    .background(Color(.systemGray6))
                                    .cornerRadius(12)
                                
                                TextField("Last Name", text: $editedProfile.lastName)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .padding(.vertical, 8)
                                    .padding(.horizontal, 12)
                                    .background(Color(.systemGray6))
                                    .cornerRadius(12)
                            }
                            
                            fieldLabel("Email Address")
                            TextField("Email Address", text: $editedProfile.email)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .padding(.vertical, 8)
                                .padding(.horizontal, 12)
                                .background(Color(.systemGray6))
                                .cornerRadius(12)
                                .keyboardType(.emailAddress)
                                .autocapitalization(.none)
                            
                            fieldLabel("Address")
                            TextEditor(text: $editedProfile.address)
                                .frame(minHeight: 80)
                                .padding(.vertical, 8)
                                .padding(.horizontal, 12)
                                .background(Color(.systemGray6))
                                .cornerRadius(12)
                          
                            fieldLabel("Blood Type")
                            Picker("Blood Type", selection: $editedProfile.bloodType) {
                                ForEach(bloodTypes, id: \.self) { bloodType in
                                    Text(bloodType)
                                }
                            }
                            .pickerStyle(.menu)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.vertical, 8)
                            .padding(.horizontal, 12)
                            .background(Color(.systemGray6))
                            .cornerRadius(12)
                            
                            fieldLabel("Allergies")
                            TextField("Allergies", text: $editedProfile.allergies)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .padding(.vertical, 8)
                                .padding(.horizontal, 12)
                                .background(Color(.systemGray6))
                                .cornerRadius(12)
                            
                            fieldLabel("Medical Conditions")
                            TextField("Medical Conditions", text: $editedProfile.medicalConditions)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .padding(.vertical, 8)
                                .padding(.horizontal, 12)
                                .background(Color(.systemGray6))
                                .cornerRadius(12)
                            
                            fieldLabel("Emergency Contact Name")
                            TextField("Emergency Contact Name", text: $editedProfile.emergencyContactName)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .padding(.vertical, 8)
                                .padding(.horizontal, 12)
                                .background(Color(.systemGray6))
                                .cornerRadius(12)
                            
                            fieldLabel("Emergency Contact Phone")
                            TextField("Emergency Contact Phone", text: $editedProfile.emergencyContactPhone)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .padding(.vertical, 8)
                                .padding(.horizontal, 12)
                                .background(Color(.systemGray6))
                                .cornerRadius(12)
                                .keyboardType(.phonePad)
                            
                            fieldLabel("Age")
                            TextField("Age", value: $editedProfile.age, formatter: NumberFormatter())
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .padding(.vertical, 8)
                                .padding(.horizontal, 12)
                                .background(Color(.systemGray6))
                                .cornerRadius(12)
                                .keyboardType(.numberPad)
                            
                            fieldLabel("Gender")
                            Picker("Gender", selection: $editedProfile.gender) {
                                ForEach(genders, id: \.self) { gender in
                                    Text(gender)
                                }
                            }
                            .pickerStyle(.menu)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.vertical, 8)
                            .padding(.horizontal, 12)
                            .background(Color(.systemGray6))
                            .cornerRadius(12)
                        } else {
                            displayField(title: "Name", value: profileManager.userProfile.fullName)
                            displayField(title: "Email Address", value: profileManager.userProfile.email)
                            displayField(title: "Address", value: profileManager.userProfile.address)
                            
                            displayField(title: "Blood Type", value: profileManager.userProfile.bloodType)
                            displayField(title: "Allergies", value: profileManager.userProfile.allergies)
                            displayField(title: "Medical Conditions", value: profileManager.userProfile.medicalConditions)
                            displayField(title: "Emergency Contact Name", value: profileManager.userProfile.emergencyContactName)
                            displayField(title: "Emergency Contact Phone", value: profileManager.userProfile.emergencyContactPhone)
                            displayField(title: "Age", value: "\(profileManager.userProfile.age)")
                            displayField(title: "Gender", value: profileManager.userProfile.gender)
                        }
                    }
                    .padding(.horizontal)
                    
                    if !isEditing {
                        Text("Last updated: \(dateFormatter.string(from: profileManager.userProfile.lastUpdated))")
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal)
                    }
                }
            }.padding(15)
        }.navigationBarTitle("Account Profile")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    if isEditing {
                        HStack(spacing: 16) {
                            Button("Cancel") {
                                isEditing = false
                            }
                            .foregroundColor(.red)
                            
                            Button("Save") {
                                profileManager.userProfile = editedProfile
                                profileManager.saveProfile()
                                isEditing = false
                            }
                            .foregroundColor(.blue)
                        }
                    } else {
                        Button("Edit") {
                            editedProfile = profileManager.userProfile
                            isEditing = true
                        }
                        .foregroundColor(.blue)
                    }
                }
            }
            .onAppear {
                editedProfile = profileManager.userProfile
                isEditing = false
            }
    }
    
    @ViewBuilder
    private func fieldLabel(_ title: String) -> some View {
        Text(title)
            .font(.subheadline)
            .foregroundColor(.secondary)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    @ViewBuilder
    private func displayField(title: String, value: String) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            Text(value)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.vertical, 8)
                .padding(.horizontal, 12)
                .background(Color(.systemGray6))
                .cornerRadius(12)
        }
    }
}

struct AccountView_Previews: PreviewProvider {
    static var previews: some View {
        AccountView()
    }
}
