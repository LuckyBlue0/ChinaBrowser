var MyIPhoneApp_ModifyLinkTargets = function() {
    var allLinks = document.getElementsByTagName('a');
    if (allLinks) {
        var i;
        for (i=0; i<allLinks.length; i++) {
            var link = allLinks[i];
            var target = link.getAttribute('target');
            if (target && target == '_blank') {
                link.setAttribute('target','_self');
                
                link.href = 'newtab:'+escape(link.href);
//                link.href = 'newtab2:'+link.href;
//                link.href = 'newtab:'+encodeURI(link.href);
                
                
            }
        }
    }
}


var MyIPhoneApp_ModifyWindowOpen = function() {
    window.open =
    function(url,target,param) {
        if (url && url.length > 0) {
            if (!target) target = "_blank";
            if (target == '_blank') {
                location.href = 'newtab:'+escape(url);
//                location.href = 'newtab:'+url;
//                location.href = 'newtab:'+encodeURI(url);
                
            } else {
                location.href = url;
            }
        }
    }
}

var MyIPhoneApp_Init = function(){
    MyIPhoneApp_ModifyLinkTargets();
    MyIPhoneApp_ModifyWindowOpen();
}

// ------------------- 有图/无图 ----

function JSHandleHideImage () {
    /*
    var allImg = document.getElementsByTagName("IMG");
    var i=0;
    for (i; i<allImg.length; i++) {
        var e = allImg[i];
        e.style.visibility = "hidden";
    }
     */
    
    var i = 0;
    var allDiv = document.getElementsByTagName("DIV");
    for (i; i<allDiv.length; i++) {
        var e = allDiv[i];
        var bg_image = e.style.backgroundImage;
        e.style.backgroundImage = "none";
        e.setAttribute("bg_image", bg_image);
    }
     
    
    var newCss = document.getElementById('newCss');
    
    if(newCss == undefined){
        document.documentElement.innerHTML= document.documentElement.innerHTML+"<style id='newCss'>img{visibility:hidden;}</style>";
    }
    else {
        if(newCss.innerHTML == '') {
            newCss.innerHTML = 'img{visibility:hidden;}';
        }
    }
}

function JSHandleShowImage () {
    /*
    var allImg = document.getElementsByTagName("IMG");
    var i=0;
    for (i; i<allImg.length; i++) {
        var e = allImg[i];
        e.style.visibility = "visibility";
     }
     */
    
    var i = 0;
    var allDiv = document.getElementsByTagName("DIV");
    for (i; i<allDiv.length; i++) {
        var e = allDiv[i];
        var bg_image = e.getAttribute("bg_image");
        e.style.backgroundImage = bg_image;
    }
    
    var newCss = document.getElementById('newCss');
    if(newCss){
        newCss.innerHTML = 'img{visibility:visibility;}';
    }
}
