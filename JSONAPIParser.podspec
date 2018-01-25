
Pod::Spec.new do |s|
  s.name             = 'JSONAPIParser'
  s.version          = '0.1.0'
  s.summary          = 'Lightweight JSON:API parser.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
Lightweight JSON:API parser that flattens complex JSON:API structure and turns it into simple JSON. It can also take simple JSON and turn it into JSON:API structure.
It works by transfering Dictionary to Dictionary, so you can use Codable, Unbox, Wrap, ObjectMapper, or any other object mapping tool that you preffer.
                       DESC

  s.homepage         = 'https://github.com/infinum/iOS-JSON-API-Parser'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Infinum' => 'ios@infinum.hr', 'Vlaho Poluta' => 'vlaho.poluta@infinum.hr', 'Filip Gulan' => 'filip.gulan@infinum.hr' }
  s.source           = { :git => 'https://github.com/infinum/iOS-JSON-API-Parser.git', :tag => s.version.to_s }

  s.requires_arc = true
  s.ios.deployment_target = '9.0'
  s.swift_version = '4.0'

  spec.default_subspec = 'Core'

  s.subspec 'Core' do |sp| 
    sp.source_files = 'JSONAPIParser/Classes/Core/**/*'
    sp.frameworks = 'Foundation'
  end

  s.subspec 'Codable' do |sp| 
    sp.source_files = 'JSONAPIParser/Classes/Codable/**/*'
    sp.dependency 'Core'
  end

  s.subspec 'Alamofire' do |sp| 
    sp.source_files = 'JSONAPIParser/Classes/Alamofire/**/*'
    sp.dependency 'Core'
  end

end
