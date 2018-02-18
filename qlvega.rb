cask 'qlvega' do
  version '0.1'
  sha256 'e857fbafe94839cb7665fef2eee2e716e68e0a2e18134d590c5c3a6eea9e29fa'
  url "https://github.com/invokesus/qlvega/releases/download/v0.1/qlvega.tgz"

  name 'qlvega'
  homepage 'https://github.com/invokesus/qlvega'

  qlplugin "qlvega.qlgenerator"

  zap trash: '~/Library/QuickLook/qlvega.qlgenerator'
end
