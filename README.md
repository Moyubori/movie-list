# MovieBrowser

This app is a part of recruitment task for Flutter Developer position at Droids on Roids. It allows users to browse movie database and look for some interesting financial statistics. It uses The Movie Database API as a source of data about movies, its documentation is available [here](https://developers.themoviedb.org/3/getting-started/introduction).

## Recruitment task

Right now, app consists of only one screen: movie list. It allows user to search movies in The Movie Database. Your task is to add some new features to our app:

1. As a warm up, sort movies fetched from the api by vote average.

2. Next, implement navigation between movie list and movie details screen. To not spent too much time on programming simple UI, I've already implemented movie details screen for you. It is available as `MovieDetailsPage` class.

3. After that, fetch detailed information about the selected movie and show its title (as a navigation bar title), budget and revenue (formatted as values in dollars).

4. Finally, let's add some logic to the app. As you can see, there is one more label on the Movie Details screen: the "Should I watch it today?" label. Let's say, that I should watch the movie today, **if today is sunday and profit from the movie is bigger than $1000000** (by profit I mean a difference between revenue and budget). So, under that label show value "Yes" if the following criteria are met or "No", if they are not.

## Tips

To regenerate JSON models, use the following command:
```
flutter pub run build_runner build
```

Good luck!
