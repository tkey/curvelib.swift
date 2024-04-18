Pod::Spec.new do |spec|
  spec.name         = "curvelib.swift"
  spec.version      = "1.0.0"
  spec.ios.deployment_target = '13.0'
  spec.summary      = "Fetches the node details from torus nodelist smart contract"
  spec.homepage     = "https://github.com/tkey/curvelib.swift"
  spec.license      = { :type => 'BSD', :file => 'License.md' }
  spec.swift_version   = "5.3"
  spec.author       = { "Web3Auth" => "info@web3auth.io" }
  spec.source       = { :git => "https://github.com/tkey/curvelib.swift.git", :tag => spec.version }
  spec.source_files = "Sources/**/*.{swift,h,c}"
  spec.vendored_frameworks = "Sources/curve_secp256k1/curve_secp256k1.xcframework"
  spec.module_name = "curveSecp256k1"
end
