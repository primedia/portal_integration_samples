#Portal Integration

Portal integration provides a single sign-on solution along with a shared navigation header and other functionality that allows your application to integrated with either ApartmentGuide.com or Rent.com. There are several levels of integration 

##Table of Contents
1. [Portal header](#portal-header)
2. [OAuth2](#oauth2)
3. [Property selection](#property-selection)

---

<a name="portal-header"></a>
##Including the Portal header (Coming Soon)


This is the first and simplest integration method that will be **required** for all integration types. The Portal header serves three main purposes: displaying a user's context, providing navigation between other portalized applications, and simple javascript authorization<sup>[1](#1)</sup>. 
 
> [1] <a name="1"></a>*simple javascript authorization* - Do **not** rely on this authorization to protect sensitive information. This provides a simple javascript redirect back to Portal if a user is not signed in.


To get started you will need to set a few application specific settings and pull in the `header_widget.js` script:


````html
<script type=`text/javascript`>
  window._phq = window._phq || [];
  window._phq.push(["tab_id", "TAB_ID"]);

  var script = document.createElement("script");
  script.src = "https://PORTAL_URL/header_widget.js";
  script.async = true;
  var entry = document.getElementsByTagName("script")[0];
  entry.parentNode.insertBefore(script, entry);
</script>
````

###Requirements  
---
- **PORTAL_URL** will need to point to the expected environment: CI, QA, or Production.  
- **TAB_ID** is a Portal generated GUID that will be assigned to an application. This ID is used to "highlight" the current application's tab.  
- **JQuery** 1.7.2 or newer is required



<a name="oauth2"></a>
##OAuth2 (Coming Soon)

The OAuth2 integration is for applications that need to know the identity of the user. Applications will need to support a specific route (**TBD**) that will initiate the OAuth2 "dance" with Portal. During this process, Portal will redirect the user to a login page if no valid session is found. The result of a sucessful "dance" is the identity of the user and an access token. The access token will be used to make server-to-server API calls. Applications will need to create/maintain their own session for that user.

This integration differs from the typical OAuth2 implemention in that logouts will need to be global. To do this, Portal supplies an API that will need to be called on every request to verify the user has a valid Portal session. As an additional precaution Portal's header will trigger a javascript event `rentpath.header.portalUser` with the `id` and `email` address of the current user.


###Requirements  
---
- **OAuth2 Client/Consumer** 
- **API Consumer using access token**
  - GET `/api/session?apiver=v1` (Route name TBD)
- **Route for verifying user identity** 
- **Handling user logouts and mismatched identify**

<a name="property-selection"></a>
##Property selection (Coming Soon)

If an application does not want to take advantage of the property selector they can hide it with css and ignore any custom javascript events.

For applications that want to take advantage of a shared context between applications, they will need to use Portal's API to retrieve and update the current shared property context. The property selector will automatically be included in the header and the properties will be populated using the Portal endpoint `/api/properties`. 

When a user selects a new property from the dropdown, Portal will trigger the javascript event `rentpath.header.propertySelectorChanged` along with some information about the property that can be used for app specific business rules.

```json
//replace with example property information
{}
```

###Handling uncontracted properties
If the property in question requires a specific contract but does not have it, Portal provides a standardized template that can be utilized at `/contactsales`. The application will need to display this template instead of taking the user to the selected property. The template provides some basic instructions on how to contact our Sales department to purchase upgrades for a property.


###Requirements  
---
- **API Consumer using access token**
  - GET `/api/property?apiver=v1` (Route name TBD)
  - PUT `/api/property?id=:id&apiver=v1` (Route name TBD)
- **Handling unknown properties**
- **Handling uncontracted properties**
- **Subscribing to the `rentpath.header.propertySelectorChanged` event and routing accordingly**
