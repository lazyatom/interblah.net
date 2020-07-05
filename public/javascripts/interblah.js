window.onload = function() {
    document.querySelectorAll("p > img").forEach(function(e) {
        e.parentNode.classList.add("p-with-image");
    });
    var tocHeader = document.getElementById("table-of-contents");
    if (tocHeader) {
        var tocElement = document.createElement("section");
        var c = document.createAttribute("class");
        c.value = "table-of-contents";
        tocElement.setAttributeNode(c);
        var article = document.querySelector("article");
        var section = document.querySelector("article > section");
        article.insertBefore(tocElement, section);
        var toc = document.querySelector("#table-of-contents + *");
        [tocHeader, toc].forEach(function(element) {
            if (element) {
                tocElement.append(element);
            }
        });
    };
};
