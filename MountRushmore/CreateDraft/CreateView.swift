import SwiftUI

struct CreateView: View {

    @State private var draftName: String = ""
    @State private var topic: String = ""
    var submitDraftInfo: (String, String) -> Void = { _, _ in }

    var body: some View {
        VStack {
            VStack(alignment: .leading) {
                Text("Draft Name")
                    .font(.headline)
                TextField("Enter draft name e.g. Draft #1", text: $draftName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                Text("Topic")
                    .font(.headline)
                    .padding(.top)
                TextField("Enter topic e.g. Desserts", text: $topic)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
            .padding()
            
            Spacer()
            
            let isButtonDisabled = draftName.isEmpty || topic.isEmpty
            
            Button(action: {
                submitDraftInfo(draftName, topic)
            }) {
                Text("CREATE")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(isButtonDisabled ? Color.gray : Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding()
            .disabled(isButtonDisabled)
        }
        .padding()
    }
}

#Preview {
    CreateView()
} 
