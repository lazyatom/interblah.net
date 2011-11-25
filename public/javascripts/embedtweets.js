var EmbedTweet = {
  enableDebugging:false,
  automaticEmbedding:true,
  doIncludeStylesheet:true,
  objRegex:/http(s)?:\/\/twitter\.com\/(#!\/)?([a-z0-9_]+)\/status(es)?\/([0-9]+)/i,
  doEmbedClass:"EmbedTweet",
  dontEmbedClass:"dontEmbedTweet",
  $:function(a){
    var b=new Array;
    for(var c=0;c<arguments.length;c++){
      var a=arguments[c];
      if(typeof a=="string") a=document.getElementById(a);
      if(arguments.length==1) return a;
      b.push(a)
    }
    return b
  },
  addLoadEvent:function(a){
    var b=window.onload;
    if(typeof window.onload!="function"){
      window.onload=a
    }else{
      window.onload=function(){
        if(b){
          b()
        }
        a()
      }
    }
  },
  insertAfter:function(a,b){
    var c=b.parentNode;
    if(c.lastchild==b){
      c.appendChild(a)
    }else{
      
    };
  },
  hide:function(a){
    a=EmbedTweet.$(a);
    a.style.display="none";
    return a
  },
  getAnchorsByClassName:function(a,b){
    if(!b) b=document.getElementsByTagName("body")[0];
    var c=[];
    var d=new RegExp("\\b"+a+"\\b");
    var e=b.getElementsByTagName("a");
    for(var f=0,g=e.length;f<g;f++)
      if(d.test(e[f].className)) c.push(e[f]);
    return c
  },
  getAnchorsWithoutClassName:function(a,b){
    if(!b) b=document.getElementsByTagName("body")[0];
    var c=[];
    var d=new RegExp("\\b"+a+"\\b");
    var e=b.getElementsByTagName("a");
    for(var f=0,g=e.length;f<g;f++)
      if(!d.test(e[f].className))c.push(e[f]);
    return c
  },
  debug:function(a){
    if(this.enableDebugging) console.log(a)
  },
  handleTweet:function(a){
    if(this.objRegex.test(a.href)){
      temp=a.href.split(/(\/)/);
      id=temp[temp.length-1];
      this.includeScript("http://embedtweet.com/embed/"+id);
      a.id="embedtweet_link_"+id;
      //EmbedTweet.hide(a)
    }
  },
  includeScript:function(a){
    var b=document.getElementsByTagName("head")[0];
    var c=document.createElement("script");
    c.type="text/javascript";
    c.src=a;
    b.appendChild(c)
  },
  includeStylesheet:function(a,b){
    var c=document.getElementsByTagName("head")[0];
    var d=document.createElement("link");
    d.type="text/css";
    d.href=a;
    d.media=b;
    d.rel="stylesheet";
    c.appendChild(d)
  },
  contentLoaded:function(a,b){
    tweet_div=document.createElement("div");
    tweet_div.innerHTML=b;
    EmbedTweet.hide(EmbedTweet.$("embedtweet_link_"+a)); // JGA
    EmbedTweet.$("embedtweet_link_"+a).parentNode.insertBefore(tweet_div,EmbedTweet.$("embedtweet_link_"+a))
  },
  init:function(){
    EmbedTweet.debug("EmbedTweet javascript library loaded.");
    if(this.doIncludeStylesheet){
      EmbedTweet.includeStylesheet("http://embedtweet.com/stylesheets/embed_v2.css","screen")
    }
    EmbedTweet.addLoadEvent(function(){EmbedTweet.start()})
  },
  start:function(){
    EmbedTweet.debug("Initializing EmbedTweet");
    var a=new Array;
    if(this.automaticEmbedding){
      a=EmbedTweet.getAnchorsWithoutClassName(this.dontEmbedClass)
    }else{
      a=EmbedTweet.getAnchorsByClassName(this.doEmbedClass)
    }
    for(var b=0;b<a.length;b++){
      if(a[b].className != "twtr-timestamp" && 
         a[b].className != "dsq-service-name" && 
         (!a[b].parentNode || a[b].parentNode.className.indexOf("dsq-reaction-retweets")==-1))
        EmbedTweet.handleTweet(a[b])
    }
  }
};
EmbedTweet.init()