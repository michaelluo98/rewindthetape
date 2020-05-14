## TODO
- setting up user:
  - spotify api wrapper? or migrate to rspotify, rspotify just seems like an overkill
    - check if request.env['omniauth.auth'] includes refresh and access tokens similar to google
    - if I want to app to persist, probably safest to just directly support... 
  - refactor
    - merge google and spotify callback flows
    - iron out google and spotify flows: test thoroughly: google first, spotify first etc
  - error handling

- [ ] setup poller:
  - [ ] design
  - [ ] for check spotify history
  - [ ] job queue?

- polish:
  - [ ] landing page after signing up and logging in (currently flash message)
  - revoke access
  - display user's name or is it creepy?
  - encrypt user tokens?

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
