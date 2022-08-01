import UIKit

class CustomCollectionViewCell: UICollectionViewCell {
    
    //MARK: - Properties
    
    let textLabel = UILabel()
    
    //MARK: - Initialize
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpTextLabelLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Private methods
    
    private func setUpTextLabelLayout() {
        contentView.addSubview(textLabel)
        
        backgroundColor = .white
        contentView.layer.borderWidth = 2
        contentView.layer.borderColor = UIColor.black.cgColor
        contentView.layer.cornerRadius = 5
        
        textLabel.textColor = .black
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            textLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            textLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        ])
    }
    
    //MARK: - Override properties
    
    override func prepareForReuse() {
        super.prepareForReuse()
        textLabel.text = nil
    }
}