Pod::Spec.new do |s|
  s.name         = 'MHDismissModalView'
  s.version      = '1.0.0'
  s.license      = 'MIT'
  s.platform     = :ios, '7.0'
  
  s.summary      = 'automatically sets the background with a blur effect and you can dismiss all modal views with a gesture'
  s.homepage     = 'https://github.com/mariohahn/MHDismissModalView'
  s.author       = { 'Mario Hahn' => 'https://twitter.com/mario_hahn' }
  s.source       = { :git => 'https://github.com/mariohahn/MHDismissModalView.git', :tag => s.version.to_s }
  
  s.source_files = 'UINavigationController+MHDismissModalView/*.{h,m}'
  s.requires_arc = true
end