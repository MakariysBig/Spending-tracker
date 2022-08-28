import UIKit

class CustomCell: UITableViewCell {
    
    //MARK: - Private properties
    
    let coverView = UIView()
    let dateAndAmountStackView = UIStackView()
    let dateAndNoteStackView = UIStackView()
    let dayAndNoteStackView = UIStackView()
    let dayLabel = UILabel()
    let dateLabel = UILabel()
    let amountLabel = UILabel()
    let noteLabel = UILabel()

    //MARK: - Override methods
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    //MARK: - Initialize
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super .init(style: style, reuseIdentifier: reuseIdentifier)
        configureAmountLabel()
        configureNoteLabel()
        configureDayLabel()
        configureDateLabel()
        setUpConteinViewLayout()
        dateAndAmountStackViewLayout()
        dayAndNoteStackViewLayout()
        dateAndNoteStackViewLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Private methods
    
    private func setUpConteinViewLayout() {
        contentView.addSubview(coverView)

        coverView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            coverView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            coverView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            coverView.topAnchor.constraint(equalTo: contentView.topAnchor),
            coverView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    private func dayAndNoteStackViewLayout() {
        coverView.addSubview(dayAndNoteStackView)
        dayAndNoteStackView.axis = .horizontal
        dayAndNoteStackView.distribution = .fill
        dayAndNoteStackView.addArrangedSubview(dayLabel)
        dayAndNoteStackView.addArrangedSubview(dateAndNoteStackView)
        
        dayAndNoteStackView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            dayAndNoteStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            dayAndNoteStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            dayAndNoteStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            dayLabel.heightAnchor.constraint(equalToConstant: 40),
            dayLabel.widthAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    private func dateAndNoteStackViewLayout() {
        dateAndNoteStackView.axis = .vertical
        dateAndNoteStackView.distribution = .equalSpacing
        dateAndNoteStackView.addArrangedSubview(dateAndAmountStackView)
        dateAndNoteStackView.addArrangedSubview(noteLabel)
    }
    
    private func dateAndAmountStackViewLayout() {
        dateAndAmountStackView.axis = .horizontal
        dateAndAmountStackView.distribution = .equalSpacing
        dateAndAmountStackView.addArrangedSubview(dateLabel)
        dateAndAmountStackView.addArrangedSubview(amountLabel)
    }

    private func configureDateLabel() {
        dateLabel.text = "20/03/2002"
        dateLabel.textColor = .black
    }
    
    private func configureAmountLabel() {
        amountLabel.text = "30.5"
        amountLabel.textColor = .red
    }
    
    private func configureNoteLabel() {
        noteLabel.text = "note"
        noteLabel.textColor = .gray
    }
    
    private func configureDayLabel() {
        dayLabel.text = "20"
        dayLabel.font = UIFont.systemFont(ofSize: 30)
        dayLabel.textColor = .black
    }
}
