/*
* Unobtrusive autocomplete
*
* To use it, you just have to include the HTML attribute autocomplete
* with the autocomplete URL as the value
*
*   Example:
*       <input type="text" data-autocomplete="/url/to/autocomplete">
*
* Optionally, you can use a $ selector to specify a field that can
* be updated with the element id whenever you find a matching value
*
*   Example:
*       <input type="text" data-autocomplete="/url/to/autocomplete" data-id-element="#id_field">
*/

(function($)
{
  var self = null;
  $.fn.railsAutocomplete = function() {
    var handler = function() {
      if (!this.railsAutoCompleter) {
        this.railsAutoCompleter = new $.railsAutocomplete(this);
      }
    };
    if ($.fn.on !== undefined) {
      return $(document).on('focus',this.selector,handler);
    }
    else {
      return this.live('focus',handler);
    }
  };

  $.railsAutocomplete = function (e) {
    _e = e;
    this.init(_e);
  };

  $.railsAutocomplete.fn = $.railsAutocomplete.prototype = {
    railsAutocomplete: '0.0.1'
  };

  $.railsAutocomplete.fn.extend = $.railsAutocomplete.extend = $.extend;
  $.railsAutocomplete.fn.extend({
    init: function(e) {
      e.delimiter = $(e).attr('data-delimiter') || null;
      function split( val ) {
        return val.split( e.delimiter );
      }
      function extractLast( term ) {
        return split( term ).pop().replace(/^\s+/,"");
      }

      $(e).autocomplete({
          delay: 0,
          source: function( request, response ) {
          $.getJSON( $(e).attr('data-autocomplete'), {
            term: extractLast( request.term )
          }, function() {
            if(arguments[0].length == 0) {
              arguments[0] = []
              arguments[0][0] = { id: "", label: "no match found" }
            }
            $(arguments[0]).each(function(i, el) {
              var obj = {};
              obj[el.id] = el;
              $(e).data(obj);
            });
            response.apply(null, arguments);
          });
        },
        change: function( event, ui ) {
            if($($(this).attr('data-id-element')).val() == "") {
              return;
            }
            $($(this).attr('data-id-element')).val(ui.item ? ui.item.id : "");
            var update_elements = $.parseJSON($(this).attr("data-update-elements"));
            var data = ui.item ? $(this).data(ui.item.id.toString()) : {};
            if(update_elements && $(update_elements['id']).val() == "") { 
              return; 
            }
            for (var key in update_elements) {
                $(update_elements[key]).val(ui.item ? data[key] : "");
            }  
        },
        search: function() {
          // custom minLength
          var term = extractLast( this.value );
          if ( term.length < 1 ) {
            return false;
          }
        },
        focus: function() {
          // prevent value inserted on focus
          return false;
        },
        select: function( event, ui ) {
          var terms = split( this.value );
          // remove the current input
          terms.pop();
          // add the selected item
          terms.push( ui.item.value );
          // add placeholder to get the comma-and-space at the end
          if (e.delimiter != null) {
            terms.push( "" );
            this.value = terms.join( e.delimiter );
          } else {
            this.value = terms.join("");
            if ($(this).attr('data-id-element')) {
              /////////////////////////////////////////////////////////////
              // added call to new variable in case we want to populate
              // with alternate id value
              /////////////////////////////////////////////////////////////
              var id_column, id_value;
              if ($(this).attr('data-id-column')) {id_column = $(this).attr('data-id-column');}
              else {id_column = 'id';}
              
              id_value = $(this).attr('data-id-element');

              $(id_value).val(ui.item[id_column]);
            }
            if ($(this).attr('data-update-elements')) {
              var data = $(this).data(ui.item.id.toString());
              var update_elements = $.parseJSON($(this).attr("data-update-elements"));
              for (var key in update_elements) {
                $(update_elements[key]).val(data[key]);
              }
            }
          }
          var remember_string = this.value;
          $(this).bind('keyup.clearId', function(){
            if($(this).val().trim() != remember_string.trim()){
              $($(this).attr('data-id-element')).val("");
              $(this).unbind('keyup.clearId');
            }
          });
          $(e).trigger('railsAutocomplete.select', ui);
          return false;
        }


    })
      .data( 'ui-autocomplete' )._renderItem = function( ul, item ) {

        if (item.image_url) {

          return $('<li />')
            .data( 'ui-autocomplete-item', item )
            .append('<a><img src="' + item.image_url + '" class="autocomplete-image"><span class="autocomplete-text">' + item.value + '</span></a>')
            .appendTo(ul);
        }

        else {
          return $('<li />')
            .data( 'ui-autocomplete-item', item )
            .append('<a><span class="autocomplete-text">' + item.value + '</span></a>')
            .appendTo(ul);
        }

    };
    }
  });

  $(document).ready(function(){
    $('input[data-autocomplete]').railsAutocomplete();
  });
})(jQuery);
