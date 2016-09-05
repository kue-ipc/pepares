@confirmAction = (element) ->
  message = element.getAttribute('data-message')
  window.confirm(message)

@WindowInformation = class WindowInformation
  @getScreenSize = =>
    width: @getScreenWidth()
    height: @getScreenHeight()
  @getScreenWidth = -> window.innerWidth
  @getScreenHeight = -> window.innerHeight
