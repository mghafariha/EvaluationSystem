﻿<%@ Assembly Name="$SharePoint.Project.AssemblyFullName$" %>
<%@ Import Namespace="Microsoft.SharePoint.ApplicationPages" %>
<%@ Register Tagprefix="SharePoint" Namespace="Microsoft.SharePoint.WebControls" Assembly="Microsoft.SharePoint, Version=15.0.0.0, Culture=neutral, PublicKeyToken=71e9bce111e9429c" %>
<%@ Register Tagprefix="Utilities" Namespace="Microsoft.SharePoint.Utilities" Assembly="Microsoft.SharePoint, Version=15.0.0.0, Culture=neutral, PublicKeyToken=71e9bce111e9429c" %>
<%@ Register Tagprefix="asp" Namespace="System.Web.UI" Assembly="System.Web.Extensions, Version=4.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35" %>
<%@ Import Namespace="Microsoft.SharePoint" %>
<%@ Assembly Name="Microsoft.Web.CommandUI, Version=15.0.0.0, Culture=neutral, PublicKeyToken=71e9bce111e9429c" %>
<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="EditForm.aspx.cs" Inherits="EvaluationSystem.Layouts.EvaluationSystem.Pages.EditForm" DynamicMasterPageFile="~masterurl/default.master" %>

<asp:Content ID="PageHead" ContentPlaceHolderID="PlaceHolderAdditionalPageHead" runat="server">
    <link href="../CSS/style3.css" rel="stylesheet" />
   
    <%--<link href="../CSS/disable-items.css" rel="stylesheet" />--%>

     <link href="../CSS/loading.css" rel="stylesheet" />
     <script src="../JS/jquery-1.11.3.min.js"></script>
    <script src="../JS/jquery-ui.js"></script>
    <script src="../JS/moment.js"></script>
    <script src="../JS/moment-jalaali.js"></script>
    <script src="../JS/angular.min.js"></script>
    <script src="../JS/angular-filter.js"></script>

    <script src="../JS/ui-bootstrap-tpls.js"></script>
   
   
    <script src="EditForm.js?v=1"></script>

    <script src="../JS/persianDatePicker.js"></script>
	<script src="../JS/bootstrap-datepicker.min.js"></script>
	<script src="../JS/bootstrap-datepicker.fa.min.js"></script>
    <script src="../JS/serverCall.js"></script>
    <script src="../JS/services.js"></script>
    <script src="../JS/QueryString.js"></script>
    <style>
        .disabeld {
        background-color:red
        }


        .red{
border-color:red;
color:red;
}
    </style>
</asp:Content>

<asp:Content ID="Main" ContentPlaceHolderID="PlaceHolderMain" runat="server">
    <asp:Literal runat="server" ID="lit1"></asp:Literal>


    <div ng-app="appEdit" ng-controller="ctrlEdit" dir="rtl">
        <div class="loading" ng-show="loading"></div>
   <div id="mycontainer">

    <div class="pageAppTitle">فرم ویرایش {{listFaName}}</div>
    <span ng-show="!isCompany">قرارداد</span>  
        <span ng-show="isCompany">شرکت</span>    
    <input ng-model="evalContract.contract"  disabled="disabled" />
        <span>دوره ارزیابی</span>
    <input ng-model="evalContract.period"  disabled="disabled"/>
            </div>
      <%-- <div>
                   <table  >
                    <thead>
                        <tr>
                            <th>گروه</th>
                            <th>معیار</th>
                            <th>ردیف</th>
                            <th>شاخص</th>
                            <th>وزن شاخص</th>
                            <th>امتیاز شاخص</th>
                            <th>موضوعیت ندارد</th>
                            <th>وزن معیار </th>
                            <th>امتیاز کل</th>
                          
                        </tr>
                    </thead>
                    <tbody>
                        <tr ng-repeat="itm in evalContract.details|orderBy:[groupIndex,rowIndex]"    ng-class="itm.isRelated? 'disabeld' : 'enabeld' " >
                            <td>{{itm.groupIndex}}</td>
                            <td>{{itm.criterion}}</td>
                            <td>{{itm.order}}</td>
                            <td>{{itm.index}}</td>
                            <td>{{itm.weight|number:2}}</td>
                
                            <td>
                                <input ng-model="itm.score" />

                            </td>
                            
                           <td>
                               <input  type="checkbox" ng-model="itm.isRelated" ng-change="notRelated(itm)"/>
                           </td>    
                            
                            <td>{{sumWeight(groupIndex)| number:2}}</td>
                            <td>{{totalScore(groupIndex)| number:2}}</td>

                        </tr>
                    </tbody>
                       <tfoot>

                       </tfoot>
                </table>
              </div>--%>


        <div>
                   <table class="container"   dir="rtl">
                    <thead class="sticky-box" >
                        <tr>
                           <th class="grop-th" >گروه</th>
                            <th class="gorp-index-th">معیار</th>
                             <th class="row-th" >ردیف</th>
                                        <th class="shakes-th" >شاخص</th>
                                        <th class="weight-th">وزن شاخص</th>
                                        <th class="score-th" >(0 تا 100)امتیاز شاخص</th>
                                        <th class="not-th" >موضوعیت ندارد</th>
                            <th class="weight-th-score" >وزن معیار </th>
                            <th class="total-score" >امتیاز کل</th>
                          
                        </tr>
                    </thead>
                    <tbody>
                                               
                        <tr ng-repeat="itm in groupIndexes" dir="rtl">
                            <td class="item-grop2">{{itm.groupIndex}}</td>
                            <td class="item-gropname2">{{itm.groupName}}</td>
                             <td colspan="5">
                                <table class="table table-responsive">
                                   
                                    <tr class="item-row" ng-repeat="e in itm.indexes"  ng-class="e.isRelated? 'disabeld' : 'enabeld'">
                                         <td class="my-roder-th2">{{e.order2}}</td>
                                         <td class="my-index" >{{e.index}}</td>
                                         <td class="my-weight-th2" >{{e.weight |number:2}}</td>
                                         <td class="input-score-th" ><input ng-model="e.score" ng-disabled="e.isRelated" ng-class="e.score % 5 !==0 ? 'red' : 'enabeld' " type='number' min=0 max=100 step='5' /></td>
                                         <td class="not-th2" >
                                           <input  type="checkbox" ng-model="e.isRelated" ng-change="notRelated(e)"/>
                                         </td>  
                                    </tr>
                                </table>
                            </td>
                            <td id="number-row" >{{sumWeight($index)|number:2}}</td>
                            <td id="number-row">{{totalScore($index) |number:2}}</td>

                        </tr>
                    </tbody>
                       <tfoot class="mytfoot" >
                           <td class="majmoo-display" colspan="4">مجموع</td>
                           <td class="footer-calss2" > {{sumCol('weight')|number:2}}</td>
                           <td class="footer-calss3" >{{sumCol('score')/100|number:2}}</td>
                           <td class="footer-calss4" ></td>
                           <td class="footer-calss5" >{{sumCol('weight')|number:2}}</t>
                           <td class="footer-calss6" >{{sumTotalCol()|number:2}}</td>
                       </tfoot>
                </table>
              </div>


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
								<td class="footer-history-1"  id="number-row" >{{($index)+1}}</td>
								<td class="footer-history-2" >{{s.UserName}}</td>
								<td class="footer-history-3" >{{s.state}}</td>
								<td class="footer-history-4" id="number-row">{{s.HistoryDate}}</td>
								<td class="footer-history-5" >{{s.Description}}</td>
							</tr>
						</tbody>
					</table>
	 </div>



       <div class="bottom-container">
            <input  type="button" value="ثبت موقت" ng-click="save(true)" /> 
            <input type="button"  value="ثبت"  ng-click="save(false)" />
            <input type="button" value="انصراف" ng-click="close()"/>

        </div>
    </div>


      <script type="text/javascript">
          var wrap = $("#s4-workspace");

          wrap.on("scroll", function (e) {

              if (this.scrollTop > 100) {
                  wrap.addClass("scroll");
              } else {
                  wrap.removeClass("scroll");
              }

          });
</script>

</asp:Content>

<asp:Content ID="PageTitle" ContentPlaceHolderID="PlaceHolderPageTitle" runat="server">
سامانه ارزشیابی
</asp:Content>

<asp:Content ID="PageTitleInTitleArea" ContentPlaceHolderID="PlaceHolderPageTitleInTitleArea" runat="server" >

</asp:Content>

