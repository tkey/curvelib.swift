Pod::Spec.new do |spec|
    spec.name         = "curveSecp256k1"
    spec.version      = "0.0.3"
    spec.platform      = :ios, "13.0"
    spec.summary      = "Curve Library for Torus"
    spec.homepage     = "https://github.com/Web3Auth"
    spec.license      = { :type => 'MIT', :file => 'License.md' }
    spec.swift_version   = "5.7"
    spec.author       = { "Torus Labs" => "gaurav@tor.us" }
    spec.module_name = "curveSecp256k1"
    spec.source       = { :git => "https://github.com/tkey/curvelib.swift.git", :tag => spec.version }

    spec.source_files = 'Sources/curvelib/secp256k1/**/*.{swift}' 
    spec.dependency 'curvelib_xc' , '0.0.3'
    spec.dependency 'curvelibCommon' '0.0.3''
end

