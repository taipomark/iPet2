//
//  Text+Ext.swift
//  iPet
//
//  Created by Mark Lai on 22/9/2021.
//

import Foundation
import SwiftUI

extension Text {

    func deepRedTextStyle() -> some View {
        self.foregroundColor(.red)
            .italic()
            .opacity(0.7)
            .font(.subheadline)
    }

    func captionTextStyle() -> some View {
        self.foregroundColor(.secondary)
            .font(.caption)
    }
    
    func topicTextStyle() -> some View{
        self.font(.system(size: 40, weight: .black, design: .rounded))
    }
    
    func contentTextStyle() -> some View{
        self.font(.system(.body, design: .rounded))
        .fontWeight(.black)
        .foregroundColor(.black)
    }
    
    func contentHeadTextStyle() -> some View{
        self.font(.system(.headline, design: .rounded))
        .fontWeight(.black)
        .foregroundColor(.black)
    }
    
}
