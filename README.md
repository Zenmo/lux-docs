# LUX ENERGY TWIN DOCUMENTATION 

This repository contains the technical documentation for LUX Energy Twin, or LUX for short.

For those just interested in reading the docs, they can be easily accessed at [docs.lux.energy](https://docs.lux.energy).

The rest of this file is for those interested in contributing to the docs.

The documentation guidelines can be found in the file: `documentation_guidelines`.

The documentation is automatically deployed to the LUX website so that it is always up to date with the status of this repository.

When developping the results can be viewed locally by running the following command:

```
podman run --volume .:/app docker.io/javanile/mkdocs:latest sh -c "pip3 install pymdown-extensions && mkdocs build"
```

This produces html files in the folder `site`, which can be opened in your browser of choice.