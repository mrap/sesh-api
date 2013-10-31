**Sesh API V1**
======================================================================
----------------------------------------------------------------------

Usage
=====

Content Type: `application/json`

Body: `JSON`

----------------------------------------------------------------------

API Requests
============
### URL format

    METHOD http://localhost:3000/api/:version/your-request-here

### Example Request: Creating a User `foo`  (version = 1):

URL

    POST http://localhost:3000/api/v1/users

Body

    {
      user:
        {
          username: "roland",
          email: "roland@example.com"
          password: "very-secure-password"
        }
    }

Response

    {
      auth_token: "4wYPA4d-ay6Vt8ah5sHz",
      info: {
        username: "roland"
      }
    }


* Note: The beginning `{` and ending `}` are implied in the following documentation for readability purposes.

Users
-----

#### Create a new user

URL

    POST /users

Body (requires `username`, `email`, `password`)

    user:
      {
        username: 'roland',
        email:    'roland@example.com',
        password: 'my-very-secure-password'
      }

Successful Response `status 201`

    auth_token: '4wYPA4d-ay6Vt8ah5sHz',
    info: {
      username: roland
    }

Unsuccessful Response `status 422`

#### GET a user (public ref/unauthenticated)

URL

    GET /users/:username
    GET /users/roland     # for this example

Successful Response `status 200`

    id: {
      $oid: "526f814fe3e9ef29ff000001"
    },
    info: {
      username: "roland"
    },
    seshes: [ NON-ANONYMOUS SESHES ] # see sesh for JSON structure

Unsuccessful Response `status 404`

#### GET a user (private/authorized)

Similar to GET user (unauthenticated) with these differences:

Body (requires `authentication_token` to access private user data and actions)

    auth_token: "4wYPA4d-ay6Vt8ah5sHz"

Successful Response `status 200`

    seshes: [ ALL SESHES ], # includes anonymous seshes
    favorites: [ ALL FAVORITED SESHES ]

Unsuccessful Response `status 200`

    Same response as unauthenticated

----------------------------------------------------------------------
## Auth Tokens

#### Fetch a fresh authentication_token for an existing user

By default, each user always has one (and only one) valid `authentication_token`.  The following methods are used to refresh and fetch a new token for existing users.

URL

    POST /tokens

Body (requires login `email` and `password`)

    login:
      {
        email: "roland@example.com",
        password: "my-very-secure-password"
      }

Successful Response `status 201`

    auth_token: "4wYPA4d-ay6Vt8ah5sHz" # a new authentication_token

----------------------------------------------------------------------

## Seshes

Any `post`, `put`, or `delete` requires a valid auth_token in the request body.
The `auth_token` must match the author's current `authentication_token`

#### GET a sesh

URL

    GET /seshes/:sesh_id
    GET /seshes/526f814fe3e9ef29ff000001 # for this example

Successful Response `status 200`

    id: {
        $oid: "526f814fe3e9ef29ff000001"
    },
    info: {
        title: "My Awesome Sesh"
        favorites_count: 5,
        listens_count: 50
    },
    assets: {
        audio_url: "http://s3-us-west-1.amazonaws.com/sesh-dev/seshes/audios/106f2838b7fcaa37693c804503b1a30a9080e5e5/original.mp3?1383039311"
    },
    author: {
        id: {
            $oid: "5268a45c3386b7b1ce000001"
        },
        username: "roland"
    }

`"author"` will not be exposed if the sesh is `anonymous`

#### Getting a list of seshes

URL

    GET /seshes

Body (optional `sort_options` array)

    sort: ["recent", "anonymous_only"]

#### Creating a new sesh

URL

    POST /seshes

Body (requires `auth_token`, `author_id`,  `asset['audio']`)

    auth_token: "4wYPA4d-ay6Vt8ah5sHz",
    sesh: {
        title: "Another Awesome Sesh",    # defaults to sesh.id
        author_id: "5268a45c3386b7b1ce000001",
        asset: {
              audio: AUDIO_FILE
          }
    }

Successful Response `status 201`

Unsuccessful Response `status 401 (if Unauthorized)` or `422 (Unprocessable Entity)`

#### Updating a sesh

URL

    PUT /seshes/:sesh_id

Body (`author` and `audio` cannot be updated)

    auth_token: "4wYPA4d-ay6Vt8ah5sHz",
    sesh: {
        title: "A New Sesh Title"
    }

#### Deleting a sesh

URL

    DELETE /seshes/:sesh_id

Body

    auth_token: "4wYPA4d-ay6Vt8ah5sHz"

#### Favoriting a sesh

URL

    PUT /seshes/:sesh_id/favorite

Body

    favoriter_authentication_token: AUTH_TOKEN_OF_USER_FAVORITING

Successful Response `status 201`

    # exposes the sesh like normal

#### Adding a `listen` to a sesh

URL

    PUT /seshes/:sesh_id/add_listener

Body

    listener_id: '5268a45c3386b7b1ce000001' # user that listens to a sesh

Successful Response `status 202`

    # exposes the sesh like normal
