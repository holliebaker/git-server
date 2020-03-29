# Git Server Docker Container

Based on [jkarlosb/git-server-docker](https://github.com/jkarlosb/git-server-docker).

Allowing the creation of repos from environment variables, a custom setup script, and custom server-side hooks per repo.

## Volumes

- `/git-server/keys`: keys for the git server (user `git`)
- `/git-server/repos`: where git repositories are stored
- `/hooks`: where server-side hook scripts should be placed (the container needs to be restarted for them to be applied).
- `/custom-setup.sh`: an optional script to be run when the container is created.

## Sample `docker-compose.yml`

```yaml
version: "3.5"

services:
  git:
    container_name: git-server
    image: git-server
    build: .
    restart: always
    ports:
      - "1234:22"
    volumes:
      - ./keys:/git-server/keys
      - ./hooks:/hooks
      - ./custom-setup.sh:/setup.sh:/custom-setup.sh
      - Git:/git-server/repos
    environment:
      - REPO_ONE=repo-one.git
      - REPO_TWO=repo-two.git

volumes:
  Git:

```

## Setup For A Local Repository

Add the remote
```
git remote add origin ssh://git@<container-ip-or-hostname>:<port>/git-server/repos/<repository-name.git>
```

Then push.

## Automatic Repository Creation

Repositories can be created by passing environment variables prefixed by `REPO_`. For example, to cleate a repository called `my-test-repo.git`, pass
```
REPO_TEST=my-test-repo.git
```

Repositories will be placed in
```
/git-server/repos/
```

## Git Hooks

Custom server-side hooks (`pre-receive`, `post-receiwe`, and `update`) can be specified on a per-repository basis. Files in
```
/hooks/<repo-name>/
```
will be treated as hooks for that repo and will be copied to the repo's hooks derictory.

For this to work, `<repo-name>` must  be defined using an environment variable.

## Setup Script

If a file named `/custom-setup.sh` exists. it will run when the container is created.

