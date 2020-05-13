## TODO
- setting up user:
  - add model level verification that user has either spotifyaccess or googlecredentials to 
  - [ ] connect to spotify 
    - change spotify redirect_uri permissions
    - should go to spotify method on spotify connect, then create method should be the callback since you may/may not create a new user
    - implement as template? both logging in and signing up
  - [ ] connect to google calendar
    - user identity:
      - scopes: openid profile email
      - endpoint: https://www.googleapis.com/oauth2/v2/userinfo
      - add code=access_token in header and make get request
- [ ] setup poller:
  - [ ] design
  - [ ] for check spotify history
  - [ ] job queue?

- polish:
  - [ ] landing page after signing up and logging in (currently flash message)

- deploying:
  - [ ] add CORS config to prod environment config
  - [ ] consider options
  - [ ] setup domain
  - [ ] rate limits?
  - [ ] consider removing faraday


## Main Idea
Currently just a mockup.
Log in the same path as sign up?

### MVP
- welcome page:
  - infographic (bootstrappy)
  - start up guide:
    - connect via both:
      - google calendar account
      - spotify music
- login page
  - get started
  - connect either via spotify or google

- poller display on calendar as events in a new spotify calendar
  - color of album? or just spotify...
  - include link to song on spotify

### Even better
- add force-sync
- youtube
- netflix
- easily fuzzy searching through history
- aggregate all of the data in a nice panel
- allow them to easily scroll/rewind the tape
