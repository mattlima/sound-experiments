###* @jsx React.DOM ###

#= require react

debounce = (func, wait, immediate) ->
  timeout = false
  () ->
    console.log 'hh'
    context = this
    args = arguments
    later = () ->
      timeout = null;
      func.apply(context, args) if (!immediate)
    callNow = immediate && !timeout
    clearTimeout timeout
    timeout = setTimeout(later, wait)
    console.log timeout
    func.apply(context, args) if (callNow)

throttle = (func, interval) ->
  timeout = false
  (event) ->
    later = (event) =>
      @timeout = null
      func.apply(@, [event])
    return if @timeout?
    @timeout = setTimeout(later, interval, event)



tt = (e)->
  note1 = Mooog.freq(Math.round((e.pageX / $(window).width()) * 40) + 30)
  osc1.param({'frequency': note1, from_now: true, ramp: 'expo', at: 0.25 })
  note2 = Mooog.freq(Math.round((e.pageY / $(window).height()) * 40) + 30)
  osc2.param({'frequency': note2, from_now: true, ramp: 'expo', at: 0.25 })
  $("#mousepos").text "#{note1} / #{note2}"


M = new Mooog()
M.node
  id: 'osc1'
  node_type: 'Oscillator'
  type: 'sawtooth'
.chain M.node('gain1','Gain')
M.node
  id: 'osc2'
  node_type: 'Oscillator'
  type: 'square'
.chain M.node('gain2','Gain')

osc1 = M.node('osc1')
osc2 = M.node('osc2')

$(document)
.on "click", "#on", () ->
  osc1.start()
  osc2.start()
.on "click", "#off", () ->
  osc1.stop()
  osc2.stop()
.on "mousemove", throttle(tt, 100)

.ready ()->

  CommentBox = React.createClass
    render: ->
      return (
        <div className="commentBox">
        Hello, world! I am a CommentBox.
        </div>
      )

  React.render(
    <CommentBox />,
    document.getElementById('content')
  )
