# Template repository for matlab PTB project

This repo used the template from the CPP Lab developpers [here](https://github.com/cpp-lln-lab/template_PTB_experiment).
It was adapted to be used as a teaching example. 

## Ressources to help structure your code

PsychDemos that are in the `exampleScripts` folder [here](https://github.com/mwmaclean/my_new_experiment/tree/master/exampleScript/PsychExampleExperiments) were taken from the PTB code:  C:\PATH\to\PTB\toolboxPsychtoolbox\PsychDemos (change path to where you downloaded PTB)

GitHub: Search for PTB repos/scripts

[Peter Scarf PTB Tutorials](https://peterscarfe.com/ptbtutorials.html). The [simple_demos.m](https://github.com/mwmaclean/my_new_experiment/blob/master/exampleScripts/simple_demos.m) in the `exampleScripts` folder are a compilation of some of these tutorials. You can simply run each. 

[Forum PTB](http://www.catb.org/~esr/faqs/smart-questions.html)

[Bug Report](https://www.chiark.greenend.org.uk/~sgtatham/bugs.html)

[Art of readable code](https://twitter.com/RemiGau/status/1457706739739070467)

#### Quick PTB coding tips for designing your experiment

1) Avoid long scripts- use fonctions : it's easier to read
    - Check if you can start from available functions from CPP_PTB [here](https://github.com/cpp-lln-lab/CPP_PTB/tree/f4f5519cb5e0661b8559921d3b71a18351250a09/src)

2) Avoid 'hard coding', centralize all your parameters in a function or structure

    - Save everything in the structure (configuration: cfg) & save in a .tsv file so other softwares can read it.

3) Use 'try-catch' in case an error/bug happens in your code
    - See example in MullerLyler demos of PTB

4) Use a seperate file for the order of trials/conditions
    - Should be independant of your code/main script.

## How to install and use this repo

For the intro course, fork [this current repo](https://github.com/mwmaclean/my_new_experiment) to your github account with all the files, folders and submodules. You only have to then clone the repository and you are good to go.

This repo originally comes from this
[template PTB experiment repository](https://github.com/cpp-lln-lab/template_PTB_experiment) from the CPP Lab.



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




