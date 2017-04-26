
// Bulk Discount Promo Rule

$(document).ready(function () {
  if ($('#bulk-discount-template').length) {
    var bulkDiscountTemplate = Handlebars.compile($('#bulk-discount-template').html());
    var optionValueSelectNameTemplate = Handlebars.compile($('#promo-rule-bulk-discount-bulk-discounts-select-name-template').html());

    var addBulkDiscount = function(product, minQuantity) {
      $('.js-promo-rule-bulk-discounts').append(bulkDiscountTemplate({
        productSelect: {value: product},
        minQuantity: {value: minQuantity}
      }));
      var bulkDiscount = $('.js-promo-rule-bulk-discounts .promo-rule-bulk-discount').last();
      bulkDiscount.find('.js-promo-rule-bulk-discount-product-select').productAutocomplete({multiple: false});

      if (product === null) {
        bulkDiscount.find('.js-promo-rule-bulk-discount-min-quantity').prop('disabled', true);
      }
    };

    var originalOptionValues = $('.js-original-promo-rule-bulk-discounts').data('original-bulk-discounts');
    if (!$('.js-original-promo-rule-bulk-discounts').data('loaded')) {
      if ($.isEmptyObject(originalOptionValues)) {
        addBulkDiscount(null, null);
      } else {
        $.each(originalOptionValues, addBulkDiscount);
      }
    }
    $('.js-original-promo-rule-bulk-discounts').data('loaded', true);

    $(document).on('click', '.js-add-promo-rule-bulk-discount', function (event) {
      event.preventDefault();
      addBulkDiscount(null, null);
    });

    $(document).on('click', '.js-remove-promo-rule-bulk-discount', function () {
      $(this).parents('.promo-rule-bulk-discount').remove();
    });

    $(document).on('change', '.js-promo-rule-bulk-discount-product-select', function () {
      var minQuantity = $(this).parents('.promo-rule-bulk-discount').find('.js-promo-rule-bulk-discount-min-quantity');
      minQuantity.attr('name', optionValueSelectNameTemplate({productId: $(this).val()}).trim());
      minQuantity.prop('disabled', $(this).val() === '').select2('val', '');
    });
  }
});