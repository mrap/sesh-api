**Sesh API V1**
======================================================================
----------------------------------------------------------------------

Usage
=====

Content Type: `application/json`

Body: `JSON`

Returns JSON.  Requested references are returned in the `"response"` hash

----------------------------------------------------------------------

API Requests
============
### URL format
    http://localhost:3000/:version/your-request-here

Example: Getting User `roland`  (version = 1):

    http://localhost:3000/1/users/roland

Users
-----

#### GET a user

    method:     GET
    url:        /users/:username
    body:       not required

    expected response:
    {
      info:
        {
          username: 'USERNAME'
        },
      seshes: [ SESH_ID, SESH_ID ] # only non-anonymous sesh ids
    }

#### New User Sign Up

Requires: `username`, `email`, `password`

    method:     POST
    url:        /users
    body:       { user:
                    {
                      username: 'USERNAME',
                      email:    'EMAIL@DOMAIN.COM',
                      password: 'PASSWORD'
                    }
                }


----------------------------------------------------------------------
## Auth Tokens

#### Create new token for user with email: `user@example.com` and password `PASSWORD`

    method:     POST
    url:        /tokens
    body:       Requires: 'email' and 'password'
                {
                  login:
                    {
                      email: "user@example.com",
                      password: "PASSWORD"
                    }
                }


----------------------------------------------------------------------
## Seshes

#### GET a sesh

`"author_id"` will not be returned if sesh.is_anonymous

    method:     GET
    url:        /seshes/[:id]
    body:       not required


#### Creating a new sesh

Requires: `author_id`, `asset['audio']`

    method:     POST
    url:        /seshes
    body:       { sesh:
                  {
                    title: 'TITLE'
                    author_id: @user.id,
                    asset:
                      { audio: AUDIO_FILE }
                  }
                }

#### Updating a sesh (unable to update `author` or `audio`)

    method:     PUT
    url:        /seshes/[:id]
    body:       { sesh:
                  {
                    title: 'TITLE'
                  }
                }

#### Deleting a sesh

TODO: should require token authentication to validate correct user

    method:     DELETE
    url:        /seshes/[:id]
    body:       not required
