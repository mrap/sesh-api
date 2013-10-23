Sesh API V1
======================================================================

Returns JSON.  Requested references are returned in the `"response"` hash


Usage
======================================================================

Content Type: `application/json`

Body: `JSON`

API Requests:
----------------------------------------------------------------------
### URL format
    http://localhost:3000/:version/your-request-here

Example: Getting User `roland`  (version = 1):

    http://localhost:3000/1/users/roland


## Seshes

GET a sesh

    method:     GET
    url:        /seshes/[:id]
    body:       not required


Creating a new sesh

    method:     POST
    url:        /seshes/
    body:       { sesh:
                  {
                    title: TITLE
                    author_id: @user.id,
                    asset:
                      { audio: AUDIO_FILE }
                  }
                }
    requires:   author_id, asset['audio']

Updating a sesh (unable to update `author` or `audio`)

    method:     PUT
    url:        /seshes/[:id]
    body:       { sesh:
                  {
                    title: TITLE
                  }
                }

Deleting a sesh

TODO: should require token authentication to validate correct user

    method:     DELETE
    url:        /seshes/[:id]
    body:       not required