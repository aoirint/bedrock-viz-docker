# bedrock-viz-docker

Dockerfile for [bedrock-viz/bedrock-viz](https://github.com/bedrock-viz/bedrock-viz).

## Usage

```shell
mkdir -p worlds build

# Copy Bedrock world 'level' data
rsynv -av --delete '/path/to/server/worlds/level/' 'worlds/level/'

# UID:GID = 1000:1000
chown -R 1000:1000 worlds build

docker run --rm --init -v './worlds:/worlds' -v './build:/build' aoirint/bedrock-viz --db '/worlds/level' --out '/build' --html-most
```

## License

The code of Dockerfile is borrowed from [bedrock-viz/bedrock-viz](https://github.com/bedrock-viz/bedrock-viz) (GPLv2).
