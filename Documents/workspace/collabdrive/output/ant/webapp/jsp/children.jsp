<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<html>
<jsp:include page="partial/head.jsp" flush="true">
    <jsp:param name="pageTitle" value="CollabDrive"/>
</jsp:include>

<body class="auth">
 
<H1 class="message">Welcome to CollabDrive!!!</H1>
 
<form method="POST" action="<%=request.getContextPath()%>/folder/id/" class="form-folder">
  <input type="hidden" name="token" value="${token}"/>
  <input type="hidden" name="folderId" value="${entry.id}"/>
  <input type="hidden" name="parentId" value="${entry.parents[0].id}"/>
<span class="message underscore">  
&lt;&lt; GO BACK: <c:out value="${entry.parents[0].id}"/> &lt;&lt;  
</span>
</form> 

<c:if test="${fn:length(childList) eq 0}">
<div class="message" >This folder is empty.</div>
</c:if>

 <ol>
 <c:forEach var="entry" items="${childList}">
    <c:if test="${entry.mimeType eq 'application/vnd.google-apps.folder'}">
    <form method="POST" action="<%=request.getContextPath()%>/folder/id/" class="form-folder">
        <input type="hidden" name="token" value="${token}"/>
        <input type="hidden" name="folderId" value="${entry.id}"/>
        <input type="hidden" name="parentId" value="${entry.parents[0].id}"/>  
    <li><div class="directory"><img src="${entry.iconLink}"/><div class="directory-title">${entry.title}</div></div></li>    
    </form>
    </c:if>
 </c:forEach>
 <c:forEach var="entry" items="${childList}"> <%-- files --%>
    <c:if test="${entry.mimeType ne 'application/vnd.google-apps.folder'}">
    
    <c:choose><c:when test="${not empty entry.defaultOpenWithLink}">
    <a target="_blank" href="${entry.defaultOpenWithLink}">
    </c:when><c:otherwise>
    <a href="${entry.webContentLink}">
    </c:otherwise></c:choose>
    <li><div class="directory"><img src="${entry.iconLink}"/><div class="directory-title">${entry.title}</div></div></li>    
    </a>    
    </c:if>
 </c:forEach>
 </ol>
 
 
<script type="text/javascript">

$(window).load( function(){    

	$('.form-folder').click(function(){
		  this.submit();
	})
  
});
</script> 
 
 </body></html>   
   