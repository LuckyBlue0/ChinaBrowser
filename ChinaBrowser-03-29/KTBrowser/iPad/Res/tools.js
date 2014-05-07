function MyAppGetHTMLElementsAtPoint(x,y) {
    var tags = ",";
    var e = document.elementFromPoint(x,y);
    while (e) {
        tags += e.href + ',';
        if (e.tagName) {
            tags += e.tagName + ',';
            if (e.tagName.toLowerCase()=='a') {
                tags += e.href + ',';
            }
            if (e.tagName.toLowerCase()=='img') {
                tags += e.src + ',';
            }
        }
        e = e.parentNode;
    }
    
    return tags;
}
