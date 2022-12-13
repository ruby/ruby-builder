def sh(*command)
  puts command.join(' ')
  raise "#{command} failed" unless system(*command)
end

versions = ARGV.dup
versions.dup.each do |engine_version|
  engine, version = engine_version.split('-', 2)
  if engine == 'truffleruby'
    versions << "truffleruby+graalvm-#{version}"
  end
end
engine_versions = versions.join(', ')
jruby = versions.any? { |v| v.start_with?('jruby-') }

file = ".github/workflows/build.yml"
lines = File.readlines(file)

unix = lines.find { |line| line.include?('ruby: ') }
windows = lines.find { |line| line.include?('jruby-version: ') }
raise unless unix && windows

unix.sub!(/ruby: .+/, "ruby: [#{engine_versions}]")
if jruby
  windows.sub!(/jruby-version: .+/, "jruby-version: #{versions.map { |v| v.delete_prefix('jruby-') }}")
end

if_lines = lines.select { |line| line.match?(/^    if: (true|false)/) }
raise unless if_lines.size == 2
if_lines[0].sub!(/if: (true|false)/, 'if: true')
if_lines[1].sub!(/if: (true|false)/, "if: #{jruby}")

File.write(file, lines.join)

sh 'git', 'add', file
sh 'git', 'commit', '-m', "Build #{engine_versions}"
