# my-env

My Develop Environment Docker

See `Dockerfile` for details

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
