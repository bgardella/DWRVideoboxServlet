package collabdrive.oauth;

import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import com.google.api.client.auth.oauth2.Credential;
import com.google.api.client.googleapis.auth.oauth2.GoogleAuthorizationCodeTokenRequest;
import com.google.api.client.googleapis.auth.oauth2.GoogleClientSecrets;
import com.google.api.client.googleapis.auth.oauth2.GoogleCredential;
import com.google.api.client.googleapis.auth.oauth2.GoogleTokenResponse;
import com.google.api.client.googleapis.json.GoogleJsonResponseException;
import com.google.api.client.http.HttpTransport;
import com.google.api.client.http.javanet.NetHttpTransport;
import com.google.api.client.json.JsonFactory;
import com.google.api.client.json.jackson.JacksonFactory;
import com.google.api.services.drive.Drive;
import com.google.api.services.drive.model.File;
import com.google.api.services.drive.model.FileList;



public class GoogleAuthService {

    protected final Log logger = LogFactory.getLog(getClass());
    
    protected static final HttpTransport TRANSPORT = new NetHttpTransport();
    protected static final JsonFactory JSON_FACTORY = new JacksonFactory();
    
    private GoogleClientSecrets clientSecrets;
    
    public GoogleAuthService(){
        if(this.clientSecrets == null){
            this.clientSecrets = getClientSecrets();
        }
    }
    
    
    public List<File> getRootFileList(Credential cred){
        Drive drive = new Drive.Builder(TRANSPORT, JSON_FACTORY, cred).setApplicationName("collabdrive").build();
        
        try {
            Drive.Files.List request = drive.files().list();
            request.setQ("title='SB1070 North East Pathways Collaborative'");
            
            List<com.google.api.services.drive.model.File> result = new ArrayList<com.google.api.services.drive.model.File>();
            
            FileList files = request.execute();
                  
            if(files.getItems().size() == 1){ //should be just the one
                String query = "'" + files.getItems().get(0).getId() + "' in parents";
                request.setQ(query);
                
                do {
                    try {
          
                      files = request.execute();
                      List<com.google.api.services.drive.model.File> fileList = files.getItems();
                      result.addAll(fileList);
                      request.setPageToken(files.getNextPageToken());
    
                    } catch (IOException e) {
                          logger.error("An error occurred: " + e);
                          request.setPageToken(null);
                    }
                    
                  } while (request.getPageToken() != null && request.getPageToken().length() > 0);
                    
                logger.info("////////////////////");
    
                return result;
            }        

        } catch (IOException e) {
            logger.error(e);
        }    
            
        return Collections.emptyList();
    }
    
    
    public List<File> getChildren(Credential cred, String id){
        Drive drive = new Drive.Builder(TRANSPORT, JSON_FACTORY, cred).setApplicationName("collabdrive").build();
    
        try {
            Drive.Files.List request = drive.files().list();
            request.setQ("'" +  id + "' in parents");
            
            List<com.google.api.services.drive.model.File> result = new ArrayList<com.google.api.services.drive.model.File>();
            
            FileList files;
            
            do {
                try {
      
                  files = request.execute();
                  List<com.google.api.services.drive.model.File> fileList = files.getItems();
                  result.addAll(fileList);
                  request.setPageToken(files.getNextPageToken());

                } catch (IOException e) {
                      logger.error("An error occurred: " + e);
                      request.setPageToken(null);
                }
              } while (request.getPageToken() != null && request.getPageToken().length() > 0);
              
            return result;
            
        } catch (IOException e) {
            logger.error(e);
        }
        
        return Collections.emptyList();
    }
    
    public Credential buildFakeFromToken(String token) throws GoogleJsonResponseException{
        Credential cred = buildEmpty();
        cred.setAccessToken(token);
        
        return cred;
    }
    
    
    public Credential retrieve(String code) {
        try {
          GoogleTokenResponse response = new GoogleAuthorizationCodeTokenRequest(
              TRANSPORT,
              JSON_FACTORY,
              clientSecrets.getWeb().getClientId(),
              clientSecrets.getWeb().getClientSecret(),
              code,
              clientSecrets.getWeb().getRedirectUris().get(0)).execute();
          
          logger.info("access token from response: " + response.getAccessToken());
          
          Credential cred = buildEmpty();
          cred.setAccessToken(response.getAccessToken());
          
          return cred;
          
        } catch (IOException e) {
            logger.error(e);
          throw new RuntimeException("An unknown problem occured while retrieving token");
        }
      }
    
    
    public Credential buildEmpty() {
        return new GoogleCredential.Builder()
            .setClientSecrets(getClientSecrets())
            .setTransport(TRANSPORT)
            .setJsonFactory(JSON_FACTORY)
            .build();
      }
    
    
    private GoogleClientSecrets getClientSecrets() {
        // TODO: do not read on each request
        InputStream stream = getClass().getClassLoader().getResourceAsStream("client_secrets.json");
        InputStreamReader reader = new InputStreamReader(stream);
        
        try {
          return GoogleClientSecrets.load(JSON_FACTORY, reader);
        } catch (IOException e) {
          throw new RuntimeException("No client_secrets.json found");
        }
      }
}
