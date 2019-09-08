Pod::Spec.new do |s|
    s.name         = "AVCalendarFramework"
    s.version      = "0.1.1"
    s.summary      = "A brief description of AVCalendarFramework project."
    s.description  = <<-DESC
    A customisable calendar framework. Which can be used to add a clear and a unique calendar to your application.
    DESC
    s.homepage     = "http://dextraltech.com"
    s.license = { :type => 'Copyright', :text => <<-LICENSE
                   Copyright 2018
                   Permission is granted to...
                  LICENSE
                }
    s.author             = { "Anirudh Vyas" => "vyas.anirudh@hotmail.com" }
    s.source       = { :git => "https://github.com/vyasanirudh/AVCalendarFramework.git", :tag => "#{s.version}" }
    s.public_header_files = "AVCalendarFramework.framework/Headers/*.h"
    s.source_files = "AVCalendarFramework.framework/Headers/*.h"
    s.vendored_frameworks = "AVCalendarFramework.framework"
    s.platform = :ios
    s.swift_version = "4.2"
    s.ios.deployment_target  = '9.0'
end
