# MES-Template
A "clone and go" MES project template.

## Installation

Firstly, clone this repository and initialize the needed git submodules.
```
git clone https://github.com/menga-team/MES-Template   

mv MES-Template <your_project_name>

cd <your_project_name>

git submodule update --init
```

After completing this step, there is two options for you:

### 1. Set up as a local project

To use the template as a local project on your PC, simply delete the git folder and your're good to go:

```
rm -rf .git
```

### 2. Set up as a new git repository

To set up your project as a new repository, first create a git repository, then follow these steps:

```
git remote remove origin   

git remote add origin <your_repository_url>

git push -u origin/main
```

## Usage

### Simulate

To simulate your game using Virtual-MES, build the executable using make, then simply run it.
Remember to install the SDL2 library, which is needed by V-MES, first.

```
make simulate
./game
```

### Upload
To test your game on real hardware you can use the `flash` target.

In order to flash your game you first need to enter:

```
make flash-setup
```

This will prepare everything for using `make flash`, if you update the
MES submodule you might need to do it again.

```
make flash
```

After that you can just use `make flash` and upload your game to the
CPU.

### Update

Occasionally, this template will receive some updates to keep up with the changing mes/vmes specifications.
To update your template, use `make update`

```
make update
```
