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

As for the ruby version, shreds known to work with MRI (>= 1.9.3) and Rubinius (2.0). Shreds using native C binding for curl, so unfortunately, jRuby is out of question.

For development, I would recommend using `rvm` to manage your ruby installation, install rvm in your local home directory. As per the documentation:  

`~$ \curl -L https://get.rvm.io | bash -s stable --ruby=2.0`

Now you can `cd` to the repository and start with `bundle install`.

For production environment, just make sure you have sane and recent version of ruby available for your OS distribution, and then continue with the steps above.

Before starting the app, there are these few things which should get set up:  
First is, configuration:

- Under config directory, copy `application.yml.sample` to `application.yml`, then edit according to your need.

- Also copy `database.yml.sample` to `database.yml` and edit the file to adapt with your database configuration.

Then we have to setup the database, type `rake db:create` then `rake db:migrate` to do this.

Assuming there is no error now you can start the application, use `foreman start` to start the app. By default, shreds using `puma` as its server, this may be changed via both Gemfile and Procfile.

License
---
shreds. 2013. Nurahmadie <nurahmadie@gmail.com>.

Distributed under MIT/X11 license.

[![Code Climate](https://codeclimate.com/repos/5264df6513d6370dde145266/badges/f847fcab81d4d1ecfcdf/gpa.png)](https://codeclimate.com/repos/5264df6513d6370dde145266/feed)
