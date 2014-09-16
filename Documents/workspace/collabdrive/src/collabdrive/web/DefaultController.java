package collabdrive.web;

import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import collabdrive.oauth.GoogleAuthService;

import com.google.api.client.auth.oauth2.Credential;
import com.google.api.client.googleapis.json.GoogleJsonResponseException;
import com.google.api.services.drive.model.File;


@Controller
public class DefaultController extends AbstractController{

    protected final Log logger = LogFactory.getLog(getClass());
    
    @Autowired
    //AuthorizationService authorizationService;
    GoogleAuthService googleAuthService;
    
    
    
    @RequestMapping(value="/", method=RequestMethod.GET)
    public String root( Model model, HttpServletRequest req ){
        setFrontEndVariables(model, req);
        return "home";
    }
    
    /*
    @RequestMapping(value="/auth/code", method=RequestMethod.POST)
    public String auth( @RequestParam("code") String code, Model model ){
      
        logger.info("auth code: [" + code + "]");
        
        //try {
            //Credential cred = authorizationService.exchangeCode(code);
            
            Credential cred = googleAuthService.retrieve(code);
            
            googleAuthService.testDriveCall(cred);
            
            
            
            model.addAttribute("token", cred.getAccessToken());
            
        //} catch (CodeExchangeException e) {
            // TODO Auto-generated catch block
        //    e.printStackTrace();
        //}
        
        return "auth";
        
    }*/

    @RequestMapping(value="/auth/token", method=RequestMethod.POST)
    public String authToken( @RequestParam("token") String token, Model model, HttpServletRequest req ){
      
        setFrontEndVariables(model, req);
        model.addAttribute("token", token);
        
        try{
            Credential cred = googleAuthService.buildFakeFromToken(token);
            
            List<File> rootList = googleAuthService.getRootFileList(cred);
            
            model.addAttribute("rootList", rootList);
            
            return "auth";

        } catch (GoogleJsonResponseException e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
        }
        
        return "redirect:/";

    }
    
    @RequestMapping(value="/folder/id", method=RequestMethod.POST)
    public String children( @RequestParam("token") String token, 
                            @RequestParam("folderId") String folderId,  
                            @RequestParam("parentId") String parentId,                              
                            Model model, HttpServletRequest req ){
        
        setFrontEndVariables(model, req);
        model.addAttribute("token", token);
        model.addAttribute("folderId", folderId);
        model.addAttribute("parentId", parentId);
        
        try {
            Credential cred = googleAuthService.buildFakeFromToken(token);
        
            List<File> childList = googleAuthService.getChildren(cred, folderId);
            
            model.addAttribute("childList", childList);
            
            return "children";
            
        } catch (GoogleJsonResponseException e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
        }
        
        return "redirect:/";
        
    }
    
    
    
    @RequestMapping(value="/oauth2callback", method=RequestMethod.GET)
    public String oauth2Callback( Model model, HttpServletRequest req ){
        setFrontEndVariables(model, req);
        return "oauth2Callback";
    }
    
}
