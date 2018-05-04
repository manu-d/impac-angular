module = angular.module('impac.components.common.trends-add',[])

module.component('trendsAdd', {
  templateUrl: 'common/trends-add.tmpl.html'
  bindings:
    onHide: '&'
    onCreateTrend: '&'
    accounts: '='
    chart: '='

  controller: ($scope, HighchartsFactory) ->
    ctrl = this

    ctrl.$onInit = ->
      ctrl.untilDatePicker =
        opened: false
        date: new Date()
        toggle: ->
          this.opened = true
      ctrl.startDatePicker =
        opened: false
        date: new Date()
        toggle: ->
          this.opened = true
      ctrl.trend =
        rate: 0
        period: "Daily"
        startDate: new Date()
        untilDate: -1
      ctrl.selectedPeriod = 1
      options = ctrl.chart.highChartOptions
      ctrl.addChart = new HighchartsFactory('trends-add-chart', ctrl.chart.series, options)
      ctrl.addChart.removeRangeSelector()
      ctrl.addChart.removeNavigator()
      ctrl.addChart.render()

    ctrl.period = ->
      switch ctrl.trend.period
        when "Once"
          ctrl.trend.untilDate = null
          ""
        when "Daily" then ("Day" + (if ctrl.selectedPeriod <= 1 then "" else "s"))
        when "Weekly" then ("Week" + (if ctrl.selectedPeriod <= 1 then "" else "s"))
        when "Monthly" then ("Month" + (if ctrl.selectedPeriod <= 1 then "" else "s"))
        when "Annually" then ("Year" + (if ctrl.selectedPeriod <= 1 then "" else "s"))

    ctrl.isPeriodDisabled = ->
      ctrl.trend.period == "Once"

    ctrl.isValid = ->
      !_.isEmpty(ctrl.trend.name) &&
      ctrl.trend.rate > 0 &&
      (ctrl.trend.untilDate? || ctrl.trend.period == "Once")

    ctrl.createTrend = ->
      ctrl.onHide()
      ctrl.trend.period = ctrl.trend.period.toLowerCase()
      ctrl.trend.account_id = ctrl.trend.account_id.id
      ctrl.onCreateTrend({ trend: ctrl.trend })

    ctrl.updateStartDate = ->
      ctrl.trend.startDate = ctrl.startDatePicker.date

    ctrl.updateUntilDate = ->
      ctrl.trend.untilDate = ctrl.untilDatePicker.date

    return ctrl
})
