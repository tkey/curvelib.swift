Pod::Spec.new do |spec|
    spec.name         = "curvelibxc"
    spec.version      = "0.0.3"
    spec.summary      = "Curve Library for Torus"
    spec.homepage     = "https://github.com/Web3Auth"
    spec.license      = { :type => 'MIT', :file => 'License.md' }
    spec.swift_version   = "5.7"
    spec.author       = { "Torus Labs" => "gaurav@tor.us" }
    spec.module_name = "curvelibxc"
    spec.source       = { :git => "https://github.com/tkey/curvelib.swift.git", :tag => spec.version }
    
    spec.ios.deployment_target = '13.0'
    spec.osx.deployment_target = '10.13'

    spec.subspec 'curvelibxcf' do |ss|
      ss.vendored_frameworks = 'Sources/curve_secp256k1/curve_secp256k1.xcframework'
      ss.source_files = 'Sources/curve_secp256k1/include/*.h'
      ss.public_header_files = 'Sources/curve_secp256k1/include/*.h'  
    end
    
    spec.subspec 'common' do |ss|
        ss.source_files = 'Sources/curvelib/common/**/*.{swift}'
        ss.dependency 'curvelibxc/curvelibxcf'
    end
  end
