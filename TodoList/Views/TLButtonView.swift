//
//  TLButtonView.swift
//  TodoList
//
//  Created by Dax Granados on 10/22/23.
//

import SwiftUI

struct TLButtonView: View {
    let title: String
    let background: Color
    let action: () -> Void
    
    var body: some View {
        Button {
            //Action
            action()
        } label: {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .foregroundColor(background)
                Text(title)
                    .foregroundColor(.white)
                    .bold()
            }
        }
        .padding()
    }
}

#Preview {
    TLButtonView(title: "Value", background: .pink) {
        //Action
    }
}
