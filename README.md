# my-env

My Develop Environment Docker

See `Dockerfile` for details

Docker can be useful to ensure your website works on the same on any machine

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

## vercel deploy useage

```
# vercel.json
{
  "builds": [
    { "src": "Dockerfile",
      "use": "@vercel/docker",
      "config": {
        "buildCommand": "docker build -t my-env:latest .",
        "pushCommand": "docker push my-env:latest"
      }
    }
  ]
}
```

## jetbrains devcontainer & other servers useage

Copy `Dockerfile` to the target repo folder

Create New Dev Container from Dockerfile under the repo folder

## TODO

-[ ] add ide configuration
- [ ] add cli configuration