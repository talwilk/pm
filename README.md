## Setup

Copy `application.yml.example` to `application.yml` into config folder and setup your settings.

Run:

```sh
bundle
```

to install necessary gems.

To create database and migrate it, run following commands:

```sh
rake db:create
rake db:migrate
```

## Seeds

```ruby
rake db:seed
```

#### Super admin login
[http://localhost:3000/super_admin](http://localhost:3000/super_admin)

`superadmin@example.com`

`password`

#### User login
[http://localhost:3000/users/sign_in](http://localhost:3000/users/sign_in)

`user@example.com`

`password`


#### Guru login
[http://localhost:3000/users/sign_in](http://localhost:3000/users/sign_in)

`guru@example.com`

`password`


## Tests

To run all tests you need to install [PhantomJS](http://phantomjs.org/) library. After that run:

```sh
rspec
```

## Images upload:

If AWS_S3_ROOT_FOLDER credential is set, files are stored into this folder on S3, 
otherwise, if it is empty, they are put into local uploads.

## Translating

To have attributes to be translated run following command and then put generated files into locale folder

```sh
rake gettext:store_model_attributes
```

To have new translation keys in locale files run

```sh
rake gettext:find
``
