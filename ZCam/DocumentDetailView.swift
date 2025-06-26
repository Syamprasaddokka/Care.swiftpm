import SwiftUI
import PDFKit

struct DocumentDetailView: View {
    @State private var isLoading: Bool = false
    @State private var showFileMover: Bool = false
    @State private var fileURL: URL?

    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context
    
    var document: Document

    var body: some View {
        if let pages = document.pages?.sorted(by: {$0.pageIndex < $1.pageIndex}) {
            VStack(spacing: 10) {
                HeaderView()
                    .padding([.horizontal, .top], 15)

                TabView {
                    ForEach(pages) { page in
                        if let image = UIImage(data: page.pageData) {
                            Image(uiImage: image)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                        }
                    }
                }
                .tabViewStyle(.page)

                FooterView()
            }
            .background(.black)
            .toolbarVisibility(.hidden, for: .navigationBar)
            .loadingScreen(status: $isLoading)
            .fileMover(isPresented: $showFileMover, file: fileURL) { result in
                if case .failure(_) = result {
                    guard let fileURL else { return }
                    try? FileManager.default.removeItem(at: fileURL)
                    self.fileURL = nil
                }
            }
        }
    }
    

    @ViewBuilder
    private func HeaderView() -> some View {
        ZStack {
            HStack{
                Spacer()
                Text(document.name)
                    .font(.callout)
                    .foregroundStyle(.white)
                    .hSpacing(.center)
                Spacer()
            }
            HStack{
                Button(action: {
                    dismiss()
                }) {
                    Image(systemName: "chevron.left")
                        .font(.title3)
                        .foregroundStyle(.blue)
                }
                Text("Back")
                Spacer()
            }
        }
    }

    @ViewBuilder
    private func FooterView() -> some View {
        HStack {
            Button(action: createAndShareDocument) {
                Image(systemName: "square.and.arrow.up.fill")
                    .font(.title3)
                    .foregroundStyle(.blue)
            }

            Spacer()

            Button {
                dismiss()
                Task { @MainActor in
                    try? await Task.sleep(for: .seconds(0.3))
                    context.delete(document)
                    try? context.save()
                }
            } label: {
                Image(systemName: "trash.fill")
                    .font(.title3)
                    .foregroundStyle(.blue)
            }
        }
        .padding([.horizontal, .bottom], 15)
    }

    private func createAndShareDocument() {
        guard let pages = document.pages?.sorted(by: {$0.pageIndex < $1.pageIndex}) else { return }
        isLoading = true

        Task.detached(priority: .high) { [document] in
            try? await Task.sleep(for: .seconds(0.2))

            let pdfDocument = PDFDocument()
            for index in pages.indices {
                if let pageImage = UIImage(data: pages[index].pageData),
                   let pdfPage = PDFPage(image: pageImage) {
                    pdfDocument.insert(pdfPage, at: index)
                }

                var pdfURL = FileManager.default.temporaryDirectory
                let fileName = "\(document.name).pdf"
                pdfURL.append(path: fileName)

                if pdfDocument.write(to: pdfURL) {
                    await MainActor.run { [pdfURL] in
                        fileURL = pdfURL
                        showFileMover = true
                        isLoading = false
                    }
                }
            }
        }
    }
}
