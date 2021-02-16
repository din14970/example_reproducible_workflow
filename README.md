# Example reproducible workflow

There are many ways to make workflows reproducible. This repo serves to demonstrate a few options.

# MyBinder
Mybinder is a free online service that builds a docker container with a jupyter server from a github repository. It looks for a config file in [binder](binder/environment.yaml), which is used to build a conda environment with the necessary dependencies to run the notebook.
You can go to [mybinder](https://mybinder.org/) and enter the URL of this repo there, or alternatively click the button below to start building the environment and serve up the notebook.

[![Binder](https://mybinder.org/badge_logo.svg)](https://mybinder.org/v2/gh/din14970/example_reproducible_workflow/HEAD)

# Docker demonstration
Since the data file is not included in the Github repository, if I delete the file on the file server, the notebook in the mybinder environment will cease to work.

In order to ensure everything is bundled together, we build a docker image. This bundles a minimalistic operating system, the necessary packages and software, and the data all together in one file that can be run as a docker container. To build such an image, the necessary configuration files `Dockerfile` and `.dockerignore` are included in this repo. To build the docker image yourself for this repo, you must:

```
$ git clone https://github.com/din14970/example_reproducible_workflow
$ cd example_reproducible_workflow
$ mkdir Data
$ wget -O "Data/example.emd" "https://owncloud.gwdg.de/index.php/s/wBifnrx7RpsP5nL/download"
$ docker build -t yourname/example_notebook .
```

or do equivalent steps manually. This presumes you are on a Unix based system, that the data file remains available, and that you have Docker CLI installed.

You can then run the image with
```
$ docker run -p 7000:8888 yourname/example_notebook
```

You can then navigate to <http://localhost:7000> and run the notebook.

In principle I can also upload this image to docker hub with

```
$ docker push yourname/example_notebook
```

And this can be downloaded with

```
$ docker pull yourname/example_notebook
```

Alternatively, the entire image can be condensed to a tar archive

```
$ docker save -o example_notebook.tar yourname/example_notebook
```
which can then be uploaded anywhere, like on Github releases. This tar file could then be loaded as an image with

```
$ docker load example_notebook.tar
```

It is only such an image that is truly reproducible! However I haven't done this yet because I didn't want to upload 3.5 Gb from my home network.
