package collabdrive.web;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.ui.Model;
import org.springframework.util.StringUtils;

public abstract class AbstractController {

    protected final Log logger = LogFactory.getLog(getClass());

    @Value("${oauth.mount}")
    private String OAUTH_MOUNT_POINT;
    
    
    protected String generateUrlBase(HttpServletRequest req) {
        
        StringBuilder buf = new StringBuilder(64);
        buf.append(req.getScheme())
            .append("://")
            .append(req.getServerName());

        int port = req.getServerPort();

        if (!req.isSecure() && port != 80) {
            buf.append(":").append(port);
        }

        if (StringUtils.hasText(req.getContextPath())) {
            // append the context path 
            buf.append(req.getContextPath());
        }

        return buf.toString();
    }
    
    protected void setFrontEndVariables(Model model, HttpServletRequest req){
        String urlBase = generateUrlBase(req);
        model.addAttribute("urlBase", urlBase);
        model.addAttribute("oauthMountPoint", OAUTH_MOUNT_POINT);
    }
    
    
}
