
var app = angular.module('fixApp', []);

app.filter('jalaliDate', function () {
    return function (inputDate, format) {
        var date = moment(inputDate);
        return date.format(format);
    }
});


app.controller('fixCtrl', function ($scope, service, $q) {
    $scope.tableData = [{}];
    
    $scope.loading = true;
    $scope.prvUrl = '/Lists/DefectFailures/AllItems.aspx';
    $q.all([service.getPeriods(), service.getContracts(), service.getReasonOfDefect()]).then(function (result) {

        $scope.periods = result[0].data.d.results; 
        $scope.contracts = result[1].data.d.results;
        $scope.resons = result[2].data.d.results;
        $scope.loading = false;
    })
   
    $scope.fillTmpDeliveries=function()
    {
        
            service.getTmpDeliveries($scope.contract.Id).then(function (result) {

                $scope.tmpDeliveries = result.data.d.results;


            })
       
      
    }
    $scope.fillProperties=function()
    {

        
        if (!$scope.period) {
            alert('لطفا دوره هفتگی را انتخاب نمایید');
        }
        else if(!$scope.contract){
            alert('لطفا پیمان را انتخاب نمایید');
        }
        else if (!$scope.tmpDelivery)
        {
            alert('لطفا تحویل موقت را انتخاب نمایید.');
        }
        else {
            $scope.showTable=true;
            $scope.NetDeliveryLevel = $scope.tmpDelivery.NetDeliveryLevel > 0 ? $scope.tmpDelivery.NetDeliveryLevel : 0;
            $scope.EquippedDeliveryLevel = $scope.tmpDelivery.EquippedDeliverylevel > 0 ? $scope.tmpDelivery.EquippedDeliverylevel : 0;
            $scope.DrainageDeliveryLevel = $scope.tmpDelivery.DrainageDeliverylevel > 0 ? $scope.tmpDelivery.DrainageDeliverylevel : 0;


           
            $scope.NetDefectDeliminationLevel =  0;
            $scope.EquippedDefectDeliminationLevel = 0;
            $scope.DrainageDefectDeliminationLevel = 0;
            $scope.NetDeadLineLevel = 0;
            $scope.EquippedDeadLineLevel = 0;
            $scope.DrainageDeadLineLevel = 0;
            $scope.NetReminedLevel = 0;
            $scope.EquippedReminedLevel = 0;
            $scope.DrainageReminedLevel = 0;
            service.getDefectDeliminations($scope.tmpDelivery.Id).then(function (result) {
                if (result.data.d.results.length > 0) {

                   
                    $scope.NetDefectDeliminationLevel = result.data.d.results[0].NetDeliveryLevel > 0 ? result.data.d.results[0].NetDeliveryLevel : 0;
                    $scope.EquippedDefectDeliminationLevel = result.data.d.results[0].EquippedDeliverylevel > 0 ? result.data.d.results[0].EquippedDeliverylevel : 0;
                    $scope.DrainageDefectDeliminationLevel = result.data.d.results[0].DrainageDeliverylevel > 0 ? result.data.d.results[0].DrainageDeliverylevel : 0;
                    $scope.NetDeadLineLevel = $scope.period.StartDate > $scope.tmpDelivery.DedlineDefectDeclarations ? 0 : $scope.tmpDelivery.NetDeliveryLevel;
                    $scope.EquippedDeadLineLevel = $scope.period.StartDate > $scope.tmpDelivery.DedlineDefectDeclarations ? 0 : $scope.tmpDelivery.EquippedDeliverylevel;
                    $scope.DrainageDeadLineLevel = $scope.period.StartDate > $scope.tmpDelivery.DedlineDefectDeclarations ? 0 : $scope.tmpDelivery.DrainageDeliverylevel;
                    $scope.NetReminedLevel = $scope.tmpDelivery.NetDeliveryLevel - $scope.NetDeadLineLevel;
                    $scope.EquippedReminedLevel = $scope.tmpDelivery.EquippedDeliverylevel - $scope.EquippedDeadLineLevel;
                    $scope.DrainageReminedLevel = $scope.tmpDelivery.DrainageDeliverylevel - $scope.DrainageDeadLineLevel;
                }
            })
        }
    }
    $scope.addRow = function ()
    {
        $scope.tableData.push({});
    }

    $scope.save = function () {
        $scope.loading = true;

        if ($scope.validateCell() != '') {
            alert($scope.validateCell());
            $scope.loading = false;
        }
        else {



            var fixItem = {};

            fixItem.Id = 0,
            fixItem.Titel = "",
            fixItem.Contract = $scope.contract.Title,
            fixItem.ContractId = $scope.contract.Id,

            fixItem.Period = $scope.period.Id,


            fixItem.TemporaryDelivery = $scope.tmpDelivery.Title;
            fixItem.TemporaryDeliveryId = $scope.tmpDelivery.Id;
            fixItem.NetDeliveryLevel =$scope.NetDeliveryLevel;
            fixItem.DrainageDeliveryLevel =$scope.DrainageDeliveryLevel;
            //
            fixItem.EquippedDeliveryLevel =$scope.EquippedDeliveryLevel;
            fixItem.NetDefectDeliminationLevel = $scope.NetDefectDeliminationLevel;
            fixItem.DrainageDefectDeliminationLevel = $scope.DrainageDefectDeliminationLevel;
            fixItem.EquippedDefectDeliminationLevel = $scope.EquippedDefectDeliminationLevel;
            //
            fixItem.NetDeadLineLevel = $scope.NetDeadLineLevel;
            fixItem.DrainageDeadLineLevel = $scope.DrainageDeadLineLevel;
            fixItem.EquippedDeadLineLevel = $scope.EquippedDeadLineLevel;
            //
            fixItem.NetReminedLevel = $scope.NetReminedLevel;
            fixItem.DrainageReminedLevel = $scope.DrainageReminedLevel;
            fixItem.EquippedReminedLevel = $scope.EquippedReminedLevel
            fixItem.items = [];


            for (var i = 0; i < $scope.tableData.length ; i++) {
                if ($scope.hasError($scope.tableData[i])) {
                    alert('مقادیر ورودی نمیتواند صفر و خالی باشد.');
                    $scope.loading = false;
                    return;
                }
                var fixDetailItem = {}
                fixDetailItem.Id = 0,
                fixDetailItem.Titel = "",
                fixDetailItem.NetLevel = $scope.tableData[i].netSurface,
                fixDetailItem.DrainageLevel = $scope.tableData[i].drainageSurface,
                fixDetailItem.EquippedLevel = $scope.tableData[i].equippedSurface,
                fixDetailItem.Reason = $scope.tableData[i].reason.Title,
                fixDetailItem.ReasonId = $scope.tableData[i].reason.Id,
                fixDetailItem.Description = $scope.tableData[i].desc;

                fixItem.items.push(fixDetailItem);
            }



            service.saveFixItem(fixItem).then(function (d) {
                $scope.loading = false;
                if (d.data.d == "") {
                    alert('اطلاعات با موفقیت ذخیره شد');
                    $scope.loading = false;
                    window.location = $scope.prvUrl;
                }
                else {
                    alert("خطا در ذخیره سازی اطلاعات" + d.data.d);
                    console.log(d.data.d);
                    $scope.loading = false;
                }
            },
            function (d) {

                console.log(d);
            });
        }
    }
       
    $scope.sumNetSurface = function ()
    {
        var sum = 0;
        if($scope.tableData.length>0)
        for (var i = 0; i < $scope.tableData.length; i++)
        {

            sum += ($scope.tableData[i].netSurface>0?$scope.tableData[i].netSurface:0);
        }
        return sum;
    }
    $scope.sumDrainageSurface = function () {
        var sum = 0;
        if ($scope.tableData.length > 0)
        for (var i = 0; i < $scope.tableData.length; i++) {
            sum +=( $scope.tableData[i].drainageSurface>0?$scope.tableData[i].drainageSurface:0);
        }
        return sum;
    }
    $scope.sumEquippedSurface = function () {
        var sum = 0;
        if ($scope.tableData.length > 0)
        for (var i = 0; i < $scope.tableData.length; i++) {
            sum += ($scope.tableData[i].equippedSurface>0?$scope.tableData[i].equippedSurface:0);
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
    $scope.hasError=function(item)
    {
        if ((item.netSurface <= 0 && item.drainageSurface <= 0 && item.equippedSurface <= 0) || (item.reason == '' || !item.reason) || (item.netSurface < 0 || item.drainageSurface < 0 || item.equippedSurface < 0))

            return true;
        else return false;
    }
});
