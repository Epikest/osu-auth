# osu!auth

[![.github/workflows/ci.yml](https://github.com/Epikest/osu-auth/actions/workflows/ci.yml/badge.svg)](https://github.com/Epikest/osu-auth/actions/workflows/ci.yml)

---

1. locates osu! folder from the Start Menu shortcut
2. deletes `.require_update` file and creates `_staging` file to prevent osu! from updating
3. replaces `osu!auth.dll` with old version embedded into the executable

## Development

build it:

```sh
shards build
```

run tests:

```sh
crystal spec
```

release it:

```sh
shards build -p -s --release --static
```

## Contributing

1. Fork it (<https://github.com/Epikest/osu-auth/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [Epikest](https://github.com/Epikest) - creator and maintainer
