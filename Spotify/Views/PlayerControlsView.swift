import Foundation
import UIKit

protocol PlayerControlsViewDelegate: AnyObject
{
    func PlayerControlsViewDidTapPlayPauseButton(_ playerControlsView: PlayerControlsView)
    func PlayerControlsViewDidTapForwardButton(_ playerControlsView: PlayerControlsView)
    func PlayerControlsViewDidTapBackwardButton(_ playerControlsView: PlayerControlsView)
    func PlayerControlsView(_ playerControlsView: PlayerControlsView, didSlideSlider value: Float)
}

struct PlayerControlsViewViewModel
{
    let title: String?
    let subtitle: String?
}

final class PlayerControlsView: UIView
{
    private var isPlaying = true
    
    weak var delegate: PlayerControlsViewDelegate?
    
    private let volumeSlider: UISlider = {
        let slider = UISlider()
        slider.value = 0.5
        return slider
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 18, weight: .regular)
        label.textColor = .secondaryLabel
        return label
    }()
    
    private let backwardButton: UIButton = {
        let button = UIButton()
        button.tintColor = .label
        let image = UIImage(systemName: "backward.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 34, weight: .regular))
        button.setImage(image, for: .normal)
        return button
    }()
    
    private let forwardButton: UIButton = {
        let button = UIButton()
        button.tintColor = .label
        let image = UIImage(systemName: "forward.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 34, weight: .regular))
        button.setImage(image, for: .normal)
        return button
    }()
    
    private let playPauseButton: UIButton = {
        let button = UIButton()
        button.tintColor = .label
        let image = UIImage(systemName: "pause.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 34, weight: .regular))
        button.setImage(image, for: .normal)
        return button
    }()
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        backgroundColor = .clear
        
        addSubview(volumeSlider)
        volumeSlider.addTarget(self, action: #selector(didSlideSlider(_:)), for: .valueChanged)
        
        addSubview(nameLabel)
        addSubview(subtitleLabel)
        
        addSubview(backwardButton)
        addSubview(forwardButton)
        addSubview(playPauseButton)
        
        backwardButton.addTarget(self, action: #selector(didTapBackward), for: .touchUpInside)
        forwardButton.addTarget(self, action: #selector(didTapForward), for: .touchUpInside)
        playPauseButton.addTarget(self, action: #selector(didTapPlayPause), for: .touchUpInside)
        
        clipsToBounds = true
    }
    
    required init?(coder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func didSlideSlider(_ slider: UISlider)
    {
        let value = slider.value
        delegate?.PlayerControlsView(self, didSlideSlider: value)
    }
    
    @objc private func didTapBackward()
    {
        delegate?.PlayerControlsViewDidTapBackwardButton(self)
    }
    
    @objc private func didTapForward()
    {
        delegate?.PlayerControlsViewDidTapForwardButton(self)
    }
    
    @objc private func didTapPlayPause()
    {
        self.isPlaying = !isPlaying
        delegate?.PlayerControlsViewDidTapPlayPauseButton(self)
        
        // Update play/pause icon
        let pauseIcon = UIImage(systemName: "pause.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 34, weight: .regular))
        
        let playIcon = UIImage(systemName: "play.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 34, weight: .regular))
        
        playPauseButton.setImage(isPlaying ? pauseIcon : playIcon, for: .normal)
    }
    
    override func layoutSubviews()
    {
        super.layoutSubviews()
        
        nameLabel.frame = CGRect(x: 0, y: 0, width: width, height: 50)
        subtitleLabel.frame = CGRect(x: 0, y: nameLabel.bottom+10, width: width, height: 50)
        
        volumeSlider.frame = CGRect(x: 10, y: subtitleLabel.bottom+20, width: width-20, height: 44)
        
        let buttonSize: CGFloat = 60
        playPauseButton.frame = CGRect(x: (width - buttonSize)/2, y: volumeSlider.bottom+30, width: buttonSize, height: buttonSize)
        
        backwardButton.frame = CGRect(x: playPauseButton.left-80-buttonSize, y: playPauseButton.top, width: buttonSize, height: buttonSize)
        
        forwardButton.frame = CGRect(x: playPauseButton.right+80, y: playPauseButton.top, width: buttonSize, height: buttonSize)
    }
    
    func configure(with viewModel: PlayerControlsViewViewModel)
    {
        nameLabel.text = viewModel.title
        subtitleLabel.text = viewModel.subtitle
    }
}
