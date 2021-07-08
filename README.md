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
