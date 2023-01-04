import UIKit

protocol HeaderViewDelegate: class {
    func headerView(_ headerView: HeaderView, didPressDeleteButton deleteButton: UIButton)
    func headerView(_ headerView: HeaderView, didPressCloseButton closeButton: UIButton)
    func headerView(_ headerView: HeaderView, didPressShareButton closeButton: UIButton)
}

open class HeaderView: UIView {
    open fileprivate(set) lazy var closeButton: UIButton = { [unowned self] in
        let title = NSAttributedString(
            string: LightboxConfig.CloseButton.text,
            attributes: LightboxConfig.CloseButton.textAttributes)
        
        let button = UIButton(type: .system)
        
        button.setAttributedTitle(title, for: UIControl.State())
        
        if let size = LightboxConfig.CloseButton.size {
            button.frame.size = size
        } else {
            button.sizeToFit()
        }
        
        button.addTarget(self, action: #selector(closeButtonDidPress(_:)),
                         for: .touchUpInside)
        
        if let image = LightboxConfig.CloseButton.image {
            button.setBackgroundImage(image, for: UIControl.State())
        }
        
        button.isHidden = !LightboxConfig.CloseButton.enabled
        
        return button
    }()
    
    open fileprivate(set) lazy var deleteButton: UIButton = { [unowned self] in
        let title = NSAttributedString(
            string: LightboxConfig.DeleteButton.text,
            attributes: LightboxConfig.DeleteButton.textAttributes)
        
        let button = UIButton(type: .system)
        
        button.setAttributedTitle(title, for: .normal)
        
        if let size = LightboxConfig.DeleteButton.size {
            button.frame.size = size
        } else {
            button.sizeToFit()
        }
        
        button.addTarget(self, action: #selector(deleteButtonDidPress(_:)),
                         for: .touchUpInside)
        
        if let image = LightboxConfig.DeleteButton.image {
            button.setBackgroundImage(image, for: UIControl.State())
        }
        
        button.isHidden = !LightboxConfig.DeleteButton.enabled
        
        return button
    }()
    
    open fileprivate(set) lazy var shareButton: UIButton = {
        let tempView = UIButton(type: .custom)
        tempView.frame.size = CGSize(width: 40, height: 40)
        if #available(iOS 13.0, *) {
            tempView.setImage((UIImage(systemName: "square.and.arrow.up"))?.withTintColor(.white, renderingMode: .alwaysOriginal), for: .normal)
        } else {
            // Fallback on earlier versions
        }
        tempView.addTarget(self, action: #selector(shareTapped), for: .touchUpInside)
        return tempView
    }()
    
    weak var delegate: HeaderViewDelegate?
    
    // MARK: - Initializers
    
    public init() {
        super.init(frame: CGRect.zero)
        
        backgroundColor = UIColor.clear
        
        [closeButton, shareButton, deleteButton].forEach { addSubview($0) }
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Actions
    
    @objc func deleteButtonDidPress(_ button: UIButton) {
        delegate?.headerView(self, didPressDeleteButton: button)
    }
    
    @objc func closeButtonDidPress(_ button: UIButton) {
        delegate?.headerView(self, didPressCloseButton: button)
    }
    
    @objc func shareTapped(_ button: UIButton) {
        delegate?.headerView(self, didPressShareButton: button)
    }
}

// MARK: - LayoutConfigurable

extension HeaderView: LayoutConfigurable {
    
    @objc public func configureLayout() {
        let topPadding: CGFloat
        
        if #available(iOS 11, *) {
            topPadding = safeAreaInsets.top
        } else {
            topPadding = 0
        }
        
        closeButton.frame.origin = CGPoint(
            x: bounds.width - closeButton.frame.width - 17,
            y: topPadding
        )
                
        shareButton.frame.origin = CGPoint(x: 17, y: topPadding)
        
        deleteButton.frame.origin = CGPoint(
            x: shareButton.frame.width + 34,
            y: topPadding
        )
    }
}
