module = angular.module('impac.components.common.transactions-list',[])

module.component('transactionsList', {
  templateUrl: 'common/transactions-list.tmpl.html'
  bindings:
    onHide: '&'
    onPageChanged: '&'
    onUpdateExpectedDate: '&'
    onChangeResources: '&'
    onChangeOverdueFilter: '&'
    onDeleteTransaction: '&'
    onChangeQuery: '&'
    transactions: '<'
    showOverdueFilter: '<'
    currency: '<'
    totalRecords: '<'
    resourcesType: '<'
    overdueFilter: '<'
    listOnly: '<'
    hideForecast: '<'
    query: '<'
    delayTimer: '<'
  controller: ->
    ctrl = this

    ctrl.$onInit = ->
      ctrl.currentPage = 1
      ctrl.showOverdueFilter = true if not ctrl.showOverdueFilter?
      ctrl.calculateTotals()

    ctrl.changeResourcesType = ->
      ctrl
        .onChangeResources({ resourcesType: ctrl.resourcesType })
        .then(-> ctrl.$onInit())

    ctrl.changeOverdueFilter = ->
      ctrl
        .onChangeOverdueFilter({ overdueFilter: ctrl.overdueFilter })
        .then(-> ctrl.$onInit())

    ctrl.changeQuery = ->
      clearTimeout(ctrl.delayTimer);
      ctrl.delayTimer = setTimeout ->
        ctrl
          .onChangeQuery({ query: ctrl.query })
          .then(-> ctrl.$onInit())
      , 1000

    ctrl.changePage = ->
      ctrl
        .onPageChanged({page: ctrl.currentPage})
        .then(-> ctrl.calculateTotals())

    ctrl.changeExpectedDate = (trx) ->
      trx.showReset = true
      ctrl.onUpdateExpectedDate({ trxId: trx.id, date: trx.datePicker.date })

    ctrl.resetExpectedDate = (trx) ->
      trx.showReset = false
      m = moment.utc(trx.due_date)
      expDate = new Date(m.year(), m.month(), m.date())
      trx.datePicker.date = expDate
      ctrl.onUpdateExpectedDate({ trxId: trx.id, date: trx.datePicker.date })

    ctrl.calculateTotals = () ->
      # Moved logic from initialize to support recalculation on page change.
      ctrl.totalAmount = 0.0
      ctrl.totalBalance = 0.0

      for trx in ctrl.transactions
        ctrl.totalAmount += trx.amount
        ctrl.totalBalance += trx.balance
        ctrl.formatDate(trx)

    ctrl.formatDate = (trx) ->
      # dates are sent in UTC by the API
      trx.trxDateUTC = moment.utc(trx.transaction_date).format('DD MMM YYYY')
      trx.dueDateUTC = moment.utc(trx.due_date).format('DD MMM YYYY')

      unless ctrl.listOnly
        trx.showReset = (trx.due_date != trx.expected_payment_date)
        m = moment.utc(trx.expected_payment_date)
        trx.datePicker =
          opened: false
          # JS Date object is required by uib-datepicker-tooltip
          date: new Date(m.year(), m.month(), m.date())
          toggle: ->
            this.opened = !this.opened

    return ctrl
})
