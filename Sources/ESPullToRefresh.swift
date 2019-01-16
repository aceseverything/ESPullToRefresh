//
//  ESPullToRefresh.swift
//
//  Created by egg swift on 16/4/7.
//  Copyright (c) 2013-2016 ESPullToRefresh (https://github.com/eggswift/pull-to-refresh)
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

import Foundation
import UIKit

private var kESRefreshHeaderKey: Void?
private var kESRefreshFooterKey: Void?
private var kESRefreshLeftElementKey: Void?
private var kESRefreshRightElementKey: Void?

public extension UIScrollView {
    
    /// Pull-to-refresh associated property
    public var header: ESRefreshHeaderView? {
        get { return (objc_getAssociatedObject(self, &kESRefreshHeaderKey) as? ESRefreshHeaderView) }
        set(newValue) { objc_setAssociatedObject(self, &kESRefreshHeaderKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN) }
    }
    
    /// Left Pull-to-refresh associated property
    public var leftRefreshElement: ESRefreshLeftView? {
        get { return (objc_getAssociatedObject(self, &kESRefreshLeftElementKey) as? ESRefreshLeftView) }
        set(newValue) { objc_setAssociatedObject(self, &kESRefreshLeftElementKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN) }
    }
    
    /// Right Pull-to-refresh associated property
    public var rightRefreshElement: ESRefreshRightView? {
        get { return (objc_getAssociatedObject(self, &kESRefreshRightElementKey) as? ESRefreshRightView) }
        set(newValue) { objc_setAssociatedObject(self, &kESRefreshRightElementKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN) }
    }
    
    /// Infinitiy scroll associated property
    public var footer: ESRefreshFooterView? {
        get { return (objc_getAssociatedObject(self, &kESRefreshFooterKey) as? ESRefreshFooterView) }
        set(newValue) { objc_setAssociatedObject(self, &kESRefreshFooterKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN) }
    }
    
}

public extension ES where Base: UIScrollView {
    /// Add pull-to-refresh
    @discardableResult
    public func addPullToRefresh(handler: @escaping ESRefreshHandler) -> ESRefreshHeaderView {
        removeRefreshHeader()
        let header = ESRefreshHeaderView(frame: CGRect.zero, handler: handler)
        let headerH = header.animator.executeIncremental
        header.frame = CGRect.init(x: 0.0, y: -headerH /* - contentInset.top */, width: self.base.bounds.size.width, height: headerH)
        self.base.addSubview(header)
        self.base.header = header
        return header
    }
    
    @discardableResult
    public func addPullToRefresh(animator: ESRefreshProtocol & ESRefreshAnimatorProtocol, handler: @escaping ESRefreshHandler) -> ESRefreshHeaderView {
        removeRefreshHeader()
        let header = ESRefreshHeaderView(frame: CGRect.zero, handler: handler, animator: animator)
        let headerH = animator.executeIncremental
        header.frame = CGRect.init(x: 0.0, y: -headerH /* - contentInset.top */, width: self.base.bounds.size.width, height: headerH)
        self.base.addSubview(header)
        self.base.header = header
        return header
    }
    
    @discardableResult
    public func addLeftPullToRefresh(frame: CGRect? = nil, animator: ESRefreshProtocol & ESRefreshAnimatorProtocol, handler: @escaping ESRefreshHandler) -> ESRefreshLeftView {
        removeLeftRefreshElement()
        let refreshElement = ESRefreshLeftView(frame: .zero, handler: handler, animator: animator)
        
        
        let width: CGFloat
        let refreshFrame: CGRect
        if let frame = frame {
            width = frame.width
            refreshFrame = CGRect(x: -width, y: frame.origin.y, width: width, height: frame.height)
        } else {
            width = animator.executeIncremental
            refreshFrame = CGRect(x: -width, y: 0.0, width: width, height: self.base.bounds.size.height)
        }
        refreshElement.frame = refreshFrame
        refreshElement.autoresizingMask = [.flexibleRightMargin]
        
        self.base.addSubview(refreshElement)
        self.base.leftRefreshElement = refreshElement
        return refreshElement
    }
    
    @discardableResult
    public func addRightPullToRefresh(frame: CGRect? = nil, animator: ESRefreshProtocol & ESRefreshAnimatorProtocol, handler: @escaping ESRefreshHandler) -> ESRefreshRightView {
        removeRightRefreshElement()
        let refreshElement = ESRefreshRightView(frame: .zero, handler: handler, animator: animator)
        
        let width: CGFloat
        let refreshFrame: CGRect
        if let frame = frame {
            width = frame.width
            refreshFrame = CGRect(x: self.base.contentSize.width + self.base.contentInset.right, y: frame.origin.y, width: width, height: frame.height)
        } else {
            width = animator.executeIncremental
            refreshFrame = CGRect(x: self.base.contentSize.width + self.base.contentInset.right, y: 0.0, width: width, height: self.base.bounds.size.height)
        }
        refreshElement.frame = refreshFrame
        refreshElement.autoresizingMask = [.flexibleRightMargin]
        
        self.base.addSubview(refreshElement)
        self.base.rightRefreshElement = refreshElement
        return refreshElement
    }
    
    
    /// Add infinite-scrolling
    @discardableResult
    public func addInfiniteScrolling(handler: @escaping ESRefreshHandler) -> ESRefreshFooterView {
        removeRefreshFooter()
        let footer = ESRefreshFooterView(frame: CGRect.zero, handler: handler)
        let footerH = footer.animator.executeIncremental
        footer.frame = CGRect.init(x: 0.0, y: self.base.contentSize.height + self.base.contentInset.bottom, width: self.base.bounds.size.width, height: footerH)
        self.base.addSubview(footer)
        self.base.footer = footer
        return footer
    }
    
    @discardableResult
    public func addInfiniteScrolling(animator: ESRefreshProtocol & ESRefreshAnimatorProtocol, handler: @escaping ESRefreshHandler) -> ESRefreshFooterView {
        removeRefreshFooter()
        let footer = ESRefreshFooterView(frame: CGRect.zero, handler: handler, animator: animator)
        let footerH = footer.animator.executeIncremental
        footer.frame = CGRect.init(x: 0.0, y: self.base.contentSize.height + self.base.contentInset.bottom, width: self.base.bounds.size.width, height: footerH)
        self.base.footer = footer
        self.base.addSubview(footer)
        return footer
    }
    
    /// Remove
    public func removeLeftRefreshElement() {
        self.base.leftRefreshElement?.stopRefreshing()
        self.base.leftRefreshElement?.removeFromSuperview()
        self.base.leftRefreshElement = nil
    }
    
    public func removeRightRefreshElement() {
        self.base.rightRefreshElement?.stopRefreshing()
        self.base.rightRefreshElement?.removeFromSuperview()
        self.base.rightRefreshElement = nil
    }
    
    public func removeRefreshHeader() {
        self.base.header?.stopRefreshing()
        self.base.header?.removeFromSuperview()
        self.base.header = nil
    }
    
    public func removeRefreshFooter() {
        self.base.footer?.stopRefreshing()
        self.base.footer?.removeFromSuperview()
        self.base.footer = nil
    }
    
    /// Manual refresh
    public func startPullToRefresh() {
        DispatchQueue.main.async { [weak base] in
            base?.header?.startRefreshing(isAuto: false)
            base?.leftRefreshElement?.startRefreshing(isAuto: false)
        }
    }
    
    public func startRightPullToRefresh() {
        DispatchQueue.main.async { [weak base] in
            base?.rightRefreshElement?.startRefreshing(isAuto: false)
        }
    }
    
    /// Auto refresh if expired.
    public func autoPullToRefresh() {
        if self.base.expired == true {
            DispatchQueue.main.async { [weak base] in
                base?.header?.startRefreshing(isAuto: true)
                base?.leftRefreshElement?.startRefreshing(isAuto: true)
            }
        }
    }
    
    /// Stop pull to refresh
    public func stopPullToRefresh(ignoreDate: Bool = false, ignoreFooter: Bool = false) {
        self.base.header?.stopRefreshing()
        self.base.leftRefreshElement?.stopRefreshing()
        self.base.rightRefreshElement?.stopRefreshing()
        if ignoreDate == false {
            if let key = self.base.header?.refreshIdentifier {
                ESRefreshDataManager.sharedManager.setDate(Date(), forKey: key)
            } else if let key = self.base.leftRefreshElement?.refreshIdentifier {
                ESRefreshDataManager.sharedManager.setDate(Date(), forKey: key)
            } else if let key = self.base.rightRefreshElement?.refreshIdentifier {
                ESRefreshDataManager.sharedManager.setDate(Date(), forKey: key)
            }
            self.base.footer?.resetNoMoreData()
        }
        self.base.footer?.isHidden = ignoreFooter
    }
    
    /// Footer notice method
    public func  noticeNoMoreData() {
        self.base.footer?.stopRefreshing()
        self.base.footer?.noMoreData = true
        
        self.base.rightRefreshElement?.stopRefreshing()
        self.base.rightRefreshElement?.noMoreData = true
    }
    
    public func resetNoMoreData() {
        self.base.footer?.noMoreData = false
        self.base.rightRefreshElement?.noMoreData = false
    }
    
    public func stopLoadingMore() {
        self.base.footer?.stopRefreshing()
        self.base.rightRefreshElement?.stopRefreshing()
    }
    
}

public extension UIScrollView /* Date Manager */ {
    
    /// Identifier for cache expired timeinterval and last refresh date.
    public var refreshIdentifier: String? {
        get {
            if let header = self.header {
                return header.refreshIdentifier
            } else if let leftElement = self.leftRefreshElement {
                return leftElement.refreshIdentifier
            } else {
                return self.rightRefreshElement?.refreshIdentifier
            }
        }
        set {
            self.rightRefreshElement?.refreshIdentifier = newValue
            self.leftRefreshElement?.refreshIdentifier = newValue
            self.header?.refreshIdentifier = newValue
        }
    }
    
    /// If you setted refreshIdentifier and expiredTimeInterval, return nearest refresh expired or not. Default is false.
    public var expired: Bool {
        get {
            if let key = self.header?.refreshIdentifier {
                return ESRefreshDataManager.sharedManager.isExpired(forKey: key)
            } else if let key = self.leftRefreshElement?.refreshIdentifier {
                return ESRefreshDataManager.sharedManager.isExpired(forKey: key)
            } else if let key = self.rightRefreshElement?.refreshIdentifier {
                return ESRefreshDataManager.sharedManager.isExpired(forKey: key)
            }
            return false
        }
    }
    
    public var expiredTimeInterval: TimeInterval? {
        get {
            if let key = self.header?.refreshIdentifier {
                let interval = ESRefreshDataManager.sharedManager.expiredTimeInterval(forKey: key)
                return interval
            } else if let key = self.leftRefreshElement?.refreshIdentifier {
                let interval = ESRefreshDataManager.sharedManager.expiredTimeInterval(forKey: key)
                return interval
            } else if let key = self.rightRefreshElement?.refreshIdentifier {
                let interval = ESRefreshDataManager.sharedManager.expiredTimeInterval(forKey: key)
                return interval
            }
            return nil
        }
        set {
            if let key = self.header?.refreshIdentifier {
                ESRefreshDataManager.sharedManager.setExpiredTimeInterval(newValue, forKey: key)
            } else if let key = self.leftRefreshElement?.refreshIdentifier {
                ESRefreshDataManager.sharedManager.setExpiredTimeInterval(newValue, forKey: key)
            } else if let key = self.rightRefreshElement?.refreshIdentifier {
                ESRefreshDataManager.sharedManager.setExpiredTimeInterval(newValue, forKey: key)
            }
        }
    }
    
    /// Auto cached last refresh date when you setted refreshIdentifier.
    public var lastRefreshDate: Date? {
        get {
            if let key = self.header?.refreshIdentifier {
                return ESRefreshDataManager.sharedManager.date(forKey: key)
            } else if let key = self.leftRefreshElement?.refreshIdentifier {
                return ESRefreshDataManager.sharedManager.date(forKey: key)
            } else if let key = self.rightRefreshElement?.refreshIdentifier {
                return ESRefreshDataManager.sharedManager.date(forKey: key)
            }
            return nil
        }
    }
    
}


open class ESRefreshHeaderView: ESRefreshComponent {
    fileprivate var previousOffset: CGFloat = 0.0
    fileprivate var scrollViewInsets: UIEdgeInsets = UIEdgeInsets.zero
    fileprivate var scrollViewBounces: Bool = true
    
    open var lastRefreshTimestamp: TimeInterval?
    open var refreshIdentifier: String?
    
    public convenience init(frame: CGRect, handler: @escaping ESRefreshHandler) {
        self.init(frame: frame)
        self.handler = handler
        self.animator = ESRefreshHeaderAnimator.init()
    }
    
    open override func didMoveToSuperview() {
        super.didMoveToSuperview()
        DispatchQueue.main.async {
            [weak self] in
            self?.scrollViewBounces = self?.scrollView?.bounces ?? true
            self?.scrollViewInsets = self?.scrollView?.contentInset ?? UIEdgeInsets.zero
        }
    }
    
    open override func offsetChangeAction(object: AnyObject?, change: [NSKeyValueChangeKey : Any]?) {
        guard let scrollView = scrollView else {
            return
        }
        
        super.offsetChangeAction(object: object, change: change)
        
        guard self.isRefreshing == false && self.isAutoRefreshing == false else {
            let top = scrollViewInsets.top
            let offsetY = scrollView.contentOffset.y
            let height = self.frame.size.height
            var scrollingTop = (-offsetY > top) ? -offsetY : top
            scrollingTop = (scrollingTop > height + top) ? (height + top) : scrollingTop
            
            scrollView.contentInset.top = scrollingTop
            
            return
        }
        
        // Check needs re-set animator's progress or not.
        var isRecordingProgress = false
        defer {
            if isRecordingProgress == true {
                let percent = -(previousOffset + scrollViewInsets.top) / self.animator.trigger
                self.animator.refresh(view: self, progressDidChange: percent)
            }
        }
        
        let offsets = previousOffset + scrollViewInsets.top
        if offsets < -self.animator.trigger {
            // Reached critical
            if isRefreshing == false && isAutoRefreshing == false {
                if scrollView.isDragging == false {
                    // Start to refresh...
                    self.startRefreshing(isAuto: false)
                    self.animator.refresh(view: self, stateDidChange: .refreshing)
                } else {
                    // Release to refresh! Please drop down hard...
                    self.animator.refresh(view: self, stateDidChange: .releaseToRefresh)
                    isRecordingProgress = true
                }
            }
        } else if offsets < 0 {
            // Pull to refresh!
            if isRefreshing == false && isAutoRefreshing == false {
                self.animator.refresh(view: self, stateDidChange: .pullToRefresh)
                isRecordingProgress = true
            }
        } else {
            // Normal state
        }
        
        previousOffset = scrollView.contentOffset.y
        
    }
    
    open override func start() {
        guard let scrollView = scrollView else {
            return
        }
        
        // ignore observer
        self.ignoreObserver(true)
        
        // stop scroll view bounces for animation
        scrollView.bounces = false
        
        // call super start
        super.start()
        
        self.animator.refreshAnimationBegin(view: self)
        
        // 缓存scrollview当前的contentInset, 并根据animator的executeIncremental属性计算刷新时所需要的contentInset，它将在接下来的动画中应用。
        // Tips: 这里将self.scrollViewInsets.top更新，也可以将scrollViewInsets整个更新，因为left、right、bottom属性都没有用到，如果接下来的迭代需要使用这三个属性的话，这里可能需要额外的处理。
        var insets = scrollView.contentInset
        self.scrollViewInsets.top = insets.top
        insets.top += animator.executeIncremental
        
        // We need to restore previous offset because we will animate scroll view insets and regular scroll view animating is not applied then.
        scrollView.contentInset = insets
        scrollView.contentOffset.y = previousOffset
        previousOffset -= animator.executeIncremental
        UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveLinear, animations: {
            scrollView.contentOffset.y = -insets.top
        }, completion: { (finished) in
            self.handler?()
            // un-ignore observer
            self.ignoreObserver(false)
            scrollView.bounces = self.scrollViewBounces
        })
        
    }
    
    open override func stop() {
        guard let scrollView = scrollView else {
            return
        }
        
        // ignore observer
        self.ignoreObserver(true)
        
        self.animator.refreshAnimationEnd(view: self)
        
        // Back state
        scrollView.contentInset.top = self.scrollViewInsets.top
        scrollView.contentOffset.y =  self.scrollViewInsets.top + self.previousOffset
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveLinear, animations: {
            scrollView.contentOffset.y = -self.scrollViewInsets.top
        }, completion: { (finished) in
            self.animator.refresh(view: self, stateDidChange: .pullToRefresh)
            super.stop()
            scrollView.contentInset.top = self.scrollViewInsets.top
            self.previousOffset = scrollView.contentOffset.y
            // un-ignore observer
            self.ignoreObserver(false)
        })
    }
    
}

open class ESRefreshFooterView: ESRefreshComponent {
    open var scrollViewInsets: UIEdgeInsets = UIEdgeInsets.zero
    open var noMoreData = false {
        didSet {
            if noMoreData != oldValue {
                self.animator.refresh(view: self, stateDidChange: noMoreData ? .noMoreData : .pullToRefresh)
            }
        }
    }
    
    open override var isHidden: Bool {
        didSet {
            if isHidden == true {
                scrollView?.contentInset.bottom = scrollViewInsets.bottom
                var rect = self.frame
                rect.origin.y = scrollView?.contentSize.height ?? 0.0
                self.frame = rect
            } else {
                scrollView?.contentInset.bottom = scrollViewInsets.bottom + animator.executeIncremental
                var rect = self.frame
                rect.origin.y = scrollView?.contentSize.height ?? 0.0
                self.frame = rect
            }
        }
    }
    
    public convenience init(frame: CGRect, handler: @escaping ESRefreshHandler) {
        self.init(frame: frame)
        self.handler = handler
        self.animator = ESRefreshFooterAnimator.init()
    }
    
    /**
     In didMoveToSuperview, it will cache superview(UIScrollView)'s contentInset and update self's frame.
     It called ESRefreshComponent's didMoveToSuperview.
     */
    open override func didMoveToSuperview() {
        super.didMoveToSuperview()
        DispatchQueue.main.async {
            [weak self] in
            self?.scrollViewInsets = self?.scrollView?.contentInset ?? UIEdgeInsets.zero
            self?.scrollView?.contentInset.bottom = (self?.scrollViewInsets.bottom ?? 0) + (self?.bounds.size.height ?? 0)
            var rect = self?.frame ?? CGRect.zero
            rect.origin.y = self?.scrollView?.contentSize.height ?? 0.0
            self?.frame = rect
        }
    }
    
    open override func sizeChangeAction(object: AnyObject?, change: [NSKeyValueChangeKey : Any]?) {
        guard let scrollView = scrollView else { return }
        super.sizeChangeAction(object: object, change: change)
        let targetY = scrollView.contentSize.height + scrollViewInsets.bottom
        if self.frame.origin.y != targetY {
            var rect = self.frame
            rect.origin.y = targetY
            self.frame = rect
        }
    }
    
    open override func offsetChangeAction(object: AnyObject?, change: [NSKeyValueChangeKey : Any]?) {
        guard let scrollView = scrollView else {
            return
        }
        
        super.offsetChangeAction(object: object, change: change)
        
        guard isRefreshing == false && isAutoRefreshing == false && noMoreData == false && isHidden == false else {
            // 正在loading more或者内容为空时不相应变化
            return
        }
        
        if scrollView.contentSize.height <= 0.0 || scrollView.contentOffset.y + scrollView.contentInset.top <= 0.0 {
            self.alpha = 0.0
            return
        } else {
            self.alpha = 1.0
        }
        
        if scrollView.contentSize.height + scrollView.contentInset.top > scrollView.bounds.size.height {
            // 内容超过一个屏幕 计算公式，判断是不是在拖在到了底部
            if scrollView.contentSize.height - scrollView.contentOffset.y + scrollView.contentInset.bottom  <= scrollView.bounds.size.height {
                self.animator.refresh(view: self, stateDidChange: .refreshing)
                self.startRefreshing()
            }
        } else {
            //内容没有超过一个屏幕，这时拖拽高度大于1/2footer的高度就表示请求上拉
            if scrollView.contentOffset.y + scrollView.contentInset.top >= animator.trigger / 2.0 {
                self.animator.refresh(view: self, stateDidChange: .refreshing)
                self.startRefreshing()
            }
        }
    }
    
    open override func start() {
        guard let scrollView = scrollView else {
            return
        }
        super.start()
        
        self.animator.refreshAnimationBegin(view: self)
        
        let x = scrollView.contentOffset.x
        let y = max(0.0, scrollView.contentSize.height - scrollView.bounds.size.height + scrollView.contentInset.bottom)
        
        // Call handler
        UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveLinear, animations: {
            scrollView.contentOffset = CGPoint.init(x: x, y: y)
        }, completion: { (animated) in
            self.handler?()
        })
    }
    
    open override func stop() {
        guard let scrollView = scrollView else {
            return
        }
        
        self.animator.refreshAnimationEnd(view: self)
        
        // Back state
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveLinear, animations: {
        }, completion: { (finished) in
            if self.noMoreData == false {
                self.animator.refresh(view: self, stateDidChange: .pullToRefresh)
            }
            super.stop()
        })
        
        // Stop deceleration of UIScrollView. When the button tap event is caught, you read what the [scrollView contentOffset].x is, and set the offset to this value with animation OFF.
        // http://stackoverflow.com/questions/2037892/stop-deceleration-of-uiscrollview
        if scrollView.isDecelerating {
            var contentOffset = scrollView.contentOffset
            contentOffset.y = min(contentOffset.y, scrollView.contentSize.height - scrollView.frame.size.height + scrollViewInsets.bottom)
            if contentOffset.y < 0.0 {
                contentOffset.y = 0.0
                UIView.animate(withDuration: 0.1, animations: {
                    scrollView.setContentOffset(contentOffset, animated: false)
                })
            } else {
                scrollView.setContentOffset(contentOffset, animated: false)
            }
        }
        
    }
    
    /// Change to no-more-data status.
    open func noticeNoMoreData() {
        self.noMoreData = true
    }
    
    /// Reset no-more-data status.
    open func resetNoMoreData() {
        self.noMoreData = false
    }
    
}

open class ESRefreshLeftView: ESRefreshComponent {
    fileprivate var previousOffset: CGFloat = 0.0
    fileprivate var scrollViewInsets: UIEdgeInsets = UIEdgeInsets.zero
    fileprivate var scrollViewBounces: Bool = true
    
    open var lastRefreshTimestamp: TimeInterval?
    open var refreshIdentifier: String?
    
    public convenience init(frame: CGRect, handler: @escaping ESRefreshHandler) {
        self.init(frame: frame)
        self.handler = handler
        self.animator = ESRefreshHeaderAnimator.init()
    }
    
    open override func didMoveToSuperview() {
        super.didMoveToSuperview()
        DispatchQueue.main.async {
            [weak self] in
            self?.scrollViewBounces = self?.scrollView?.bounces ?? true
            self?.scrollViewInsets = self?.scrollView?.contentInset ?? UIEdgeInsets.zero
        }
    }
    
    open override func offsetChangeAction(object: AnyObject?, change: [NSKeyValueChangeKey : Any]?) {
        guard let scrollView = scrollView else {
            return
        }
        
        super.offsetChangeAction(object: object, change: change)
        
        guard self.isRefreshing == false && self.isAutoRefreshing == false else {
            
            let left = scrollViewInsets.left
            let offsetX = scrollView.contentOffset.x
            let width = self.frame.size.width
            var scrollingLeft = (-offsetX > left) ? -offsetX : left
            scrollingLeft = (scrollingLeft > width + left) ? (width + left) : scrollingLeft
            
            scrollView.contentInset.left = scrollingLeft
            
            return
        }
        
        // Check needs re-set animator's progress or not.
        var isRecordingProgress = false
        defer {
            if isRecordingProgress == true {
                let percent = -(previousOffset + scrollViewInsets.left) / self.animator.trigger
                self.animator.refresh(view: self, progressDidChange: percent)
            }
        }
        
        let offsets = previousOffset + scrollViewInsets.left
        // Make trigger more far away in case if we have content that exceeds frame of scroll view
        let trigger = scrollView.contentSize.width + scrollView.contentInset.right > scrollView.bounds.size.width ? animator.trigger * 2 : animator.trigger
        if offsets < -trigger {
            // Reached critical
            if isRefreshing == false && isAutoRefreshing == false {
                if scrollView.isDragging == false {
                    // Start to refresh...
                    self.startRefreshing(isAuto: false)
                    self.animator.refresh(view: self, stateDidChange: .refreshing)
                } else {
                    // Release to refresh! Please drop down hard...
                    self.animator.refresh(view: self, stateDidChange: .releaseToRefresh)
                    isRecordingProgress = true
                }
            }
        } else if offsets < 0 {
            // Pull to refresh!
            if isRefreshing == false && isAutoRefreshing == false {
                self.animator.refresh(view: self, stateDidChange: .pullToRefresh)
                isRecordingProgress = true
            }
        } else {
            // Normal state
        }
        
        previousOffset = scrollView.contentOffset.x
        
    }
    
    open override func start() {
        guard let scrollView = scrollView else {
            return
        }
        
        // ignore observer
        self.ignoreObserver(true)
        
        // stop scroll view bounces for animation
        scrollView.bounces = false
        
        // call super start
        super.start()
        
        self.animator.refreshAnimationBegin(view: self)
        
        var insets = scrollView.contentInset
        self.scrollViewInsets.left = insets.left
        insets.left += animator.executeIncremental
        
        // We need to restore previous offset because we will animate scroll view insets and regular scroll view animating is not applied then.
        scrollView.contentInset = insets
        scrollView.contentOffset.x = previousOffset
        previousOffset -= animator.executeIncremental
        UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveLinear, animations: {
            scrollView.contentOffset.x = -insets.left
            self.alpha = 1.0
        }, completion: { (finished) in
            self.handler?()
            // un-ignore observer
            self.ignoreObserver(false)
            scrollView.bounces = self.scrollViewBounces
        })
        
    }
    
    open override func stop() {
        guard let scrollView = scrollView else {
            return
        }
        
        // ignore observer
        self.ignoreObserver(true)
        
        self.animator.refreshAnimationEnd(view: self)
        
        // Back state
        scrollView.contentInset.left = self.scrollViewInsets.left
        scrollView.contentOffset.x =  self.scrollViewInsets.left + self.previousOffset
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveLinear, animations: {
            scrollView.contentOffset.x = -self.scrollViewInsets.left
            self.alpha = 0.0
        }, completion: { (finished) in
            self.animator.refresh(view: self, stateDidChange: .pullToRefresh)
            super.stop()
            scrollView.contentInset.left = self.scrollViewInsets.left
            self.previousOffset = scrollView.contentOffset.x
            // un-ignore observer
            self.ignoreObserver(false)
        })
    }
}

open class ESRefreshRightView: ESRefreshComponent {
    open var lastRefreshTimestamp: TimeInterval?
    open var refreshIdentifier: String?
    
    open var scrollViewInsets: UIEdgeInsets = UIEdgeInsets.zero
    open var scrollViewBounces: Bool = true
    fileprivate var previousOffset: CGFloat = 0.0
    
    open var noMoreData = false {
        didSet {
            if noMoreData != oldValue {
                self.animator.refresh(view: self, stateDidChange: noMoreData ? .noMoreData : .pullToRefresh)
            }
        }
    }
    
    open override var isHidden: Bool {
        didSet {
            if isHidden == true {
                scrollView?.contentInset.right = scrollViewInsets.right
                var rect = self.frame
                rect.origin.x = scrollView?.contentSize.width ?? 0.0
                self.frame = rect
            } else {
                scrollView?.contentInset.right = scrollViewInsets.right + animator.executeIncremental
                var rect = self.frame
                rect.origin.x = scrollView?.contentSize.width ?? 0.0
                self.frame = rect
            }
        }
    }
    
    public convenience init(frame: CGRect, handler: @escaping ESRefreshHandler) {
        self.init(frame: frame)
        self.handler = handler
        self.animator = ESRefreshFooterAnimator.init()
    }
    
    /**
     In didMoveToSuperview, it will cache superview(UIScrollView)'s contentInset and update self's frame.
     It called ESRefreshComponent's didMoveToSuperview.
     */
    open override func didMoveToSuperview() {
        super.didMoveToSuperview()
        DispatchQueue.main.async {
            [weak self] in
            self?.scrollViewInsets = self?.scrollView?.contentInset ?? UIEdgeInsets.zero
            self?.scrollViewBounces = self?.scrollView?.bounces ?? true
            var rect = self?.frame ?? CGRect.zero
            rect.origin.x = self?.scrollView?.contentSize.width ?? 0.0
            self?.frame = rect
        }
    }
    
    open override func sizeChangeAction(object: AnyObject?, change: [NSKeyValueChangeKey : Any]?) {
        guard let scrollView = scrollView else { return }
        super.sizeChangeAction(object: object, change: change)
        let targetX = scrollView.contentSize.width + scrollViewInsets.right
        if self.frame.origin.x != targetX {
            var rect = self.frame
            rect.origin.x = targetX
            self.frame = rect
        }
    }
    
    open override func offsetChangeAction(object: AnyObject?, change: [NSKeyValueChangeKey : Any]?) {
        guard let scrollView = scrollView else {
            return
        }
        
        super.offsetChangeAction(object: object, change: change)
        
        guard isRefreshing == false && isAutoRefreshing == false else { return }
        
        guard isRefreshing == false && isAutoRefreshing == false && noMoreData == false && isHidden == false else {
            return
        }
        
        if scrollView.contentSize.width <= 0.0 || scrollView.contentOffset.x + scrollView.contentInset.right <= 0.0 {
            self.alpha = 0.0
            return
        } else {
            self.alpha = 1.0
        }
        
        let offsets = scrollView.contentOffset.x
        let offsetThreshold = max(scrollView.contentSize.width - scrollView.bounds.size.width, 0) + scrollViewInsets.right
        
        if scrollView.contentSize.width + scrollView.contentInset.right > scrollView.bounds.size.width {
            // Context exceed frame of the scroll view
            let offsets = scrollView.contentOffset.x
            let offsetThreshold = max(scrollView.contentSize.width - scrollView.bounds.size.width, 0) + scrollViewInsets.right
            
            // Place trigger farther
            if offsets > offsetThreshold + animator.trigger * 2 {
                if isRefreshing == false && isAutoRefreshing == false {
                    if scrollView.isDragging == false {
                        self.animator.refresh(view: self, stateDidChange: .refreshing)
                        self.startRefreshing()
                    } else {
                        self.animator.refresh(view: self, stateDidChange: .releaseToRefresh)
                    }
                }
            } else if offsets > offsetThreshold {
                
                if isRefreshing == false && isAutoRefreshing == false {
                    self.animator.refresh(view: self, stateDidChange: .pullToRefresh)
                }
            }
        } else {
            if isRefreshing == false && isAutoRefreshing == false {
                if scrollView.contentOffset.x + scrollView.contentInset.left >= animator.trigger {
                    self.animator.refresh(view: self, stateDidChange: .refreshing)
                    self.startRefreshing()
                }
            }
        }
        
        previousOffset = scrollView.contentOffset.x
        
    }
    
    open override func start() {
        guard let scrollView = scrollView else {
            return
        }
        super.start()
        
        self.animator.refreshAnimationBegin(view: self)
        
        var insets = scrollView.contentInset
        self.scrollViewInsets.right = insets.right
        insets.right = animator.executeIncremental
        
        // We need to restore previous offset because we will animate scroll view insets and regular scroll view animating is not applied then.
        scrollView.contentInset = insets
        scrollView.contentOffset.x = previousOffset
        previousOffset -= animator.executeIncremental
        
        let x = max(0, scrollView.contentSize.width - scrollView.bounds.width + scrollView.contentInset.right)
        
        UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveLinear, animations: {
            scrollView.contentOffset.x = x
            self.alpha = 1.0
        }, completion: { (finished) in
            self.handler?()
            // un-ignore observer
            self.ignoreObserver(false)
            scrollView.bounces = self.scrollViewBounces
        })
        
    }
    
    open override func stop() {
        guard let scrollView = scrollView else {
            return
        }
        
        // ignore observer
        self.ignoreObserver(true)
        
        self.animator.refreshAnimationEnd(view: self)
        
        // Back state        
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveLinear, animations: {
            scrollView.contentInset.right = self.scrollViewInsets.right
            self.alpha = 0.0
        }, completion: { (finished) in
            self.animator.refresh(view: self, stateDidChange: .pullToRefresh)
            self.previousOffset = scrollView.contentOffset.x
            // un-ignore observer
            self.ignoreObserver(false)
            super.stop()
        })
        
    }
    
    /// Change to no-more-data status.
    open func noticeNoMoreData() {
        self.noMoreData = true
    }
    
    /// Reset no-more-data status.
    open func resetNoMoreData() {
        self.noMoreData = false
    }
    
}

