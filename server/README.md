## Digdag server

Running a digdag server means that directories can be packaged and submitted
to it. Once submitted it runs the dags specified in any of the top-level
.dig folders. We the following:

- TODO.dig

But before you submit these, you need to set up the server.

The server should not run any python code and instead should only care for the scheduling and the code should be run in another piece of infrastructure.

However, because the workload is so small this should not be a problem, and having one less piece of infrastructure will make things easier and simpler.

## Running the server

### Setting up auth

The first thing you need to do is set up a username / password. We are going
old-school for this one both in production and in dev. We will do this by
creating a `nginx/.htaccess` file and adding a single user to it:

```bash
htpasswd -b -c nginx/.htpasswd admin admin
```

Now the file should be created. NEVER check one of these into the repo!
Especially production ones!

To add another user, you just omit the `-c` from the previous command
so you don't overwrite the password file.

I know this is really not ideal right now but there just does not seem to be
trivial auth option for digdag. This will certainly need fixing in the future.

### Changing the password

If you want to change the password for one of the digdag servers:

* ssh into the digdag server
* go to the `/opt/app/server` folder
* run `sudo htpasswd -b -c nginx/.htpasswd admin <YOUR_PASSWORD>`
* restart docker with `sudo make dc-start`
* your all done!

### Running the server

You should now be able to run

```bash
docker-compose up
```

and see everything come to
life! You will then be able to visit your browser on http://localhost:9090
and see your digdag interfece.

## Submitting projects

So if you submit the `ingestion` directory, you should see those two in
the web interface when you log in.

```bash
# if you are starting from this directory:

cd ../ingestion

digdag push tracking-ingestion-dev \
  -r "$(date +%Y-%m-%dT%H:%M:%S%z)" \
  --basic-auth admin:admin \
  -e 'http://localhost:9090/'

```

This snippet does a few things:

1. Puts us in the directory we want to be in
1. Pushes the current directory to the digdag server running on my machine
1. Authenticates using the basic-auth username / pass from earlier
1. Specifies the domain / port of where the server is running.

## Prod

Still stuff to do here. Namely:

- letsencrypt
- more?


