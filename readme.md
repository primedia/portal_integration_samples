#Portal Integration

Portal integration provides a single sign-on solution along with a shared navigation header and other functionality that allows your application to integrated with either ApartmentGuide.com or Rent.com. There are several levels of integration 

##Table of Contents
1. [Portal header](#portal-header)
2. [OAuth2](#oauth2)
3. [Property selection](#property-selection)

---

<a name="portal-header"></a>
##Including the Portal header


This is the first and simplest integration method that will be **required** for all integration types. The Portal header serves three main purposes: displaying a user's context, providing navigation between other portalized applications, and simple javascript authorization<sup>[1](#1)</sup>. 
 
> [1] <a name="1"></a>*simple javascript authorization* - Do **not** rely on this authorization to protect sensitive information. This provides a simple javascript redirect back to Portal if a user is not signed in.


To get started you will need to set a few application specific settings and pull in the `header_widget.js` script:


````html
<script type="text/javascript">
  window.portalSettings = window.portalSettings || [];
  window.portalSettings.push(["set", "tab_id", "TAB_ID"]);

  var script = document.createElement("script");
  script.src = "https://PORTAL_URL/header_widget.js";
  script.async = true;
  var entry = document.getElementsByTagName("script")[0];
  entry.parentNode.insertBefore(script, entry);
</script>
````

Since the header is pulled in from an external source, there will be a slight delay resulting in a "pop" when the header loads.
To reduce this effect, you can create a div with an id of `rp_header_wrapper` and a fixed height.
The header will inject the html in this div if it exists.

```html
<div id="rp_header_wrapper" style="height:50px;"></div>
```

###Requirements  
---
- **PORTAL_URL** will need to point to the expected environment: CI, QA, or Production.  
- **TAB_ID** is a Portal generated GUID that will be assigned to an application when a Pretty Square is created.
This ID is used to "highlight" the current application's tab.  
- **JQuery** 1.7.2 or newer is required



<a name="oauth2"></a>
##OAuth2

The OAuth2 integration is for applications that need to know the identity of the user or contract data about for a specific property.
To get started, applications will need a company and client registered with Portal.
Please supply your contact with the OAuth2 callback URLs (must be https) for each environment which will allow us
to create a client and give you a `client_id` and `secret` that will be used in the OAuth2 "dance".

An example client implementation can be found under the `client` directory.
During this "dance", Portal will redirect the user to a login page if no valid session is found.
The result of a sucessful "dance" is the identity of the user and an access token.
The access token will be used to make server-to-server [API calls](Portal_API.md).
Applications will need to create/maintain their own session for that user. Also attached to each access token is its time-until-expiration and a refresh token. An old or expired access token can be exchanged for a new one by sending the refresh token to Portal. The OAuth2 gem provides [a convenient method](https://github.com/intridea/oauth2/blob/master/lib/oauth2/access_token.rb#L80) for making this request.

This integration differs from the typical OAuth2 implemention in that logouts will need to be global.
To do this, Portal supplies an [API](Portal_API.md) that will need to be called on every request to verify the user has a valid Portal session.
As an additional precaution Portal's header will trigger a javascript event
`rentpath.header.portalUser` with the `id` and `email` address of the current user.


###Requirements  
---
- **OAuth2 Client/Consumer** 
- **API Consumer using access token**
  - GET `/api/session?apiver=v1`
- **Route for verifying user identity** 
- **Handling user logouts and mismatched identify**

<a name="property-selection"></a>
##Property selection

By default the property selector is loaded along side the Portal header, but is hidden with css.
To display the selector, you can add the following css to the needed pages:

```css
#portal_property_selector {
  display:block !important;
}
```

For applications that want to take advantage of a shared context between applications,
they will need to use Portal's [API](Portal_API.md) to retrieve and update the current shared property context.
The property selector will automatically be included in the header and the properties will be populated using the Portal endpoint `/api/properties`. 

When a user selects a new property from the dropdown,
Portal will trigger the javascript event `rentpath.header.propertySelectorChanged`
along with JSON about the property that can be used for app specific business rules.
Contract data is included in this JSON in the form of "has_contract_name".
The value of each contract can be respresented with either a 0 (inactive), 1 (active), or null (property not found).

```json
{
  "id": 12345,
  "city": "Atlanta",
  "state": "GA",
  "text": "Property Name",
  "has_media_center": 0,
  "has_repmon": 1
}
```

###Handling uncontracted properties
If the property in question requires a specific contract but does not have it, Portal provides a standardized template that can be utilized at `/contactsales`. The application will need to display this template instead of taking the user to the selected property. The template provides some basic instructions on how to contact our Sales department to purchase upgrades for a property.


###Requirements  
---
- **API Consumer using access token**
  - GET `/api/session?apiver=v1`
  - PUT `/api/property?id=:id&apiver=v1`
- **Handling unknown properties**
- **Handling uncontracted properties**
- **Subscribing to the `rentpath.header.propertySelectorChanged` event and routing accordingly**
