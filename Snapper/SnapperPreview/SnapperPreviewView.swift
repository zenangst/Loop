//
//  SnapperPreviewView.swift
//  Snapper
//
//  Created by Kai Azim on 2023-01-24.
//

import SwiftUI
import Defaults

struct SnapperPreviewView: View {
    
    // Used to preview inside the app's settings
    @State var previewMode = false
    
    @State var currentSnappingDirection: WindowSnappingOptions = .doNothing
    
    @Default(.snapperUsesSystemAccentColor) var snapperUsesSystemAccentColor
    @Default(.snapperAccentColor) var snapperAccentColor
    @Default(.snapperAccentColorUseGradient) var snapperAccentColorUseGradient
    @Default(.snapperAccentColorGradient) var snapperAccentColorGradient
    
    @Default(.showPreviewWhenSnapping) var showPreviewWhenSnapping
    @Default(.snapperPreviewPadding) var snapperPreviewPadding
    @Default(.snapperPreviewCornerRadius) var snapperPreviewCornerRadius
    @Default(.snapperPreviewBorderThickness) var snapperPreviewBorderThickness
    
    var body: some View {
        VStack {
            if (self.currentSnappingDirection == .bottomHalf ||
                self.currentSnappingDirection == .bottomRightQuarter ||
                self.currentSnappingDirection == .bottomLeftQuarter ||
                self.currentSnappingDirection == .doNothing) {
                Rectangle()
                    .foregroundColor(.clear)
            }
            
            HStack {
                
                if (self.currentSnappingDirection == .topRightQuarter ||
                    self.currentSnappingDirection == .rightHalf ||
                    self.currentSnappingDirection == .bottomRightQuarter ||
                    self.currentSnappingDirection == .doNothing) {
                    Rectangle()
                        .foregroundColor(.clear)
                }
                
                ZStack {
                    VisualEffectView(material: .hudWindow, blendingMode: .behindWindow)
                        .mask(RoundedRectangle(cornerRadius: self.snapperPreviewCornerRadius).foregroundColor(.white))
                        .shadow(radius: 10)
                    RoundedRectangle(cornerRadius: self.snapperPreviewCornerRadius)
                        .stroke(LinearGradient(
                            gradient: Gradient(colors: [
                                self.snapperUsesSystemAccentColor ? Color.accentColor : self.snapperAccentColor,
                                self.snapperUsesSystemAccentColor ? Color.accentColor : self.snapperAccentColorUseGradient ? self.snapperAccentColorGradient : self.snapperAccentColor]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing), lineWidth: self.snapperPreviewBorderThickness)
                }
                .padding(self.snapperPreviewPadding + self.snapperPreviewBorderThickness/2)
                .frame(width: self.currentSnappingDirection == .doNothing ? 0 : nil,
                       height: self.currentSnappingDirection == .doNothing ? 0 : nil)
                .blur(radius: self.currentSnappingDirection == .doNothing ? 20 : 0)
                
                if (self.currentSnappingDirection == .topLeftQuarter ||
                    self.currentSnappingDirection == .leftHalf ||
                    self.currentSnappingDirection == .bottomLeftQuarter ||
                    self.currentSnappingDirection == .doNothing) {
                    Rectangle()
                        .foregroundColor(.clear)
                }
            }
            
            if (self.currentSnappingDirection == .topHalf ||
                self.currentSnappingDirection == .topRightQuarter ||
                self.currentSnappingDirection == .topLeftQuarter ||
                self.currentSnappingDirection == .doNothing) {
                Rectangle()
                    .foregroundColor(.clear)
            }
        }
        .animation(.interpolatingSpring(stiffness: 250, damping: 30), value: self.currentSnappingDirection)
        
        .onReceive(.currentSnappingDirectionChanged) { obj in
            if (!self.previewMode) {
                if let direction = obj.userInfo?["Direction"] as? WindowSnappingOptions {
                    self.currentSnappingDirection = direction
                }
            }
        }
        
        .onAppear {
            if (self.previewMode) {
                self.currentSnappingDirection = .maximize
            }
        }
    }
}