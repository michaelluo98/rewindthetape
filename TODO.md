## TODO
- [ ] setting up user
  - add model level verification that user has either spotifyaccess or googlecredentials to 
  - faraday
  - google and spotify secrets
  - [ ] connect to spotify 
    - implement as template? both logging in and signing up
  - [ ] connect to google calendar
- [ ] setup poller:
  - [ ] design
  - [ ] for check spotify history
  - [ ] job queue?

- polish:
  - [ ] landing page after signing up and logging in (currently flash message)

- deploying:
  - [ ] consider options
  - [ ] setup domain
  - [ ] rate limits?


## Main Idea
Currently just a mockup.

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
- youtube
- netflix
- easily fuzzy searching through history
- aggregate all of the data in a nice panel
- allow them to easily scroll/rewind the tape
