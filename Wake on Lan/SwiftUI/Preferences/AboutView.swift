//
//  AboutView.swift
//  Wake on Lan
//
//  Created by Iván Moreno Zambudio on 13/07/2020.
//

import SwiftUI

struct AboutView: View {
    var body: some View {
        VStack {
            Text("Made with ❤️ in Murcia")
        }
        .frame(width: 500, height: 300)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.leading)
        .padding(.trailing)
    }
}

struct AboutView_Previews: PreviewProvider {
    static var previews: some View {
        AboutView()
    }
}
