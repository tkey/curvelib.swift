Pod::Spec.new do |spec|
    spec.name         = "encryption_aes_cbc_sha512"
    spec.version      = "0.1.2"
    spec.platform      = :ios, "13.0"
    spec.summary      = "Curve Library for Torus"
    spec.homepage     = "https://github.com/Web3Auth"
    spec.license      = { :type => 'MIT', :file => 'License.md' }
    spec.swift_version   = "5.7"
    spec.author       = { "Torus Labs" => "gaurav@tor.us" }
    spec.module_name = "encryption_aes_cbc_sha512"
    spec.source       = { :git => "https://github.com/tkey/curvelib.swift.git", :tag => spec.version }
    


    spec.dependency 'curveSecp256k1'
    spec.dependency 'curvelib'
    spec.source_files = 'Sources/curvelib/encryption/**/*.{swift}' 

    # spec.test_spec 'Tests' do |test_spec|
    #     test_spec.source_files = 'Tests/**/*.{swift}'
    #     test_spec.dependency 'curvelib'
    #     test_spec.dependency 'curveSecp256k1'
    #     test_spec.dependency 'encryption_aes_cbc_sha512'
    # end
  end
