class ConfirmModalControl
  constructor: (id) ->
    @element = document.getElementById(id)
    for ele in @element.getElementsByClassName('cmc-cancel')
      ele.addEventListener 'click', (evt) =>
        @modalOff()
    for ele in @element.getElementsByClassName('cmc-ok')
      ele.addEventListener 'click', (evt) =>
        @runAction()
    @messageElement = @element.getElementsByClassName('cmc-message')[0]
    @formElement = @element.getElementsByClassName('cmc-form')[0]
    @formName = @formElement.getAttribute('name')

  modalOn: () ->
    unless @element.classList.contains('is-active')
      @element.classList.add('is-active')

  modalOff: () ->
    if @element.classList.contains('is-active')
      @element.classList.remove('is-active')

  confirm: (ele) ->
    @setMessage(ele.getAttribute('data-message'))
    @setForm(ele.getAttribute('data-action'), ele.getAttribute('data-method'))
    @modalOn()
    console.log ele

  setMessage: (message) ->
    @messageElement.textContent = message

  setForm: (action, method) ->
    form = document.forms[@formName]
    form.action = action
    if method == 'GET'
      form.method = 'GET'
    else
      form.method = 'POST'
    form.elements['_method'].value = method

@cmc = new ConfirmModalControl('confirm-modal')
