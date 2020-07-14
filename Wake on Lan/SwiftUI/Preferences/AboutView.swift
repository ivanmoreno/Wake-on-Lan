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
        .frame(width: Defaults.preferencesWindowWidth,
               height: Defaults.preferencesWindowHeight)
        .padding()
    }
}

struct AboutView_Previews: PreviewProvider {
    static var previews: some View {
        AboutView()
    }
}
