 ;BEDDAPPL.EDWarning.1
 ;(C)InterSystems, generated for class BEDDAPPL.EDWarning.  Do NOT edit. 10/29/2015 07:58:24AM
 ;;326A5365;BEDDAPPL.EDWarning
 ;
%ApplyURLParms() public {
 Set tSC = 1
 If $IsObject($G(%request)) {
  Set ..dlID = $G(%request.Data("dlID",1),..dlID)
  If (..dlID '= "") {
   Set tSC = ..dlIDIsValid(..dlID)
   If ('tSC) Quit $$Error^%apiOBJ(5001,"Invalid URL parameter: dlID")
  }
 }
 Quit tSC }
%CreateApplication(pStatus) public {
 Set pStatus = 1
 Quit ##class(BEDDAPPL.EDManager).%New()
}
%CreatePage() public {
 Set:'$IsObject($G(%application)) %application = ..%CreateApplication(.tAppStatus)
 Set:'$IsObject($G(%application)) %application = ##class(%ZEN.application).%New()
 Set %application.%StatusCode = tAppStatus
 Set tPage = ""
 Set pg1 = ..%New()
 Set %page = pg1
 Do %page.%ApplyURLParms()
 Set pg1.nextIndex=1
 Set pg1.title="ED Dashboard Warnings"
 Set EDMn2 = ##class(BEDDAPPL.EDMenu).%New()
 Set EDMn2.width="100%"
 Do pg1.%AddChild(EDMn2)
 Set hgrp2 = ##class(%ZEN.Component.hgroup).%New()
 Set hgrp2.width="100%"
 Do pg1.%AddChild(hgrp2)
 Set vgrp3 = ##class(%ZEN.Component.vgroup).%New()
 Set vgrp3.width="2%"
 Do hgrp2.%AddChild(vgrp3)
 Set vgrp3 = ##class(%ZEN.Component.vgroup).%New()
 Set vgrp3.width="94%"
 Do hgrp2.%AddChild(vgrp3)
 Set spcr4 = ##class(%ZEN.Component.spacer).%New()
 Set spcr4.width=2
 Do vgrp3.%AddChild(spcr4)
 Set tblNvgtr4 = ##class(%ZEN.Component.tableNavigator).%New()
 Set tblNvgtr4.id="warnNav"
 Set tblNvgtr4.tablePaneId="warnTable"
 Do vgrp3.%AddChild(tblNvgtr4)
 Set spcr4 = ##class(%ZEN.Component.spacer).%New()
 Set spcr4.width=2
 Do vgrp3.%AddChild(spcr4)
 Set tblPn4 = ##class(%ZEN.Component.tablePane).%New()
 Set tblPn4.id="warnTable"
 Set tblPn4.caption="Warnings"
 Set clmn5 = ##class(%ZEN.Auxiliary.column).%New()
 Set clmn5.colName="ID"
 Set clmn5.hidden=1
 Do tblPn4.columns.Insert(clmn5)
 Do:$IsObject(%page) %page.%AddComponent(clmn5)
 Set clmn5 = ##class(%ZEN.Auxiliary.column).%New()
 Set clmn5.colName="EDStatus"
 Set clmn5.filterType="text"
 Set clmn5.header="EDStatus"
 Set clmn5.width="8%"
 Do tblPn4.columns.Insert(clmn5)
 Do:$IsObject(%page) %page.%AddComponent(clmn5)
 Set clmn5 = ##class(%ZEN.Auxiliary.column).%New()
 Set clmn5.colName="WaitTime"
 Set clmn5.header="WaitTime"
 Set clmn5.width="6%"
 Do tblPn4.columns.Insert(clmn5)
 Do:$IsObject(%page) %page.%AddComponent(clmn5)
 Set clmn5 = ##class(%ZEN.Auxiliary.column).%New()
 Set clmn5.colName="Color"
 Set clmn5.header="Color"
 Set clmn5.width="8%"
 Do tblPn4.columns.Insert(clmn5)
 Do:$IsObject(%page) %page.%AddComponent(clmn5)
 Set clmn5 = ##class(%ZEN.Auxiliary.column).%New()
 Set clmn5.colName="NotifyMgr"
 Set clmn5.header="Contact Name:"
 Set clmn5.width="12%"
 Do tblPn4.columns.Insert(clmn5)
 Do:$IsObject(%page) %page.%AddComponent(clmn5)
 Set clmn5 = ##class(%ZEN.Auxiliary.column).%New()
 Set clmn5.colName="NotifyByEmail"
 Set clmn5.header="Email"
 Set clmn5.width="20%"
 Do tblPn4.columns.Insert(clmn5)
 Do:$IsObject(%page) %page.%AddComponent(clmn5)
 Set clmn5 = ##class(%ZEN.Auxiliary.column).%New()
 Set clmn5.colName="NotifyByPager"
 Set clmn5.header="Pager"
 Set clmn5.width="12%"
 Do tblPn4.columns.Insert(clmn5)
 Do:$IsObject(%page) %page.%AddComponent(clmn5)
 Set clmn5 = ##class(%ZEN.Auxiliary.column).%New()
 Set clmn5.colName="StartTm"
 Set clmn5.header="Start Time"
 Set clmn5.width="8%"
 Do tblPn4.columns.Insert(clmn5)
 Do:$IsObject(%page) %page.%AddComponent(clmn5)
 Set clmn5 = ##class(%ZEN.Auxiliary.column).%New()
 Set clmn5.colName="EndTm"
 Set clmn5.header="End Time"
 Set clmn5.width="8%"
 Do tblPn4.columns.Insert(clmn5)
 Do:$IsObject(%page) %page.%AddComponent(clmn5)
 Set tblPn4.extraColumnWidth="3%"
 Set tblPn4.maxRows=1000
 Set tblPn4.onselectrow="zenPage.rowSelected(zenThis);"
 Set tblPn4.orderByClause="EDStatus,WaitTime"
 Set tblPn4.pageSize=15
 Set tblPn4.showRowNumbers=1
 Set tblPn4.showZebra=1
 Set tblPn4.tableName="BEDD.EDWarning"
 Set tblPn4.useSnapshot=1
 Set tblPn4.valueColumn="ID"
 Set tblPn4.width="1000px"
 Do vgrp3.%AddChild(tblPn4)
 Set vgrp3 = ##class(%ZEN.Component.vgroup).%New()
 Set vgrp3.width="2%"
 Do hgrp2.%AddChild(vgrp3)
 Set spcr2 = ##class(%ZEN.Component.spacer).%New()
 Set spcr2.width=10
 Do pg1.%AddChild(spcr2)
 Set dtCntrllr2 = ##class(%ZEN.Auxiliary.dataController).%New()
 Set dtCntrllr2.id="warnData"
 Set dtBg3 = ##class(%ZEN.Auxiliary.dataBag).%New()
 Set dtCntrllr2.dataBag = dtBg3
 Set dtBg3.parent = dtCntrllr2
 Do:$IsObject(%page) %page.%AddComponent(dtBg3)
 Set dtCntrllr2.modelClass="BEDDAPPL.EDWarningModel"
 Do pg1.%AddChild(dtCntrllr2)
 Set spcr2 = ##class(%ZEN.Component.spacer).%New()
 Set spcr2.width=5
 Do pg1.%AddChild(spcr2)
 Set fldSt2 = ##class(%ZEN.Component.fieldSet).%New()
 Set fldSt2.id="warnFormGroup"
 Set fldSt2.legend="Warning Setup"
 Do pg1.%AddChild(fldSt2)
 Set frm3 = ##class(%ZEN.Component.form).%New()
 Set frm3.id="warnForm"
 Set frm3.cellStyle="padding: 2px; padding-left: 5px; padding-right: 5px;"
 Set frm3.controllerId="warnData"
 Do fldSt2.%AddChild(frm3)
 Set hgrp4 = ##class(%ZEN.Component.hgroup).%New()
 Do frm3.%AddChild(hgrp4)
 Set vgrp5 = ##class(%ZEN.Component.vgroup).%New()
 Set vgrp5.width=20
 Do hgrp4.%AddChild(vgrp5)
 Set hgrp6 = ##class(%ZEN.Component.hgroup).%New()
 Do vgrp5.%AddChild(hgrp6)
 Set cmbbx7 = ##class(%ZEN.Component.combobox).%New()
 Set cmbbx7.id="EDStatus"
 Set cmbbx7.name="EDStatus"
 Set cmbbx7.dataBinding="EDStatus"
 Set cmbbx7.label="EDStatus:"
 Set ptn8 = ##class(%ZEN.Auxiliary.option).%New()
 Set ptn8.text="Check-In"
 Set ptn8.value="Check In"
 Do cmbbx7.options.Insert(ptn8)
 Do:$IsObject(%page) %page.%AddComponent(ptn8)
 Set ptn8 = ##class(%ZEN.Auxiliary.option).%New()
 Set ptn8.text="Triage"
 Set ptn8.value="Triage"
 Do cmbbx7.options.Insert(ptn8)
 Do:$IsObject(%page) %page.%AddComponent(ptn8)
 Set ptn8 = ##class(%ZEN.Auxiliary.option).%New()
 Set ptn8.text="Room Management"
 Set ptn8.value="Room Management"
 Do cmbbx7.options.Insert(ptn8)
 Do:$IsObject(%page) %page.%AddComponent(ptn8)
 Do hgrp6.%AddChild(cmbbx7)
 Set spcr7 = ##class(%ZEN.Component.spacer).%New()
 Set spcr7.width=10
 Do hgrp6.%AddChild(spcr7)
 Set txt7 = ##class(%ZEN.Component.text).%New()
 Set txt7.id="WaitTime"
 Set txt7.name="WaitTime"
 Set txt7.dataBinding="WaitTime"
 Set txt7.label="Exceeds Wait Time (mins):"
 Set txt7.size=10
 Do hgrp6.%AddChild(txt7)
 Set spcr7 = ##class(%ZEN.Component.spacer).%New()
 Set spcr7.width=10
 Do hgrp6.%AddChild(spcr7)
 Set rdSt7 = ##class(%ZEN.Component.radioSet).%New()
 Set rdSt7.id="Color"
 Set rdSt7.name="Color"
 Set rdSt7.dataBinding="Color"
 Set rdSt7.displayList="yellow,green,blue,red"
 Set rdSt7.label="Color:"
 Set rdSt7.valueList="yellow,green,blue,red"
 Do hgrp6.%AddChild(rdSt7)
 Set spcr7 = ##class(%ZEN.Component.spacer).%New()
 Set spcr7.width=10
 Do hgrp6.%AddChild(spcr7)
 Set hgrp4 = ##class(%ZEN.Component.hgroup).%New()
 Do frm3.%AddChild(hgrp4)
 Set spcr5 = ##class(%ZEN.Component.spacer).%New()
 Set spcr5.width=10
 Do hgrp4.%AddChild(spcr5)
 Set vgrp5 = ##class(%ZEN.Component.vgroup).%New()
 Do hgrp4.%AddChild(vgrp5)
 Set hgrp6 = ##class(%ZEN.Component.hgroup).%New()
 Do vgrp5.%AddChild(hgrp6)
 Set txt7 = ##class(%ZEN.Component.text).%New()
 Set txt7.id="NotifyMgr"
 Set txt7.name="NotifyMgr"
 Set txt7.dataBinding="NotifyMgr"
 Set txt7.label="Contact:"
 Set txt7.size=20
 Do hgrp6.%AddChild(txt7)
 Set spcr7 = ##class(%ZEN.Component.spacer).%New()
 Set spcr7.width=10
 Do hgrp6.%AddChild(spcr7)
 Set txt7 = ##class(%ZEN.Component.text).%New()
 Set txt7.id="NotifyByEmail"
 Set txt7.name="NotifyByEmail"
 Set txt7.dataBinding="NotifyByEmail"
 Set txt7.label="Email:"
 Set txt7.size=25
 Do hgrp6.%AddChild(txt7)
 Set spcr7 = ##class(%ZEN.Component.spacer).%New()
 Set spcr7.width=10
 Do hgrp6.%AddChild(spcr7)
 Set txt7 = ##class(%ZEN.Component.text).%New()
 Set txt7.id="NotifyByPager"
 Set txt7.name="NotifyByPager"
 Set txt7.dataBinding="NotifyByPager"
 Set txt7.label="Pager:"
 Set txt7.size=15
 Do hgrp6.%AddChild(txt7)
 Set spcr7 = ##class(%ZEN.Component.spacer).%New()
 Set spcr7.width=10
 Do hgrp6.%AddChild(spcr7)
 Set txt7 = ##class(%ZEN.Component.text).%New()
 Set txt7.id="StartTm"
 Set txt7.name="StartTm"
 Set txt7.dataBinding="StartTm"
 Set txt7.label="Starting Time:"
 Set txt7.size=12
 Do hgrp6.%AddChild(txt7)
 Set spcr7 = ##class(%ZEN.Component.spacer).%New()
 Set spcr7.width=10
 Do hgrp6.%AddChild(spcr7)
 Set txt7 = ##class(%ZEN.Component.text).%New()
 Set txt7.id="EndTm"
 Set txt7.name="EndTm"
 Set txt7.dataBinding="EndTm"
 Set txt7.label="Ending:"
 Set txt7.size=12
 Do hgrp6.%AddChild(txt7)
 Set spcr7 = ##class(%ZEN.Component.spacer).%New()
 Set spcr7.width=10
 Do hgrp6.%AddChild(spcr7)
 Set hgrp4 = ##class(%ZEN.Component.hgroup).%New()
 Do frm3.%AddChild(hgrp4)
 Set spcr5 = ##class(%ZEN.Component.spacer).%New()
 Set spcr5.width=10
 Do hgrp4.%AddChild(spcr5)
 Set vgrp5 = ##class(%ZEN.Component.vgroup).%New()
 Do hgrp4.%AddChild(vgrp5)
 Set hgrp6 = ##class(%ZEN.Component.hgroup).%New()
 Do vgrp5.%AddChild(hgrp6)
 Set bttn7 = ##class(%ZEN.Component.button).%New()
 Set bttn7.caption="Save"
 Set bttn7.onclick="zenPage.saveEntry();"
 Do hgrp6.%AddChild(bttn7)
 Set spcr7 = ##class(%ZEN.Component.spacer).%New()
 Set spcr7.width=2
 Do hgrp6.%AddChild(spcr7)
 Set bttn7 = ##class(%ZEN.Component.button).%New()
 Set bttn7.caption="Add"
 Set bttn7.onclick="zenPage.newEntry();"
 Do hgrp6.%AddChild(bttn7)
 Set spcr7 = ##class(%ZEN.Component.spacer).%New()
 Set spcr7.width=2
 Do hgrp6.%AddChild(spcr7)
 Set bttn7 = ##class(%ZEN.Component.button).%New()
 Set bttn7.caption="Delete"
 Set bttn7.onclick="zenPage.deleteEntry();"
 Do hgrp6.%AddChild(bttn7)
 Do ..%GetDependentComponents(pg1)
 Quit pg1 }
%DrawClassDefinition() public {
 Write !
 Write "self._zenClassIdx['EDWarning'] = 'BEDDAPPL_EDWarning';",!
 Write "self.BEDDAPPL_EDWarning = function(index,id) {",!
 Write $C(9),"if (index>=0) {BEDDAPPL_EDWarning__init(this,index,id);}",!
 Write "}",!
 Write !
 Write "self.BEDDAPPL_EDWarning__init = function(o,index,id) {",!
 Write $C(9),"('undefined' == typeof _ZEN_Component_page__init) ?"
 Write "zenMaster._ZEN_Component_page__init(o,index,id)"
 Write ":"
 Write "_ZEN_Component_page__init(o,index,id);",!
 Write $C(9),"o.dlID = '"_$ZCVT("","O","JS")_"';",!
 Write $C(9),"o.useSoftModals = ",$S(+(..%OnUseSoftModals()):"true",1:"false"),";",!
 Write "}",!
 Set tSC=..%DrawJSSerialize()
 Quit:('tSC) tSC
 Set tSC=..%DrawJSGetSettings()
 Quit:('tSC) tSC
 Do JSClientMethod("deleteEntry","")
 Do JSClientMethod("newEntry","")
 Do JSClientMethod("rowSelected","")
 Do JSClientMethod("saveEntry","")
 Do JSClientMethod("showwarnForm","id")
 Do JSSvrMethod(1,"BOOLEAN","LoadZenComponent","pNamespace,pName,pClassName,pCSSLevel","L,L,L,L")
 Do JSSvrMethod(1,"","MonitorBackgroundTask","pTaskID","L")
 Do JSSvrMethod(0,"","ReallyRefreshContents","","")
 Write "self.BEDDAPPL_EDWarning__Loader = function() {",!
 Set tCls = "BEDDAPPL_EDWarning"
 Write $C(9),"zenLoadClass('_ZEN_Component_page');",!
 Write $C(9),tCls,".prototype = zenCreate('_ZEN_Component_page',-1);",!
 Write $C(9),"var p = ",tCls,".prototype;",!
 Write $C(9),"if (null==p) {return;}",!
 Write $C(9),"p.constructor = ",tCls,";",!
 Write $C(9),"p.superClass = ('undefined' == typeof _ZEN_Component_page) ? zenMaster._ZEN_Component_page.prototype:_ZEN_Component_page.prototype;",!
 Write $C(9),"p.__ZENcomponent = true;",!
 Write $C(9),"p._serverClass = '"_$ZCVT("BEDDAPPL.EDWarning","O","JS")_"';",!
 Write $C(9),"p._type = '"_"EDWarning"_"';",!
 Write $C(9),"p.serialize = ",tCls,"_serialize;",!
 Write $C(9),"p.getSettings = ",tCls,"_getSettings;",!
 Write $C(9),"p.LoadZenComponent = ",tCls,"_LoadZenComponent;",!
 Write $C(9),"p.MonitorBackgroundTask = ",tCls,"_MonitorBackgroundTask;",!
 Write $C(9),"p.ReallyRefreshContents = ",tCls,"_ReallyRefreshContents;",!
 Write $C(9),"p.deleteEntry = ",tCls,"_deleteEntry;",!
 Write $C(9),"p.newEntry = ",tCls,"_newEntry;",!
 Write $C(9),"p.rowSelected = ",tCls,"_rowSelected;",!
 Write $C(9),"p.saveEntry = ",tCls,"_saveEntry;",!
 Write $C(9),"p.showwarnForm = ",tCls,"_showwarnForm;",!
 Write "}",!
 Quit 1
JSClientMethod(method,args)
 Write !,"self.","BEDDAPPL_EDWarning","_",method," = function(",args,") {",!
 For line=1:1:$s($d(^oddCOM("BEDDAPPL.EDWarning","m",method,30))#2:^(30),$d(^oddCOM($g(^(2),"BEDDAPPL.EDWarning"),"m",method,30))#2:^(30),1:$s($d(^oddDEF($g(^oddCOM("BEDDAPPL.EDWarning","m",method,2),"BEDDAPPL.EDWarning"),"m",method,30))#2:^(30),1:$g(^%qCacheObjectKey(1,"m",30)))) {
  If +$G(%zenStripJS) {
   Set tLine = $ZSTRIP($s($d(^oddCOM("BEDDAPPL.EDWarning","m",method,30,line))#2:^(line),$d(^oddCOM($g(^oddCOM("BEDDAPPL.EDWarning","m",method,2),"BEDDAPPL.EDWarning"),"m",method,30,line))#2:^(line),1:$g(^oddDEF($g(^oddCOM("BEDDAPPL.EDWarning","m",method,2),"BEDDAPPL.EDWarning"),"m",method,30,line))),"<>W")
   If (tLine["&") {
    Set tLine = $Replace(tLine,"&nbsp;","&#160;")
    Set tLine = $Replace(tLine,"&raquo;","&#187;")
    Set tLine = $Replace(tLine,"&laquo;","&#171;")
   }
   Write:(($L(tLine)>0)&&($E(tLine,1,2)'="//")) tLine,!
  } Else {
   Write $s($d(^oddCOM("BEDDAPPL.EDWarning","m",method,30,line))#2:^(line),$d(^oddCOM($g(^oddCOM("BEDDAPPL.EDWarning","m",method,2),"BEDDAPPL.EDWarning"),"m",method,30,line))#2:^(line),1:$g(^oddDEF($g(^oddCOM("BEDDAPPL.EDWarning","m",method,2),"BEDDAPPL.EDWarning"),"m",method,30,line))),!
  }
 }
 Write "}",!
 Quit
JSSvrMethod(cm,retType,method,args,spec)
 Write !,"self.","BEDDAPPL_EDWarning","_",method," = function(",args,") {",!
 Write $C(9),$S(retType="":"",1:"return "),$S(cm:"zenClassMethod",1:"zenInstanceMethod"),"(this,'",method,"','",spec,"','",retType,"',arguments);",!
 Write "}",!
 Quit }
%DrawJSGetSettings() public {
 Write "function BEDDAPPL_EDWarning_getSettings(s)",!
 Write "{",!
 Write $C(9),"s['name'] = 'string';",!
 Write $C(9),"s['dlID'] = 'string';",!
 Write $C(9),"this.invokeSuper('getSettings',arguments);",!
 Write "}",!
 Quit 1 }
%DrawJSSerialize() public {
 Write "function BEDDAPPL_EDWarning_serialize(set,s)",!
 Write "{",!
 Write $C(9)
 Write "var o = this;"
 Write "s[0]='"_$ZCVT(..%GetClassCRC(),"O","JS")_"';"
 Write "s[1]=o.index;"
 Write "s[2]=o.id;"
 Write "s[3]=o.name;"
 Write "s[4]=set.addObject(o.parent,'parent');"
 Write "s[5]=set.addObject(o.composite,'composite');"
 Write "s[6]=o.SVGClassList;"
 Write "s[7]=o.UserSVGPackageList;"
 Write "s[8]=o.align;"
 Write "s[9]=o.aux;"
 Write "s[10]=o.backgroundTimerInterval;"
 Write "s[11]=o.cellAlign;"
 Write "s[12]=o.cellSize;"
 Write "s[13]=o.cellStyle;"
 Write "s[14]=o.cellVAlign;"
 Write "s[15]=set.serializeList(o,o.children,true,'children');"
 Write "s[16]=o.containerStyle;"
 Write "s[17]=o.cssLevel;"
 Write "s[18]=(o.designMode?1:0);"
 Write "s[19]=(o.disabled?1:0);"
 Write "s[20]=o.dlID;"
 Write "s[21]=(o.dragAndDrop?1:0);"
 Write "s[22]=(o.dragEnabled?1:0);"
 Write "s[23]=(o.dropEnabled?1:0);"
 Write "s[24]=(o.dynamic?1:0);"
 Write "s[25]=o.enclosingClass;"
 Write "s[26]=o.enclosingStyle;"
 Write "s[27]=o.error;"
 Write "s[28]=o.groupClass;"
 Write "s[29]=o.groupStyle;"
 Write "s[30]=o.height;"
 Write "s[31]=(o.hidden?1:0);"
 Write "s[32]=o.hint;"
 Write "s[33]=o.hintClass;"
 Write "s[34]=o.hintStyle;"
 Write "s[35]=(o.inlineSVG?1:0);"
 Write "s[36]=(o.isPopup?1:0);"
 Write "s[37]=(o.isSoftModal?1:0);"
 Write "s[38]=o.label;"
 Write "s[39]=o.labelClass;"
 Write "s[40]=o.labelDisabledClass;"
 Write "s[41]=o.labelPosition;"
 Write "s[42]=o.labelStyle;"
 Write "s[43]=o.lastModalIndex;"
 Write "s[44]=o.layout;"
 Write "s[45]=o.nextIndex;"
 Write "s[46]=o.onafterdrag;"
 Write "s[47]=o.onbeforedrag;"
 Write "s[48]=o.onclick;"
 Write "s[49]=o.ondrag;"
 Write "s[50]=o.ondrop;"
 Write "s[51]=o.onhide;"
 Write "s[52]=o.onoverlay;"
 Write "s[53]=o.onrefresh;"
 Write "s[54]=o.onshow;"
 Write "s[55]=o.onupdate;"
 Write "s[56]=o.overlayMode;"
 Write "s[57]=o.popupParent;"
 Write "s[58]=o.renderFlag;"
 Write "s[59]=(o.showLabel?1:0);"
 Write "s[60]=o.slice;"
 Write "s[61]=o.title;"
 Write "s[62]=o.tuple;"
 Write "s[63]=(o.useSVG?1:0);"
 Write "s[64]=(o.useSoftModals?1:0);"
 Write "s[65]=o.valign;"
 Write "s[66]=(o.visible?1:0);"
 Write "s[67]=o.width;"
 Write "s[68]=(o.zenPersistentPopup?1:0);"
 Write !,"}",!
 Quit 1 }
%DrawJSStrings(pVisited) public {
 Set tSC = 1
 If '$D(pVisited("BEDDAPPL.EDWarning")) {
  Set tSC = ##class(%ZEN.Component.page)$this.%DrawJSStrings(.pVisited)
  Set pVisited("BEDDAPPL.EDWarning") = ""
 }
 Quit tSC }
%DrawObjectProperties() public {
 Write:(..SVGClassList'="") "o.SVGClassList = '",$ZCVT(..SVGClassList,"O","JS"),"';",!
 Write:(..UserSVGPackageList'="") "o.UserSVGPackageList = '",$ZCVT(..UserSVGPackageList,"O","JS"),"';",!
 Write:(..align'="") "o.align = '",$ZCVT(..align,"O","JS"),"';",!
 Write:(..aux'="") "o.aux = '",$ZCVT(..aux,"O","JS"),"';",!
 Write:(..backgroundTimerInterval'=1000) "o.backgroundTimerInterval = ",$S($IsValidNum(..backgroundTimerInterval):..backgroundTimerInterval,1:"''"),";",!
 Write:(..cellAlign'=$parameter(,"DEFAULTCELLALIGN")) "o.cellAlign = '",$ZCVT(..cellAlign,"O","JS"),"';",!
 Write:(..cellSize'=$parameter(,"DEFAULTCELLSIZE")) "o.cellSize = '",$ZCVT(..cellSize,"O","JS"),"';",!
 Write:(..cellStyle'=$parameter(,"DEFAULTCELLSTYLE")) "o.cellStyle = '",$ZCVT(..cellStyle,"O","JS"),"';",!
 Write:(..cellVAlign'=$parameter(,"DEFAULTCELLVALIGN")) "o.cellVAlign = '",$ZCVT(..cellVAlign,"O","JS"),"';",!
 For i=1:1:..children.Count() {
  If ##class(%ZEN.Component.component).%IsA("%ZEN.Component.object") {
   Set idx = +..children.GetAt(i).index
   Write:'idx "throw new Error('Collection element is not part of the page model.\nClass: BEDDAPPL.EDWarning\nProperty: children\nElement Type:%ZEN.Component.component\nKey: ",i,"');",!
   Write "o.children[",i-1,"] = _zenIndex[",idx,"];",!
  }
 }
  If ##class(%ZEN.Component.group).%IsA("%ZEN.Component.object") {
  Write:$IsObject(..composite) "o.composite = _zenIndex[",(+..composite.index),"]",";",!
 }
 Write:(..containerStyle'="") "o.containerStyle = '",$ZCVT(..containerStyle,"O","JS"),"';",!
 Write:(..cssLevel'=2) "o.cssLevel = ",$S($IsValidNum(..cssLevel):..cssLevel,1:"''"),";",!
 Write:(..designMode'=0) "o.designMode = ",$S(+..designMode:"true",1:"false"),";",!
 Write:(..disabled'=0) "o.disabled = ",$S(+..disabled:"true",1:"false"),";",!
 Write:(..dlID'="") "o.dlID = '",$ZCVT(..dlID,"O","JS"),"';",!
 Write:(..dragAndDrop'=0) "o.dragAndDrop = ",$S(+..dragAndDrop:"true",1:"false"),";",!
 Write:(..dragEnabled'=0) "o.dragEnabled = ",$S(+..dragEnabled:"true",1:"false"),";",!
 Write:(..dropEnabled'=0) "o.dropEnabled = ",$S(+..dropEnabled:"true",1:"false"),";",!
 Write:(..dynamic'=0) "o.dynamic = ",$S(+..dynamic:"true",1:"false"),";",!
 Write:(..enclosingClass'=$parameter(,"DEFAULTENCLOSINGCLASS")) "o.enclosingClass = '",$ZCVT(..enclosingClass,"O","JS"),"';",!
 Write:(..enclosingStyle'="") "o.enclosingStyle = '",$ZCVT(..enclosingStyle,"O","JS"),"';",!
 Write:(..error'="") "o.error = '",$ZCVT(..error,"O","JS"),"';",!
 Write:(..groupClass'=$parameter(,"DEFAULTGROUPCLASS")) "o.groupClass = '",$ZCVT(..groupClass,"O","JS"),"';",!
 Write:(..groupStyle'=$parameter(,"DEFAULTGROUPSTYLE")) "o.groupStyle = '",$ZCVT(..groupStyle,"O","JS"),"';",!
 Write:(..height'=$parameter(,"DEFAULTHEIGHT")) "o.height = '",$ZCVT(..height,"O","JS"),"';",!
 Write:(..hidden'=$parameter(,"DEFAULTHIDDEN")) "o.hidden = ",$S(+..hidden:"true",1:"false"),";",!
 Write:(..hint'="") "o.hint = '",$ZCVT(..hint,"O","JS"),"';",!
 Write:(..hintClass'=$parameter(,"DEFAULTHINTCLASS")) "o.hintClass = '",$ZCVT(..hintClass,"O","JS"),"';",!
 Write:(..hintStyle'="") "o.hintStyle = '",$ZCVT(..hintStyle,"O","JS"),"';",!
 Write:(..id'="") "o.id = '",$ZCVT(..id,"O","JS"),"';",!
 Write:(..inlineSVG'=$parameter(,"INLINESVG")) "o.inlineSVG = ",$S(+..inlineSVG:"true",1:"false"),";",!
 Write:(..isPopup'="") "o.isPopup = ",$S(+..isPopup:"true",1:"false"),";",!
 Write:(..isSoftModal'="") "o.isSoftModal = ",$S(+..isSoftModal:"true",1:"false"),";",!
 Write:(..label'="") "o.label = '",$ZCVT(..label,"O","JS"),"';",!
 Write:(..labelClass'=$parameter(,"DEFAULTLABELCLASS")) "o.labelClass = '",$ZCVT(..labelClass,"O","JS"),"';",!
 Write:(..labelDisabledClass'=$parameter(,"DEFAULTLABELDISABLEDCLASS")) "o.labelDisabledClass = '",$ZCVT(..labelDisabledClass,"O","JS"),"';",!
 Write:(..labelPosition'=$parameter(,"DEFAULTLABELPOSITION")) "o.labelPosition = '",$ZCVT(..labelPosition,"O","JS"),"';",!
 Write:(..labelStyle'="") "o.labelStyle = '",$ZCVT(..labelStyle,"O","JS"),"';",!
 Write:(..lastModalIndex'=0) "o.lastModalIndex = ",$S($IsValidNum(..lastModalIndex):..lastModalIndex,1:"''"),";",!
 Write:(..layout'=$parameter(,"DEFAULTLAYOUT")) "o.layout = '",$ZCVT(..layout,"O","JS"),"';",!
 Write:(..name'="") "o.name = '",$ZCVT(..name,"O","JS"),"';",!
 Write:(..nextIndex'=0) "o.nextIndex = ",$S($IsValidNum(..nextIndex):..nextIndex,1:"''"),";",!
 Write:(..onafterdrag'="") "o.onafterdrag = '",$ZCVT(..onafterdrag,"O","JS"),"';",!
 Write:(..onbeforedrag'="") "o.onbeforedrag = '",$ZCVT(..onbeforedrag,"O","JS"),"';",!
 Write:(..onclick'="") "o.onclick = '",$ZCVT(..onclick,"O","JS"),"';",!
 Write:(..ondrag'="") "o.ondrag = '",$ZCVT(..ondrag,"O","JS"),"';",!
 Write:(..ondrop'="") "o.ondrop = '",$ZCVT(..ondrop,"O","JS"),"';",!
 Write:(..onhide'="") "o.onhide = '",$ZCVT(..onhide,"O","JS"),"';",!
 Write:(..onoverlay'="") "o.onoverlay = '",$ZCVT(..onoverlay,"O","JS"),"';",!
 Write:(..onrefresh'="") "o.onrefresh = '",$ZCVT(..onrefresh,"O","JS"),"';",!
 Write:(..onshow'="") "o.onshow = '",$ZCVT(..onshow,"O","JS"),"';",!
 Write:(..onupdate'="") "o.onupdate = '",$ZCVT(..onupdate,"O","JS"),"';",!
 Write:(..overlayMode'=0) "o.overlayMode = ",$S($IsValidNum(..overlayMode):..overlayMode,1:"''"),";",!
  If ##class(%ZEN.Component.object).%IsA("%ZEN.Component.object") {
  Write:$IsObject(..parent) "o.parent = _zenIndex[",(+..parent.index),"]",";",!
 }
 Write:(..popupParent'="") "o.popupParent = ",$S($IsValidNum(..popupParent):..popupParent,1:"''"),";",!
 Write:(..renderFlag'=0) "o.renderFlag = ",$S($IsValidNum(..renderFlag):..renderFlag,1:"''"),";",!
 Write:(..showLabel'=1) "o.showLabel = ",$S(+..showLabel:"true",1:"false"),";",!
 Write:(..slice'="") "o.slice = ",$S($IsValidNum(..slice):..slice,1:"''"),";",!
 Write:(..title'=$parameter(,"PAGETITLE")) "o.title = '",$ZCVT(..title,"O","JS"),"';",!
 Write:(..tuple'="") "o.tuple = '",$ZCVT(..tuple,"O","JS"),"';",!
 Write:(..useSVG'=0) "o.useSVG = ",$S(+..useSVG:"true",1:"false"),";",!
 Write:(..useSoftModals'=..%OnUseSoftModals()) "o.useSoftModals = ",$S(+..useSoftModals:"true",1:"false"),";",!
 Write:(..valign'="") "o.valign = '",$ZCVT(..valign,"O","JS"),"';",!
 Write:(..visible'=$parameter(,"DEFAULTVISIBLE")) "o.visible = ",$S(+..visible:"true",1:"false"),";",!
 Write:(..width'=$parameter(,"DEFAULTWIDTH")) "o.width = '",$ZCVT(..width,"O","JS"),"';",!
 Write:(..window'="") "o.window = '",$ZCVT(..window,"O","JS"),"';",!
 Write:(..zenPersistentPopup'=0) "o.zenPersistentPopup = ",$S(+..zenPersistentPopup:"true",1:"false"),";",!
 Do $System.CLS.SetSModified($this,0) }
%DrawSVGDef() public {
 Write "<!-- SVGDef: BEDDAPPL.EDWarning -->",!  }
%DrawStyleHTML(pLevel=2) public {
 Write "<!-- Style: BEDDAPPL.EDWarning -->",! 
 Write "",!
	Write "<style type=""text/css""> ",!
	Write "</style>",!
	Write " ",!  }
%DrawStyleSVG() public {
 Write "<!-- SVGStyle: BEDDAPPL.EDWarning -->",!  }
%GetClassCRC() public {
 Quit 1392427714 }
%GetDependentComponents(pPage) public {
   Set pPage.%ComponentClasses(6,"BEDDAPPL.EDWarning") = 1
 If ##class(%ZEN.Component.object).%IsA("%ZEN.Component.object") {
  Do AddToList(pPage,##class(%ZEN.Component.object).%GetSuperClassList())
 }
 If ##class(%ZEN.Component.page).%IsA("%ZEN.Component.object") {
  Do AddToList(pPage,##class(%ZEN.Component.page).%GetSuperClassList())
 }
 If ##class(%ZEN.Component.component).%IsA("%ZEN.Component.object") {
  Do AddToList(pPage,##class(%ZEN.Component.component).%GetSuperClassList())
 }
 If ##class(%ZEN.Component.group).%IsA("%ZEN.Component.object") {
  Do AddToList(pPage,##class(%ZEN.Component.group).%GetSuperClassList())
 }
 Quit 1
AddToList(pPage,tList)
 For n=1:1:$L(tList,",") {
  Set tSuper = $P(tList,",",n)
   Set pPage.%ComponentClasses(n,tSuper) = 0
 }
 Quit }
%GetIncludeFiles(pMode="HTML") public {
 If $D(%zenClassList("BEDDAPPL.EDWarning")) Quit
 Set %zenClassList("BEDDAPPL.EDWarning") = ""
 Do ##class(%ZEN.Component.page)$this.%GetIncludeFiles(pMode)
}
%GetIncludeInfo(pModules,pHasJS,pCSSType,pInline) public {
 Set pModules("BEDDAPPL","BEDDAPPL") = $LB(6,"")
 Set pHasJS = 0
 Set pCSSType = "HTML"
 Set pInline = 1 }
%GetLinks() public {
	Quit "images/combobox.png,images/comboboxpress.png" }
%GetPaneContents(pGroup,pPaneName,pPaneExists) public {
 Set pPaneExists = 0
 Goto Dispatch
Dispatch
Done
 Quit 1 }
%GetSuperClassList(pList) public {
 Quit "%ZEN.Component.object,%ZEN.Component.component,%ZEN.Component.abstractGroup,%ZEN.Component.group,%ZEN.Component.abstractPage,%ZEN.Component.page,BEDDAPPL.EDWarning" }
%GetXMLName(pNamespace,pName) public {
 Set pNamespace = "http://www.intersystems.com/zen"
 Set pName = "EDWarning" }
%ObjectSynch() public {
 Set tSC = 1
 Set $ZT="Trap"
 Set osp =  "o.setProperty"
 Set s%"%%OID"=0
 Set s%%ComponentClasses=0
 Set s%%ComponentIds=0
 Set s%%ComponentNames=0
 Set s%%Components=0
 Set s%%CompositeList=0
 Set s%%DeletedIds=0
 Set s%%NotifyList=0
 Set s%%RenderList=0
 Set s%%UserPackageList=0
 Set s%%condition=0
 Set s%%import=0
 Set s%%includeFiles=0
 Set s%%page=0
 Set s%%partial=0
 Set s%%resource=0
 Set s%%xmlOutputMode=0
 Quit:'$system.CLS.GetSModified($this) tSC
 Write:s%SVGClassList osp,"('SVGClassList','",$ZCVT(..SVGClassList,"O","JS"),"');",!
 Write:s%UserSVGPackageList osp,"('UserSVGPackageList','",$ZCVT(..UserSVGPackageList,"O","JS"),"');",!
 Write:s%align osp,"('align','",$ZCVT(..align,"O","JS"),"');",!
 Write:s%aux osp,"('aux','",$ZCVT(..aux,"O","JS"),"');",!
 Write:s%backgroundTimerInterval osp,"('backgroundTimerInterval',",$S($IsValidNum(..backgroundTimerInterval):..backgroundTimerInterval,1:"''"),");",!
 Write:s%cellAlign osp,"('cellAlign','",$ZCVT(..cellAlign,"O","JS"),"');",!
 Write:s%cellSize osp,"('cellSize','",$ZCVT(..cellSize,"O","JS"),"');",!
 Write:s%cellStyle osp,"('cellStyle','",$ZCVT(..cellStyle,"O","JS"),"');",!
 Write:s%cellVAlign osp,"('cellVAlign','",$ZCVT(..cellVAlign,"O","JS"),"');",!
 If (('..%partial)&&s%children) {
 Write "o.children.length = 0;",!
 For i=1:1:..children.Count() {
  If ##class(%ZEN.Component.component).%IsA("%ZEN.Component.object") {
   Set idx = +..children.GetAt(i).index
   Write:'idx "throw new Error('Collection element is not part of the page model.\nClass: BEDDAPPL.EDWarning\nProperty: children\nElement Type:%ZEN.Component.component\nKey: ",i,"');",!
   Write "o.children[",i-1,"] = _zenIndex[",idx,"];",!
  }
 }
 }
 If s%composite {
 If ##class(%ZEN.Component.group).%IsA("%ZEN.Component.object") {
  Write "o.composite = ",$S($IsObject(..composite):"_zenIndex["_(+..composite.index)_"]",1:"null"),";",!
 }
 }
 Write:s%containerStyle osp,"('containerStyle','",$ZCVT(..containerStyle,"O","JS"),"');",!
 Write:s%cssLevel "o.cssLevel = ",$S($IsValidNum(..cssLevel):..cssLevel,1:"''"),";",!
 Write:s%designMode "o.designMode = ",$S(+..designMode:"true",1:"false"),";",!
 Write:s%disabled osp,"('disabled',",$S(+..disabled:"true",1:"false"),");",!
 Write:s%dlID osp,"('dlID','",$ZCVT(..dlID,"O","JS"),"');",!
 Write:s%dragAndDrop osp,"('dragAndDrop',",$S(+..dragAndDrop:"true",1:"false"),");",!
 Write:s%dragEnabled osp,"('dragEnabled',",$S(+..dragEnabled:"true",1:"false"),");",!
 Write:s%dropEnabled osp,"('dropEnabled',",$S(+..dropEnabled:"true",1:"false"),");",!
 Write:s%dynamic "o.dynamic = ",$S(+..dynamic:"true",1:"false"),";",!
 Write:s%enclosingClass osp,"('enclosingClass','",$ZCVT(..enclosingClass,"O","JS"),"');",!
 Write:s%enclosingStyle osp,"('enclosingStyle','",$ZCVT(..enclosingStyle,"O","JS"),"');",!
 Write:s%error "o.error = '",$ZCVT(..error,"O","JS"),"';",!
 Write:s%groupClass osp,"('groupClass','",$ZCVT(..groupClass,"O","JS"),"');",!
 Write:s%groupStyle osp,"('groupStyle','",$ZCVT(..groupStyle,"O","JS"),"');",!
 Write:s%height osp,"('height','",$ZCVT(..height,"O","JS"),"');",!
 Write:s%hidden osp,"('hidden',",$S(+..hidden:"true",1:"false"),");",!
 Write:s%hint osp,"('hint','",$ZCVT(..hint,"O","JS"),"');",!
 Write:s%hintClass osp,"('hintClass','",$ZCVT(..hintClass,"O","JS"),"');",!
 Write:s%hintStyle osp,"('hintStyle','",$ZCVT(..hintStyle,"O","JS"),"');",!
 Write:s%id osp,"('id','",$ZCVT(..id,"O","JS"),"');",!
 Write:s%inlineSVG osp,"('inlineSVG',",$S(+..inlineSVG:"true",1:"false"),");",!
 Write:s%isPopup osp,"('isPopup',",$S(+..isPopup:"true",1:"false"),");",!
 Write:s%isSoftModal osp,"('isSoftModal',",$S(+..isSoftModal:"true",1:"false"),");",!
 Write:s%label osp,"('label','",$ZCVT(..label,"O","JS"),"');",!
 Write:s%labelClass osp,"('labelClass','",$ZCVT(..labelClass,"O","JS"),"');",!
 Write:s%labelDisabledClass osp,"('labelDisabledClass','",$ZCVT(..labelDisabledClass,"O","JS"),"');",!
 Write:s%labelPosition osp,"('labelPosition','",$ZCVT(..labelPosition,"O","JS"),"');",!
 Write:s%labelStyle osp,"('labelStyle','",$ZCVT(..labelStyle,"O","JS"),"');",!
 Write:s%lastModalIndex osp,"('lastModalIndex',",$S($IsValidNum(..lastModalIndex):..lastModalIndex,1:"''"),");",!
 Write:s%layout osp,"('layout','",$ZCVT(..layout,"O","JS"),"');",!
 Write:s%name osp,"('name','",$ZCVT(..name,"O","JS"),"');",!
 Write:s%nextIndex osp,"('nextIndex',",$S($IsValidNum(..nextIndex):..nextIndex,1:"''"),");",!
 Write:s%onafterdrag osp,"('onafterdrag','",$ZCVT(..onafterdrag,"O","JS"),"');",!
 Write:s%onbeforedrag osp,"('onbeforedrag','",$ZCVT(..onbeforedrag,"O","JS"),"');",!
 Write:s%onclick osp,"('onclick','",$ZCVT(..onclick,"O","JS"),"');",!
 Write:s%ondrag osp,"('ondrag','",$ZCVT(..ondrag,"O","JS"),"');",!
 Write:s%ondrop osp,"('ondrop','",$ZCVT(..ondrop,"O","JS"),"');",!
 Write:s%onhide osp,"('onhide','",$ZCVT(..onhide,"O","JS"),"');",!
 Write:s%onoverlay osp,"('onoverlay','",$ZCVT(..onoverlay,"O","JS"),"');",!
 Write:s%onrefresh osp,"('onrefresh','",$ZCVT(..onrefresh,"O","JS"),"');",!
 Write:s%onshow osp,"('onshow','",$ZCVT(..onshow,"O","JS"),"');",!
 Write:s%onupdate osp,"('onupdate','",$ZCVT(..onupdate,"O","JS"),"');",!
 Write:s%overlayMode "o.overlayMode = ",$S($IsValidNum(..overlayMode):..overlayMode,1:"''"),";",!
 If s%parent {
 If ##class(%ZEN.Component.object).%IsA("%ZEN.Component.object") {
  Write "o.parent = ",$S($IsObject(..parent):"_zenIndex["_(+..parent.index)_"]",1:"null"),";",!
 }
 }
 Write:s%popupParent osp,"('popupParent',",$S($IsValidNum(..popupParent):..popupParent,1:"''"),");",!
 Write:s%renderFlag "o.renderFlag = ",$S($IsValidNum(..renderFlag):..renderFlag,1:"''"),";",!,"zenRenderContents(o);",!
 Write:s%showLabel osp,"('showLabel',",$S(+..showLabel:"true",1:"false"),");",!
 Write:s%slice osp,"('slice',",$S($IsValidNum(..slice):..slice,1:"''"),");",!
 Write:s%title osp,"('title','",$ZCVT(..title,"O","JS"),"');",!
 Write:s%tuple "o.tuple = '",$ZCVT(..tuple,"O","JS"),"';",!
 Write:s%useSVG osp,"('useSVG',",$S(+..useSVG:"true",1:"false"),");",!
 Write:s%useSoftModals osp,"('useSoftModals',",$S(+..useSoftModals:"true",1:"false"),");",!
 Write:s%valign osp,"('valign','",$ZCVT(..valign,"O","JS"),"');",!
 Write:s%visible "o.visible = ",$S(+..visible:"true",1:"false"),";",!
 Write:s%width osp,"('width','",$ZCVT(..width,"O","JS"),"');",!
 Write:s%zenPersistentPopup osp,"('zenPersistentPopup',",$S(+..zenPersistentPopup:"true",1:"false"),");",!
 Do $System.CLS.SetSModified($this,0)
 Quit tSC
Trap
 Set $ZT=""
 Set tSC = $$Error^%apiOBJ(5002,"BEDDAPPL.EDWarning:ObjectSynch: "_$ZE)
 Quit tSC }
%ZENDeserialize(pState,pObjSet) public {
 Set tSC=1
 If (..%GetClassCRC()'=$P(pState,$C(1),1)) { Quit $$Error^%apiOBJ(5001,"Server version of object does not match version sent from the client: "_..%ClassName(1)) } 
 Set ..index=$P(pState,$C(1),2)
 Set ..id=$P(pState,$C(1),3)
 Set ..name=$P(pState,$C(1),4)
 Set parent=$S($P(pState,$C(1),5)="":"",1:$G(pObjSet($P(pState,$C(1),5)))) Do:$IsObject(parent) parent.%AddChild($this)
 Set ..composite=$S($P(pState,$C(1),6)="":"",1:$G(pObjSet($P(pState,$C(1),6))))
 Set ..SVGClassList=$P(pState,$C(1),7)
 Set ..UserSVGPackageList=$P(pState,$C(1),8)
 Set ..align=$P(pState,$C(1),9)
 Set ..aux=$P(pState,$C(1),10)
 Set ..backgroundTimerInterval=$P(pState,$C(1),11)
 Set ..cellAlign=$P(pState,$C(1),12)
 Set ..cellSize=$P(pState,$C(1),13)
 Set ..cellStyle=$P(pState,$C(1),14)
 Set ..cellVAlign=$P(pState,$C(1),15)
 Set:(($P(pState,$C(1),16))=-1) ..%partial=1
 Set ..containerStyle=$P(pState,$C(1),17)
 Set ..cssLevel=$P(pState,$C(1),18)
 Set ..designMode=''$P(pState,$C(1),19)
 Set ..disabled=''$P(pState,$C(1),20)
 Set ..dlID=$P(pState,$C(1),21)
 Set ..dragAndDrop=''$P(pState,$C(1),22)
 Set ..dragEnabled=''$P(pState,$C(1),23)
 Set ..dropEnabled=''$P(pState,$C(1),24)
 Set ..dynamic=''$P(pState,$C(1),25)
 Set ..enclosingClass=$P(pState,$C(1),26)
 Set ..enclosingStyle=$P(pState,$C(1),27)
 Set ..error=$P(pState,$C(1),28)
 Set ..groupClass=$P(pState,$C(1),29)
 Set ..groupStyle=$P(pState,$C(1),30)
 Set ..height=$P(pState,$C(1),31)
 Set ..hidden=''$P(pState,$C(1),32)
 Set ..hint=$P(pState,$C(1),33)
 Set ..hintClass=$P(pState,$C(1),34)
 Set ..hintStyle=$P(pState,$C(1),35)
 Set ..inlineSVG=''$P(pState,$C(1),36)
 Set ..isPopup=''$P(pState,$C(1),37)
 Set ..isSoftModal=''$P(pState,$C(1),38)
 Set ..label=$P(pState,$C(1),39)
 Set ..labelClass=$P(pState,$C(1),40)
 Set ..labelDisabledClass=$P(pState,$C(1),41)
 Set ..labelPosition=$P(pState,$C(1),42)
 Set ..labelStyle=$P(pState,$C(1),43)
 Set ..lastModalIndex=$P(pState,$C(1),44)
 Set ..layout=$P(pState,$C(1),45)
 Set ..nextIndex=$P(pState,$C(1),46)
 Set ..onafterdrag=$P(pState,$C(1),47)
 Set ..onbeforedrag=$P(pState,$C(1),48)
 Set ..onclick=$P(pState,$C(1),49)
 Set ..ondrag=$P(pState,$C(1),50)
 Set ..ondrop=$P(pState,$C(1),51)
 Set ..onhide=$P(pState,$C(1),52)
 Set ..onoverlay=$P(pState,$C(1),53)
 Set ..onrefresh=$P(pState,$C(1),54)
 Set ..onshow=$P(pState,$C(1),55)
 Set ..onupdate=$P(pState,$C(1),56)
 Set ..overlayMode=$P(pState,$C(1),57)
 Set ..popupParent=$P(pState,$C(1),58)
 Set ..renderFlag=$P(pState,$C(1),59)
 Set ..showLabel=''$P(pState,$C(1),60)
 Set ..slice=$P(pState,$C(1),61)
 Set ..title=$P(pState,$C(1),62)
 Set ..tuple=$P(pState,$C(1),63)
 Set ..useSVG=''$P(pState,$C(1),64)
 Set ..useSoftModals=''$P(pState,$C(1),65)
 Set ..valign=$P(pState,$C(1),66)
 Set ..visible=''$P(pState,$C(1),67)
 Set ..width=$P(pState,$C(1),68)
 Set ..zenPersistentPopup=''$P(pState,$C(1),69)
 Do $System.CLS.SetSModified($this,0)
 Quit tSC }
zPage(skipheader=1) public {
	New %CSPsc Set %CSPsc=1
	Set dopage=(%request.Method'="HEAD")
	If %response.Language="" Do %response.MatchLanguage()
	If 'skipheader Do $zutil(96,18,2,"UTF8")
	Try {
		If ..OnPreHTTP()=0 Set dopage=0
		If 'skipheader Set %CSPsc=%response.WriteHTTPHeader(.dopage) Set:('%CSPsc) dopage=0
		If $get(dopage) Set %CSPsc=..OnPage()
	} Catch exception {
		If $ZError'["<ZTHRO"||($get(%CSPsc)="")||(+%CSPsc) Set %CSPsc=exception.AsStatus()
	}
	Do ..OnPostHTTP()
	Quit %CSPsc }
zXMLNew(document,node,containerOref="")
	Quit (##class(BEDDAPPL.EDWarning).%New())
