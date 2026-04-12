# Python 3.14 backport for Debian 13 trixie
The aim of this project is to provide a Python 3.14 backport to Debian trixie. Packages are of course much better manageable than compiling the source from scratch. In my opinion it is also more manageable than using `pyenv`. By using my packages you will also be sure to get the latest patches (on a best effort basis).

Motivation for this project was the [removal of Python 3.13 support in Home Assistant 2026.2](https://github.com/home-assistant/core/pull/161426). Debian trixie doesn't have Python 3.14 however.

## Scope
The scope of this project is limited to backporting just Python 3.14 itself. So no defaults (which provide virtual packages so `python3` get's automatically linked to `python3.14`) and no precompiled pip-packages or wheels besides pip itself. Therefore it can coexist with your regular Python (3.13) installation without any interference and still being simple to maintain. It's main use is for in virtual environments where you can use pip to compile and install any packages you desire. It does provide all the packages and dependencies needed to create a Python 3.14 virtual environment.

Because the version of pip present in Debian 13 trixie isn't compatible with Python 3.14, I've included pip inside the Python package. Normally pip on Debian is inside the `python3-pip` package, but backporting that would clash with an existing pip installation. This is the easiest solution for now.

## Repository
The APT repository is hosted on GitHub Pages. First add my PGP key to APT's sources keyring:
```sh
wget -qO- https://syssi.github.io/python3.14-backport/syssi-python3.14-backport.gpg | sudo tee /etc/apt/keyrings/syssi-python3.14-backport.gpg
```

Now add the repository to your sources:
```sh
cat <<EOF | sudo tee /etc/apt/sources.list.d/python3.14-backport.sources
Types: deb
URIs: https://syssi.github.io/python3.14-backport
Suites: trixie-backports
Components: main
Signed-By: /etc/apt/keyrings/syssi-python3.14-backport.gpg
EOF
```

After running `apt update` you should now be able to install Python 3.14 related packages.

Individual `.deb` packages can also be downloaded directly from the [GitHub Releases](https://github.com/syssi/python3.14-backport/releases) page and installed with `dpkg -i`.

Packages are built using Github Actions along with a file containing the checksums of all packages. Therefore, you can compare the checksums of the packages in the repository with the checksums in Github Actions and trace the entire process (up to 90 days after the build after which the artifacts and logs get removed). This way, if you trust the Github Actions build system, you can be sure that the packages I provide are actually built using the instructions in this repo.

## Support
Currently there is support for **`amd64`**, **`arm64`** and **`armhf`** architectures. The `amd64` packages are build natively while the `arm64` and `armhf` packages are crossbuilt. Testing is not possible while crossbuilding, so these packages did not undergo the same amount of testing as usual Debian packages do.

## Building the packages yourself
If you want to build the packages yourself, you can use the Dockerfile and the patches in this repository. Patches will be applied by the Dockerfile. Buildkit is required.

Packages are built using the `buildx bake` command. The following targets are supported: `native`, `crossbuild`, `crossbuild-armhf` and `crossbuild-arm64`. Supplying no target or `default` will build all packages. Build artifacts are extracted to the `artifacts` folder (will be created automatically).

```sh
docker buildx bake default
```

You can supply the following environment variables to modify the changelog: `NAME`, `EMAIL` and `CHANGE` (for an additional message in the changelog besides "Rebuild for trixie-backports").

```sh
NAME="James Smith" EMAIL="jamessmith@example.org" CHANGE="Fixed some bug somewhere" docker buildx bake default
```

Building natively takes about 2 hours on a modern decent PC because of the extensive testing. Cross building takes about 30 minutes (but uses native binaries so requires the extra 2 hours the first time).
