new_supporter = (data) ->
  $("#campaign-supporters .count").text(data.supporter_count + " Supporter" + (if data.supporter_count != 1 then "s" else ""))
                         .effect("highlight", {color: '#63DB00'}, 500)
  $(".all-label .ui-button-text").text('All ' + data.supporter_count)
  $(".new-label .ui-button-text").text(data.new_supporter_count + ' New')
  
  delete_last = -> 
    if $('#supporters-numbers li').length > 10
      $('#supporters-numbers li').last().remove()
  
  $("<li>#{data.number}</li>").hide()
                              .css('opacity', 0.0)
                              .prependTo("ul.supporters")
                              .slideDown(250)
                              .animate({opacity: 1.0}, 250, delete_last)


setupBroadcastTextArea = ->
  character_limit = 160
  $('#broadcast-text-area').bind('input', -> 
    if $.trim($(this).val()) == "" || $(this).val().length > character_limit
      $('#broadcastbutton').attr('disabled', 'disabled')
    else
      $('#broadcastbutton').removeAttr('disabled'))
  $('#broadcast-text-area').charCount({
    allowed: character_limit,
    warning: 20,
  })

setupFilters = (buttons) ->
  $(buttons).buttonset()
  $("#{buttons} :radio").change ->
    context = $(buttons).parent().parent()
    $("#filter-options", context).slideUp()
    clicked = $(this)
    id = $(this).attr('id')
    id = id.substr(0, id.length-1)
    if $("##{id}-options").length == 1
      $("#filter-options", context).html($("##{id}-options").html()).slideDown()

      $("#filter-options :checkbox", context).change(->
        str = 'country:' + $("#filter-options :checked", context).map((_, c) -> c.value).toArray().join('|')
        clicked.val(str)
      )

loadCampaign = (pusher, campaign, prev_channel) ->
  if prev_channel?
    pusher.unsubscribe(prev_channel)

  $("#campaign").empty()
  $("select.campaign-select").val(campaign)
  $("select").trigger("liszt:updated")

  channel_name = null
  if campaign != ""
    $.get("/campaign/#{campaign}",
      (data) ->
        $("#campaign").hide()
                      .html(data)
                      .slideDown(200)
        setupBroadcastTextArea()
        setupFilters('#broadcast-filter')
        setupFilters('#export-filter')
    ).error(-> window.location.replace '/')

    channel_name = campaign
    channel = pusher.subscribe(channel_name)
    channel.bind 'new', new_supporter
  window.onhashchange = -> loadCampaign(pusher, document.location.hash[1..], channel_name)


$ ->
  $('select').chosen()
  setTimeout((->$('.notice').slideUp('medium')), 3000)

  pusher = new Pusher(window.pusher_key)
  $("#campaign").empty()
  window.onhashchange = -> loadCampaign(pusher, document.location.hash[1..], null)
  window.onhashchange()
  $("select.campaign-select").change (evt) ->
    document.location.hash = $(this).val()




