import UIKit
import AVFAudio

class PlayerViewController: UIViewController{
    
    private var panGestureRecognizer: UIPanGestureRecognizer!
    
    private let grabberView: UIView = {
        let grabberView = UIView()
        grabberView.translatesAutoresizingMaskIntoConstraints = false
        grabberView.backgroundColor = UIColor.lightGray
        grabberView.layer.cornerRadius = 2.5
        return grabberView
    }()
    
    let stackViewContain: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 20
        return stackView
    }()
    
    private let imageViewContain: UIView = {
       let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let playerControlView = PlayerControlView()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(grabberView)
        view.addSubview(stackViewContain)
        stackViewContain.addArrangedSubview(imageViewContain)
        imageViewContain.addSubview(imageView)
        stackViewContain.addArrangedSubview(playerControlView)
        setupPanGestureRecognizer()
        playerControlView.delegate = PlayAudioManager.shared
        
        //Play background music
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [.mixWithOthers, .allowAirPlay])
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print(error)
        }

    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        stackViewContain.frame = CGRect(x: 10, y: grabberView.bottom, width: view.width-20, height: view.height - grabberView.bottom)
        NSLayoutConstraint.activate([
            grabberView.topAnchor.constraint(equalTo: view.topAnchor, constant: 50),
            grabberView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            grabberView.widthAnchor.constraint(equalToConstant: 40),
            grabberView.heightAnchor.constraint(equalToConstant: 5),
            
            imageViewContain.heightAnchor.constraint(equalToConstant: stackViewContain.height*0.45),
            imageView.heightAnchor.constraint(equalToConstant: view.width*0.7),
            imageView.widthAnchor.constraint(equalToConstant: view.width*0.7),
            imageView.centerXAnchor.constraint(equalTo: imageViewContain.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo:imageViewContain.centerYAnchor)
        ])
        
    }
    //MARK: - Handle close screen
    private func setupPanGestureRecognizer() {
        panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        view.addGestureRecognizer(panGestureRecognizer)
    }

    @objc private func handlePan(_ recognizer: UIPanGestureRecognizer) {
        let translation = recognizer.translation(in: view)

        switch recognizer.state {
        case .changed:
            view.frame.origin.y = max(0, translation.y)
        case .ended:
                //Speed of pan > 1000
            let velocity = recognizer.velocity(in: view)
            if velocity.y >= 1000 {
                dismiss(animated: true, completion: nil)
            } else {
                let shouldDismiss = translation.y > view.height / 2
                if shouldDismiss {
                    dismiss(animated: true, completion: nil)
                } else {
                    UIView.animate(withDuration: 0.3) {
                        self.view.frame.origin.y = 0
                    }
                }
            }
        default:
            break
        }
    }
    
    func configure(currentTrack : AudioTrack?){
        imageView.sd_setImage(with: URL(string:  currentTrack?.album?.images.first?.url ?? ""), completed: nil)
        playerControlView.configureNamelabel(track: currentTrack)
    }
}
