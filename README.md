# Shiny application for Clinical Chemistry Quizzes

![App UI](/ui.png)

This is a work-in-progress web application using _Shiny_ for undertaking quizzes relatedo to the field of clinical chemistry and laboratory medicine. 
It showcases 'off-label' uses of Shiny for developing modern web applications.  
The current version is in Dutch and a live version can be found at http://quiz.wptmdoorn.name.

**Package dependecies**

See `renv.lock` but some of these include `googledrive`, `shiny` and `dplyr`.

**Installation** 

1. Git clone the current repository
2. Adjust code for own spreadsheets
* Especially `server/data.R/load_quiz_drive_data`
* Refer to the `googledrive` package for extensive documentation on automatic identification
* As an alternative you can load local data, see `server/data/load_quiz_data`
3. Run Shiny application
