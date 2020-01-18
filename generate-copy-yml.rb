from_tag = 'builds-bundler1'
to_tag = 'builds-newer-openssl'

versions = {
  "ruby": [
    # "2.3.0", "2.3.1", "2.3.2", "2.3.3", "2.3.4", "2.3.5", "2.3.6", "2.3.7", "2.3.8",
    "2.4.0", "2.4.1", "2.4.2", "2.4.3", "2.4.4", "2.4.5", "2.4.6", "2.4.7", "2.4.9",
    "2.5.0", "2.5.1", "2.5.2", "2.5.3", "2.5.4", "2.5.5", "2.5.6", "2.5.7",
    "2.6.0", "2.6.1", "2.6.2", "2.6.3", "2.6.4", "2.6.5",
    "2.7.0"
  ],
  "jruby": ["9.2.9.0"],
  "truffleruby": ["19.3.0", "19.3.1"]
}

platforms = [ "ubuntu-16.04", "ubuntu-18.04", "macos-latest" ]

download_url_base = "https://github.com/eregon/ruby-install-builder/releases/download/#{from_tag}"
upload_url = `curl -s 'https://api.github.com/repos/eregon/ruby-install-builder/releases/tags/#{to_tag}' | jq -r .upload_url`.strip
p upload_url

yaml = <<YAML
name: Copy assets between releases
on: [push]
jobs:
  copy:
    if: true
    runs-on: ubuntu-latest
    steps:
YAML


versions.each_pair { |engine, vs|
  vs.each { |version|
    ruby = "#{engine}-#{version}"
    platforms.each { |os|
      yaml << <<YAML
    - name: Download #{ruby}-#{os}
      run: wget --no-verbose '#{download_url_base}/#{ruby}-#{os}.tar.gz'
    - name: Upload #{ruby}-#{os}
      uses: actions/upload-release-asset@v1.0.1
      env:
        GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
      with:
        upload_url: '#{upload_url}'
        asset_path: #{ruby}-#{os}.tar.gz
        asset_name: #{ruby}-#{os}.tar.gz
        asset_content_type: application/gzip
YAML
    }
  }
}

File.write '.github/workflows/copy.yml', yaml
