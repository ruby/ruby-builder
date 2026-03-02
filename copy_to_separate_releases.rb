require 'json'

def sh(*args, **kwargs)
  puts "$ #{args.join(' ')}"
  system(*args, exception: true, **kwargs)
end

assets = JSON.load(`gh release view toolcache --json assets`).fetch('assets')

filter = ARGV[0] || 'jruby-10.0.0.0'

PLATFORM_MAPPING = {
  'macos-latest'       => 'darwin-x64',
  'macos-13-arm64'     => 'darwin-arm64',
  'ubuntu-22.04'       => 'ubuntu-22.04-x64',
  'ubuntu-22.04-arm64' => 'ubuntu-22.04-arm64',
  'ubuntu-24.04'       => 'ubuntu-24.04-x64',
  'ubuntu-24.04-arm64' => 'ubuntu-24.04-arm64',
  'windows-latest'     => 'windows-x64',
  'windows-arm64'      => 'windows-arm64',
}

assets.each do |asset|
  name = asset['name']
  raise name unless /^(?<engine>[\w+]+)-(?<version>[\d.]+(?:-(p|preview|rc)\d+)?)-(?<platform>\w+-.+)\.tar\.gz$/ =~ name
  new_platform = PLATFORM_MAPPING.fetch(platform)
  new_name = "#{engine}-#{version}-#{new_platform}.tar.gz"
  if name.start_with?(filter)
    puts name
    tag = "#{engine}-#{version}"
    notes = "Builds of #{tag}"

    unless sh 'gh', 'release', 'view', tag, out: File::NULL, exception: false
      sh 'gh', 'release', 'create', tag, '--notes', notes
    end

    sh 'gh', 'release', 'download', 'toolcache', '--pattern', name
    File.rename name, new_name
    sh 'gh', 'release', 'upload', tag, new_name
    File.delete new_name
  end
end
