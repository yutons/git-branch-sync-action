# Git Branch Sync Action


A GitHub Action for sync a git repository branch to another location (Github、Gitlab、Gitee) via SSH.

## Inputs

### `source-repo`

**Required** SSH URL of the source repo.

## Inputs

### `source-branch`

**Required** branch of the source repo.

### `destination-repo`

**Required** SSH URL of the destination repo.

### `destination-branch`

**Required** branch of the destination repo.

### `dry-run`

**Optional** *(default: `false`)* Execute a dry run. All steps are executed, but no updates are pushed to the destination repo.

## Environment variables

`SSH_PRIVATE_KEY`: Create a [SSH key](https://docs.github.com/en/github/authenticating-to-github/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent#generating-a-new-ssh-key) **without** a passphrase which has access to both repositories. On GitHub you can add the public key as [a deploy key to the repository](https://docs.github.com/en/developers/overview/managing-deploy-keys#deploy-keys). GitLab has also [deploy keys with write access](https://docs.gitlab.com/ee/user/project/deploy_keys/) and for any other services you may have to add the public key to your personal account.  
Store the private key as [an encrypted secret](https://docs.github.com/en/actions/reference/encrypted-secrets) and use it in your workflow as seen in the example workflow below.

`SSH_KNOWN_HOSTS`: Known hosts as used in the `known_hosts` file. *StrictHostKeyChecking* is disabled in case the variable isn't available.

If you added the private key or known hosts in an [environment](https://docs.github.com/en/actions/reference/environments) make sure to [reference the environment name in your workflow](https://docs.github.com/en/actions/reference/workflow-syntax-for-github-actions#jobsjob_idenvironment) otherwise the secret is not passed to the workflow.

## Example workflow

```yml
name: Fork Sync To Gitee
on:
  schedule:
    - cron:  '0 7,12 * * *'
  workflow_dispatch: # on button click

concurrency:
  group: git-branch-sync-action
  
jobs:
  git-branch-sync-action:
    runs-on: ubuntu-latest
    steps:
      - name: git-branch-sync-action
        uses: yutons/git-branch-sync-action@v1.0.2
        env:
          SSH_PRIVATE_KEY: ${{ secrets.SSH_PRIVATE_KEY }}
        with:
          source-repo: git@github.com:yutons/git-branch-sync-action.git
          source-branch: main
          destination-repo: git@github.com:yutons/git-branch-sync-action.git
          destination-branch: main
```

## Docker

```sh
docker run --rm -e "SSH_PRIVATE_KEY=$(cat ~/.ssh/id_rsa)" $(docker build -q .) "$SOURCE_REPO" "$SOURCE_BRANCH" "$DESTINATION_REPO" "$DESTINATION_BRANCH"
```