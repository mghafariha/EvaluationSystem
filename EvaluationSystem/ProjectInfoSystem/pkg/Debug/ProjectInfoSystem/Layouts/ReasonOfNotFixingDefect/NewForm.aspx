<%@ Assembly Name="ProjectInfoSystem, Version=1.0.0.0, Culture=neutral, PublicKeyToken=e1d8bb0b77db53e9" %>
<%@ Import Namespace="Microsoft.SharePoint.ApplicationPages" %>
<%@ Register TagPrefix="SharePoint" Namespace="Microsoft.SharePoint.WebControls" Assembly="Microsoft.SharePoint, Version=15.0.0.0, Culture=neutral, PublicKeyToken=71e9bce111e9429c" %>
<%@ Register TagPrefix="Utilities" Namespace="Microsoft.SharePoint.Utilities" Assembly="Microsoft.SharePoint, Version=15.0.0.0, Culture=neutral, PublicKeyToken=71e9bce111e9429c" %>
<%@ Register TagPrefix="asp" Namespace="System.Web.UI" Assembly="System.Web.Extensions, Version=4.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35" %>
<%@ Import Namespace="Microsoft.SharePoint" %>
<%@ Assembly Name="Microsoft.Web.CommandUI, Version=15.0.0.0, Culture=neutral, PublicKeyToken=71e9bce111e9429c" %>

<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="NewForm.aspx.cs" Inherits="ProjectInfoSystem.Layouts.ReasonOfNotFixingDefect.NewForm" DynamicMasterPageFile="~masterurl/default.master" %>

<asp:Content ID="PageHead" ContentPlaceHolderID="PlaceHolderAdditionalPageHead" runat="server">
   
     <link href="/_layouts/15/ProjectInfoSystem/CSS/loading.css" rel="stylesheet" />
    <link href="/_layouts/15/ProjectInfoSystem/CSS/style3.css" rel="stylesheet" />
    <script src="/_layouts/15/ProjectInfoSystem/JS/jquery-3.2.1.min.js"></script>
    <script src="/_layouts/15/ProjectInfoSystem/JS/moment.js"></script>
    <script src="/_layouts/15/ProjectInfoSystem/JS/moment-jalaali.js"></script>
    <script src="/_layouts/15/ProjectInfoSystem/JS/angular.min.js"></script>
    <script src="NewForm.js"></script>
    <script src="/_layouts/15/ProjectInfoSystem/JS/service.js"></script>
    <script src="/_layouts/15/ProjectInfoSystem/JS/serverCall.js"></script>

    <style>
        .error {
            border: solid 1px red !important;
        }
    </style>
</asp:Content>

<asp:Content ID="Main" ContentPlaceHolderID="PlaceHolderMain" runat="server">
    <div ng-app="fixApp" ng-controller="fixCtrl">

        <div id="select">

            <div class="loading" ng-show="loading"></div>
            <div id="mycontainer" style="padding-right: 19%;">
                <div class="newhead-priod">
                    <span>دوره </span>
                    <select  ng-model="period" ng-options="x.Title for x in periods"></select>

                    <div ng-show="period" class="show-date fade-in-out" ng-style="animation">تاریخ شروع : {{period.StartDate | jalaliDate:'jYYYY/jMM/jDD' }}</div>
                    <div ng-show="period" class="show-date fade-in-out" ng-style="animation">تاریخ پایان: {{period.EndDate | jalaliDate:'jYYYY/jMM/jDD' }}</div>

                </div>
                <div class="newhead-contract">
                    <span>پیمان</span>
                    <select ng-model="contract" ng-change="fillTmpDeliveries()" ng-options="x.Title for x in contracts"></select>
                </div>
               <div class="newhead-delivery">
                    <span>تحويل موقت</span>                                      
                    <select ng-model="tmpDelivery" ng-options="x.Title for x in tmpDeliveries"></select>
                </div>
                <input type="button" id="show-operation" value="اعمال فیلتر" ng-click="fillProperties()"/>
           </div>
            </div>
             <div ng-show="showTable">
                 <table class="container" dir="rtl"  style="width:30%">
                     <thead>
                         <tr>
                             <th class="item-run">عنوان</th>
                             <th class="item-run">شبکه</th>
                             <th class="item-run">زهکش</th>
                             <th class="item-run">تجهیز</th>

                         </tr>
                     </thead>
                     <tbody>
                         <tr>
                             <td>سطح تحویل</td>
                             <td>{{NetDeliveryLevel}}</td>
                             <td>{{DrainageDeliveryLevel}}</td>
                             <td>{{EquippedDeliveryLevel}}</td>
                         </tr>
                         <tr>
                             <td>سطح رفع نقص </td>
                             <td>{{NetDefectDeliminationLevel}}</td>
                             <td>{{DrainageDefectDeliminationLevel}}</td>
                             <td>{{EquippedDefectDeliminationLevel}}</td>

                         </tr>
                         <tr>
                            <td>سطح تعهد رفع نقص تاکنون</td>
                             <td>{{NetDeadLineLevel}}</td>
                             <td>{{DrainageDeadLineLevel}}</td>
                             <td>{{EquippedDeadLineLevel}}</td>
                         </tr>
                         <tr>
                             <td>باقی مانده تعهد رفع نقص</td>
                             <td>{{NetReminedLevel}}</td>
                             <td>{{DrainageReminedLevel}}</td>
                             <td>{{EquippedReminedLevel}}</td>
                         </tr>
                     </tbody>
                 </table>
               
   <input type="button" value="اضافه کردن مورد" ng-click="addRow()" ng-show="tmpDelivery"/>
            <table  class="container"dir="rtl" ng-show="tableData.length>0" style="width:65%" >
                <thead>
                    <tr>
                        <th class="operation-run" >رديف</th>
                        <th class="item-run">سطح شبکه</th>
                        <th class="item-run">سطح زهکش زیرزمینی</th>
                        <th class="item-run">سطح تجهیز و نوسازی</th>
                        <th class="item-run">دلیل عدم رفع نقص</th>
                        <th tyle="width:30%" >توضیحات</th>
                       
                    </tr>
                </thead>
                <tbody>
                    <tr ng-repeat="r in tableData ">
                        <td>{{$index+1}}</td>
                        <td> <input type="number" ng-model="r.netSurface"/></td>
                        <td> <input type="number" ng-model="r.drainageSurface"/></td>
                        <td> <input type="number" ng-model="r.equippedSurface"/></td>
                        <td> <select  ng-model="r.reason" ng-options="x.Title for x in resons"></select></td>
                        <td> <textarea ng-model="r.desc" rows="2"></textarea></td>
                       
                    </tr>
                    <tr>
                        <td>مجموع</td>
                        <td>{{sumNetSurface()}}</td>
                        <td>{{sumDrainageSurface()}}</td>
                        <td>{{sumEquippedSurface()}}</td>
                        <td></td>
                        <td></td>
                    </tr>
                </tbody>
            </table>
           
 
        <div class="footer-botten">
            <input  type="button" ng-click="close()" value="انصراف" />
            <input ng-show="tableData.length>0" type="button" ng-click="save()" value="ثبت" />
          

        </div>
        </div>
    </div>
</asp:Content>

<asp:Content ID="PageTitle" ContentPlaceHolderID="PlaceHolderPageTitle" runat="server">
    فرم دلایل عدم رفع نقص
</asp:Content>

<asp:Content ID="PageTitleInTitleArea" ContentPlaceHolderID="PlaceHolderPageTitleInTitleArea" runat="server">
   فرم دلایل عدم رفع نقص
</asp:Content>
