inhibit_all_warnings!

def frameworks
  pod 'RxSwift', '~> 4.0'
  pod 'RxCocoa', '~> 4.0'

  pod 'RealmSwift', '~> 3.0'

  pod "RxContacts", '~> 1.0'

  pod "ReachabilitySwift", '~> 4.0'
  pod "RxReachability", '~> 0.0'
end

target 'CSContacts_iOS' do
  frameworks
  use_frameworks!

  target 'CSContacts_iOSTests' do
    inherit! :search_paths
  end

end

target 'CSContacts_iOS_examples' do
  frameworks
  use_frameworks!

end
