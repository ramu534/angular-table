angular.module("angular-table").directive "atPagination", ["angularTableManager", (angularTableManager) ->
  {
    replace: true
    restrict: "E"

    template: "
      <div class='pagination' style='margin: 0px;'>
        <ul>
          <li ng-class='{disabled: #{irk_current_page} <= 0}'>
            <a href='' ng-click='go_to_page(#{irk_current_page} - 1)'>&laquo;</a>
          </li>
          <li ng-class='{active: #{irk_current_page} == page}' ng-repeat='page in pages'>
            <a href='' ng-click='go_to_page(page)'>{{page + 1}}</a>
          </li>
          <li ng-class='{disabled: #{irk_current_page} >= #{irk_number_of_pages} - 1}'>
            <a href='' ng-click='go_to_page(#{irk_current_page} + 1); normalize()'>&raquo;</a>
          </li>
        </ul>
      </div>"

    controller: ["$scope", "$element", "$attrs",
    ($scope, $element, $attrs) ->
      angularTableManager.register_pagination_scope($attrs.atTableId, $scope)
    ]

    scope: true

    link: ($scope, $element, $attributes) ->
      tc = angularTableManager.get_table_configuration($attributes.atTableId)

      $scope[irk_current_page] = 0

      update = (reset) ->
        $scope[irk_current_page] = 0

        if $scope[tc.list]
          if $scope[tc.list].length > 0
            $scope[irk_number_of_pages] = Math.ceil($scope[tc.list].length / $scope[tc.items_per_page])
            $scope.pages = for x in [0..($scope[irk_number_of_pages] - 1)]
              x
          else
            $scope[irk_number_of_pages] = 1
            $scope.pages = [0]

      normalizePage = (page) ->
        page = Math.max(0, page)
        page = Math.min($scope[irk_number_of_pages] - 1, page)
        page

      $scope.go_to_page = (page) ->
        $scope[irk_current_page] = normalizePage(page)

      update()

      $scope.$watch tc.items_per_page, () ->
        update()

      $scope.$watch tc.list, () ->
        update()

  }
]