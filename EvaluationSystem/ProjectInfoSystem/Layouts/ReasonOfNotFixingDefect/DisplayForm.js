
var app = angular.module('fixApp', []);

app.filter('jalaliDate', function () {
    return function (inputDate, format) {
        var date = moment(inputDate);
        return date.format(format);
    }
});


app.controller('fixCtrl', function ($scope, service, $q) {
    $scope.tableData = [];
    
    $scope.loading = true;
    $scope.listname = "DefectFailures";
    $scope.requestId = getUrlVars()['ID'];
    $scope.prvUrl = '/Lists/DefectFailures/AllItems.aspx';

    $q.all([service.getFixItem($scope.requestId), service.getFixItemDetails($scope.requestId), service.canApprove($scope.requestId,'DefectFailures'), service.getHistories($scope.requestId,'DefectFailures')]).then(function (d) {

        $scope.fixItem = d[0].data.d.results[0];
        $scope.fixItem.Items = d[1].data.d.results;
        $scope.canApprove = d[2].data.d;
        $scope.histories = d[3].data.d.histories;
        for (var i = 0; i < $scope.histories.length; i++) {
            $scope.histories[i].HistoryDate = moment($scope.histories[i].HistoryDate).format('jYYYY/jMM/jDD');

        }

        $scope.loading = false;
    });
   
   
       
    $scope.sumNetSurface = function ()
    {
        var sum = 0;
        if ($scope.fixItem) {
            if ($scope.fixItem.Items.length > 0)
                for (var i = 0; i < $scope.fixItem.Items.length; i++) {
                    sum += $scope.fixItem.Items[i].NetLevel;
                }
        }
        return sum;
    }
    $scope.sumDrainageSurface = function () {
        var sum = 0;
        if ($scope.fixItem) {
            if ($scope.fixItem.Items.length > 0)
                for (var i = 0; i < $scope.fixItem.Items.length; i++) {
                    sum += $scope.fixItem.Items[i].DrainageLevel;
                }
        }
        return sum;
    }
    $scope.sumEquippedSurface = function () {
        var sum = 0;
        if ($scope.fixItem) {
            if ($scope.fixItem.Items.length > 0)
                for (var i = 0; i < $scope.fixItem.Items.length; i++) {
                    sum += $scope.fixItem.Items[i].EquippedLevel;
                }
        }
        return sum;
    }
    $scope.validateCell = function () {
        var msg='';
        if ($scope.sumNetSurface() != $scope.NetReminedLevel)
            msg+='مجموع سطح شبکه باید با باقیمانده شبکه برابر باشد.';
        if ($scope.sumDrainageSurface() != $scope.DrainageReminedLevel)
            msg += 'مجموع سطح زهکشی باید با باقی مانده زهکشی برابر باشد ';
        if ($scope.sumEquippedSurface() != $scope.EquippedReminedLevel)
            msg += 'مجموع سطح تجهیز باید با باقی مانده تجهیز برابر باشد';
        return msg;
    }
    $scope.close = function () {
        window.location.href = $scope.prvUrl;
    }

    $scope.approve = function () {
        $scope.loading = true;
        if (!$scope.comment)
            $scope.comment = '';
        service.approve($scope.fixItem.Id, $scope.comment, $scope.listname).then(function (d) {
            if (d.data.d == "") {
                alert('رسیدگی به ارزیابی با موفقیت انجام شد');
                $scope.loading = false;
                window.location.href = $scope.prvUrl;
            }
            else {
                console.log(d);
                alert(d.data.d);
                $scope.loading = false;
            }

        }, function (d) {

            console.log(d);
            alert(d);
            $scope.loading = false;
        })
    }
    $scope.reject = function () {
        $scope.loading = true;
        if (!$scope.comment || $scope.comment == '') {
            alert('وارد نمودن توضیحات الزامی است.');
            $scope.loading = false;
        }
        else {
            service.reject($scope.fixItem.Id, $scope.comment, $scope.listname).then(function (d) {
                if (d.data.d == "") {
                    alert(' ارزیابی با موفقیت انجام شد');

                    $scope.loading = false;
                    window.location.href = $scope.prvUrl;
                }
                else {
                    console.log(d);
                    alert(d.data.d);
                    $scope.loading = false;

                }
            }, function (d) {

                console.log(d.data.d);

            })
        }
    }

});
