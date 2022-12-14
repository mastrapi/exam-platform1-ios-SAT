//
//  OSlide5View.swift
//  Nursing
//
//  Created by Andrey Chernyshev on 24.01.2021.
//

import UIKit

final class OSlideWhenTakingView: OSlideView {
    lazy var titleLabel = makeTitleLabel()
    lazy var datePickerView = makeDatePickerView()
    lazy var button = makeButton()
    lazy var skipButton = makeSkipButton()
    
    override init(step: OnboardingView.Step, scope: OnboardingScope) {
        super.init(step: step, scope: scope)
        
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func moveToThis() {
        super.moveToThis()
        
        AmplitudeManager.shared
            .logEvent(name: "When Exam Screen", parameters: [:])
    }
}

// MARK: Private
private extension OSlideWhenTakingView {
    @objc
    func buttonTapped() {
        let date = self.datePickerView.date
        
        scope.examDate = date
        
        onNext()
    }
}

// MARK: Make constraints
private extension OSlideWhenTakingView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: ScreenSize.isIphoneXFamily ? 117.scale : 70.scale)
        ])
        
        NSLayoutConstraint.activate([
            datePickerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            datePickerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            datePickerView.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
        
        NSLayoutConstraint.activate([
            button.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 26.scale),
            button.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -26.scale),
            button.heightAnchor.constraint(equalToConstant: 60.scale),
            button.bottomAnchor.constraint(equalTo: skipButton.topAnchor, constant: -14.scale)
        ])
        
        NSLayoutConstraint.activate([
            skipButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 26.scale),
            skipButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -26.scale),
            skipButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -31.scale),
            skipButton.heightAnchor.constraint(equalToConstant: 25.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension OSlideWhenTakingView {
    func makeTitleLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.blackColor)
            .font(Fonts.SFProRounded.bold(size: 27.scale))
            .lineHeight(32.scale)
            .textAlignment(.center)
        
        let view = UILabel()
        view.numberOfLines = 0
        view.attributedText = "Onboarding.WhenTaking.Title".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeDatePickerView() -> UIDatePicker {
        let minimumDate = Calendar.current.date(byAdding: .day, value: 6, to: Date()) ?? Date()
        
        let startDate = Calendar.current.date(byAdding: .day, value: 7, to: Date()) ?? Date()
        
        let view = UIDatePicker()
        view.backgroundColor = UIColor.clear
        view.minimumDate = minimumDate
        view.datePickerMode = .date
        view.date = startDate
        view.locale = Locale.current
        if #available(iOS 13.4, *) {
             view.preferredDatePickerStyle = .wheels
        }
        view.setValue(Appearance.mainColor, forKeyPath: "textColor")
        view.datePickerMode = .countDownTimer
        view.datePickerMode = .date
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeButton() -> UIButton {
        let attrs = TextAttributes()
            .textColor(UIColor.white)
            .font(Fonts.SFProRounded.semiBold(size: 20.scale))
            .textAlignment(.center)
        
        let view = UIButton()
        view.backgroundColor = Appearance.mainColor
        view.layer.cornerRadius = 30.scale
        view.setAttributedTitle("Onboarding.Proceed".localized.attributed(with: attrs), for: .normal)
        view.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeSkipButton() -> UIButton {
        let attrs = TextAttributes()
            .textColor(Appearance.blackColor)
            .font(Fonts.SFProRounded.regular(size: 20.scale))
            .textAlignment(.center)
        
        let view = UIButton()
        view.setAttributedTitle("Onboarding.Skip".localized.attributed(with: attrs), for: .normal)
        view.addTarget(self, action: #selector(onNext), for: .touchUpInside)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
