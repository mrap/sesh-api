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

    METHOD http://localhost:3000/:version/your-request-here

### Example Request: Creating a User `foo`  (version = 1):

URL

    POST http://localhost:3000/1/users

Body

    {
      user:
        {
          username: 'foo',
          email: 'foo@example.com'
          password: 'very-secure-password'
        }
    }

Response

    {
      authentication_token: '4wYPA4d-ay6Vt8ah5sHz'
    }



### **NOTE:** `Body` and `Response` are hashes
The beginning `{` and ending `}` are implied in the following documentation for readability purposes.

Users
-----

#### New User Sign Up

URL

    POST /users

Body (requires `username` `email` `password`)

    user:
      {
        username: 'USERNAME',
        email:    'EMAIL@DOMAIN.COM',
        password: 'PASSWORD'
      }

Response

    authentication_token: NEW_AUTH_TOKEN  # save it!

#### GET a user (public/unauthorized)

URL

    GET /users/:username

Response

    info:
      {
        username: 'USERNAME'
      },
    seshes: [ SESH_ID, SESH_ID ] # only non-anonymous sesh ids

#### GET a user (private/authorized)

URL

    GET /users/:username

Body (requires `authentication_token` to access private user data and actions)

    authentication_token: USER_AUTH_TOKEN

Response

    info:
      {
        username: 'USERNAME'
      },
    seshes: [ SESH_ID, SESH_ID ] # all sesh ids, includes anonymous seshes

----------------------------------------------------------------------
## Auth Tokens

#### Create new token for existing user

URL

    POST /tokens

Body (requires `login['email']` and `login['password']`)

    login:
      {
        email: "foo@example.com",
        password: "a-very-secure-password"
      }

----------------------------------------------------------------------

## Seshes

#### GET a sesh

URL

    GET /seshes/:sesh_id

`"author_id"` will not be returned if sesh.is_anonymous

#### Creating a new sesh

URL

    POST /seshes

Body (requires `author_id` and  `asset['audio']`)

    sesh:
      {
        title: 'TITLE',       # defaults to sesh.id
        author_id: @user.id,
        asset:
          {
            audio: AUDIO_FILE
          }
      }

#### Updating a sesh

URL

    PUT /seshes/:sesh_id

Body (`author` and `audio` cannot be updated)

    sesh:
      {
        title: 'TITLE'
      }

#### Deleting a sesh

TODO: should require token authentication to validate correct user

URL

    DELETE /seshes/:id

#### Favoriting a sesh

URL

    PUT /seshes/:id/favorite

Body

    favoriter_authentication_token: AUTH_TOKEN_OF_USER_FAVORITING

Response

    # same as seshes#show
