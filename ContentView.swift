import SwiftUI

struct ContentView: View {
    @AppStorage("showIntroView") private var showIntroView: Bool = true
    @State private var visibility: NavigationSplitViewVisibility = .all

    var body: some View {
        NavigationSplitView(columnVisibility: $visibility) {
            SidebarView()
                .navigationSplitViewColumnWidth(360)
        } content: {
            Text("Please select an item from the sidebar.")
                .accessibilityLabel("Content Area. Select an option from the sidebar.")
                .font(.body)
                .padding()
        } detail: {
            Text("Welcome to the application.")
                .accessibilityLabel("Welcome Message.")
                .font(.body)
                .padding()
        }
        .navigationSplitViewStyle(.balanced)
        .sheet(isPresented: $showIntroView) {
            IntroScreen()
                .interactiveDismissDisabled()
        }
    }
}
