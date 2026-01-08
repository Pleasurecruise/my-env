# my-env

My Develop Environment Docker

See `Dockerfile` for details

Docker can be useful to ensure your website works on the same on any machine

add following config file to the repo before use

p.s. vercel does not support docker useage

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

## jetbrains devcontainer & other servers useage

Copy `Dockerfile` to the target repo folder

Create New Dev Container from Dockerfile under the repo folder
