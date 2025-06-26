import SwiftUI
import SwiftData
import VisionKit

struct SidebarView: View {
    @State private var showScannerView: Bool = false
    @State private var scanDocument: VNDocumentCameraScan?
    @State private var documentName: String = "New Document"
    @State private var askDocumentName: Bool = false
    @State private var isLoading: Bool = false
    
    @Query(sort: [.init(\Document.createdAt, order: .reverse)], animation: .snappy(duration: 0.25, extraBounce: 0)) private var documents: [Document]
    
    @Environment(\.modelContext) private var context
    @Namespace private var animationID
    @State private var selectedOption: String? = nil
    
    
    
    var body: some View {
        VStack{
            //CARE Title
            HStack{
                Text("Care")
                    .font(.system(size: 40))
                    .fontWeight(.bold)
                Spacer()
            }
                HStack{
                    NavigationLink(destination: AccountView()
                                   , tag: "View1" , selection: $selectedOption) {
                        ZStack{
                            RoundedRectangle(cornerRadius: 15)
                                .fill(selectedOption == "View1" ? Color.blue : Color.black.opacity(0.05))
                                .frame(minWidth: 140,maxWidth: .infinity)
                            HStack{
                                VStack(alignment: .leading){
                                    Image(systemName: "person.circle.fill")
                                        .resizable()
                                        .scaledToFill()
                                        .aspectRatio(1/1 ,contentMode: .fit)
                                        .symbolRenderingMode(.multicolor)
                                        .foregroundStyle(.blue)
                                    
                                        .foregroundStyle(.blue, .white)
                                        .frame(minWidth: 30, idealWidth: 30, maxWidth: 30)
                                    
                                    Text("Account")
                                    
                                        .font(.title3)
                                        .bold()
                                        .foregroundColor(selectedOption == "View1" ? .white : .black)
                                }
                                .padding()
                                Spacer()
                            }
                            .padding(.trailing)
                        }.frame(minHeight:110, idealHeight: 110, maxHeight: 110)
                        
                    }
                    NavigationLink(destination: AppointmentListView(), tag: "View2" , selection: $selectedOption) {
                        ZStack{
                            RoundedRectangle(cornerRadius: 15)
                                .fill(selectedOption == "View2" ? Color(red:255/255,green:87/255,blue:51/255) : Color.black.opacity(0.05))
                                .frame(minWidth: 140,maxWidth: .infinity)
                            HStack{
                                VStack(alignment: .leading){
                                    Image(systemName: "stethoscope.circle.fill")
                                        .resizable()
                                        .scaledToFill()
                                        .symbolRenderingMode(.multicolor)
                                        .foregroundStyle(Color(red:255/255,green:87/255,blue:51/255))
                                        .aspectRatio(1/1 ,contentMode: .fit)
                                        .frame(minWidth: 30, idealWidth: 30, maxWidth: 30)
                                    
                                    Text("Visits")
                                    
                                        .font(.title3)
                                        .foregroundColor(selectedOption == "View2" ? .white : .black)
                                        .bold()
                                }
                                .padding()
                                Spacer()
                            }
                        }
                    }.frame(minHeight:110, idealHeight: 110, maxHeight: 110)
                    
                }
                
                HStack{
                    NavigationLink(destination: MedicationView()
                                   , tag: "View3" , selection: $selectedOption) {
                        ZStack{
                            RoundedRectangle(cornerRadius: 15)
                                .fill(selectedOption == "View3" ? Color(red:255/255,green:191/255,blue:0/255) : Color.black.opacity(0.05))
                                .frame(minWidth: 140,maxWidth: .infinity)
                            HStack{
                                VStack(alignment: .leading){
                                    Image(systemName: "pill.circle.fill")
                                        .resizable()
                                        .scaledToFill()
                                        .aspectRatio(1/1 ,contentMode: .fit)
                                        .symbolRenderingMode(.multicolor)
                                        .foregroundStyle(Color(red:255/255,green:191/255,blue:0/255))
                                        .frame(minWidth: 30, idealWidth: 30, maxWidth: 30)
                                    
                                    Text("Medication")
                                    
                                        .font(.title3)
                                        .bold()
                                        .foregroundColor(selectedOption == "View3" ? .white : .black)
                                }
                                .padding()
                                Spacer()
                            }
                            .padding(.trailing)
                        }.frame(minHeight:110, idealHeight: 110, maxHeight: 110)
                        
                    }
                    NavigationLink(destination: DocumentsView(), tag: "View4" , selection: $selectedOption) {
                        ZStack{
                            RoundedRectangle(cornerRadius: 15)
                                .fill(selectedOption == "View4" ? Color(red:92/255,green:200/255,blue:77/255) : Color.black.opacity(0.05))
                                .frame(minWidth: 140,maxWidth: .infinity)
                            HStack{
                                VStack(alignment: .leading){
                                    Image(systemName: "tray.circle.fill")
                                        .resizable()
                                        .scaledToFill()
                                        .symbolRenderingMode(.multicolor)
                                        .foregroundStyle(Color(red:92/255,green:200/255,blue:77/255))
                                        .aspectRatio(1/1 ,contentMode: .fit)
                                        .frame(minWidth: 30, idealWidth: 30, maxWidth: 30)
                                    
                                    Text("Records")
                                    
                                        .font(.title3)
                                        .foregroundColor(selectedOption == "View4" ? .white : .black)
                                        .bold()
                                }
                                .padding()
                                Spacer()
                            }
                        }
                    }.frame(minHeight:110, idealHeight: 110, maxHeight: 110)
                }
            
            
            
            
            
            
            
            Spacer()
            CreateButton()
        }
        .padding()
        .fullScreenCover(isPresented: $showScannerView) {
            ScannerView { error in
                
            } didCancel: {
                showScannerView = false
            } didFinish: { scan in
                scanDocument = scan
                showScannerView = false
                askDocumentName = true
            }
            .ignoresSafeArea()
        }
        .alert("Document Name", isPresented: $askDocumentName) {
            TextField("New Document", text: $documentName)
            
            Button("Save"){
                createDocument()
            }
            .disabled(documentName.isEmpty)
        }
        .loadingScreen(status: $isLoading)
    }
    @ViewBuilder
    private func CreateButton() -> some View {
        Button {
            showScannerView.toggle()
        } label: {
            HStack {
                Spacer()
                Text("Add Record")
                    .bold()
                    .font(.headline)
                    .foregroundColor(.white)
                Image(systemName: "plus.circle.fill")
                    .foregroundColor(.white)
                Spacer()
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.blue.gradient)
            .cornerRadius(10)
        }
        .hSpacing(.center)
        .padding(.vertical, 10)
        
        .background(
            Rectangle()
                .fill(.background)
                .mask {
                    Rectangle()
                        .fill(.linearGradient(colors: [
                            .white.opacity(0),
                            .white.opacity(0.5),
                            .white,
                            .white
                        ], startPoint: .top, endPoint: .bottom))
                }
                .ignoresSafeArea()
        )
    }
    
    private func createDocument() {
        guard let scanDocument else { return }
        isLoading = true
        Task.detached(priority: .high) { [documentName] in
            let document = Document(name: documentName)
            var pages: [DocumentPage] = []
            
            for pageIndex in 0..<scanDocument.pageCount {
                let pageImage = scanDocument.imageOfPage(at: pageIndex)
                guard let pageData = pageImage.jpegData(compressionQuality: 0.65) else { return }
                let documentPage = DocumentPage(document: document, pageIndex: pageIndex, pageData: pageData)
                pages.append(documentPage)
            }
            
            document.pages = pages
            
            await MainActor.run {
                context.insert(document)
                try? context.save()
                
                self.scanDocument = nil
                isLoading = false
                self.documentName = "New Document"
            }
        }
    }
}

