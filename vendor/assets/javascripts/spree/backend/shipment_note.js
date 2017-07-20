$(document).ready(function () {
  var toggleNoteEdit = function(event) {
    event.preventDefault();

    var link = $(this);
    link.parents('tbody').find('tr.edit-note').toggle();
    link.parents('tbody').find('tr.show-note').toggle();
  }

  // handle note edit click
  $('a.edit-note').click(toggleNoteEdit);
  $('a.cancel-note').click(toggleNoteEdit);

  // handle note save
  $('[data-hook=admin_shipment_form] a.save-note').on('click', function (event) {
    event.preventDefault();

    var link = $(this);
    var shipment_number = link.data('shipment-number');
    var note = link.parents('tbody').find('input#note').val();
    var url = Spree.url(Spree.routes.shipments_api + '/' + shipment_number + '.json');

    $.ajax({
      type: 'PUT',
      url: url,
      data: {
        shipment: {
          note: note
        },
        token: Spree.api_key
      }
    }).done(function (data) {
      link.parents('tbody').find('tr.edit-note').toggle();
      var show = link.parents('tbody').find('tr.show-note');
      show.toggle();
      show.find('.shipment-note').html($("<strong>").html("Note: ")).append(data.note);
    });
  });
});