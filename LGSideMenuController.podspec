Pod::Spec.new do |s|

    s.name = 'LGSideMenuController'
    s.version = '2.0.7'
    s.platform = :ios, '8.0'
    s.license = 'MIT'
    s.homepage = 'https://github.com/Friend-LGA/LGSideMenuController'
    s.author = { 'Grigory Lutkov' => 'Friend.LGA@gmail.com' }
    s.source = { :git => 'https://github.com/Friend-LGA/LGSideMenuController.git', :tag => s.version }
    s.summary = 'iOS view controller, shows left and right views by pressing button or gesture'

    s.requires_arc = true

    s.source_files = 'LGSideMenuController/*.{h,m}'

end
