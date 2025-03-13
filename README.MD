# Event Master IOS App

This documentation outlines the structure and components of the Event Master IOS App implemented in Swift.

## Preview
[![Even Master Demo](https://img.youtube.com/vi/rigvMbLewEw/0.jpg)](https://www.youtube.com/watch?v=rigvMbLewEw)

## Login/Signup features
The `Authentication` system, including sign-up and login features, was developed using Firebase Authentication. The system also has requirements when it comes to validity of user's email and password including: correct email format, password has to be longer than 6 characters, no duplicate users or email allowed, etc.

`Login` session will also be saved. Meaning once a user log in, even after closing the app, the user will still stay logging in. 

## Homepage
From the `homepage` you can view event's name, type of event and address. You can also create a new event by clicking on the plus sign at the bottom right corner

## Event
Event can be created using pre-defined field. Once created, user can view event details including name, capacity as well as address directly on Google map that has been implemented into the app (more on this features can be found <a href="https://swift-map.gitbook.io/swift-map">here</a>)

## Profile
Once created, user will have the flexibility to update their bio as well as profile picture. Log in session will be saved unless user log out from the profile screen.
