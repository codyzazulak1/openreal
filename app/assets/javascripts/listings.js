function blur_sale_listings(){
   var sold2 = document.getElementsByClassName("sold");
   for (var i = sold2.length - 1; i >= 0; i--) {
    var lbadge = sold2.item(i).parentElement;
    var limg = lbadge.parentElement;
    limg.style.filter = "blur(3px)";
   }
}

function sold_banner(element){
  $(element).prepend("<p style='z-index: 10000;top: 17em;font-size: 1rem;padding: 6px 3rem;color: white;background-color: #a4e125; position: absolute;top: 0;right: 0;padding: 0.5rem 1.95rem;'> Sold </p>");
 
}

function remove_sold_from_listing(){
  var sold2 = document.getElementsByClassName("sold");
  for(var i = sold2.length - 1; i >= 0; i--){
    var lbage = sold2.item(i).parentElement;
    var limg = lbage.parentElement;
    limg.removeChild(lbage);
    sold_banner(limg.parentElement);
  }
}
