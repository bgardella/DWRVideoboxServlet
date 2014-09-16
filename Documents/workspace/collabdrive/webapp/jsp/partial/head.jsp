<head>
    <title>${param.pageTitle}</title>
    
    <meta name="keywords" content="collabdrive" />
    <meta name="description" content="Collaborative Wrapper Around Google Drive" />
    
    <meta name="viewport" content="width=device-width, user-scalable=no, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0">
    
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/base.css"/>
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/ui-lightness/jquery-ui-1.10.4.custom.css">
    <link rel="shortcut icon" href="<%=request.getContextPath()%>/image/favicon.ico" type="image/x-icon" />
    
    <script type='text/javascript' src="<%=request.getContextPath()%>/js/jquery-1.10.2.js"></script>
    <script type='text/javascript' src="<%=request.getContextPath()%>/js/jquery-ui-1.10.4.custom.js"></script>
    
    <script type='text/javascript' src="<%=request.getContextPath()%>/js/jquery-1.10.2.js"></script>    
    <script type="text/javascript" src="https://apis.google.com/js/client.js"></script>
    
    <script type='text/javascript' src="<%=request.getContextPath()%>/js/promise.js"></script>
    
    <script type='text/javascript'>
       var context = "<%=request.getContextPath()%>";
       var urlBase = "${urlBase}";
    </script>
    
    <script type="text/javascript">
      (function() {
       var po = document.createElement('script'); po.type = 'text/javascript'; po.async = true;
       po.src = 'https://apis.google.com/js/client:plusone.js';
       var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(po, s);
     })();
    </script>
    
</head>