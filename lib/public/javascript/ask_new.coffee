$ ->
  $('select.ask-type').change (evt) ->
    type = $(this).val()
    if type == 'voicemail_ask'
      $('#selected-ask-type').append("<div><h3>What should the ringer hear when they call?</h3>
        <input class='msg-text-area' type='textarea' name='prompt' 
          placeholder='Please leave a message of peace after the beep.'/></div>")