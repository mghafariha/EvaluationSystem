<%@ Assembly Name="$SharePoint.Project.AssemblyFullName$" %>
<%@ Import Namespace="Microsoft.SharePoint.ApplicationPages" %>
<%@ Register Tagprefix="SharePoint" Namespace="Microsoft.SharePoint.WebControls" Assembly="Microsoft.SharePoint, Version=15.0.0.0, Culture=neutral, PublicKeyToken=71e9bce111e9429c" %>
<%@ Register Tagprefix="Utilities" Namespace="Microsoft.SharePoint.Utilities" Assembly="Microsoft.SharePoint, Version=15.0.0.0, Culture=neutral, PublicKeyToken=71e9bce111e9429c" %>
<%@ Register Tagprefix="asp" Namespace="System.Web.UI" Assembly="System.Web.Extensions, Version=4.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35" %>
<%@ Import Namespace="Microsoft.SharePoint" %>
<%@ Assembly Name="Microsoft.Web.CommandUI, Version=15.0.0.0, Culture=neutral, PublicKeyToken=71e9bce111e9429c" %>
<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="DisplayForm.aspx.cs" Inherits="ProjectInfoSystem.Layouts.ReasonOfNotFixingDefect.DisplayForm" DynamicMasterPageFile="~masterurl/default.master" %>

<asp:Content ID="PageHead" ContentPlaceHolderID="PlaceHolderAdditionalPageHead" runat="server">
   
     <link href="/_layouts/15/ProjectInfoSystem/CSS/loading.css" rel="stylesheet" />
    <link href="/_layouts/15/ProjectInfoSystem/CSS/style3.css" rel="stylesheet" />
    <script src="/_layouts/15/ProjectInfoSystem/JS/jquery-3.2.1.min.js"></script>
    <script src="/_Layouts/15/ProjectInfoSystem/JS/QueryString.js"></script>
    <script src="/_layouts/15/ProjectInfoSystem/JS/moment.js"></script>
    <script src="/_layouts/15/ProjectInfoSystem/JS/moment-jalaali.js"></script>
    <script src="/_layouts/15/ProjectInfoSystem/JS/angular.min.js"></script>
    <script src="DisplayForm.js"></script>
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

                <div class="newhead-priod" >
                   <span>دوره </span>
                   <div id="period" class="display-head-data" >{{fixItem.Period.Title}}</div>

                     <div ng-show="period" class="show-date fade-in-out" ng-style="animation">تاریخ شروع : {{period.StartDate | jalaliDate:'jYYYY/jMM/jDD' }}</div>
                    <div ng-show="period" class="show-date fade-in-out" ng-style="animation">تاریخ پایان: {{period.EndDate | jalaliDate:'jYYYY/jMM/jDD' }}</div>
               </div>
               <div class="newhead-contract" >
                   <span>پیمان</span>
                   <div id="contract" class="display-head-data"  >{{fixItem.Contract.Title}}</div>
                </div>

                
               <div class="newhead-delivery">
                    <span>تحويل موقت</span>    
                   <div id="tmpDelivery" class="display-head-data">{{fixItem.TemporaryDelivery.Title}}</div>                                  
                    
                </div>
                </div>
            </div>
                
             <div >
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
                             <td>{{fixItem.NetDeliveryLevel}}</td>
                             <td>{{fixItem.DrainageDeliveryLevel}}</td>
                             <td>{{fixItem.EquippedDeliveryLevel}}</td>
                         </tr>
                         <tr>
                             <td>سطح رفع نقص </td>
                             <td>{{fixItem.NetDefectDeliminationLevel}}</td>
                             <td>{{fixItem.DrainageDefectDeliminationLevel}}</td>
                             <td>{{fixItem.EquippedDefectDeliminationLevel}}</td>

                         </tr>
                         <tr>
                            <td>سطح تعهد رفع نقص تاکنون</td>
                             <td>{{fixItem.NetDeadLineLevel}}</td>
                             <td>{{fixItem.DrainageDeadLineLevel}}</td>
                             <td>{{fixItem.EquippedDeadLineLevel}}</td>
                         </tr>
                         <tr>
                             <td>باقی مانده تعهد رفع نقص</td>
                             <td>{{fixItem.NetReminedLevel}}</td>
                             <td>{{fixItem.DrainageReminedLevel}}</td>
                             <td>{{fixItem.EquippedReminedLevel}}</td>
                         </tr>
                     </tbody>
                 </table>
               
  
                  <table  class="container"dir="rtl"  style="width:65%" >
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
                    <tr ng-repeat="r in fixItem.Items ">
                        <td>{{$index+1}}</td>
                        <td>{{r.NetLevel}}</td>
                        <td>{{r.DrainageLevel}}</td>
                        <td>{{r.EquippedLevel}}</td>
                        <td>{{r.Reason.Title}}</td>
                        <td>{{r.Description}}</td>
                       
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
                 <div id="historydiv" ng-if="histories.length>0">
					<table class="container history" >
						<thead>
							<tr>
								<th>ردیف</th>
								<th>کاربر</th>
								<th>رویداد</th>
								<th>تاریخ</th>
								<th>توضیحات</th>
							</tr>
						</thead>
						<tbody>
							<tr ng-repeat="s in histories">
								<td class="footer-history-1" id="number-row" >{{($index)+1}}</td>
								<td class="footer-history-2">{{s.UserName}}</td>
								<td class="footer-history-3">{{s.state}}</td>
								<td class="footer-history-4" id="number-row">{{s.HistoryDate}}</td>
								<td class="footer-history-5">{{s.Description}}</td>
							</tr>
						</tbody>
                        
					</table>
	 </div>
           
            </div>
       
         <div class="bottom-container">
       
            <input ng-show="canApprove!=-1"  ng-model="comment" class="form-coment" ></input>
            <div id="form-botem">
                 <input type="button" ng-click="close()" value="انصراف" />
               
                <input ng-show="canApprove!=-1" type="button" value="رد" ng-click="reject()" />
                 <input ng-show="canApprove!=-1" type="button" value="تایید" ng-click="approve()" />
               
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

