M = new Mooog()
M.node
  node_type: 'Oscillator'
  id: 'osc'
  frequency: 240
.chain M.node
  node_type: 'Delay'
  feedback: 0.5
  id: 'del'
  delayTime: 0.4
.chain M.node
  node_type: 'Convolver'
  buffer_source_file: '/assets/sound/sportscentre-york-ortf-shaped.wav'
.chain M.node
  node_type: 'Gain'
  gain: 0.2

M.node
  node_type: 'Oscillator'
  id: 'lfo'
  frequency: 0.5
  type: 'sawtooth'
.start()
.chain M.node
  node_type: 'Gain'
  id: 'lfo_gain'
  gain: 1000
.chain M.node('osc'), 'detune'


M.node('osc').start()

window.M = M
