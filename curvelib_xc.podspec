Pod::Spec.new do |spec|
    spec.name         = "curvelib_xc"
    spec.version      = "0.1.2"
    spec.summary      = "Curve Library for Torus"
    spec.homepage     = "https://github.com/Web3Auth"
    spec.license      = { :type => 'MIT', :file => 'License.md' }
    spec.swift_version   = "5.7"
    spec.author       = { "Torus Labs" => "gaurav@tor.us" }
    spec.module_name = "curvelib_xc"
    spec.source       = { :git => "https://github.com/tkey/curvelib.swift.git", :tag => spec.version }
    
    spec.vendored_frameworks = 'Sources/curve_secp256k1/curve_secp256k1.xcframework'
    
    spec.ios.deployment_target = '13.0'
    spec.osx.deployment_target = '10.13'

    spec.source_files = 'Sources/curve_secp256k1/include/*.h'
    spec.public_header_files = 'Sources/curve_secp256k1/include/*.h'

  end
