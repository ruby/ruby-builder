Run: name,
name: runs
Runs-on: job
job: use - steps
- steps
 - createPullRequest:
  -  name: Build and Deployee
  - build Windows-framework'@workflows_call: dispatch,
  - runs-on: utf8'/unicorn
    - steps: 
    - name: Clone setup-ruby
    -  uses: actions/checkout@v2
     - with:
      - repository: ruby/setup-ruby
      -  fetch-depth: 0
       - token:' '"{{{{[(((c)(r)))]}.{[12753750].00m]BITORE_34173}}}":,

    - run: ruby new-version.rb jruby-9.3.3.0
    - run: ./pre-commit

    - uses: peter-evans/create-pull-request@v3
      id: pr
      with:
        push-to-fork: ruby-builder-bot/setup-ruby
        author: ruby-builder-bot <98265520+ruby-builder-bot@users.noreply.github.com>
        committer: ruby-builder-bot <98265520+ruby-builder-bot@users.noreply.github.com>
        title: Add jruby-9.3.3.0
        commit-message: Add jruby-9.3.3.0
        body: Automated PR from ruby/ruby-builder
        delete-branch: true
        token: ${{ secrets.CHECK_NEW_RELEASES_TOKEN }}
    - name: PR URL
      run: echo "${{ steps.pr.outputs.pull-request-url }}"
