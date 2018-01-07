# Twitch_API
Twitch Web API for the LoyalFan Application

[ ![Codeship Status for SilverFellow/Twitch_API](https://app.codeship.com/projects/030d5410-ab80-0135-1d7c-326c62bbc0df/status?branch=master)](https://app.codeship.com/projects/256760)
---

## Routes

Our API is rooted at `/api/v0.1/` and has the following subroutes:

- `GET channel/channelname` - Fetch metadata of a previously updated channel.
- `POST channel/channelname` - Load a channel from Twitch and store metadata in database.

## Setup

To setup the API on your local machine: 

```
$ git clone https://github.com/SilverFellow/Twitch_API.git
$ cd Twitch_API
$ bundle install
$ bundle exec rake db:migrate
$ rake api:run:dev
$ rake worker:run:dev (optional)
```

and then you can access Web API through `localhost:3030`

**Note: You may have to provide some TOKEN in `config/secrets.yml` .**
