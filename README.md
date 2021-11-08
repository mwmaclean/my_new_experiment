# Template repository for matlab PTB project

This repo used the template from the CPP Lab developpers [here](https://github.com/cpp-lln-lab/template_PTB_experiment). 

## Ressources to help structure your code

PsychDemos downloaded with PTB:  C:\PATH\to\PTB\Psychtoolbox\PsychDemos (change path to where you downloaded PTB)

GitHub: Search for PTB scripts

[Peter Scarf PTB Tutorials](https://peterscarfe.com/ptbtutorials.html)

[Forum PTB](http://www.catb.org/~esr/faqs/smart-questions.html)

[Bug Report](https://www.chiark.greenend.org.uk/~sgtatham/bugs.html)


## How to install and use this template

For the intro course, fork [this current repo](https://github.com/mwmaclean/my_new_experiment) to your github account with all the files, folders and submodules. You only have to then clone the repository and you are good to go.

This repo originally comes from this
[template PTB experiment repository](https://github.com/cpp-lln-lab/template_PTB_experiment) from the CPP Lab.



**How to install and run**

Install
```
git clone --recurse-submodules https://github.com/mwmaclean/my_new_experiment.git
```

Set parameters in `setParameters.m`

Run
```
mainScript
```


**Basic steps of the mainScript (template experiment)**

- Clear screen,
- Set parameters, 
- Prompt user input, 
- Initialize PTB, 
- Display instructions, 
- Start experiment,
- Design blocks/trials, Collect responses, Save events, 
- Goodbye screen, 
- Close.

#### Quick PTB coding tips

1) Avoid long scripts- use fonctions : it's easier to read
    Check if you can use/start from available functions from CPP_SPM [here](https://github.com/cpp-lln-lab/CPP_PTB/tree/f4f5519cb5e0661b8559921d3b71a18351250a09/src)

2) Avoid 'hard coding', centralize all your parameters in a function or structure

- Save everything in the structure (configuration: cfg) & save in a .tsv file so other softwares can read it.

3) Use 'try-catch' in case an error/bug happens in your code: see example in MullerLyler demos of PTB

4) Use a seperate file for the order of trials/conditions- should be independant of your code/main script.



