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


makeGrid = (container, divs) ->
  c = $(container)
  w = (100 / divs) + "%"
  for i in [divs..1]
    for j in [1..divs]
      c.append $("<div class='tone-button x-#{j} y-#{i}' style='height:#{w};width:#{w};'>")
  false


$(document).ready ()->

  gridsize = 5
  makeGrid '.fret-contain', gridsize
  notes = [60,62,64,65,67,69,71,72]

  tt = (e)->
    c = $(".fret-contain")
    o = c.offset()
    {left, top} = o
    x = (e.pageX - left) / c.width()
    x = if x > 1 then gridsize-1 else Math.floor(x * gridsize)
    y = 1 - ((e.pageY - top) / c.height())
    y = if y > 1 then gridsize-1 else Math.floor(y * gridsize)
    note1 = Mooog.freq(notes[x])
    osc1.param({'frequency': note1, from_now: true, ramp: 'expo', at: 0.15 })
    note2 = Mooog.freq(notes[y])
    osc2.param({'frequency': note2, from_now: true, ramp: 'expo', at: 0.15 })
    $(".tone-button.active").removeClass('active');
    $(".tone-button.x-#{x+1}.y-#{y+1}").addClass('active');
    React.render(
      <NumberSpan label='x' number={x} />,
      document.getElementById('mouseposX')
    )
    React.render(
      <NumberSpan label='y' number={y} />,
      document.getElementById('mouseposY')
    )

  NumberSpan = React.createClass
    render: ->
      return (
        <div className="numberSpan">
        {this.props.label}: {this.props.number}
        </div>
      )



  $(document)
    .on "click", "#on", () ->
      osc1.start()
      osc2.start()
    .on "click", "#off", () ->
      osc1.stop()
      osc2.stop()
    .on "mousemove", ".fret-contain", throttle(tt, 50)
