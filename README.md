# bedrock-viz-docker

Unofficial Dockerfile for [bedrock-viz/bedrock-viz](https://github.com/bedrock-viz/bedrock-viz).

## Usage

```shell
mkdir -p worlds build

# Copy Bedrock world 'level' data
rsync -av --delete '/path/to/server/worlds/level/' 'worlds/level/'

# UID:GID = 1000:1000
sudo chown -R 1000:1000 worlds build

sudo docker run --rm --init -v './worlds:/worlds' -v './build:/build' aoirint/bedrock-viz --db '/worlds/level' --out '/build' --html-most
```

## License

The original code of Dockerfile is borrowed from [bedrock-viz/bedrock-viz](https://github.com/bedrock-viz/bedrock-viz) (GPLv2).
