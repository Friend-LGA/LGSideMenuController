Pod::Spec.new do |s|

    s.name = 'LGSideMenuController'
    s.version = '3.0.0'
    s.license = { type: 'MIT', file: 'LICENSE' }
    s.homepage = 'https://github.com/Friend-LGA/LGSideMenuController'
    s.author = { 'Grigorii Lutkov': 'friend.lga@gmail.com' }
    s.source = { git: 'https://github.com/Friend-LGA/LGSideMenuController.git', tag: s.version }
    s.summary = 'iOS view controller, shows left and right views by pressing button or gesture'
    s.platform = :ios, '9.0'
    s.swift_version = '5.0'
    s.source_files = 'LGSideMenuController/**/*.swift'
    s.framework = 'Foundation', 'CoreGraphics', 'UIKit', 'ObjectiveC'

end
