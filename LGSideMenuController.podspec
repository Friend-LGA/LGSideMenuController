Pod::Spec.new do |s|

    s.name = 'LGSideMenuController'
    s.version = '3.1.2'
    s.license = { type: 'MIT', file: 'LICENSE' }
    s.homepage = 'https://github.com/Friend-LGA/LGSideMenuController'
    s.author = { 'Grigorii Lutkov': 'friend.lga@gmail.com' }
    s.source = { git: 'https://github.com/Friend-LGA/LGSideMenuController.git', tag: s.version }
    s.summary = 'iOS view controller which manages left and right side views'
    s.platform = :ios, '9.0'
    s.swift_version = '5.0'
    s.source_files = 'LGSideMenuController/**/*.swift'
    s.framework = 'Foundation', 'CoreGraphics', 'QuartzCore', 'UIKit'

end
