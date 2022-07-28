import UIKit

class CustomCollectionViewCell: UICollectionViewCell {
    
    let textLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpTextLabelLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setUpTextLabelLayout() {
        contentView.addSubview(textLabel)
        
        backgroundColor = .white
        textLabel.textColor = .black
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            textLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            textLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),

        ])
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        textLabel.text = nil
    }
    
}
