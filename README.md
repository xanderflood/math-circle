# lotto-ticket

A class scheduling and registration platform. Built on Rails 5, and relies on Postgres as currently written. It was originally created for Emory University's Math-Circle program, a K-12 after school math enrichment program run by graduate students in the Department of Math and CS.

## Postgres setup

On Debian systems, you can install Postgres before bundling by executing:

    $ apt-get install postgres libpg-dev
    $ bundle install

There are many ways to set up postgres for your dev environement, but here's a brief outline of how I do it.

First, change the authentication mode for the postgres role corresponding to the Linux user who will be running your application:

    xflood$ sudo su - postgres;
    postgres$ createuser --superuser xflood
    postgres$ exit
    xflood$ vim /etc/postgresql/9.5/main/pg_hba.conf

Scroll to the bottom of this file, and below the line

    local   all             postgres                                ident 

add

    local   all             xflood                                  trust

Restart postgres:

    sudo systemctl restart postgresql

on systems using `systemd`, such as newer versions of Ubuntu, or

    sudo restart postgresql

if you're using `upstart`.

Now check that your application user is able to execute the following without using `sudo`:

    psql --dbname=postgres

If this works, then you should be able to run

    rake db:create db:setup

to finish the process.

For beginners, be warned that this setup is not secure, and shouldn't be used in a production environment. The app is designed to be easily deployed to a Heroku server, so while you can use the postgresql role corresponding your linux user, you can also override this by setting the environment variables `PG_USERNAME` and `PG_PASSWORD`. The cleanest way to do this is to create a file called `config/db.env` (which is `.gitignore`d by this repository) and place in it:

    export PG_USERNAME=my_postgres_user
    export PG_PASSWORD=secure_password

and then start the server using:

    source config/db.env && bundle exec rails server

I keep this aliased for ease of use.

## Using the application 

Then you'll want to create a "teacher" account, which is the administrative role for the application:

    $ bundle exec rails console
    Running via Spring preloader in process 4724
    Loading development environment (Rails 5.0.3)
    2.3.1 :001 > Teacher.create!(email: "me@myisite.com", password: "password")

Visit `http://localhost:3000/` and log in using these credentials. From the teacher portal, you can manage the following information:

- Semesters: are the most fundamental grouping. A semester has a lifecycle that teachers can manage from this portal. When first created, a semester is hidden from users until the teacher opens registration. Then, the teacher can close the registration process and initiate the lottery to make class assignements. The lottery results can be re-viewed and re-run before committing to them, but at this time it is not possible to edit them directly. Only one semester at a time can be marked "active," meaning that it is visible to parents.
- Sections: are individual classes with a particular student roster. When creating a section, you specify a weekday and time, but the individual meetings can then be managed separately, and irregular meetings are not an issue.
- Courses: group together sections that cover the same content.
- Parents/students: are the other users. Teachers can view and manage these, but new ones can only be created from the parent portal.

As currently implemented, there is not accessible teacher registration page. The parent registration page is publically accessible, and after creating an account, parents can:

- Add and manage multiple students, including emergency contacts, registration info, and special needs.
- For each student, when a semester is marked active, the parent can select one course and submit their lottery preferences, a ranked list of that course's sections.
