## Portal v1 API calls 
---
These calls are meant to be used server to server because you don't want to expose your token. 
You can use any GET route client side at your own discretion. 
If you do use the endpoints client-side (ajax) you can set `withcredentials` to true with some of the endpoints.
This will allow them to verify identity through cookies/sessions. 
The API will still always check for a token first, before checking for cookies/sessions. 

###Updating Property Context
API endpoint used to update the current property context for an user.

| Parameter     | Required?     | Type      | Notes|
|:-------------:|:-------------:|:-----:    |:----:|
|token          |&#x2714;       |String     |                                                               |
|id             |&#x2714;       |Integer    |                                                               |
|apiver         |               |String     |By default, the first matching version is used if not specified|

Respone codes

    200 - The property context was updated for an user
    400 - Missing Token,  Missing ID, The property context was not updated for an user

Example Call

    curl -X PUT "http://portal.local.apartmentguide.com/api/property" -d "token=fuu7px8y96n60bkav7bct563roglye5&apiver=v1&id=1337"

Example Response

```json
{
    "property_name": "San Melia",
    "property_id": 1337
}
```

###Get current session with context
API endpoint used to get current session context

| Parameter     | Required?     | Type      | Notes|
|:-------------:|:-------------:|:-----:    |:----:|
|token          |&#x2714;       |String     |                                                               |
|apiver         |               |String     |By default, the first matching version is used if not specified|

Note: If this call is made client-side and token is not found, it will try to verify through cookie/session (must set withcredentials)

Respone codes

    200 - Session context returned
    400 - Bad Request, Missing Token
    460 - Invalid token or expired token
    
Example call 

    curl "http://portal.local.apartmentguide.com/api/session?token=fuu7px8y96n60bkav7bct563roglye5&apiver=v1"

Example response

```json
{
    "email": "example@example.com",
    "id": "302609",
    "property_name": "San Melia",
    "property_id": 1337
}
```

###Get a list of properties
API endpoint used to get a list of properties (with details) for a user

| Parameter     | Required?     | Type  | Notes|
|:-------------:|:-------------:|:-----:|:----:|
|token          |&#x2714;       |String |                                                               |
|apiver         |               |String |By default, the first matching version is used if not specified|

Note: If this call is made clientsite and token is not found, it will try to verify through cookie/session (must set withcredentials)

Respone codes

    200 - The property context was updated for an user
    400 - Bad Request, Missing Token
    460 - Invalid token or expired token
    
Example call 

    curl "http://portal.local.apartmentguide.com/api/properties?token=34o8fjhfdkdfh&apiver=v1"

Example Response (call from above)

```json
{
    "total": 10,
    "properties": [
        {
            "id": "All",
            "text": "All",
            "city": "",
            "state": ""
        },
        {
            "id": 78360,
            "text": " Alvista at Laguna Bay",
            "city": "Naples",
            "state": "FL"
        },
        {
            "id": 39186,
            "text": " ARIUM Bala Sands",
            "city": "Orlando",
            "state": "FL"
        }, 
        .....
    ]
}

```

###Retrieve contract information for a property
API endpoint used to retrieve contract information for a property

| Parameter     | Required?     | Type      | Notes|
|:-------------:|:-------------:|:-----:    |:----:|
|token          |&#x2714;       |String     |                                                               |
|id             |&#x2714;       |Integer    |                                                               |
|apiver         |               |String     |By default, the first matching version is used if not specified|

Note: If this call is made clientsite and token is not found, it will try to verify through cookie/session (must set withcredentials)

Respone codes

    200 - Contract information for a property was returned
    400 - Bad request, Missing Token, Missing ID
    460 - Invalid token or expired token

Example Call

    curl "http://portal.local.apartmentguide.com/api/property?token=ogk287dswcjztbdcd64k1ddb4o&apiver=v1&id=12345"

Example Response

```json
{
    "has_repmon": 0,
    "has_media_center": 1
}
```

 Note: Both will return null if property id doesnt belong to a property
