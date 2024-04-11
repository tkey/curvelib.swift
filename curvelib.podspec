Pod::Spec.new do |spec|
    spec.name         = "curvelib"
    spec.version      = "0.1.2"
    spec.platform      = :ios, "13.0"
    spec.summary      = "Curve Library for Torus"
    spec.homepage     = "https://github.com/Web3Auth"
    spec.license      = { :type => 'MIT', :file => 'License.md' }
    spec.swift_version   = "5.7"
    spec.author       = { "Torus Labs" => "gaurav@tor.us" }
    spec.module_name = "curvelib"
    spec.source       = { :git => "https://github.com/tkey/curvelib.swift.git", :tag => spec.version }
    
    spec.default_subspecs = []

    spec.subspec 'curvelib_xc' do |ss|
        ss.vendored_frameworks = 'Sources/curve_secp256k1/curve_secp256k1.xcframework'
        ss.source_files = 'Sources/curve_secp256k1/include/*.h'
        ss.public_header_files = 'Sources/curve_secp256k1/include/*.h'  
    end
    
    spec.subspec 'common' do |ss|
        ss.source_files = 'Sources/curvelib/common/**/*.{swift}'
        ss.dependency 'curvelib/curvelib_xc'
    end
    
    # spec.subspec 'curveSecp256k1' do |ss|
    #     ss.source_files = 'Sources/curvelib/secp256k1/**/*.{swift}' 
    #     ss.dependency 'curvelib/curvelib_xc'
    #     ss.dependency 'curvelib/common'
    # end

    # spec.subspec 'encryption_aes_cbc_sha512' do |ss|
    #     ss.dependency 'curvelib/curveSecp256k1'
    #     ss.dependency 'curvelib/curvelib_xc'
    #     ss.dependency 'curvelib/common'
    #     ss.source_files = 'Sources/curvelib/encryption/**/*.{swift}'
    # end 

    spec.subspec 'sha3' do |ss|
        ss.source_files = 'Sources/curvelib/sha3/**/*.{swift}'
        ss.dependency 'curvelib/curvelib_xc'
        ss.dependency 'curvelib/common'
    end
  end
