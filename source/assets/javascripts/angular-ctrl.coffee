#=require bower_components/angular/angular

Audio_Experiment = angular.module('Audio_Experiment', [])

AudioContextExperiment = ($scope, $http) ->
  $scope.audCtxt = new AudioContext()
  $scope.destination_node = $scope.audCtxt.destination
  $scope.oscillator = $scope.audCtxt.createOscillator()
  $scope.oscillator.connect($scope.destination_node, 0, 0)
  $scope.oscillator.state = 'stopped'
#   $scope.oscillator.start()
#   $scope.oscillator.type = 'square'

  $scope.on_off = () ->
    console.log('hello')
    if $scope.oscillator.state == 'stopped'
      $scope.oscillator.state = 'playing'
      $scope.oscillator.start()
    else
      $scope.oscillator.state = 'stopped'
      $scope.oscillator.stop()

  $scope




Audio_Experiment.controller('AudioContextExperiment', ['$scope','$http', AudioContextExperiment])
