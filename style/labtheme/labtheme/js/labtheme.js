$(document).ready(function() {
  var url = window.location.toString();

  function breadCrumbs(url){
    var ls = url.split("//")[1].split("/");
    var gitSource = "https://github.com/vlead/vlabs-dev-pages/tree/master/src";
    ls[0] = "Home";
    var result = "<ul class='breadcrumb'>";
    if(ls.length == 2){
      result = result.concat("<li><a href='/'>Home</a></li>");
      result = result.concat("<li class='gitLink'><a href='"+gitSource+"/index.org'>Edit on Github</a></li>")
      return result.concat("</ul>");
    }
    if(ls[ls.length-1] == ""){
      ls = ls.slice(0,ls.length-1);
    }
    ls.forEach(function(i){
      if(i == "Home"){
        result = result.concat("<li><a href='/'>"+ i +"</a></li>");
      }else if(i.indexOf(".html") > -1){
        result = result.concat("<li class='active'>"+ capitalize(i.split(".")[0].replace(new RegExp("-",'g')," ")) +"</li>");
      }else{
        result = result.concat("<li><a href='/"+i+"/'>"+ capitalize(i.replace(new RegExp("-",'g')," ")) +"</a></li>");
      }
    });

    var gitUrl;

    if(url.indexOf(".html") == -1){
      gitUrl =  url.replace("http://".concat(window.location.host),gitSource).concat("index.org")
    }else{
      gitUrl = url.replace("http://".concat(window.location.host),gitSource).replace(".html",".org");
    }
    
    result = result.concat("<li class='gitLink'><a href='"+gitUrl+"'>Edit on Github</a></li>")
    result = result.concat("</ul>");
    return result;
  }

  function capitalize(s){
    var ls = s.split(" ");
    ls = ls.map(function(i){
      return i[0].toUpperCase().concat(i.slice(1));
    });
    return ls.join(" ");
  }

  $('#content').prepend(breadCrumbs(url));

  $('.dropdown').hover(function(){$('this .dropdown-toggle').dropdown('toggle') });

  contents = $('ul.org-ul').first();

  contents.children('li').addClass("c-dropdown");
  contents.children('li').children('ul').addClass("c-dropdown-menu");
  contents.children('li').children('ul').removeClass("org-ul");

  contents.find('a').each(function() {
    this.attributes['href'].value = '/' + this.attributes['href'].value;
  })

  cld = contents.children().has("ul");
  for(var i=0;i<cld.length;i++) {
    text = cld[i].innerText;
    iHtml = cld[i].innerHTML.slice(text.length);
    iHtml = '<a href="/'+text+'">'+capitalize(text)+'</a>' + iHtml;
    cld[i].innerHTML = iHtml;
  }

  iHtml = contents[0].innerHTML;
  str = `<nav class="navbar navbar-default navbar-fixed-top header-nav">
          <div class="container-fluid">
            <!-- Brand and toggle get grouped for better mobile display -->
            <div class="navbar-header">
              <button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target="#bs-example-navbar-collapse-1" aria-expanded="false">
                <span class="sr-only">Toggle navigation</span>
                <span class="icon-bar"></span>
                <span class="icon-bar"></span>
                <span class="icon-bar"></span>
              </button>
              <a class="navbar-brand" href="/"><img src="/style/labtheme/img/logo-new.png" /></a>
            </div>
          </div>
        </nav>
        <nav class="navbar navbar-default navbar-fixed-top bottom-nav">
          <div class="container-fluid">
            <div class="navbar-header">
              <button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target="#bs-example-navbar-collapse-1" aria-expanded="false">
                <span class="sr-only">Toggle navigation</span>
                <span class="icon-bar"></span>
                <span class="icon-bar"></span>
                <span class="icon-bar"></span>
              </button>
            </div>
            <div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1">
              <ul class="nav navbar-nav">`;
  str = str + iHtml;
  str = str + '</ul></div></div></nav>';
  $('body').prepend(str);


  contents.children('li').children('ul').removeClass("c-dropdown-menu");
  contents.children('li').children('ul').addClass("footer-links");

  str = `<footer class="navbar navbar-default">
            <div class="container-fluid">`;
  cld = contents.children();
  for(var i=0;i<cld.length;i++) {
    if(i%4 == 0) {
      str = str + '<div class="row">';
    }
    sib1 = cld[i].firstElementChild;
    sib2 = cld[i].firstElementChild.nextElementSibling;
    iHtml = cld[i].innerHTML.slice(text.length);

    col = '<div class="col-md-3"><div class="footer-heading">';
    col = col + '<a href="' + sib1.attributes.href.value + '">' + sib1.text + '</a></div>';
    if(sib2) col = col + sib2.outerHTML;
    col = col + '</div>';
    str = str + col;
    if(i%4 == 3) {
      str = str + '</div>';
    }
  }
  str = str + '</div></footer>';
  contents[0].innerHTML = '';
  $('#postamble').before(str);

  $('.c-dropdown').hover(function(){
    if($(this).find('ul.c-dropdown-menu')[0]) {
      $(this).find('ul.c-dropdown-menu')[0].style.display = 'block';
    }
  },function(){
    if($(this).find('ul.c-dropdown-menu')[0]) {
      $(this).find('ul.c-dropdown-menu')[0].style.display = 'none';
    }
  });
})
