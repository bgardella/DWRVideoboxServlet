/****************************************************************************
 * The contents of this file are subject to the Mozilla Public License
 * Version 1.1 (the "License"); you may not use this file except in
 * compliance with the License. You may obtain a copy of the License at
 * http://www.mozilla.org/MPL/
 * 
 * Software distributed under the License is distributed on an "AS IS"
 * basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. See the
 * License for the specific language governing rights and limitations
 * under the License.
 * 
 * The Original Code is DwrMetaInterfacesServlet.
 * 
 * The Initial Developer of the Original Code is Ben Gardella.
 * Portions created by Ben Gardella are Copyright (C) 2010
 * Meta Interfaces LLC. All Rights Reserved.
 * 
 *****************************************************************************/
package com.videobox.web.util.dwr;

import java.io.IOException;

import javax.servlet.ServletConfig;
import javax.servlet.ServletContext;
import javax.servlet.ServletException;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.directwebremoting.Container;
import org.directwebremoting.impl.StartupUtil;
import org.directwebremoting.servlet.DwrServlet;


/**
 * Extension of the DwrServlet @see http://directwebremoting.org/dwr-javadoc/org/directwebremoting/servlet/DwrServlet.html
 * 
 * Version 3 of DWR supports annotations, which is nifty, but it requires two things:
 * 
 * 		1) You must explicitly list each class that is annotated.
 * 		2) It requires Spring
 * 
 * Not so nifty.  Using this extension allows you to configure the servlet with a list of package names that contain methods
 * with the @RemoteProxy annotation.  No Spring Framework required.  Ahhh.  Much better.
 * 
 * @author Ben
 *
 */
public class DwrVideoboxServlet extends DwrServlet 
{
	protected final Log logger = LogFactory.getLog(getClass());
	

    /* (non-Javadoc)
     * @see org.directwebremoting.servlet.DwrServlet#createContainer(javax.servlet.ServletConfig)
     */
    @Override
    protected Container createContainer(ServletConfig servletConfig) {
        if ( logger.isDebugEnabled()) {
            logger.debug("Creating container for Custom DWR servlet");    	
        }
        try {
            String packageList = servletConfig.getInitParameter("packages");    		
            ServletContext ctx = servletConfig.getServletContext();
            AutoAnnotationDiscoveryContainer container = new AutoAnnotationDiscoveryContainer();
            String classNames = container.findAnnotatedClasses( packageList, ctx );
            if (logger.isDebugEnabled()) {
                logger.debug("discovered @RemoteProxy annotated classes: " + classNames);
            }
            container.addParameter("classes", classNames);    		   		
            StartupUtil.setupDefaultContainer(container, servletConfig);
            return container;    		
        } catch(Exception e) {
            e.printStackTrace();
            return null;
        }finally{
            logger.info("Creation of Custom DWR servlet container done.");   
        }
    }
	
    /* (non-Javadoc)
     * @see
     * org.directwebremoting.servlet.DwrServlet#configureContainer(org.directwebremoting.Container,
     * javax.servlet.ServletConfig)
     */
    @Override
    protected void configureContainer(Container container, ServletConfig servletConfig) 
        throws ServletException, IOException {
        if (logger.isDebugEnabled()) {
            logger.debug("Configuring container for Custom DWR servlet");
        }     
        try {	    
            //sets up the DWR engine settings
            StartupUtil.configureFromSystemDwrXml(container);  
            //dwr.xml still used for setting up converters
            StartupUtil.configureFromDefaultDwrXml(container, servletConfig); 
            //tells the engine to look inside the container for the 
            // annotated "classes" parameter set in above method: "createContainer"
            StartupUtil.configureFromAnnotations(container);  
        } catch (IOException ex) {
            throw ex;
        } catch (Exception ex) {
            throw new ServletException(ex);
        } finally{
            logger.info("Configuration of DWR servlet container done.");   
        }
    }
}
