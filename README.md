shreds
===

It's a news reader, written in Ruby on Rails.


installation
---

shreds stands on the shoulder of these giants:

- curl  
  `@ubuntu:~# apt-get install libcurl4-openssl-dev`

- postgresql  
  `@ubuntu:~# apt-get install postgresql postgresql-client libpq-dev`

- redis (>= 2.6)   
  `@ubuntu:~# add-apt-repository ppa:chris-lea/redis-server && apt-get update && apt-get install redis-server`

As for the ruby version, shreds known to work with MRI (>= 2.1). Shreds may work with rubinius but haven't really tested. And since [feedjira](https://github.com/feedjira/feedjira) is currently using _curb_, a native C binding for curl in ruby, using shreds with jRuby is probably impossible.

For development or just hacking around shreds, I would recommend using `rvm` to manage your ruby installation, install rvm in your local home directory. As per the [documentation](http://rvm.io/):  

```
~$ gpg --keyserver hkp://keys.gnupg.net --recv-keys D39DC0E3
~$ \curl -L https://get.rvm.io | bash -s stable --ruby=2.1.5
```

Now you can `cd` to the repository and start with `bundle install`.

For production environment, just make sure you have sane and recent version of ruby available for your OS distribution and all dependencies above.

Before starting the app, there are these few things which should get set up:  
First is configuration:

- Setting environment variables in application.yml [figaro](https://github.com/laserlemon/figaro). Under config directory, copy `application.yml.sample` to `application.yml`, then edit according to your need.

- Also copy `database.yml.sample` to `database.yml` and edit the file to adapt with your database configuration.

- Bower to manage Rails app assets [bower](http://bower.io/). `bower install`

Second is the database, to setup, type `rake db:create` then `rake db:migrate`.

And the last, assuming there is no error, start the application with `foreman start`. By default, shreds using `puma` as its server, this may be changed via both Gemfile and Procfile.

License
---bo
shreds. 2013-2014. Nurahmadie <nurahmadie@gmail.com>.

Distributed under MIT/X11 license.

[![Code Climate](https://codeclimate.com/github/fudanchii/shreds/badges/gpa.svg)](https://codeclimate.com/github/fudanchii/shreds)
