# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

def pods
  pod 'RxSwift'
  pod 'RxCocoa'
  pod 'RxViewController'
  pod 'RxKeyboard'
  pod 'ReactorKit'

  pod 'SnapKit'
  pod 'Then'
  pod 'Toaster'
  pod 'Kingfisher'
end

def pods_for_test
  pod 'Quick', '~> 1.3.1'
  pod 'Nimble', '~> 8.0.0'
  pod 'RxBlocking', '~> 4.0'
  pod 'RxTest',     '~> 4.0'
end

target 'BringMyOwnBeer🍺' do
  use_frameworks!

  pods
end

target 'BringMyOwnBeer🍺Tests' do
  use_frameworks!

  pods
  pods_for_test
end

target 'BringMyOwnBeer🍺UITests' do
  use_frameworks!

  pods
  pods_for_test
end
