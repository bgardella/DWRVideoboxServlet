<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>


<html>
		<jsp:include page="partial/head.jsp" flush="true">
		    <jsp:param name="pageTitle" value="CollabDrive"/>
		</jsp:include>
  
  <body>
    <div class="message" >To login:  collabdrive2@gmail.com / asdf5678</div>
    
    <div id="gSignInWrapper">
		  <div id="myButton" class="classesToStyleWith">
		    Sign in with Google
		  </div>
		</div>
    
    
    <form id="auth-form" method="POST">
        <%--<input type="text" name="code" id="code"/> --%>
        <input type="hidden" name="token" id="token"/>
    </form>
    
<script type="text/javascript">


    var CLIENT_ID = '495034446548-8t26r3rfsed5vmhodmjl75vmhulvbe4r.apps.googleusercontent.com';
    var SCOPES = [
        'https://www.googleapis.com/auth/drive',
        'https://www.googleapis.com/auth/drive.file',
        'https://www.googleapis.com/auth/drive.readonly',
        'https://www.googleapis.com/auth/drive.appdata',
        'https://www.googleapis.com/auth/drive.apps.readonly',
        'https://www.googleapis.com/auth/drive.metadata.readonly',
        'https://www.googleapis.com/auth/drive.readonly',
        
        'https://www.googleapis.com/auth/userinfo.email',
        'https://www.googleapis.com/auth/userinfo.profile',
        // Add other scopes needed by your application.
      ];

    /**
     * Called when the client library is loaded.
     */
    function handleClientLoad() {
      checkAuth();
    }

    /**
     * Check if the current user has authorized the application.
     */
    function checkAuth() {
      gapi.auth.authorize(
          {'client_id': CLIENT_ID, 'scope': SCOPES.join(' '), 'immediate': true},// 'response_type': 'code',  },
          handleAuthResult);
    }

    /**
     * Called when authorization server replies.
     *
     * @param {Object} authResult Authorization result.
     */
    function handleAuthResult(authResult) {
      if (authResult && authResult.error) {
          // No access token could be retrieved, force the authorization flow.
          //gapi.auth.authorize(
          //    {'client_id': CLIENT_ID, 'scope': SCOPES, 'immediate': false},// 'access_type': 'offline'},
          //    handleAuthResult);
          renderButton();
      } else {
        
          //authResult.access_token
          //authResult.expires_at
          //authResult.issued_at
            
          console.log("looks to be authorized.");
          // Access token has been successfully retrieved, requests can be sent to the API
          
          //var code = escape(authResult.code);
          //console.log(code);
          var token = escape(authResult.access_token);
          console.log(token);
          
          $('#auth-form').attr('action', '${oauthMountPoint}');
          $('#token').val(token);
          //$('#code').val(code);
          $('#auth-form').submit();
      }
    }
    
    
    function renderButton() {

    	  // Additional params
    	  var additionalParams = {
    	    'theme' : 'dark'
    	  };

    	  gapi.signin.render('myButton', additionalParams);
    	}
    
    
    
    
$(window).load( function(){    
    
	 checkAuth();
	
});
</script>	
	
  </body>
</html>