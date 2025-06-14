import SwiftUI

struct CreateView: View {

    @State private var draftName: String = ""
    @State private var topic: String = ""
    var submitDraftInfo: (String, String) -> Void = { _, _ in }

    var body: some View {
        VStack {
            VStack(alignment: .leading) {
                Text("createDraft.nameHeader")
                    .font(.headline)
                TextField("createDraft.namePlaceholder", text: $draftName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                Text("createDraft.topicHeader")
                    .font(.headline)
                    .padding(.top)
                TextField("createDraft.topicPlaceholder", text: $topic)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
            .padding()
            
            Spacer()
            
            let isButtonDisabled = draftName.isEmpty || topic.isEmpty
            
            Button(action: {
                submitDraftInfo(draftName, topic)
            }) {
                Text("createDraft.createButton")
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
