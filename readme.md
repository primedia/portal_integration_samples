Portal Integration
---

Portal integration provides a navigation header and other functionality that allows your application to integrated with either ApartmentGuide.com or Rent.com. There are several levels of integration with Portal:

1. [Portal header](#including-the-portal-header)
2. OAuth2
3. Property selection


###Including the Portal header
---

This is the first and simplest integration method that will be **required** for all integration types. The Portal header serves three main purposes: displaying a user's context, providing navigation between other portalized applications, and simple javascript authorization<sup>[1](#simple-javascript-authorization)</sup>.

To get started you will need to pull in a script, `header_widget.js`, from Portal.
Include the following snippet in your layout:

```html
<script type="text/javascript">
    var script = document.createElement('script');
    script.src = "https://PORTAL_URL/header_widget.js";
    script.async = true;
    var entry = document.getElementsByTagName('script')[0];
    entry.parentNode.insertBefore(script, entry);
    $('body').prepend("<span id='tab_highlight_id' data-tab_id='TAB_ID'></span>");
</script>
```

or simply

```html
<script type="text/javascript" src="https://PORTAL_URL/header_widget.js"></script>
<span id='tab_highlight_id' data-tab_id='TAB_ID'></span>
```

> **PORTAL_URL** will need to point to the expected environment: CI, QA, or Production.  
> **TAB_ID** is a Portal generated GUID that will be assigned to an application. This ID is used to "highlight" the current application's tab.
> **JQuery** 1.7.2 or newer is required

<a name="simple-javascript-authorization"></a>*simple javascript authorization* - Do **not** rely on this authorization to protect sensitive information. This provides a simple javascript redirect back to Portal if a user is not signed in.




### OAuth2
---

Coming soon

### Property selection
---

Coming soon