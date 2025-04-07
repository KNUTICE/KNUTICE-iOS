# Uncomment the next line to define a global platform for your project
platform :ios, '15.0'

use_frameworks!

def pods
  # Alamofire
  pod 'Alamofire'

  # ReactiveX
  pod 'RxSwift', '6.9.0'
  pod 'RxCocoa', '6.9.0'
  pod 'RxDataSources'

  # SnapKit
  pod 'SnapKit'

  # Kingfisher
  pod 'Kingfisher', '~> 7.0'

  # SkeletonView
  pod 'SkeletonView'

  # Google Firebase
  pod 'GoogleUtilities'
  pod 'FirebaseAnalytics'
  pod 'FirebaseMessaging'

  # Factory
  pod 'Factory'
end

target 'KNUTICE' do
  pods
end

target 'KNUTICE-dev' do
  pods
end

target 'KNUTICEUnitTests' do
  pods
end

target 'NotificationService' do
  pod 'GoogleUtilities'
  pod 'Firebase/Messaging'
end

target 'NotificationService-dev' do
  pod 'GoogleUtilities'
  pod 'Firebase/Messaging'
end
