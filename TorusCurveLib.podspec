Pod::Spec.new do |spec|
    spec.name         = "TorusCurveLib"
    spec.version      = "0.1.2"
    spec.platform      = :ios, "13.0"
    spec.summary      = "Curve Library for Torus"
    spec.homepage     = "https://github.com/Web3Auth"
    spec.license      = { :type => 'MIT', :file => 'License.md' }
    spec.swift_version   = "5.7"
    spec.author       = { "Torus Labs" => "gaurav@tor.us" }
    spec.module_name = "TorusCurveLib"
    spec.source       = { :git => "https://github.com/tkey/curvelib.swift.git", :tag => spec.version }
    
    spec.default_subspecs = 'curveSecp256k1' , 'encryption_aes_cbc_sha512'

    spec.subspec 'curvelib' do |ss|
        ss.vendored_frameworks = 'Sources/curve_secp256k1/curve_secp256k1.xcframework'
        ss.source_files = 'Sources/curve_secp256k1/include/*.h'
        ss.public_header_files = 'Sources/curve_secp256k1/include/*.h'  
    end

    spec.subspec 'curveSecp256k1' do |ss|
        ss.source_files = 'Sources/curvelib/secp256k1/**/*.{swift}' 
        ss.dependency 'TorusCurveLib/curvelib'
    end 

    spec.subspec 'encryption_aes_cbc_sha512' do |ss|
        ss.dependency 'TorusCurveLib/curveSecp256k1'
        ss.dependency 'TorusCurveLib/curvelib'
        ss.source_files = 'Sources/curvelib/encryption/**/*.{swift}' 
    end 

    # spec.test_spec 'Tests' do |test_spec|
    #     test_spec.source_files = 'Tests/**/*.{swift}'
    #     test_spec.dependency 'TorusCurveLib/curvelib'
    #     test_spec.dependency 'TorusCurveLib/curveSecp256k1'
    #     test_spec.dependency 'TorusCurveLib/encryption_aes_cbc_sha512'
    # end
  end
