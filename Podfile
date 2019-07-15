# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'BringMyOwnBeer🍺' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for BringMyOwnBeer🍺
  # RxSwift + Dependencies
  pod 'RxSwift', '~> 4.4.0'
  pod 'RxCocoa', '~> 4.4.0'
  pod 'RxOptional', '~> 3.6.2'
  pod 'Moya/RxSwift', '~> 12.0.1'
  pod 'RxKeyboard', '~> 0.9.0'
  pod 'RxAppState'
  pod 'RxDataSources', '~> 3.1.0'

  # Image + Animation + UI
  pod 'Kingfisher', '~> 4.10.1'
  pod 'Toaster', '~> 2.1.0'
  pod 'SnapKit', '~> 4.2.0'

  # Other Swift Utilities
  pod 'Then', '~> 2.4.0'

def testing_pods
  pod 'Quick', '~> 1.3.1'
  pod 'Nimble', '~> 8.0.0'
  pod 'RxBlocking', '~> 4.0'
  pod 'RxTest',     '~> 4.0'
end

  target 'BringMyOwnBeer🍺Tests' do
    inherit! :search_paths
    # Pods for testing
    testing_pods
  end

  target 'BringMyOwnBeer🍺UITests' do
    inherit! :search_paths
    # Pods for testing
    testing_pods
  end

end
