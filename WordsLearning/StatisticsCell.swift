//
//  StatisticsCell.swift
//  WordsLearning
//
//  Created by Кузин Роман Эдуардович on 27.10.2022.
//

import UIKit

final class StatisticsCell: UITableViewCell, DRTableViewCellProtocol {

	// TODO: реюзабилити не работает
	var shouldReuse = false

	private let wordLabel = UILabel()
	private let remarkLabel = UILabel()
	private let raitingLabel = UILabel()
	private let studyPercentLabel = UILabel()

	private let underlineView = UIView()

	let wordText: String
	let remarkText: String?
	let raintinText: String
	let studyPercentText: String

	init(word: String, remark: String?, studyPercent: Double, raiting: Double) {
		self.remarkText = remark
		self.wordText = word
		self.studyPercentText = String(studyPercent)
		self.raintinText = String(format: "%.4f", raiting)

		super.init(style: .subtitle, reuseIdentifier: nil)
		setupUI()
		setupConstraints()
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		self.wordText = ""
		self.raintinText = ""
		self.remarkText = nil
		self.studyPercentText = ""
		super.init(style: style, reuseIdentifier: reuseIdentifier)
	}

	func didSelected() {}

	func someCellWasSelected() {}

	func emptySpaceOnTableWasTapped() {}


	// MARK: Private

	private func setupConstraints() {
		contentView.addSubview(wordLabel)
		contentView.addSubview(remarkLabel)
		contentView.addSubview(raitingLabel)
		contentView.addSubview(studyPercentLabel)
		contentView.addSubview(underlineView)
		contentView.subviews.forEach { $0.translatesAutoresizingMaskIntoConstraints = false }

		NSLayoutConstraint.activate([
			wordLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
			wordLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
			wordLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),

			remarkLabel.centerYAnchor.constraint(equalTo: wordLabel.centerYAnchor),
			remarkLabel.leadingAnchor.constraint(equalTo: wordLabel.trailingAnchor, constant: 10),

			studyPercentLabel.centerYAnchor.constraint(equalTo: wordLabel.centerYAnchor),
			studyPercentLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),

			raitingLabel.centerYAnchor.constraint(equalTo: wordLabel.centerYAnchor),
			raitingLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -100),
		])
	}

	private func setupUI() {
		backgroundColor = .clear
		wordLabel.text = wordText
		if let remarkText = remarkText {
			remarkLabel.text = "(" + remarkText + ")"
		}
		raitingLabel.text = raintinText
		studyPercentLabel.text = studyPercentText
	}
}
