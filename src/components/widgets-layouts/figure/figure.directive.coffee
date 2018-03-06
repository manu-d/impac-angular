module = angular.module('impac.components.widgets-layouts.figure',[])

module.controller('FigureLayoutCtrl', ($scope, $translate, $timeout, ImpacWidgetsSvc, ImpacTheming, ImpacUtilities) ->

)

module.directive('impacFigureLayout', ($templateCache) ->
  return {
    restrict: 'E',
    scope: {
      content: '='
      timePeriodEnabled: '=?'
      selectorList: '=?'
      selectorUid: '=?'
    },
    template: $templateCache.get('widgets-layouts/figure.tmpl.html'),
    controller: 'FigureLayoutCtrl'
  }
)
