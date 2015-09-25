class Pane
  constructor: (@config) ->
    @capture_selector = @config.capture_selector
    @pane = @config.pane_selector
    @mousemove_factor = 12.0
    @mousemove_y_max = 8000
    @mousemove_x_max = 1000
    @pane_z_start = -2000
    @pane_z_min = -2000
    @pane_z_max = 0
    @wheel_factor = 0.7
    @rotate_x_factor = 0.01
    @rotate_y_factor = 0.001
    @init()


  init: ()->
    @pane_z = @pane_z_start
    @pane_z_range = @pane_z_max - @pane_z_min
    TweenMax.to(@pane, 0.2, { z: @pane_z } )

    @juke = new JukeBox

    $(document).on "wheel", @config.capture_selector, @throttle(@wheel, 50)
    .on "mousemove", @config.capture_selector, @throttle(@mousemove, 50)
    .on "click" , @config.capture_selector, (e) =>
      split = new SplitText(@config.pane_selector,{type:"chars,words",position:"absolute"});
      TweenMax.staggerFrom(split.words, 1, {y:-100 , textShadow:"20px 20px 50px rgba(255,255,255,0)" }, 0.6);

  throttle:(func, interval) ->
    timeout = false
    (event) ->
      later = (event) =>
        @timeout = null
        func.apply(@, [event])
      return if @timeout?
      @timeout = setTimeout(later, interval, event)

  mousemove: (e) =>
    displaceX = (($(window).width()/2) - e.pageX) * @mousemove_factor
    displaceY = (($(window).height()/2) - e.pageY) * @mousemove_factor
    if displaceX > @mousemove_x_max
      displaceX = @mousemove_x_max
    if displaceX < -1 * @mousemove_x_max
      displaceX = -1 * @mousemove_x_max
    if displaceY > @mousemove_y_max
      displaceY = @mousemove_y_max
    if displaceY < -1 * @mousemove_y_max
      displaceY = -1 * @mousemove_y_max
    TweenMax.to(@pane, 0.2, { x:displaceX, y:displaceY, rotationY: (displaceX * @rotate_x_factor)+"deg", rotationX: (-1 * displaceY * @rotate_y_factor)+"deg"  } )

  wheel: (e) =>
    e.preventDefault()
    @pane_z += (e.originalEvent.deltaY * @wheel_factor)
    if @pane_z < @pane_z_min
      @pane_z = @pane_z_min
    if @pane_z > @pane_z_max
      @pane_z = @pane_z_max
    pane_prop = (@pane_z - @pane_z_min) / @pane_z_range
    @juke.f1.param('gain',pane_prop)
    @juke.f2.param('gain',pane_prop)
    TweenMax.to(@pane, 0.2, { z: @pane_z } )




class JukeBox
  constructor: ()->
    @init()

  init: ()->
    @M = new Mooog({debug:true});

    @master = @M.node('master','Gain').param('gain',0.5)

    @f1 = @M.track('f1', @M.node(
      id: 'f1_osc'
      node_type: 'Oscillator'
      frequency: Mooog.freq(40)
      type: 'sawtooth'
      ),
      id: 'f1_fil'
      node_type: 'BiquadFilter'
      frequency: 500
      type: 'lowpass'
      Q: 3
    ).param('gain',0)
    @f1.chain @master

    @f2 = @M.track('f2', {
      id: 'f2_osc',
      node_type: 'Oscillator'
      frequency: Mooog.freq(47)
      type: 'sawtooth'
      },{
      id: 'f2_fil'
      node_type: 'BiquadFilter'
      frequency: 500
      type: 'lowpass'
      Q: 3
      }
    ).param('gain',0)
    @f2.chain @master

    @verb = @M.track( 'verb',
      node_type: 'Convolver'
      buffer_source_file: "/assets/sound/st-andrews-church-ortf-shaped.mp3"
      ,
      node_type: 'Delay'
      feedback: 0.5
      delayTime: 0.25
    )

    @lfo1 = @M.node(
      id: 'lfo1'
      node_type: 'Oscillator'
      frequency: 0.33
      connect_to_destination:false
    ).start().connect( @M.node(
      id: 'lfo1_gain'
      node_type: 'Gain'
      gain: 300
      connect_to_destination:false
      )
    )
    @M.node('lfo1_gain')
    .connect( @M.node('f1_fil'), 'frequency' )
    .connect( @M.node('f2_fil'), 'frequency' )

    @f1.send('verb_send', @verb , 'post', 0.7)
    @f2.send('verb_send', @verb , 'post', 0.7)

    $(document)
    .on "click", @start

  start: ()=>
    @M.node("f1_osc").start()
    @M.node("f2_osc").start()
    @f1.param({ gain: 0.5, at: 0, ramp: 'expo',  timeConstant: 10 })
    @f2.param({ gain: 0.5, at: 0, ramp: 'expo',  timeConstant: 20 })





$(document).ready ()->
  window.pane = new Pane
    capture_selector: "body"
    pane_selector: "div.poem"
  window.juke = pane.juke
