Pod::Spec.new do |s|
  s.name             = "RocketChatAdapter"
  s.version          = "0.1.0"
  s.summary          = "Adapter to connect your app with a rocket chat"

  s.description      = <<-DESC
			An adapter to connect your app with a rocket chat installation
                       DESC

  s.homepage         = "https://github.com/barteljan/RocketChatAdapter"
  s.license          = 'MIT'
  s.author           = { "Jan Bartel" => "barteljan@yahoo.de" }
  s.source           = { :git => "https://github.com/barteljan/RocketChatAdapter.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/janbartel'

  s.platform     = :ios, '8.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/**/*'
  s.resource_bundles = {
    'RocketChatAdapter' => ['Pod/Assets/*.*']
  }

  s.dependency 'VISPER-CommandBus', '~> 0.1.5'
  s.dependency 'ObjectiveDDP'
end
