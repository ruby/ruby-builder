# ruby-builder

A repository building released rubies to be used in GitHub Actions.

The action to use these prebuilt rubies is [ruby/setup-ruby](https://github.com/ruby/setup-ruby).

Please report issues to [ruby/setup-ruby](https://github.com/ruby/setup-ruby).

[The latest release](https://github.com/ruby/ruby-builder/releases/latest) contains all built Rubies.

## Process for new releases

When making builds a different way, first create a new release and mark it as `prerelease`.

Then if it might cause breaking changes, open an issue on
[actions/virtual-environments](https://github.com/actions/virtual-environments/issues) with a description of the changes.
This needs to be done 2 weeks prior to using the release.

Once it's ready, mark the release as non-prerelease and switch to it in `ruby/setup-ruby`.

## Naming

Archives are named `$engine-$version-$platform.tar.gz`.

`platform` is one of:
* `ubuntu-NN.NN`: built on the corresponding GitHub-hosted runner virtual environment
* `macos-latest`: built on `macos-10.15` (the oldest `macos` available on GitHub-hosted runners)
* `windows-latest`: built on `windows-2019` (does not matter, it's only for repacking a JRuby release, no actual build)

The names contain `-latest` for compatibility, even though what `-latest` points to for runners might have changed.
