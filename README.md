# Template repository for matlab PTB project

## Ressources to help structure your code

PsychDemos downloaded with PTB:  C:\PATH\to\PTB\Psychtoolbox\PsychDemos (change path to where you downloaded PTB)

GitHub: Search for PTB scripts

[Peter Scarf PTB Tutorials](https://peterscarfe.com/ptbtutorials.html)

[Forum PTB](http://www.catb.org/~esr/faqs/smart-questions.html)

[Bug Report](https://www.chiark.greenend.org.uk/~sgtatham/bugs.html)


## How to install and use this template

By using the
[template PTB experiment repository](https://github.com/mwmaclean/my_new_experiment/blob/master/mainScript.m):
you can create a new repository on your github account with all the basic folders,
files and submodules already set up. You only have to then clone the repository
and you are good to go.


**How to install and run**

Install
```
git clone --recurse-submodules https://github.com/your_github_account/the_name_of_your_new_experiment.git
```

Set parameters in `setParameters.m`

Run
```
mainScript
```

**Quick PTB coding tips**

Avoid long scripts- use fonctions : it's easier to read
    Check if you can use/start from available functions from CPP_SPM [here](https://github.com/cpp-lln-lab/CPP_PTB/tree/f4f5519cb5e0661b8559921d3b71a18351250a09/src)

Avoid 'hard coding', centralize all your parameters in a function or structure

Save everything in the structure (configuration: cfg)

Also directly save everything in a .tsv file so other softwares can read it.

Use 'try-catch' in case an error/bug happens in your code: see example in MullerLyler demos of PTB

The order of trials/conditions should be independant of your code - save in a seperate file

