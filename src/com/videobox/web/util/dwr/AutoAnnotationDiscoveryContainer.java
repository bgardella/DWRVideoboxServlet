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
 * The Original Code is AutoAnnotationDiscoveryContainer.
 * 
 * The Initial Developer of the Original Code is Ben Gardella.
 * Portions created by Ben Gardella are Copyright (C) 2010
 * Meta Interfaces LLC. All Rights Reserved.
 * 
 *****************************************************************************/
package com.videobox.web.util.dwr;

import java.io.DataInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.lang.reflect.Method;
import java.net.URL;
import java.net.URLClassLoader;
import java.util.Arrays;
import java.util.HashSet;
import java.util.Set;

import javassist.bytecode.AnnotationsAttribute;
import javassist.bytecode.ClassFile;
import javassist.bytecode.annotation.Annotation;

import javax.servlet.ServletContext;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.directwebremoting.annotations.DataTransferObject;
import org.directwebremoting.annotations.RemoteProperty;
import org.directwebremoting.annotations.RemoteProxy;
import org.directwebremoting.convert.BeanConverter;
import org.directwebremoting.extend.Converter;
import org.directwebremoting.extend.ConverterManager;
import org.directwebremoting.impl.DefaultContainer;

/**
 * Enhances DWR's primitive IoC container to discover annotated DWR methods
 * based on package names. This way, we don't have to explicitly state every
 * annotated class that we wish to expose via DWR. This could have been done
 * using Spring's IoC, but we didn't want DWR so tightly coupled with Spring.
 * 
 * Also, I could not use a runtime classloader because the videobox jar is not
 * guaranteed to be loaded on this thread. In all likelihood, it won't be. So I
 * had to scan for classes using the servlet context. Using bytecode processing
 * (javassist) should be fairly quick and hopefully won't be a huge resource
 * drain since we will only scan for packages that are explicitly listed in the
 * servlet <init-param> tags.
 * 
 * See this page for the background and inspiration on how I implemented the
 * discovery process, if you are curious:
 * 
 * @see http://bill.burkecentral.com/2008/01/14/scanning-java-annotations-at-runtime
 * 
 *      Bill Burke is the MAN, btw.
 * 
 * @author Ben
 * 
 */
public class AutoAnnotationDiscoveryContainer extends DefaultContainer {

    protected final Log logger = LogFactory.getLog(getClass());

    private static final String[] ANNOTATIONS = new String[] {
        RemoteProxy.class.getName(),
        DataTransferObject.class.getName()
    };

    private Set<String> dataConverterObjects = new HashSet<String>();
    
    protected String findAnnotatedClasses(String packageList, ServletContext ctx) throws IOException {
        StringBuilder sb = new StringBuilder();
        packageList.replaceAll("\\s+", "");
        for (String pkg : packageList.split(",")) {
            pkg = pkg.trim();
            if (pkg.length() > 0) {
                if (scanLoader(sb, pkg) == null) {
                    if (scanContext(ctx, sb, pkg) == null) {
                        throw new IllegalStateException("No such package: " + pkg);
                    }
                }
            }
        }
        return sb.toString();
    }

    private void handleClass(InputStream istream, StringBuilder sb) throws IOException {
        DataInputStream dstream = new DataInputStream(istream);
        ClassFile cf = new ClassFile(dstream);
        AnnotationsAttribute visible = (AnnotationsAttribute)cf.getAttribute(AnnotationsAttribute.visibleTag);
        if (visible != null) {
            for (Annotation ann : visible.getAnnotations()) {
                // logger.info( cf.getName() + " contains @" + ann.getTypeName() );
                if (ann.getTypeName().equals(RemoteProxy.class.getName())) {
                    sb.append(cf.getName() + ",");
                } else if (ann.getTypeName().equals(DataTransferObject.class.getName())) {
                    dataConverterObjects.add(cf.getName());
//                    addDataConverterObject(cf);
                }
            }
        }
    }

    @Override
    public void setupFinished() {
        super.setupFinished();
        for (String className: dataConverterObjects) {
            addDataConverterObject(className);
        }
    }

    private void addDataConverterObject(String className) {
        Class<?> cls;
        try {
            cls = Class.forName(className);
        } catch (ClassNotFoundException e) {
            throw new IllegalStateException("No such class: " + className);
        }
        StringBuilder excludes = new StringBuilder();
        for (Method m: cls.getMethods()) {
            if (logger.isDebugEnabled()) {
                logger.debug("CHECKING " + cls.getSimpleName() + "." + 
                          m.getName() + "(" + m.getParameterTypes().length + ") -> " + 
                          Arrays.asList(m.getAnnotations()));
            }
            if (!m.isAnnotationPresent(RemoteProperty.class)) {
                if (logger.isDebugEnabled()) {
                    logger.debug("EXCLUDING " + cls.getSimpleName() + "." + m.getName() + " -> " + 
                              Arrays.asList(m.getAnnotations()));
                }
                excludes.append(propName(m)).append(',');
            }
        }
        BeanConverter beanConverter = new BeanConverter();
        beanConverter.setInstanceType(cls);
        beanConverter.setExclude(excludes.toString());
        ConverterManager cm = this.getBean(ConverterManager.class);
        cm.addConverter(cls.getName(), beanConverter);
        if (logger.isDebugEnabled()) {
            logger.debug("CONVERTER: " + cls.getName() + " -> " + excludes);
        }
    }
    
    private String propName(Method m) {
        String name = m.getName();
        if (name.startsWith("get")) {
            return lowerFirst(name.substring(3));
        }
        if (name.startsWith("is")) {
            return lowerFirst(name.substring(2));
        }
        return name;
    }

    private String lowerFirst(String name) {
        return Character.toLowerCase(name.charAt(0)) + name.substring(1);
    }
    //////////////////////////////////////////////////////////////////////////
    //////////////////////////////////////////////////////////////////////////
    //////////////////////////////////////////////////////////////////////////

    private StringBuilder scanContext(ServletContext ctx, StringBuilder sb, String pkg) throws IOException {
        String path = pkg.replaceAll("\\.", "/");
        Set<String> set = ctx.getResourcePaths("/WEB-INF/classes/" + path);
        if (set == null) {
            return null;
        }
        for (String className : set) {
            scanContextPath(ctx, sb, className);
        }
        return sb;
    }

    private StringBuilder scanContextPath(ServletContext ctx, StringBuilder sb, String pathName) throws IOException {
        if (pathName.endsWith(".class")) {
            InputStream istream = ctx.getResourceAsStream(pathName);
            handleClass(istream, sb);
        } else if (pathName.endsWith("/")) {
            // log.info( "PATH: " + pathName );
            Set<String> set = ctx.getResourcePaths(pathName);
            for (String className : set) {
                sb = scanContextPath(ctx, sb, className);
            }
        }
        Converter c = null;
        return sb;
    }
    
    //////////////////////////////////////////////////////////////////////////
    //////////////////////////////////////////////////////////////////////////
    //////////////////////////////////////////////////////////////////////////

    private StringBuilder scanLoader(StringBuilder sb, String pkg) throws IOException {
        ClassLoader loader = Thread.currentThread().getContextClassLoader();
        URL url = findResource(loader, pkg.replace('.', '/'));
        if (url == null) {
            return null;
        }
        String dirPath = url.getFile();
        File dir = new File(dirPath);
        return scanLoader(sb, dir);
    }
    
    private URL findResource(ClassLoader loader, String pkgPath) {
        if (loader == null) {
            return null;
        }
        if (!(loader instanceof URLClassLoader)) {
            return findResource(loader.getParent(), pkgPath);
        }
        URLClassLoader ucl = (URLClassLoader)loader;
        URL url = ucl.getResource(pkgPath);
        if (url==null) {
            logger.warn("Not found in " + ucl + " -> " + Arrays.asList(ucl.getURLs()));
            return findResource(loader.getParent(), pkgPath);
        }
        return url;
    }
    
    private StringBuilder scanLoader(StringBuilder sb, File file) throws IOException {
        if (file.getName().endsWith(".class")) {
            InputStream istream = new FileInputStream(file);
            handleClass(istream, sb);
        } else if (file.isDirectory()) {
            // logger.info( "PATH: " + pathName );
            for (File f: file.listFiles()) {
                scanLoader(sb, f);
            }
        }
        return sb;
    }

}
