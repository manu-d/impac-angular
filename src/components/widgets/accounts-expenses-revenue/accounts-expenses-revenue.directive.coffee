module = angular.module('impac.components.widgets.accounts-expenses-revenue',[])

module.controller('WidgetAccountsExpensesRevenueCtrl', ($scope, $q, ChartFormatterSvc) ->

  w = $scope.widget

  # Define settings
  # --------------------------------------
  $scope.orgDeferred = $q.defer()
  $scope.timeRangeDeferred = $q.defer()
  $scope.histModeDeferred = $q.defer()
  $scope.chartDeferred = $q.defer()

  settingsPromises = [
    $scope.orgDeferred.promise
    $scope.timeRangeDeferred.promise
    $scope.histModeDeferred.promise
    $scope.chartDeferred.promise
  ]


  # Widget specific methods
  # --------------------------------------
  w.initContext = ->
    $scope.isDataFound = w.content? && w.content.values?

  $scope.getCurrentRevenue = ->
    _.last(w.content.values.revenue) if $scope.isDataFound

  $scope.getCurrentExpenses = ->
    _.last(w.content.values.expenses) if $scope.isDataFound

  $scope.getCurrency = ->
    w.content.currency if $scope.isDataFound


  # Chart formating function
  # --------------------------------------
  $scope.drawTrigger = $q.defer()
  w.format = ->
    if $scope.isDataFound
      if w.isHistoryMode
        lineData = [
          {title: "Expenses (#{$scope.getCurrency()})", labels: w.content.dates, values: w.content.values.expenses },
          {title: "Revenue (#{$scope.getCurrency()})", labels: w.content.dates, values: w.content.values.revenue },
        ]
        all_values_are_positive = true
        angular.forEach(w.content.values.expenses, (value) ->
          all_values_are_positive &&= value >= 0
        )
        angular.forEach(w.content.values.revenue, (value) ->
          all_values_are_positive &&= value >= 0
        )
        lineOptions = {
          scaleBeginAtZero: all_values_are_positive,
          showXLabels: false,
        }
        chartData = ChartFormatterSvc.lineChart(lineData,lineOptions, true)

      else
        pieData = [
          { label: "Expenses (#{$scope.getCurrency()})", value: $scope.getCurrentExpenses() },
          { label: "Revenue (#{$scope.getCurrency()})", value: $scope.getCurrentRevenue() },
        ]
        pieOptions = {
          tooltipFontSize: 12,
          percentageInnerCutout: 0,
        }
        chartData = ChartFormatterSvc.pieChart(pieData, pieOptions, true)
      
      # calls chart.draw()
      $scope.drawTrigger.notify(chartData)


  # Widget is ready: can trigger the "wait for settigns to be ready"
  # --------------------------------------
  $scope.widgetDeferred.resolve(settingsPromises)
)

module.directive('widgetAccountsExpensesRevenue', ->
  return {
    restrict: 'A',
    controller: 'WidgetAccountsExpensesRevenueCtrl'
  }
)