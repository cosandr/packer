# Stuff

Build all base image

```sh
packer build -only '*base*' .
```

Build just one OS base image

```sh
packer build -only '*base*rocky*' .
packer build -only '*base*cs8*' .
packer build -only '*base*cs9*' .
```

Build final images (*MUST* build base prior, as well as manually move them into `/templates`)

```sh
packer build -only '*clone*' .
```

Build one final image

```sh
packer build -only '*clone*rocky*' .
packer build -only '*clone*cs8*' .
packer build -only '*clone*cs9*' .
```
