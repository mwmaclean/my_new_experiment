**Unit tests and coverage**

[![](https://img.shields.io/badge/Octave-CI-blue?logo=Octave&logoColor=white)](https://github.com/cpp-lln-lab/template_PTB_experiment/actions)
![](https://github.com/Remi-gau/template_matlab_analysis/workflows/CI/badge.svg)

[![codecov](https://codecov.io/gh/Remi-gau/template_matlab_analysis/branch/master/graph/badge.svg)](https://codecov.io/gh/cpp-lln-lab/template_PTB_experiment)

**Miss_hit linter**

[![Build Status](https://travis-ci.com/Remi-gau/template_matlab_analysis.svg?branch=master)](https://travis-ci.com/cpp-lln-lab/template_PTB_experiment)

# Template repository for matlab analysis project

## Content

```bash
├── .git
│   ├── COMMIT_EDITMSG
│   ├── FETCH_HEAD
│   ├── HEAD
│   ├── ORIG_HEAD
│   ├── branches
│   ├── config
│   ├── description
│   ├── hooks
│   │   ├── pre-commit.sample
│   │   └── pre-push.sample
│   ├── ...
│   └── ...
├── .github  # where you put anything github related
│   └── workflows # where you define your github actions
│       └── moxunit.yml # a yaml file that defines a github action
├── lib # where you put the code from external libraries (mathworks website or other github repositories)
│   └── README.md
├── src # where you put your code
│   ├── README.md
│   └── miss_hit.cfg
├── tests # where you put your unit tests
|   ├── README.md
|   └── miss_hit.cfg
├── .travis.yml # where you define the continuous integration done by Travis
├── LICENSE
├── README.md
├── environment.yml # a simple environment for anything python related in this repo
├── miss_hit.cfg # configuration file for the matlab miss hit linter
└── initEnv.m # a .m file to set up your project (adds the right folder to the path)
```

## Keeping your code stylish: miss hit linter

## Python environment

More on this
[here](https://the-turing-way.netlify.app/reproducible-research/renv/renv-package.html)

[Conda cheat sheet](https://docs.conda.io/projects/conda/en/4.6.0/_downloads/52a95608c49671267e40c689e0bc00ca/conda-cheatsheet.pdf)

## Testing your code

## Continuous integration

## How to install and use this template

By using the
[template PTB experiment repository](https://github.com/cpp-lln-lab/template_PTB_experiment):
you can create a new repository on your github account with all the basic folders,
files and submodules already set up. You only have to then clone the repository
and you are good to go.


## How to install and run

Install
```
git clone --recurse-submodules https://github.com/your_github_account/the_name_of_your_new_experiment.git
```

Set parameters in `setParameters.m`

Run
```
mainScript
```