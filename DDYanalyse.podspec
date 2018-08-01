Pod::Spec.new do |s|

  s.name         = "DDYAnalyse"
  s.version      = "0.0.8"
  s.summary      = "当当埋点SDK"

 
  s.description  = <<-DESC
                   当当埋点SDK基于大当埋点规则去开发的，详见readme
                   DESC

  s.license      = "MIT"
  s.homepage     = "http://10.255.223.213/ios-code/DDYAnalyse.git"

  s.author             = { "马栋军" => "madongjun@dangdang.com" }
  
  s.platform     = :ios, "8.0"

  s.source       = { :git => "http://10.255.223.213/ios-code/DDYAnalyse.git", :tag =>"#{s.version }"}

  s.source_files  = "DDYAnalyse/**/*.{h,m,md}"
  s.resources =  "DDYAnalyse/**/*.plist"
   
  s.requires_arc = true

  s.dependency 'LKDBHelper', '2.4.7'

end