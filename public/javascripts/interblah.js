window.onload = function() {
    document.querySelectorAll("p > img, p > a > img").forEach(function(e) {
        e.closest("p").classList.add("p-with-image");
    });
    document.querySelectorAll("p > code").forEach(function(e) {
        e.innerHTML = e.innerHTML.replace(" ", "&nbsp;");
    });
    var tocHeader = document.getElementById("table-of-contents");
    if (tocHeader) {
        var tocElement = document.createElement("aside");
        var c = document.createAttribute("class");
        c.value = "table-of-contents";
        tocElement.setAttributeNode(c);
        var article = document.querySelector("article");
        var section = article.querySelector("section");
        section.insertBefore(tocElement, section.children[0]);
        var toc = document.querySelector("#table-of-contents + *");
        [tocHeader, toc].forEach(function(element) {
            if (element) {
                tocElement.append(element);
            }
        });
        article.classList.add("with-table-of-contents");

        Promise.all(Array.from(document.images).filter(img => !img.complete).map(img => new Promise(resolve => { img.onload = img.onerror = resolve; }))).then(() => {
            var children = section.children;
            var tocHeight = tocElement.getBoundingClientRect().height;
            var accumulatedHeight = 0;
            for(var i = 1; i < children.length; i++) {
                if (accumulatedHeight < tocHeight) {
                    children[i].classList.add("beside-float");
                    accumulatedHeight += children[i].getBoundingClientRect().height;
                }
            }
        });
    };
};
