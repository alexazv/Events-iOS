//
//  LoadingView.swift
//  Events-iOS
//
//  Created by Alexandre Azevedo on 21/01/21.
//

import UIKit

class LoadingView: UIView {
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    var contentView : UIView?
    var loading: Bool = false {
        didSet {
            animateLoadingView()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        xibSetup()
    }
    
    private func animateLoadingView() {
        UIView.animate(withDuration: 0.5, animations: {
            self.heightConstraint.constant = self.loading ? 50 : 0
            self.layoutIfNeeded()
        }, completion: { _ in
            if (self.loading) { self.loadingIndicator?.startAnimating() }
            else { self.loadingIndicator?.stopAnimating() }
        })
    }

    func xibSetup() {
        contentView = loadViewFromNib()
        contentView?.frame = bounds

        contentView?.autoresizingMask = [UIView.AutoresizingMask.flexibleWidth, UIView.AutoresizingMask.flexibleHeight]
        
        addSubview(contentView!)
    }
    
    func loadViewFromNib() -> UIView? {

        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "LoadingView", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as? UIView

        return view
    }
}
