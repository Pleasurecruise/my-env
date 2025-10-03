# my-env

My Develop Environment Docker

See `Dockerfile` for details

add following config file to the repo before use

## github codespace useage

```
# .devcontainer/devcontainer.json
{
  "image": "ghcr.io/pleasurecruise/my-env:latest",
  "features": {}
}
```

## cloud native build useage

```
# .cnb.yml
$:
  vscode:
    - runner:
        cpus: 16
      docker:
        image:
          name: docker.cnb.cool/pleasure1234/my-env:latest
      services:
        - docker
        - vscode
      stages:
        - name: ls
          script: ls
```
