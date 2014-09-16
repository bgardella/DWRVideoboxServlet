package collabdrive.oauth;

import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.util.Arrays;
import java.util.List;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import com.google.api.client.auth.oauth2.Credential;
import com.google.api.client.googleapis.auth.oauth2.GoogleAuthorizationCodeFlow;
import com.google.api.client.googleapis.auth.oauth2.GoogleAuthorizationCodeRequestUrl;
import com.google.api.client.googleapis.auth.oauth2.GoogleAuthorizationCodeTokenRequest;
import com.google.api.client.googleapis.auth.oauth2.GoogleClientSecrets;
import com.google.api.client.googleapis.auth.oauth2.GoogleTokenResponse;
import com.google.api.client.http.HttpTransport;
import com.google.api.client.http.javanet.NetHttpTransport;
import com.google.api.client.json.jackson.JacksonFactory;
import com.google.api.services.oauth2.Oauth2;
import com.google.api.services.oauth2.model.Userinfoplus;

public class AuthorizationService {

    protected final Log logger = LogFactory.getLog(getClass());
    
    
    private static final String REDIRECT_URI = "http://localhost:8080/collabdrive/oauth2callback";
    
    private static final List<String> SCOPES = Arrays.asList(
        "https://www.googleapis.com/auth/drive.file",
        "https://www.googleapis.com/auth/userinfo.email",
        "https://www.googleapis.com/auth/userinfo.profile");
    
    
    //START HERE
    
    public Credential exchangeCode(String authorizationCode) throws CodeExchangeException {
        
            logger.info(REDIRECT_URI);
            
            try {
                //String encoded = URLEncoder.encode(REDIRECT_URI, "UTF-8");
                //logger.info(encoded);
                
                GoogleAuthorizationCodeFlow flow = getFlow();
                
                GoogleAuthorizationCodeTokenRequest req = flow.newTokenRequest(authorizationCode);
                req.setRedirectUri(REDIRECT_URI);
                
                GoogleTokenResponse response = req.execute();
                
                return flow.createAndStoreCredential(response, null);
            }catch (IOException e) {
                logger.error("code exchange fail", e);
                  //System.err.println("An error occurred: " + e);
                throw new CodeExchangeException(null);
            }
    }    
    
    
    private GoogleAuthorizationCodeFlow getFlow() throws IOException {
        
          HttpTransport httpTransport = new NetHttpTransport();
          JacksonFactory jsonFactory = new JacksonFactory();
          
          InputStream inputStream = getClass().getClassLoader().getResourceAsStream("client_secrets.json");
          InputStreamReader reader = new InputStreamReader(inputStream);
          
          GoogleClientSecrets clientSecrets = GoogleClientSecrets.load(jsonFactory, reader);
          GoogleAuthorizationCodeFlow flow =
              new GoogleAuthorizationCodeFlow.Builder(httpTransport, jsonFactory, clientSecrets, SCOPES)
                  .setAccessType("offline").setApprovalPrompt("force").build();
        
          return flow;
    }

    

    
    
    /**
     * Retrieve credentials using the provided authorization code.
     *
     * This function exchanges the authorization code for an access token and
     * queries the UserInfo API to retrieve the user's e-mail address. If a
     * refresh token has been retrieved along with an access token, it is stored
     * in the application database using the user's e-mail address as key. If no
     * refresh token has been retrieved, the function checks in the application
     * database for one and returns it if found or throws a NoRefreshTokenException
     * with the authorization URL to redirect the user to.
     *
     * @param authorizationCode Authorization code to use to retrieve an access
     *        token.
     * @param state State to set to the authorization URL in case of error.
     * @return OAuth 2.0 credentials instance containing an access and refresh
     *         token.
     * @throws NoRefreshTokenException No refresh token could be retrieved from
     *         the available sources.
     * @throws IOException Unable to load client_secrets.json.
     */
    public Credential getCredentials(String authorizationCode, String state) throws CodeExchangeException, NoRefreshTokenException, IOException {
      String emailAddress = "";
      try {
        Credential credentials = exchangeCode(authorizationCode);
        Userinfoplus userInfo = getUserInfo(credentials);
        String userId = userInfo.getId();
        emailAddress = userInfo.getEmail();
        if (credentials.getRefreshToken() != null) {
          storeCredentials(userId, credentials);
          return credentials;
        } else {
          credentials = getStoredCredentials(userId);
          if (credentials != null && credentials.getRefreshToken() != null) {
            return credentials;
          }
        }
      } catch (CodeExchangeException e) {
        e.printStackTrace();
        // Drive apps should try to retrieve the user and credentials for the current
        // session.
        // If none is available, redirect the user to the authorization URL.
        e.setAuthorizationUrl(getAuthorizationUrl(emailAddress, state));
        throw e;
      } catch (NoUserIdException e) {
        e.printStackTrace();
      }
      // No refresh token has been retrieved.
      String authorizationUrl = getAuthorizationUrl(emailAddress, state);
      throw new NoRefreshTokenException(authorizationUrl);
    }
    
    
    Userinfoplus getUserInfo(Credential credentials) throws NoUserIdException {
        Oauth2 userInfoService = new Oauth2.Builder(new NetHttpTransport(), new JacksonFactory(), credentials).build();
        Userinfoplus userInfo = null;
        try {
            userInfo = userInfoService.userinfo().get().execute();
        } catch (IOException e) {
            System.err.println("An error occurred: " + e);
        }
        if (userInfo != null && userInfo.getId() != null) {
            return userInfo;
        } else {
            throw new NoUserIdException();
        }
    }

    void storeCredentials(String userId, Credential credentials) {
        // TODO: Implement this method to work with your database.
        // Store the credentials.getAccessToken() and credentials.getRefreshToken()
        // string values in your database.
        throw new UnsupportedOperationException();
    }
    
    Credential getStoredCredentials(String userId) {
        // TODO: Implement this method to work with your database. Instantiate a new
        // Credential instance with stored accessToken and refreshToken.
        throw new UnsupportedOperationException();
    }
    
    /**
     * Retrieve the authorization URL.
     *
     * @param emailAddress User's e-mail address.
     * @param state State for the authorization URL.
     * @return Authorization URL to redirect the user to.
     * @throws IOException Unable to load client_secrets.json.
     */
    public String getAuthorizationUrl(String emailAddress, String state) throws IOException {
      GoogleAuthorizationCodeRequestUrl urlBuilder = getFlow().newAuthorizationUrl().setRedirectUri(REDIRECT_URI).setState(state);
      urlBuilder.set("user_id", emailAddress);
      return urlBuilder.build();
    }
    
    
    ///////////////////////////////
    ///////////////////////////////
    ///////////////////////////////
    
    class NoUserIdException extends Exception {
    }
    
    class GetCredentialsException extends Exception {

        protected String authorizationUrl;

        /**
         * Construct a GetCredentialsException.
         *
         * @param authorizationUrl The authorization URL to redirect the user to.
         */
        public GetCredentialsException(String authorizationUrl) {
          this.authorizationUrl = authorizationUrl;
        }

        /**
         * Set the authorization URL.
         */
        public void setAuthorizationUrl(String authorizationUrl) {
          this.authorizationUrl = authorizationUrl;
        }

        /**
         * @return the authorizationUrl
         */
        public String getAuthorizationUrl() {
          return authorizationUrl;
        }
    }
    
    public class CodeExchangeException extends GetCredentialsException {

        /**
         * Construct a CodeExchangeException.
         *
         * @param authorizationUrl The authorization URL to redirect the user to.
         */
        public CodeExchangeException(String authorizationUrl) {
          super(authorizationUrl);
        }
    }
    
    class NoRefreshTokenException extends GetCredentialsException {

        /**
         * Construct a NoRefreshTokenException.
         *
         * @param authorizationUrl The authorization URL to redirect the user to.
         */
        public NoRefreshTokenException(String authorizationUrl) {
          super(authorizationUrl);
        }

      }
}
