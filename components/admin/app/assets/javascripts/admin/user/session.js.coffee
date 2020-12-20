
$(document).on("ready page:load turbolinks:load", ->

  $("#verification_code").bind "keyup", ->
    if $(this).val().length is 6 #second clientside validation
      data = undefined
      $.ajax
        type: "POST"
        url: "/check_verification_code"
        data: "verification_code=" + $("#verification_code").val() + "&" + "verification_phone=" + $("#verification_phone").val()
        success: (data) ->
          if data.result is true
            $("#provider_business_phone").val($("#verification_phone").val())
            $("#verification_phone").prop("disabled", false);
            clearInterval(interval)
            $("#error_code_label").hide()
            $("#success_code_label").show()
            $("#verification_code").prop "disabled", true
            $("#provider_submit").prop "value", I18n.t "shared.navbar.pleasewait"
            $("#providerform").submit() # provider gets mobile_verified inside
            return
          else
            $("#error_code_label").text 'shared.navbar.error_in_code'.show()
          return
        error: (data) ->
          $("#error_code_label").text  'shared.navbar.problem_sending_request'.show()
          return
    else
      $("#error_code_label").hide()
      $("#success_code_label").hide()
      return
    return

  interval = undefined
  $("#sendverification").click ->
    if $("#verification_phone").val().length is 11 #second clientside vald(before svrside)
      time = 30000 #OTP default wait time
      seconds = Math.ceil(time / 1000)
      $(this).each ->
        disabled_elem = $(this)
        $("#verification_phone").prop "disabled", true
        disabled_elem.prop "disabled", true
        new_text =  'shared.navbar.send_code_again'
        disabled_elem.val new_text + " (" + seconds + ")"
        interval = setInterval(->
          disabled_elem.val new_text + " (" + --seconds + ")"
          if seconds is 0
            $("#verification_phone").prop "disabled", false
            disabled_elem.prop "disabled", false
            disabled_elem.val new_text
            clearInterval interval
          return
        , 1000)
        return
      $.ajax
        data: "verification_phone=" + $("#verification_phone").val()
        type: "get"
        url: "/sendverification"
        success: (data) ->
          if data.result is true
            $("#verification_code").show()
            $("#verify_code_label").show()
            $("#error_mobile_label").hide()
            $("#error_code_label").hide()
            $("#verification_code").val ''
            $("#verification_code").focus()
            return
          else
            $("#error_mobile_label").text 'shared.navbar.problem_sending_sms'.show()
            return
        error: (data) ->
          $("#error_mobile_label").text 'shared.navbar.problem_sendbing_request'.show()
          return
    return false

);
