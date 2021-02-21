//
//  LGSideMenuController+ValidatingViewsTransforms.swift
//  LGSideMenuController
//
//
//  The MIT License (MIT)
//
//  Copyright © 2015 Grigorii Lutkov <friend.lga@gmail.com>
//  (https://github.com/Friend-LGA/LGSideMenuController)
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//

import Foundation
import UIKit

private let pointsNeededForShadow: CGFloat = 10.0

internal extension LGSideMenuController {

    func validateViewsTransforms() {
        self.validateRootViewsTransforms()
        self.validateLeftViewsTransforms()
        self.validateRightViewsTransforms()
    }

    func validateRootViewsTransforms() {
        validateRootViewsTransforms(percentage: self.isSideViewShowing ? 1.0 : 0.0)
    }

    func validateLeftViewsTransforms() {
        validateLeftViewsTransforms(percentage: self.isSideViewShowing ? 1.0 : 0.0)
    }

    func validateRightViewsTransforms() {
        validateRightViewsTransforms(percentage: self.isSideViewShowing ? 1.0 : 0.0)
    }

    func validateRootViewsTransforms(percentage: CGFloat) {
        guard let rootContainerView = self.rootContainerView,
              let rootViewCoverView = self.rootViewCoverView else { return }

        let isLeftViewMoving = self.leftView != nil && self.isLeftViewVisible
        let isRightViewMoving = self.rightView != nil && self.isRightViewVisible

        if isLeftViewMoving {
            rootViewCoverView.alpha = self.rootViewCoverAlphaForLeftView * percentage
        }
        else if isRightViewMoving {
            rootViewCoverView.alpha = self.rootViewCoverAlphaForRightView * percentage
        }
        else {
            rootViewCoverView.alpha = percentage
        }

        let originalWidth = self.view.bounds.width
        var translateX: CGFloat = 0.0
        var scale: CGFloat = 1.0

        if isLeftViewMoving {
            if !self.isSideViewAlwaysVisibleForCurrentOrientation {
                // If any of side views is visible, we can't change the scale of root view
                scale = 1.0 + (self.rootViewScaleForLeftView - 1.0) * percentage
            }

            if self.leftViewPresentationStyle != .slideAbove {
                let shift = originalWidth * (1.0 - scale) / 2.0
                translateX = (self.leftViewWidthTotal - shift) * percentage
            }
        }
        else if isRightViewMoving {
            if !self.isSideViewAlwaysVisibleForCurrentOrientation {
                // If any of side views is visible, we can't change the scale of root view
                scale = 1.0 + (self.rootViewScaleForRightView - 1.0) * percentage
            }

            if self.rightViewPresentationStyle != .slideAbove {
                let shift = originalWidth * (1.0 - scale) / 2.0
                translateX = -(self.rightViewWidthTotal - shift) * percentage
            }
        }

        let transformScale = CGAffineTransform(scaleX: scale, y: scale)
        let transfromTranslate = CGAffineTransform(translationX: translateX, y: 0.0)
        let transform = transformScale.concatenating(transfromTranslate)

        rootContainerView.transform = transform
    }

    func validateLeftViewsTransforms(percentage: CGFloat) {
        guard self.leftView != nil,
              let leftContainerView = self.leftContainerView,
              let leftViewShadowView = self.leftViewShadowView,
              let leftViewBackgroundView = self.leftViewBackgroundView,
              let leftViewStyleView = self.leftViewEffectView,
              let leftViewWrapperView = self.leftViewWrapperView,
              let leftViewCoverView = self.leftViewCoverView else { return }

        // TODO: Add option to change alpha of the view itself

        leftContainerView.transform = {
            var translateX: CGFloat = 0.0
            if self.rightView != nil && self.isRightViewVisible {
                if !self.isLeftViewAlwaysVisibleForCurrentOrientation && self.leftViewPresentationStyle == .slideAbove {
                    translateX -= self.leftViewWidthTotal
                }
                if self.isRootViewShouldMoveForRightView {
                    translateX -= self.rightViewWidthTotal * percentage
                }
            }
            else if !self.isLeftViewAlwaysVisibleForCurrentOrientation && self.leftViewPresentationStyle == .slideAbove {
                translateX -= self.leftViewWidthTotal * (1.0 - percentage)
            }
            return CGAffineTransform(translationX: translateX, y: 0.0)
        }()

        leftViewShadowView.alpha = {
            if !self.isLeftViewAlwaysVisibleForCurrentOrientation {
                if self.leftViewPresentationStyle.isAbove {
                    let pointsPerPercent = self.leftViewWidthTotal / 100.0
                    let percentsNeeded = pointsNeededForShadow / pointsPerPercent / 100.0
                    return percentage / percentsNeeded
                }
            }
            return 1.0
        }()

        leftViewCoverView.alpha = {
            if !self.isLeftViewAlwaysVisibleForCurrentOrientation {
                if self.isLeftViewVisible {
                    return self.leftViewCoverAlpha - (self.leftViewCoverAlpha * percentage)
                }
            }
            else if self.rightView != nil && self.isRightViewVisible {
                return self.leftViewCoverAlphaWhenAlwaysVisible * percentage
            }
            return 0.0
        }()

        var wrapperViewTransform: CGAffineTransform = .identity
        var backgroundViewTransform: CGAffineTransform = .identity

        if !self.isLeftViewAlwaysVisibleForCurrentOrientation {
            let scale = 1.0 + (self.leftViewInitialScale - 1.0) * (1.0 - percentage)
            let backgroundViewScale = self.leftViewBackgroundImageFinalScale + ((self.leftViewBackgroundImageInitialScale - self.leftViewBackgroundImageFinalScale) * (1.0 - percentage))
            let wrapperViewOffset = self.leftViewInitialOffsetX * (1.0 - percentage)

            let wrapperViewTransformTranslate = CGAffineTransform(translationX: wrapperViewOffset, y: 0.0)
            let wrapperViewTransformScale = CGAffineTransform(scaleX: scale, y: scale)

            wrapperViewTransform = wrapperViewTransformScale.concatenating(wrapperViewTransformTranslate)
            backgroundViewTransform = CGAffineTransform(scaleX: backgroundViewScale, y: backgroundViewScale)
        }

        leftViewWrapperView.transform = wrapperViewTransform
        leftViewShadowView.transform = backgroundViewTransform
        leftViewBackgroundView.transform = backgroundViewTransform
        leftViewStyleView.transform = wrapperViewTransform
    }

    func validateRightViewsTransforms(percentage: CGFloat) {
        guard self.rightView != nil,
              let rightContainerView = self.rightContainerView,
              let rightViewShadowView = self.rightViewShadowView,
              let rightViewBackgroundView = self.rightViewBackgroundView,
              let rightViewStyleView = self.rightViewEffectView,
              let rightViewWrapperView = self.rightViewWrapperView,
              let rightViewCoverView = self.rightViewCoverView else { return }

        // TODO: Add option to change alpha of the view itself

        rightContainerView.transform = {
            var translateX: CGFloat = 0.0
            if self.leftView != nil && self.isLeftViewVisible {
                if !self.isRightViewAlwaysVisibleForCurrentOrientation && self.rightViewPresentationStyle == .slideAbove {
                    translateX += self.rightViewWidthTotal
                }
                if self.isRootViewShouldMoveForLeftView {
                    translateX += self.leftViewWidthTotal * percentage
                }
            }
            else if !self.isRightViewAlwaysVisibleForCurrentOrientation && self.rightViewPresentationStyle == .slideAbove {
                translateX += self.rightViewWidthTotal * (1.0 - percentage)
            }
            return CGAffineTransform(translationX: translateX, y: 0.0)
        }()

        rightViewShadowView.alpha = {
            if self.rightViewPresentationStyle.isAbove {
                let pointsPerPercent = self.rightViewWidthTotal / 100.0
                let percentsNeeded = pointsNeededForShadow / pointsPerPercent / 100.0
                return percentage / percentsNeeded
            }
            return 1.0
        }()

        rightViewCoverView.alpha = {
            if !self.isRightViewAlwaysVisibleForCurrentOrientation {
                if self.isRightViewVisible {
                    return self.rightViewCoverAlpha - (self.rightViewCoverAlpha * percentage)
                }
            }
            else if self.leftView != nil && self.isLeftViewVisible {
                return self.rightViewCoverAlphaWhenAlwaysVisible * percentage
            }
            return 0.0
        }()

        var wrapperViewTransform: CGAffineTransform = .identity
        var backgroundViewTransform: CGAffineTransform = .identity

        if !self.isRightViewAlwaysVisibleForCurrentOrientation {
            let scale = 1.0 + (self.rightViewInitialScale - 1.0) * (1.0 - percentage)
            let backgroundViewScale = self.rightViewBackgroundImageFinalScale + ((self.rightViewBackgroundImageInitialScale - self.rightViewBackgroundImageFinalScale) * (1.0 - percentage))
            let additionalWrapperViewOffset = self.rightViewInitialOffsetX * (1.0 - percentage)

            let wrapperViewTransformTranslate = CGAffineTransform(translationX: additionalWrapperViewOffset, y: 0.0)
            let wrapperViewTransformScale = CGAffineTransform(scaleX: scale, y: scale)

            wrapperViewTransform = wrapperViewTransformScale.concatenating(wrapperViewTransformTranslate)
            backgroundViewTransform = CGAffineTransform(scaleX: backgroundViewScale, y: backgroundViewScale)
        }

        rightViewWrapperView.transform = wrapperViewTransform
        rightViewShadowView.transform = backgroundViewTransform
        rightViewBackgroundView.transform = backgroundViewTransform
        rightViewStyleView.transform = wrapperViewTransform
    }
    
}
