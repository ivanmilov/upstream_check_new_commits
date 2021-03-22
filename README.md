# upstream_check_new_commits
Github action to check whether upstream repo has new commits

Inspired by [aormsby/Fork-Sync-With-Upstream-action](https://github.com/aormsby/Fork-Sync-With-Upstream-action)



## Usage

```yml
name: Check new upstream commits

on:
  push:
  repository_dispatch:
    types: [check_upstream]

jobs:
  check_upstream_commits:
    runs-on: ubuntu-latest
    name: Check upstream latest commits

    steps:
    - name: Checkout main
      uses: actions/checkout@v2

    - name: Fetch upstream changes
      id: sync
      uses: ivanmilov/upstream_check_new_commits@v1
      with:
        upstream_repository: i3/go-i3
        upstream_branch: master
        target_branch: master_upstream

    - name: Notify if new commits
      if: ${{ steps.sync.outputs.has_new_commits == 'true' }}
      uses: ivanmilov/telegram_notify_action@v1
      with:
        api_key: ${{secrets.TELEGRAM_API_KEY}}
        chat_id: ${{secrets.TELEGRAM_CHAT_ID}}
        message: "New commit in upstream repo ${{github.repository}}"
```

## Inputs

All fields are mandatory
* `upstream_repository`: 'i3/go-i3', \<your-name>/\<repository-name>, ...
* `upstream_branch`: 'main', 'master', 'feature', ...
* `target_branch`: 'main', 'master', 'feature', ...
