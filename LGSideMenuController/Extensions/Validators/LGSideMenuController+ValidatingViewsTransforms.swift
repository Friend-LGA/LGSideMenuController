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

        // TODO: Add callback

        // TODO: Add option to change alpha of the view itself

        let isLeftViewMoving = self.leftView != nil && self.isLeftViewVisible
        let isRightViewMoving = self.rightView != nil && self.isRightViewVisible

        rootViewCoverView.alpha = {
            if isLeftViewMoving {
                return self.rootViewCoverAlphaForLeftView * percentage
            }
            else if isRightViewMoving {
                return self.rootViewCoverAlphaForRightView * percentage
            }
            else {
                return percentage
            }
        }()

        let scale: CGFloat = {
            // If any of side views is visible, we can't change the scale of root view
            if !self.leftViewPresentationStyle.shouldRootViewScale ||
                self.isSideViewAlwaysVisibleForCurrentOrientation {
                return 1.0
            }
            var rootViewScale: CGFloat = 1.0
            if isLeftViewMoving {
                rootViewScale = self.rootViewScaleForLeftView
            }
            if isRightViewMoving {
                rootViewScale = self.rootViewScaleForRightView
            }
            return 1.0 + (rootViewScale - 1.0) * percentage
        }()

        let translateX: CGFloat = {
            if !self.leftViewPresentationStyle.shouldRootViewMove {
                return 0.0
            }
            let shift = self.view.bounds.width * (1.0 - scale) / 2.0
            if isLeftViewMoving {
                return (self.rootViewOffsetTotalForLeftView - shift) * percentage
            }
            else if isRightViewMoving {
                return -(self.rootViewOffsetTotalForRightView - shift) * percentage
            }
            return 0.0
        }()

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

        // TODO: Add callback

        // TODO: Add option to change alpha of the view itself

        leftContainerView.transform = {
            var translateX: CGFloat = 0.0
            if self.rightView != nil && self.isRightViewVisible {
                if self.leftViewPresentationStyle.isHiddenAside && !self.isLeftViewAlwaysVisibleForCurrentOrientation {
                    translateX -= self.leftViewWidthTotal
                }
                if self.isRootViewShouldMoveForRightView {
                    translateX -= self.rootViewOffsetTotalForRightView * percentage
                }
            }
            else if self.leftViewPresentationStyle.isHiddenAside && !self.isLeftViewAlwaysVisibleForCurrentOrientation {
                translateX -= self.leftViewWidthTotal * (1.0 - percentage)
            }
            return CGAffineTransform(translationX: translateX, y: 0.0)
        }()

        leftViewShadowView.alpha = {
            if self.leftViewPresentationStyle.isAbove && !self.isLeftViewAlwaysVisibleForCurrentOrientation {
                let pointsPerPercent = self.leftViewWidthTotal / 100.0
                let percentsNeeded = pointsNeededForShadow / pointsPerPercent / 100.0
                return percentage / percentsNeeded
            }
            return 1.0
        }()

        leftViewCoverView.alpha = {
            if !self.isLeftViewAlwaysVisibleForCurrentOrientation {
                return self.leftViewCoverAlpha - (self.leftViewCoverAlpha * percentage)
            }
            else if self.rightView != nil && self.isRightViewVisible {
                return self.leftViewCoverAlphaWhenAlwaysVisible * percentage
            }
            return 0.0
        }()

        let backgroundViewTransform: CGAffineTransform = {
            if !self.isLeftViewAlwaysVisibleForCurrentOrientation {
                let scale = self.leftViewBackgroundImageFinalScale + ((self.leftViewBackgroundImageInitialScale - self.leftViewBackgroundImageFinalScale) * (1.0 - percentage))
                return CGAffineTransform(scaleX: scale, y: scale)
            }
            return .identity
        }()

        let wrapperViewTransform: CGAffineTransform = {
            if !self.isLeftViewAlwaysVisibleForCurrentOrientation {
                let scale = 1.0 + (self.leftViewInitialScale - 1.0) * (1.0 - percentage)
                let offset = self.leftViewInitialOffsetX * (1.0 - percentage)

                let transformTranslate = CGAffineTransform(translationX: offset, y: 0.0)
                let transformScale = CGAffineTransform(scaleX: scale, y: scale)

                return transformTranslate.concatenating(transformScale)
            }
            return .identity
        }()

        leftViewShadowView.transform = backgroundViewTransform
        leftViewBackgroundView.transform = backgroundViewTransform
        leftViewStyleView.transform = wrapperViewTransform
        leftViewWrapperView.transform = wrapperViewTransform
    }

    func validateRightViewsTransforms(percentage: CGFloat) {
        guard self.rightView != nil,
              let rightContainerView = self.rightContainerView,
              let rightViewShadowView = self.rightViewShadowView,
              let rightViewBackgroundView = self.rightViewBackgroundView,
              let rightViewStyleView = self.rightViewEffectView,
              let rightViewWrapperView = self.rightViewWrapperView,
              let rightViewCoverView = self.rightViewCoverView else { return }

        // TODO: Add callback

        // TODO: Add option to change alpha of the view itself

        rightContainerView.transform = {
            var translateX: CGFloat = 0.0
            if self.leftView != nil && self.isLeftViewVisible {
                if self.rightViewPresentationStyle.isHiddenAside && !self.isRightViewAlwaysVisibleForCurrentOrientation {
                    translateX += self.rightViewWidthTotal
                }
                if self.isRootViewShouldMoveForLeftView {
                    translateX += self.rootViewOffsetTotalForLeftView * percentage
                }
            }
            else if self.rightViewPresentationStyle.isHiddenAside && !self.isRightViewAlwaysVisibleForCurrentOrientation {
                translateX += self.rightViewWidthTotal * (1.0 - percentage)
            }
            return CGAffineTransform(translationX: translateX, y: 0.0)
        }()

        rightViewShadowView.alpha = {
            if self.rightViewPresentationStyle.isAbove && !self.isRightViewAlwaysVisibleForCurrentOrientation {
                let pointsPerPercent = self.rightViewWidthTotal / 100.0
                let percentsNeeded = pointsNeededForShadow / pointsPerPercent / 100.0
                return percentage / percentsNeeded
            }
            return 1.0
        }()

        rightViewCoverView.alpha = {
            if !self.isRightViewAlwaysVisibleForCurrentOrientation {
                return self.rightViewCoverAlpha - (self.rightViewCoverAlpha * percentage)
            }
            else if self.leftView != nil && self.isLeftViewVisible {
                return self.rightViewCoverAlphaWhenAlwaysVisible * percentage
            }
            return 0.0
        }()

        let backgroundViewTransform: CGAffineTransform = {
            if !self.isRightViewAlwaysVisibleForCurrentOrientation {
                let scale = self.rightViewBackgroundImageFinalScale + ((self.rightViewBackgroundImageInitialScale - self.rightViewBackgroundImageFinalScale) * (1.0 - percentage))
                return CGAffineTransform(scaleX: scale, y: scale)
            }
            return .identity
        }()

        let wrapperViewTransform: CGAffineTransform = {
            if !self.isRightViewAlwaysVisibleForCurrentOrientation {
                let scale = 1.0 + (self.rightViewInitialScale - 1.0) * (1.0 - percentage)
                let offset = self.rightViewInitialOffsetX * (1.0 - percentage)

                let transformTranslate = CGAffineTransform(translationX: offset, y: 0.0)
                let transformScale = CGAffineTransform(scaleX: scale, y: scale)

                return transformTranslate.concatenating(transformScale)
            }
            return .identity
        }()

        rightViewShadowView.transform = backgroundViewTransform
        rightViewBackgroundView.transform = backgroundViewTransform
        rightViewStyleView.transform = wrapperViewTransform
        rightViewWrapperView.transform = wrapperViewTransform
    }
    
}
