# ruby-builder

A repository building released rubies to be used in GitHub Actions.

The action to use these prebuilt rubies is [ruby/setup-ruby](https://github.com/ruby/setup-ruby).

Please report issues to [ruby/setup-ruby](https://github.com/ruby/setup-ruby).

There is one release per `$engine-$version` holding the corresponding built Rubies for the various platforms.

## Building a new Ruby release

```
ruby build.rb [ruby|jruby|truffleruby] VERSION
```

## Process for new builds

When making builds a different way, first create a new release and mark it as `prerelease`.

Then if it might cause breaking changes, open an issue on
[actions/virtual-environments](https://github.com/actions/virtual-environments/issues) with a description of the changes.
This needs to be done 2 weeks prior to using the release.

Once it's ready, mark the release as non-prerelease and switch to it in `ruby/setup-ruby`.

## Naming

Archives are named `$engine-$version-$platform.tar.gz`.
`$arch` is either `x64` or `arm64`

`platform` is one of:
* `darwin-$arch`: built on the oldest macOS GitHub-hosted runner for that arch
* `ubuntu-NN.NN-$arch`: built on the corresponding GitHub-hosted runner
* `windows-$arch`: built on the oldest Windows GitHub-hosted runner for that arch
