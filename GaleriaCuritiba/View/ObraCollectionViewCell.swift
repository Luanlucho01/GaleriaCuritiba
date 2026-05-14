//
//  ObraCollectionViewCell.swift
//  GaleriaCuritiba
//
//  Camada View: célula da grade — apenas apresentação (imagem, título, artista).
//

import UIKit

final class ObraCollectionViewCell: UICollectionViewCell {
    static let reuseId = "ObraCollectionViewCell"

    private let imageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 8
        iv.backgroundColor = .secondarySystemFill
        return iv
    }()

    private let titleLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.font = .preferredFont(forTextStyle: .subheadline)
        l.adjustsFontForContentSizeCategory = true
        l.numberOfLines = 2
        l.textColor = .label
        return l
    }()

    private let artistLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.font = .preferredFont(forTextStyle: .caption1)
        l.adjustsFontForContentSizeCategory = true
        l.numberOfLines = 1
        l.textColor = .secondaryLabel
        return l
    }()

    private let stack: UIStackView = {
        let s = UIStackView()
        s.translatesAutoresizingMaskIntoConstraints = false
        s.axis = .vertical
        s.spacing = 4
        s.alignment = .fill
        return s
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .secondarySystemGroupedBackground
        contentView.layer.cornerRadius = 12
        contentView.clipsToBounds = true

        let textStack = UIStackView(arrangedSubviews: [titleLabel, artistLabel])
        textStack.axis = .vertical
        textStack.spacing = 2

        stack.addArrangedSubview(imageView)
        stack.addArrangedSubview(textStack)
        stack.setCustomSpacing(8, after: imageView)
        contentView.addSubview(stack)

        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            stack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            stack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            stack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: 0.72),
        ])
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    func configure(with obra: ObraDeArte) {
        titleLabel.text = obra.titulo
        artistLabel.text = obra.artista
        imageView.image = UIImage(named: obra.imagemNome)
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        titleLabel.text = nil
        artistLabel.text = nil
    }
}
