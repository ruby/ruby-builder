require 'json'

engines_and_min_versions = {
  'ruby' => Gem::Version.new('2.6.0'),
  'jruby' => Gem::Version.new('9.2.9.0'),
  'truffleruby' => Gem::Version.new('21.0.0'),
}

min_version_for_preview_rc = Gem::Version.new('3.0.0.a')

def sh(*command)
  puts command.join(' ')
  raise "#{command} failed" unless system(*command)
end

all_versions = `ruby-build --definitions`
abort unless $?.success?

all_versions = all_versions.lines.map(&:chomp)
all_versions_per_engine = Hash.new { |h,k| h[k] = [] }
all_versions.each { |version|
  case version
  when /^\d/
    all_versions_per_engine['ruby'] << version
  when /^(\w+)-(.+)$/
    all_versions_per_engine[$1] << $2
  else
    nil
  end
}

all_already_built = JSON.load(File.read('setup-ruby/ruby-builder-versions.json'))

engines_and_min_versions.each_pair { |engine, min_version|
  versions = all_versions_per_engine.fetch(engine)
  releases = versions.grep(/^\d+(\.\d+)+$/).select { |version|
    Gem::Version.new(version) >= min_version
  }
  if engine == 'ruby'
    releases += versions.grep(/^\d+(\.\d+)+-(preview|rc)(\d+)$/).select { |version|
      Gem::Version.new(version) >= min_version_for_preview_rc
    }
  elsif engine == 'truffleruby'
    releases += versions.grep(/^\d+(\.\d+)+-preview(\d+)$/).select { |version|
      Gem::Version.new(version) >= min_version
    }
  end

  already_built = all_already_built.fetch(engine)
  new = releases - already_built
  unless new.empty?
    puts "New releases for #{engine}: #{new}"
    sh("ruby", "build.rb", *new.map { |v| "#{engine}-#{v}" })
    sh("git", "push")
  end
}
