 $(function() {
  var status = $("#slide-status");

  $(".owl-carousel").owlCarousel({
    responsive: true,
    navigation: true,
    navigationText: ["<i class='carousel-arrow-left'>","<i class='carousel-arrow-right'>"],
    pagination: false,
    singleItem: true,
    afterAction: afterAction,
    autoHeight: true,
    touchDrag: false
  });

  function updateResult(pos,value) {
    status.find(pos).find(".result").text(value);
  }

  function afterAction() {
    status.show();
    updateResult(".owlItems", this.owl.owlItems.length);
    updateResult(".currentItem", this.owl.currentItem + 1);
  }
});
