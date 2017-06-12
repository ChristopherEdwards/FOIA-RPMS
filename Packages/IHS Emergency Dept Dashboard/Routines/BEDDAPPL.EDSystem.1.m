 ;BEDDAPPL.EDSystem.1
 ;(C)InterSystems, generated for class BEDDAPPL.EDSystem.  Do NOT edit. 04/14/2017 08:47:50AM
 ;;62704B34;BEDDAPPL.EDSystem
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
 Set pg1.title="Emergency Dashboard Setup"
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
 Set tblPn4 = ##class(%ZEN.Component.tablePane).%New()
 Set tblPn4.id="sysTable"
 Set tblPn4.caption="ED Dashboard Setup"
 Set clmn5 = ##class(%ZEN.Auxiliary.column).%New()
 Set clmn5.colName="ID"
 Set clmn5.width=5
 Do tblPn4.columns.Insert(clmn5)
 Do:$IsObject(%page) %page.%AddComponent(clmn5)
 Set clmn5 = ##class(%ZEN.Auxiliary.column).%New()
 Set clmn5.colName="SMTPSERVER"
 Set clmn5.header="SMTPSERVER"
 Set clmn5.width=20
 Do tblPn4.columns.Insert(clmn5)
 Do:$IsObject(%page) %page.%AddComponent(clmn5)
 Set clmn5 = ##class(%ZEN.Auxiliary.column).%New()
 Set clmn5.colName="SiteName"
 Set clmn5.header="SiteName"
 Set clmn5.width=40
 Do tblPn4.columns.Insert(clmn5)
 Do:$IsObject(%page) %page.%AddComponent(clmn5)
 Set tblPn4.extraColumnWidth="5%"
 Set tblPn4.onselectrow="zenPage.rowSelected(zenThis);"
 Set tblPn4.pageSize=100
 Set tblPn4.showRowNumbers=1
 Set tblPn4.showZebra=1
 Set tblPn4.tableName="BEDD.EDSYSTEM"
 Set tblPn4.useSnapshot=1
 Set tblPn4.valueColumn="ID"
 Set tblPn4.width="1000px"
 Do vgrp3.%AddChild(tblPn4)
 Set spcr2 = ##class(%ZEN.Component.spacer).%New()
 Set spcr2.height=10
 Do pg1.%AddChild(spcr2)
 Set spcr2 = ##class(%ZEN.Component.spacer).%New()
 Set spcr2.width=10
 Do pg1.%AddChild(spcr2)
 Set hgrp2 = ##class(%ZEN.Component.hgroup).%New()
 Do pg1.%AddChild(hgrp2)
 Set dtCntrllr3 = ##class(%ZEN.Auxiliary.dataController).%New()
 Set dtCntrllr3.id="sysData"
 Set dtBg4 = ##class(%ZEN.Auxiliary.dataBag).%New()
 Set dtCntrllr3.dataBag = dtBg4
 Set dtBg4.parent = dtCntrllr3
 Do:$IsObject(%page) %page.%AddComponent(dtBg4)
 Set dtCntrllr3.modelClass="BEDDAPPL.EDSystemModel"
 Do hgrp2.%AddChild(dtCntrllr3)
 Set spcr3 = ##class(%ZEN.Component.spacer).%New()
 Set spcr3.width=5
 Do hgrp2.%AddChild(spcr3)
 Set fldSt3 = ##class(%ZEN.Component.fieldSet).%New()
 Set fldSt3.id="sysFormGroup"
 Set fldSt3.enclosingStyle="border: 2px solid black;"
 Set fldSt3.legend="Dashboard System Setup"
 Do hgrp2.%AddChild(fldSt3)
 Set frm4 = ##class(%ZEN.Component.form).%New()
 Set frm4.id="sysForm"
 Set frm4.cellStyle="padding: 2px; padding-left: 5px; padding-right: 5px;"
 Set frm4.controllerId="sysData"
 Do fldSt3.%AddChild(frm4)
 Set fldSt5 = ##class(%ZEN.Component.fieldSet).%New()
 Set fldSt5.id="SystemPreferences"
 Set fldSt5.enclosingStyle="border: 2px solid grey;"
 Set fldSt5.legend="System Preferences"
 Do frm4.%AddChild(fldSt5)
 Set spcr6 = ##class(%ZEN.Component.spacer).%New()
 Set spcr6.height=10
 Do fldSt5.%AddChild(spcr6)
 Set hgrp6 = ##class(%ZEN.Component.hgroup).%New()
 Do fldSt5.%AddChild(hgrp6)
 Set spcr7 = ##class(%ZEN.Component.spacer).%New()
 Set spcr7.width=5
 Do hgrp6.%AddChild(spcr7)
 Set vgrp7 = ##class(%ZEN.Component.vgroup).%New()
 Do hgrp6.%AddChild(vgrp7)
 Set hgrp8 = ##class(%ZEN.Component.hgroup).%New()
 Do vgrp7.%AddChild(hgrp8)
 Set txt9 = ##class(%ZEN.Component.text).%New()
 Set txt9.id="Site"
 Set txt9.name="Site"
 Set txt9.dataBinding="Site"
 Set txt9.disabled=1
 Set txt9.hidden=1
 Do hgrp8.%AddChild(txt9)
 Set txt9 = ##class(%ZEN.Component.text).%New()
 Set txt9.id="ID"
 Set txt9.name="ID"
 Set txt9.dataBinding="%id"
 Set txt9.disabled=1
 Set txt9.label="ID:"
 Set txt9.readOnly=1
 Set txt9.size=5
 Do hgrp8.%AddChild(txt9)
 Set spcr9 = ##class(%ZEN.Component.spacer).%New()
 Set spcr9.width=5
 Do hgrp8.%AddChild(spcr9)
 Set txt9 = ##class(%ZEN.Component.text).%New()
 Set txt9.id="SMTPSERVER"
 Set txt9.name="SMTPSERVER"
 Set txt9.dataBinding="SMTPSERVER"
 Set txt9.disabled=1
 Set txt9.label="SMTPSERVER:"
 Set txt9.size=30
 Do hgrp8.%AddChild(txt9)
 Set spcr9 = ##class(%ZEN.Component.spacer).%New()
 Set spcr9.width=5
 Do hgrp8.%AddChild(spcr9)
 Set txt9 = ##class(%ZEN.Component.text).%New()
 Set txt9.id="Phone"
 Set txt9.name="Phone"
 Set txt9.dataBinding="Phone"
 Set txt9.disabled=1
 Set txt9.label="Phone:"
 Set txt9.size=15
 Do hgrp8.%AddChild(txt9)
 Set spcr9 = ##class(%ZEN.Component.spacer).%New()
 Set spcr9.width=5
 Do hgrp8.%AddChild(spcr9)
 Set txt9 = ##class(%ZEN.Component.text).%New()
 Set txt9.id="TimeOut"
 Set txt9.name="TimeOut"
 Set txt9.dataBinding="TimeOut"
 Set txt9.disabled=1
 Set txt9.label="Screen Timeout (in seconds)"
 Set txt9.onchange="zenPage.TimeOutChk();"
 Set txt9.size=15
 Do hgrp8.%AddChild(txt9)
 Set hgrp6 = ##class(%ZEN.Component.hgroup).%New()
 Do fldSt5.%AddChild(hgrp6)
 Set spcr7 = ##class(%ZEN.Component.spacer).%New()
 Set spcr7.width=5
 Do hgrp6.%AddChild(spcr7)
 Set vgrp7 = ##class(%ZEN.Component.vgroup).%New()
 Do hgrp6.%AddChild(vgrp7)
 Set hgrp8 = ##class(%ZEN.Component.hgroup).%New()
 Do vgrp7.%AddChild(hgrp8)
 Set spcr9 = ##class(%ZEN.Component.spacer).%New()
 Set spcr9.width=5
 Do hgrp8.%AddChild(spcr9)
 Set pn9 = ##class(%ZEN.Component.pane).%New()
 Set pn9.paneName="Dashboard Operations"
 Do hgrp8.%AddChild(pn9)
 Set chckbx9 = ##class(%ZEN.Component.checkbox).%New()
 Set chckbx9.id="StandAlone"
 Set chckbx9.name="StandAlone"
 Set chckbx9.dataBinding="StandAlone"
 Set chckbx9.disabled=1
 Set chckbx9.label="Operate Dashboard Stand Alone:"
 Do hgrp8.%AddChild(chckbx9)
 Set spcr9 = ##class(%ZEN.Component.spacer).%New()
 Set spcr9.width=5
 Do hgrp8.%AddChild(spcr9)
 Set chckbx9 = ##class(%ZEN.Component.checkbox).%New()
 Set chckbx9.id="TwoClinics"
 Set chckbx9.name="TwoClinics"
 Set chckbx9.dataBinding="TwoClinics"
 Set chckbx9.disabled=1
 Set chckbx9.label="Use more than 1 Clinic:"
 Do hgrp8.%AddChild(chckbx9)
 Set spcr9 = ##class(%ZEN.Component.spacer).%New()
 Set spcr9.width=5
 Do hgrp8.%AddChild(spcr9)
 Set chckbx9 = ##class(%ZEN.Component.checkbox).%New()
 Set chckbx9.id="ShoDlySum"
 Set chckbx9.name="ShoDlySum"
 Set chckbx9.dataBinding="ShoDlySum"
 Set chckbx9.disabled=1
 Set chckbx9.label="Show Daily Summary on Dashboard:"
 Do hgrp8.%AddChild(chckbx9)
 Set hgrp6 = ##class(%ZEN.Component.hgroup).%New()
 Do fldSt5.%AddChild(hgrp6)
 Set spcr7 = ##class(%ZEN.Component.spacer).%New()
 Set spcr7.width=5
 Do hgrp6.%AddChild(spcr7)
 Set vgrp7 = ##class(%ZEN.Component.vgroup).%New()
 Do hgrp6.%AddChild(vgrp7)
 Set hgrp8 = ##class(%ZEN.Component.hgroup).%New()
 Do vgrp7.%AddChild(hgrp8)
 Set spcr9 = ##class(%ZEN.Component.spacer).%New()
 Set spcr9.width=5
 Do hgrp8.%AddChild(spcr9)
 Set pn9 = ##class(%ZEN.Component.pane).%New()
 Set pn9.paneName="Check in functions"
 Do hgrp8.%AddChild(pn9)
 Set spcr9 = ##class(%ZEN.Component.spacer).%New()
 Set spcr9.width=5
 Do hgrp8.%AddChild(spcr9)
 Set chckbx9 = ##class(%ZEN.Component.checkbox).%New()
 Set chckbx9.id="MedRec"
 Set chckbx9.name="MedRec"
 Set chckbx9.dataBinding="MedRec"
 Set chckbx9.disabled=1
 Set chckbx9.label="Print Med-Rec Worksheet:"
 Do hgrp8.%AddChild(chckbx9)
 Set spcr9 = ##class(%ZEN.Component.spacer).%New()
 Set spcr9.width=5
 Do hgrp8.%AddChild(spcr9)
 Set chckbx9 = ##class(%ZEN.Component.checkbox).%New()
 Set chckbx9.id="PtRtSheet"
 Set chckbx9.name="PtRtSheet"
 Set chckbx9.dataBinding="PtRtSheet"
 Set chckbx9.disabled=1
 Set chckbx9.label="Print Pt Routing Sheet"
 Do hgrp8.%AddChild(chckbx9)
 Set spcr9 = ##class(%ZEN.Component.spacer).%New()
 Set spcr9.width=5
 Do hgrp8.%AddChild(spcr9)
 Set chckbx9 = ##class(%ZEN.Component.checkbox).%New()
 Set chckbx9.id="PtArmBand"
 Set chckbx9.name="PtArmBand"
 Set chckbx9.dataBinding="PtArmBand"
 Set chckbx9.disabled=1
 Set chckbx9.label="Print Arm Band"
 Do hgrp8.%AddChild(chckbx9)
 Set hgrp6 = ##class(%ZEN.Component.hgroup).%New()
 Do fldSt5.%AddChild(hgrp6)
 Set spcr7 = ##class(%ZEN.Component.spacer).%New()
 Set spcr7.width=5
 Do hgrp6.%AddChild(spcr7)
 Set vgrp7 = ##class(%ZEN.Component.vgroup).%New()
 Do hgrp6.%AddChild(vgrp7)
 Set hgrp8 = ##class(%ZEN.Component.hgroup).%New()
 Do vgrp7.%AddChild(hgrp8)
 Set pn9 = ##class(%ZEN.Component.pane).%New()
 Set pn9.paneName="Dashboard Table options"
 Do hgrp8.%AddChild(pn9)
 Set chckbx9 = ##class(%ZEN.Component.checkbox).%New()
 Set chckbx9.id="ShoUsedRm"
 Set chckbx9.name="ShoUsedRm"
 Set chckbx9.dataBinding="ShoUsedRm"
 Set chckbx9.disabled=1
 Set chckbx9.label="Show Used Rooms:"
 Do hgrp8.%AddChild(chckbx9)
 Set spcr9 = ##class(%ZEN.Component.spacer).%New()
 Set spcr9.width=5
 Do hgrp8.%AddChild(spcr9)
 Set chckbx9 = ##class(%ZEN.Component.checkbox).%New()
 Set chckbx9.id="ShoPrv"
 Set chckbx9.name="ShoPrv"
 Set chckbx9.dataBinding="ShoPrv"
 Set chckbx9.disabled=1
 Set chckbx9.label="Show Provider:"
 Do hgrp8.%AddChild(chckbx9)
 Set spcr9 = ##class(%ZEN.Component.spacer).%New()
 Set spcr9.width=5
 Do hgrp8.%AddChild(spcr9)
 Set chckbx9 = ##class(%ZEN.Component.checkbox).%New()
 Set chckbx9.id="ShoNrse"
 Set chckbx9.name="ShoNrse"
 Set chckbx9.dataBinding="ShoNrse"
 Set chckbx9.disabled=1
 Set chckbx9.label="Show Nurse:"
 Do hgrp8.%AddChild(chckbx9)
 Set spcr9 = ##class(%ZEN.Component.spacer).%New()
 Set spcr9.width=5
 Do hgrp8.%AddChild(spcr9)
 Set chckbx9 = ##class(%ZEN.Component.checkbox).%New()
 Set chckbx9.id="ShoCons"
 Set chckbx9.name="ShoCons"
 Set chckbx9.dataBinding="ShoCons"
 Set chckbx9.disabled=1
 Set chckbx9.label="Show Consult:"
 Do hgrp8.%AddChild(chckbx9)
 Set hgrp6 = ##class(%ZEN.Component.hgroup).%New()
 Do fldSt5.%AddChild(hgrp6)
 Set spcr7 = ##class(%ZEN.Component.spacer).%New()
 Set spcr7.width=5
 Do hgrp6.%AddChild(spcr7)
 Set vgrp7 = ##class(%ZEN.Component.vgroup).%New()
 Do hgrp6.%AddChild(vgrp7)
 Set hgrp8 = ##class(%ZEN.Component.hgroup).%New()
 Do vgrp7.%AddChild(hgrp8)
 Set pn9 = ##class(%ZEN.Component.pane).%New()
 Set pn9.paneName="Dashboard Table functions"
 Do hgrp8.%AddChild(pn9)
 Set chckbx9 = ##class(%ZEN.Component.checkbox).%New()
 Set chckbx9.id="AutoNote"
 Set chckbx9.name="AutoNote"
 Set chckbx9.dataBinding="AutoNote"
 Set chckbx9.disabled=1
 Set chckbx9.label="Use AutoNote:"
 Do hgrp8.%AddChild(chckbx9)
 Set spcr9 = ##class(%ZEN.Component.spacer).%New()
 Set spcr9.width=5
 Do hgrp8.%AddChild(spcr9)
 Set chckbx9 = ##class(%ZEN.Component.checkbox).%New()
 Set chckbx9.id="CommBoard"
 Set chckbx9.name="CommBoard"
 Set chckbx9.dataBinding="CommBoard"
 Set chckbx9.disabled=1
 Set chckbx9.label="Use Comm Board:"
 Do hgrp8.%AddChild(chckbx9)
 Set spcr9 = ##class(%ZEN.Component.spacer).%New()
 Set spcr9.width=5
 Do hgrp8.%AddChild(spcr9)
 Set chckbx9 = ##class(%ZEN.Component.checkbox).%New()
 Set chckbx9.id="TriageRpt"
 Set chckbx9.name="TriageRpt"
 Set chckbx9.dataBinding="TriageRpt"
 Set chckbx9.disabled=1
 Set chckbx9.label="Print Triage Report upon Save:"
 Do hgrp8.%AddChild(chckbx9)
 Set spcr9 = ##class(%ZEN.Component.spacer).%New()
 Set spcr9.width=5
 Do hgrp8.%AddChild(spcr9)
 Set chckbx9 = ##class(%ZEN.Component.checkbox).%New()
 Set chckbx9.id="SwitchEHRPat"
 Set chckbx9.name="SwitchEHRPat"
 Set chckbx9.dataBinding="SwitchEHRPat"
 Set chckbx9.disabled=1
 Set chckbx9.label="Switch EHR Patient on Edit: "
 Do hgrp8.%AddChild(chckbx9)
 Set spcr9 = ##class(%ZEN.Component.spacer).%New()
 Set spcr9.width=5
 Do hgrp8.%AddChild(spcr9)
 Set hgrp6 = ##class(%ZEN.Component.hgroup).%New()
 Do fldSt5.%AddChild(hgrp6)
 Set spcr7 = ##class(%ZEN.Component.spacer).%New()
 Set spcr7.width=5
 Do hgrp6.%AddChild(spcr7)
 Set vgrp7 = ##class(%ZEN.Component.vgroup).%New()
 Do hgrp6.%AddChild(vgrp7)
 Set hgrp8 = ##class(%ZEN.Component.hgroup).%New()
 Do vgrp7.%AddChild(hgrp8)
 Set spcr9 = ##class(%ZEN.Component.spacer).%New()
 Set spcr9.width=5
 Do hgrp8.%AddChild(spcr9)
 Set pn9 = ##class(%ZEN.Component.pane).%New()
 Set pn9.paneName="Pending Status Look Back"
 Do hgrp8.%AddChild(pn9)
 Set txt9 = ##class(%ZEN.Component.text).%New()
 Set txt9.id="PendingStsLookBack"
 Set txt9.name="PendingStsLookBack"
 Set txt9.dataBinding="PendingStsLookBack"
 Set txt9.disabled=1
 Set txt9.label="Pending Status Look Back Days:"
 Set txt9.onchange="zenPage.PendingDaysChk()"
 Set txt9.size=30
 Do hgrp8.%AddChild(txt9)
 Set spcr9 = ##class(%ZEN.Component.spacer).%New()
 Set spcr9.width=5
 Do hgrp8.%AddChild(spcr9)
 Set vgrp5 = ##class(%ZEN.Component.vgroup).%New()
 Do frm4.%AddChild(vgrp5)
 Set spcr6 = ##class(%ZEN.Component.spacer).%New()
 Set spcr6.height=10
 Do vgrp5.%AddChild(spcr6)
 Set fldSt5 = ##class(%ZEN.Component.fieldSet).%New()
 Set fldSt5.id="UserPreferences"
 Set fldSt5.enclosingStyle="border: 2px solid grey;"
 Set fldSt5.legend="User Specific Preferences"
 Do frm4.%AddChild(fldSt5)
 Set spcr6 = ##class(%ZEN.Component.spacer).%New()
 Set spcr6.height=10
 Do fldSt5.%AddChild(spcr6)
 Set vgrp6 = ##class(%ZEN.Component.vgroup).%New()
 Do fldSt5.%AddChild(vgrp6)
 Set hgrp7 = ##class(%ZEN.Component.hgroup).%New()
 Do vgrp6.%AddChild(hgrp7)
 Set txt8 = ##class(%ZEN.Component.text).%New()
 Set txt8.id="DUZ"
 Set txt8.name="DUZ"
 Set txt8.hidden=1
 Set txt8.label="User ID:"
 Set txt8.readOnly=1
 Set txt8.size=8
 Do hgrp7.%AddChild(txt8)
 Set dtCmb8 = ##class(%ZEN.Component.dataCombo).%New()
 Set dtCmb8.id="UserName"
 Set dtCmb8.name="UserName"
 Set dtCmb8.buttonCaption="Lookup User"
 Set dtCmb8.buttonTitle="Search for a record by Patient Name"
 Set dtCmb8.comboType="button"
 Set dtCmb8.disabled=1
 Set dtCmb8.displayColumns=2
 Set dtCmb8.dropdownHeight=100
 Set dtCmb8.dropdownWidth=300
 Set dtCmb8.editable=1
 Set dtCmb8.label="User Name:"
 Set dtCmb8.onchange="zenPage.selectUser(zenThis);"
 Set dtCmb8.searchKeyLen=5
 Set dtCmb8.size=24
 Set dtCmb8.sql="SELECT TOP 100 NEW_PERSON.IEN,NEW_PERSON.NAME,KEYS_200C200_051.KEY_01->NAME,KEYS_200C200_051.NEW_PERSON->IEN FROM BMW.NEW_PERSON NEW_PERSON,BMW.KEYS_200C200_051 KEYS_200C200_051 WHERE  NEW_PERSON.NAME %STARTSWITH UPPER(?) AND KEYS_200C200_051.KEY_01->NAME = 'BEDDZDASH' AND NEW_PERSON.IEN = KEYS_200C200_051.NEW_PERSON->IEN ORDER BY NEW_PERSON.NAME"
 Set dtCmb8.title="This list will contain users who have been assigned the BEDDZDASH security key"
 Set dtCmb8.unrestricted=1
 Set dtCmb8.valueColumn=2
 Do hgrp7.%AddChild(dtCmb8)
 Set spcr6 = ##class(%ZEN.Component.spacer).%New()
 Set spcr6.height=10
 Do fldSt5.%AddChild(spcr6)
 Set vgrp6 = ##class(%ZEN.Component.vgroup).%New()
 Do fldSt5.%AddChild(vgrp6)
 Set fldSt7 = ##class(%ZEN.Component.fieldSet).%New()
 Set fldSt7.id="PatDispGrp"
 Set fldSt7.legend="Patient Name Format Display"
 Do vgrp6.%AddChild(fldSt7)
 Set hgrp8 = ##class(%ZEN.Component.hgroup).%New()
 Do fldSt7.%AddChild(hgrp8)
 Set rdBttn9 = ##class(%ZEN.Component.radioButton).%New()
 Set rdBttn9.id="FLFF"
 Set rdBttn9.name="Patient Name"
 Set rdBttn9.caption="Last Name, First Name"
 Set rdBttn9.disabled=1
 Set rdBttn9.optionValue="FLFF"
 Do hgrp8.%AddChild(rdBttn9)
 Set rdBttn9 = ##class(%ZEN.Component.radioButton).%New()
 Set rdBttn9.id="FLIF"
 Set rdBttn9.name="Patient Name"
 Set rdBttn9.caption="Last Name, First Initial"
 Set rdBttn9.disabled=1
 Set rdBttn9.optionValue="FLIF"
 Do hgrp8.%AddChild(rdBttn9)
 Set rdBttn9 = ##class(%ZEN.Component.radioButton).%New()
 Set rdBttn9.id="ILIF"
 Set rdBttn9.name="Patient Name"
 Set rdBttn9.caption="Last Initial. First Initial."
 Set rdBttn9.disabled=1
 Set rdBttn9.optionValue="ILIF"
 Do hgrp8.%AddChild(rdBttn9)
 Set rdBttn9 = ##class(%ZEN.Component.radioButton).%New()
 Set rdBttn9.id="L3F2"
 Set rdBttn9.name="Patient Name"
 Set rdBttn9.caption="Last Three, First Two."
 Set rdBttn9.disabled=1
 Set rdBttn9.optionValue="L3F2"
 Do hgrp8.%AddChild(rdBttn9)
 Set vgrp6 = ##class(%ZEN.Component.vgroup).%New()
 Do fldSt5.%AddChild(vgrp6)
 Set spcr7 = ##class(%ZEN.Component.spacer).%New()
 Set spcr7.height=10
 Do vgrp6.%AddChild(spcr7)
 Set hgrp7 = ##class(%ZEN.Component.hgroup).%New()
 Do vgrp6.%AddChild(hgrp7)
 Set spcr8 = ##class(%ZEN.Component.spacer).%New()
 Set spcr8.width=15
 Do hgrp7.%AddChild(spcr8)
 Set chckbx8 = ##class(%ZEN.Component.checkbox).%New()
 Set chckbx8.id="UserPrefDOB"
 Set chckbx8.name="UserPrefDOB"
 Set chckbx8.disabled=1
 Set chckbx8.label="Hide DOB:"
 Do hgrp7.%AddChild(chckbx8)
 Set spcr8 = ##class(%ZEN.Component.spacer).%New()
 Set spcr8.width=25
 Do hgrp7.%AddChild(spcr8)
 Set chckbx8 = ##class(%ZEN.Component.checkbox).%New()
 Set chckbx8.id="UserPrefComp"
 Set chckbx8.name="UserPrefComp"
 Set chckbx8.disabled=1
 Set chckbx8.label="Hide Complaint:"
 Do hgrp7.%AddChild(chckbx8)
 Set spcr8 = ##class(%ZEN.Component.spacer).%New()
 Set spcr8.width=25
 Do hgrp7.%AddChild(spcr8)
 Set chckbx8 = ##class(%ZEN.Component.checkbox).%New()
 Set chckbx8.id="UserPrefSex"
 Set chckbx8.name="UserPrefSex"
 Set chckbx8.disabled=1
 Set chckbx8.label="Hide Gender:"
 Do hgrp7.%AddChild(chckbx8)
 Set fldSt5 = ##class(%ZEN.Component.fieldSet).%New()
 Set fldSt5.id="Whiteboard Display"
 Set fldSt5.enclosingStyle="border: 2px solid grey;"
 Set fldSt5.legend="Whiteboard Display Settings"
 Set fldSt5.title="Click on the Whiteboard Display entry above to edit. Only users holding the BEDDZWHITEBOARD security key can edit this information"
 Do frm4.%AddChild(fldSt5)
 Set spcr6 = ##class(%ZEN.Component.spacer).%New()
 Set spcr6.height=10
 Do fldSt5.%AddChild(spcr6)
 Set vgrp6 = ##class(%ZEN.Component.vgroup).%New()
 Do fldSt5.%AddChild(vgrp6)
 Set hgrp7 = ##class(%ZEN.Component.hgroup).%New()
 Do vgrp6.%AddChild(hgrp7)
 Set txt8 = ##class(%ZEN.Component.text).%New()
 Set txt8.id="WACCESS"
 Set txt8.name="WACCESS"
 Set txt8.controlStyle="background: grey"
 Set txt8.label="Whiteboard Access:"
 Set txt8.readOnly=1
 Set txt8.size=12
 Set txt8.title="Click on the Whiteboard Display entry above to edit. Only users holding the BEDDZWHITEBOARD security key can edit this information"
 Set txt8.value="Whiteboard"
 Do hgrp7.%AddChild(txt8)
 Set spcr8 = ##class(%ZEN.Component.spacer).%New()
 Set spcr8.width=25
 Do hgrp7.%AddChild(spcr8)
 Set psswrd8 = ##class(%ZEN.Component.password).%New()
 Set psswrd8.id="WVERIFY"
 Set psswrd8.name="WVERIFY"
 Set psswrd8.dataBinding="Verify"
 Set psswrd8.disabled=1
 Set psswrd8.label="Whiteboard Verify:"
 Set psswrd8.size=12
 Set psswrd8.title="Click on the Whiteboard Display entry above to edit. Only users holding the BEDDZWHITEBOARD security key can edit this information"
 Do hgrp7.%AddChild(psswrd8)
 Set spcr6 = ##class(%ZEN.Component.spacer).%New()
 Set spcr6.height=10
 Do fldSt5.%AddChild(spcr6)
 Set vgrp6 = ##class(%ZEN.Component.vgroup).%New()
 Do fldSt5.%AddChild(vgrp6)
 Set hgrp7 = ##class(%ZEN.Component.hgroup).%New()
 Do vgrp6.%AddChild(hgrp7)
 Set chckbx8 = ##class(%ZEN.Component.checkbox).%New()
 Set chckbx8.id="WhiteboardAccess"
 Set chckbx8.name="WhiteboardAccess"
 Set chckbx8.dataBinding="WhiteboardAccess"
 Set chckbx8.disabled=1
 Set chckbx8.label="Whiteboard Access: "
 Set chckbx8.title="Click on the Whiteboard Display entry above to edit. Only users holding the BEDDZWHITEBOARD security key can edit this information"
 Do hgrp7.%AddChild(chckbx8)
 Set chckbx8 = ##class(%ZEN.Component.checkbox).%New()
 Set chckbx8.id="WhiteboardShowAge"
 Set chckbx8.name="WhiteboardShowAge"
 Set chckbx8.dataBinding="WhiteboardShowAge"
 Set chckbx8.disabled=1
 Set chckbx8.label="Show Age:"
 Set chckbx8.title="Click on the Whiteboard Display entry above to edit. Only users holding the BEDDZWHITEBOARD security key can edit this information"
 Do hgrp7.%AddChild(chckbx8)
 Set spcr8 = ##class(%ZEN.Component.spacer).%New()
 Set spcr8.width=25
 Do hgrp7.%AddChild(spcr8)
 Set chckbx8 = ##class(%ZEN.Component.checkbox).%New()
 Set chckbx8.id="WhiteboardShowProvider"
 Set chckbx8.name="WhiteboardShowProvider"
 Set chckbx8.dataBinding="WhiteboardShowProvider"
 Set chckbx8.disabled=1
 Set chckbx8.label="Show Provider:"
 Set chckbx8.title="Click on the Whiteboard Display entry above to edit. Only users holding the BEDDZWHITEBOARD security key can edit this information"
 Do hgrp7.%AddChild(chckbx8)
 Set spcr8 = ##class(%ZEN.Component.spacer).%New()
 Set spcr8.width=25
 Do hgrp7.%AddChild(spcr8)
 Set chckbx8 = ##class(%ZEN.Component.checkbox).%New()
 Set chckbx8.id="WhiteboardShowNurse"
 Set chckbx8.name="WhiteboardShowNurse"
 Set chckbx8.dataBinding="WhiteboardShowNurse"
 Set chckbx8.disabled=1
 Set chckbx8.label="Show Nurse:"
 Set chckbx8.title="Click on the Whiteboard Display entry above to edit. Only users holding the BEDDZWHITEBOARD security key can edit this information"
 Do hgrp7.%AddChild(chckbx8)
 Set spcr8 = ##class(%ZEN.Component.spacer).%New()
 Set spcr8.width=25
 Do hgrp7.%AddChild(spcr8)
 Set chckbx8 = ##class(%ZEN.Component.checkbox).%New()
 Set chckbx8.id="WhiteboardShowOrders"
 Set chckbx8.name="WhiteboardShowOrders"
 Set chckbx8.dataBinding="WhiteboardShowOrders"
 Set chckbx8.disabled=1
 Set chckbx8.label="Show Orders:"
 Set chckbx8.title="Click on the Whiteboard Display entry above to edit. Only users holding the BEDDZWHITEBOARD security key can edit this information"
 Do hgrp7.%AddChild(chckbx8)
 Set spcr8 = ##class(%ZEN.Component.spacer).%New()
 Set spcr8.width=25
 Do hgrp7.%AddChild(spcr8)
 Set chckbx8 = ##class(%ZEN.Component.checkbox).%New()
 Set chckbx8.id="WhiteboardShowName"
 Set chckbx8.name="WhiteboardShowName"
 Set chckbx8.dataBinding="WhiteboardShowName"
 Set chckbx8.disabled=1
 Set chckbx8.label="Show Name:"
 Set chckbx8.title="Click on the Whiteboard Display entry above to edit. Only users holding the BEDDZWHITEBOARD security key can edit this information"
 Do hgrp7.%AddChild(chckbx8)
 Set vgrp6 = ##class(%ZEN.Component.vgroup).%New()
 Do fldSt5.%AddChild(vgrp6)
 Set hgrp7 = ##class(%ZEN.Component.hgroup).%New()
 Do vgrp6.%AddChild(hgrp7)
 Set chckbx8 = ##class(%ZEN.Component.checkbox).%New()
 Set chckbx8.id="WhiteboardShowNotes"
 Set chckbx8.name="WhiteboardShowNotes"
 Set chckbx8.dataBinding="WhiteboardShowNotes"
 Set chckbx8.disabled=1
 Set chckbx8.label="Show Info:"
 Set chckbx8.title="Click on the Whiteboard Display entry above to edit. Only users holding the BEDDZWHITEBOARD security key can edit this information"
 Do hgrp7.%AddChild(chckbx8)
 Set spcr8 = ##class(%ZEN.Component.spacer).%New()
 Set spcr8.width=25
 Do hgrp7.%AddChild(spcr8)
 Set chckbx8 = ##class(%ZEN.Component.checkbox).%New()
 Set chckbx8.id="WhiteboardShowComplaint"
 Set chckbx8.name="WhiteboardShowComplaint"
 Set chckbx8.dataBinding="WhiteboardShowComplaint"
 Set chckbx8.disabled=1
 Set chckbx8.label="Show Complaint:"
 Set chckbx8.title="Click on the Whiteboard Display entry above to edit. Only users holding the BEDDZWHITEBOARD security key can edit this information"
 Do hgrp7.%AddChild(chckbx8)
 Set spcr8 = ##class(%ZEN.Component.spacer).%New()
 Set spcr8.width=25
 Do hgrp7.%AddChild(spcr8)
 Set chckbx8 = ##class(%ZEN.Component.checkbox).%New()
 Set chckbx8.id="WhiteboardShowChartNumber"
 Set chckbx8.name="WhiteboardShowChartNumber"
 Set chckbx8.dataBinding="WhiteboardShowChartNumber"
 Set chckbx8.disabled=1
 Set chckbx8.label="Show Chart Number:"
 Set chckbx8.title="Click on the Whiteboard Display entry above to edit. Only users holding the BEDDZWHITEBOARD security key can edit this information"
 Do hgrp7.%AddChild(chckbx8)
 Set spcr8 = ##class(%ZEN.Component.spacer).%New()
 Set spcr8.width=25
 Do hgrp7.%AddChild(spcr8)
 Set chckbx8 = ##class(%ZEN.Component.checkbox).%New()
 Set chckbx8.id="WhiteboardShowRoom"
 Set chckbx8.name="WhiteboardShowRoom"
 Set chckbx8.dataBinding="WhiteboardShowRoom"
 Set chckbx8.disabled=1
 Set chckbx8.label="Show Room:"
 Set chckbx8.title="Click on the Whiteboard Display entry above to edit. Only users holding the BEDDZWHITEBOARD security key can edit this information"
 Do hgrp7.%AddChild(chckbx8)
 Set spcr8 = ##class(%ZEN.Component.spacer).%New()
 Set spcr8.width=25
 Do hgrp7.%AddChild(spcr8)
 Set chckbx8 = ##class(%ZEN.Component.checkbox).%New()
 Set chckbx8.id="WhiteboardShowAcuity"
 Set chckbx8.name="WhiteboardShowAcuity"
 Set chckbx8.dataBinding="WhiteboardShowAcuity"
 Set chckbx8.disabled=1
 Set chckbx8.label="Show Acuity: "
 Set chckbx8.title="Click on the Whiteboard Display entry above to edit. Only users holding the BEDDZWHITEBOARD security key can edit this information"
 Do hgrp7.%AddChild(chckbx8)
 Set hgrp5 = ##class(%ZEN.Component.hgroup).%New()
 Do frm4.%AddChild(hgrp5)
 Set spcr6 = ##class(%ZEN.Component.spacer).%New()
 Set spcr6.height=10
 Do hgrp5.%AddChild(spcr6)
 Set vgrp6 = ##class(%ZEN.Component.vgroup).%New()
 Do hgrp5.%AddChild(vgrp6)
 Set hgrp7 = ##class(%ZEN.Component.hgroup).%New()
 Do vgrp6.%AddChild(hgrp7)
 Set bttn8 = ##class(%ZEN.Component.button).%New()
 Set bttn8.id="Save"
 Set bttn8.caption="Save"
 Set bttn8.disabled=1
 Set bttn8.onclick="zenPage.saveItem();"
 Do hgrp7.%AddChild(bttn8)
 Set spcr8 = ##class(%ZEN.Component.spacer).%New()
 Set spcr8.width=10
 Do hgrp7.%AddChild(spcr8)
 Set bttn8 = ##class(%ZEN.Component.button).%New()
 Set bttn8.id="Cancel"
 Set bttn8.caption="Cancel"
 Set bttn8.onclick="zenPage.cancel();"
 Do hgrp7.%AddChild(bttn8)
 Set spcr8 = ##class(%ZEN.Component.spacer).%New()
 Set spcr8.width=10
 Do hgrp7.%AddChild(spcr8)
 Do ..%GetDependentComponents(pg1)
 Quit pg1 }
%DrawClassDefinition() public {
 Write !
 Write "self._zenClassIdx['EDSystem'] = 'BEDDAPPL_EDSystem';",!
 Write "self.BEDDAPPL_EDSystem = function(index,id) {",!
 Write $C(9),"if (index>=0) {BEDDAPPL_EDSystem__init(this,index,id);}",!
 Write "}",!
 Write !
 Write "self.BEDDAPPL_EDSystem__init = function(o,index,id) {",!
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
 Do JSClientMethod("CheckUser","")
 Do JSClientMethod("PendingDaysChk","")
 Do JSClientMethod("TimeOutChk","")
 Do JSClientMethod("cancel","")
 Do JSClientMethod("deleteEntry","")
 Do JSClientMethod("newEntry","")
 Do JSClientMethod("rowSelected","")
 Do JSClientMethod("saveItem","")
 Do JSClientMethod("selectUser","cb")
 Do JSClientMethod("showsysForm","id")
 Do JSSvrMethod(1,"","ClearUser","pForm","O")
 Do JSSvrMethod(1,"","LoadUser","pForm,pID","O,L")
 Do JSSvrMethod(1,"BOOLEAN","LoadZenComponent","pNamespace,pName,pClassName,pCSSLevel","L,L,L,L")
 Do JSSvrMethod(1,"","MonitorBackgroundTask","pTaskID","L")
 Do JSSvrMethod(0,"","ReallyRefreshContents","","")
 Do JSSvrMethod(0,"","SaveUserPref","form","O")
 Do JSSvrMethod(0,"","SaveWhiteboardPref","form","O")
 Do JSSvrMethod(0,"VARCHAR","getAppTimeout","","")
 Do JSSvrMethod(0,"INTEGER","getWhiteboardAccess","","")
 Write "self.BEDDAPPL_EDSystem__Loader = function() {",!
 Set tCls = "BEDDAPPL_EDSystem"
 Write $C(9),"zenLoadClass('_ZEN_Component_page');",!
 Write $C(9),tCls,".prototype = zenCreate('_ZEN_Component_page',-1);",!
 Write $C(9),"var p = ",tCls,".prototype;",!
 Write $C(9),"if (null==p) {return;}",!
 Write $C(9),"p.constructor = ",tCls,";",!
 Write $C(9),"p.superClass = ('undefined' == typeof _ZEN_Component_page) ? zenMaster._ZEN_Component_page.prototype:_ZEN_Component_page.prototype;",!
 Write $C(9),"p.__ZENcomponent = true;",!
 Write $C(9),"p._serverClass = '"_$ZCVT("BEDDAPPL.EDSystem","O","JS")_"';",!
 Write $C(9),"p._type = '"_"EDSystem"_"';",!
 Write $C(9),"p.serialize = ",tCls,"_serialize;",!
 Write $C(9),"p.getSettings = ",tCls,"_getSettings;",!
 Write $C(9),"p.CheckUser = ",tCls,"_CheckUser;",!
 Write $C(9),"p.ClearUser = ",tCls,"_ClearUser;",!
 Write $C(9),"p.LoadUser = ",tCls,"_LoadUser;",!
 Write $C(9),"p.LoadZenComponent = ",tCls,"_LoadZenComponent;",!
 Write $C(9),"p.MonitorBackgroundTask = ",tCls,"_MonitorBackgroundTask;",!
 Write $C(9),"p.PendingDaysChk = ",tCls,"_PendingDaysChk;",!
 Write $C(9),"p.ReallyRefreshContents = ",tCls,"_ReallyRefreshContents;",!
 Write $C(9),"p.SaveUserPref = ",tCls,"_SaveUserPref;",!
 Write $C(9),"p.SaveWhiteboardPref = ",tCls,"_SaveWhiteboardPref;",!
 Write $C(9),"p.TimeOutChk = ",tCls,"_TimeOutChk;",!
 Write $C(9),"p.cancel = ",tCls,"_cancel;",!
 Write $C(9),"p.deleteEntry = ",tCls,"_deleteEntry;",!
 Write $C(9),"p.getAppTimeout = ",tCls,"_getAppTimeout;",!
 Write $C(9),"p.getWhiteboardAccess = ",tCls,"_getWhiteboardAccess;",!
 Write $C(9),"p.newEntry = ",tCls,"_newEntry;",!
 Write $C(9),"p.rowSelected = ",tCls,"_rowSelected;",!
 Write $C(9),"p.saveItem = ",tCls,"_saveItem;",!
 Write $C(9),"p.selectUser = ",tCls,"_selectUser;",!
 Write $C(9),"p.showsysForm = ",tCls,"_showsysForm;",!
 Write "}",!
 Quit 1
JSClientMethod(method,args)
 Write !,"self.","BEDDAPPL_EDSystem","_",method," = function(",args,") {",!
 For line=1:1:$s($d(^oddCOM("BEDDAPPL.EDSystem","m",method,30))#2:^(30),$d(^oddCOM($g(^(2),"BEDDAPPL.EDSystem"),"m",method,30))#2:^(30),1:$s($d(^oddDEF($g(^oddCOM("BEDDAPPL.EDSystem","m",method,2),"BEDDAPPL.EDSystem"),"m",method,30))#2:^(30),1:$g(^%qCacheObjectKey(1,"m",30)))) {
  If +$G(%zenStripJS) {
   Set tLine = $ZSTRIP($s($d(^oddCOM("BEDDAPPL.EDSystem","m",method,30,line))#2:^(line),$d(^oddCOM($g(^oddCOM("BEDDAPPL.EDSystem","m",method,2),"BEDDAPPL.EDSystem"),"m",method,30,line))#2:^(line),1:$g(^oddDEF($g(^oddCOM("BEDDAPPL.EDSystem","m",method,2),"BEDDAPPL.EDSystem"),"m",method,30,line))),"<>W")
   If (tLine["&") {
    Set tLine = $Replace(tLine,"&nbsp;","&#160;")
    Set tLine = $Replace(tLine,"&raquo;","&#187;")
    Set tLine = $Replace(tLine,"&laquo;","&#171;")
   }
   Write:(($L(tLine)>0)&&($E(tLine,1,2)'="//")) tLine,!
  } Else {
   Write $s($d(^oddCOM("BEDDAPPL.EDSystem","m",method,30,line))#2:^(line),$d(^oddCOM($g(^oddCOM("BEDDAPPL.EDSystem","m",method,2),"BEDDAPPL.EDSystem"),"m",method,30,line))#2:^(line),1:$g(^oddDEF($g(^oddCOM("BEDDAPPL.EDSystem","m",method,2),"BEDDAPPL.EDSystem"),"m",method,30,line))),!
  }
 }
 Write "}",!
 Quit
JSSvrMethod(cm,retType,method,args,spec)
 Write !,"self.","BEDDAPPL_EDSystem","_",method," = function(",args,") {",!
 Write $C(9),$S(retType="":"",1:"return "),$S(cm:"zenClassMethod",1:"zenInstanceMethod"),"(this,'",method,"','",spec,"','",retType,"',arguments);",!
 Write "}",!
 Quit }
%DrawJSGetSettings() public {
 Write "function BEDDAPPL_EDSystem_getSettings(s)",!
 Write "{",!
 Write $C(9),"s['name'] = 'string';",!
 Write $C(9),"s['dlID'] = 'string';",!
 Write $C(9),"this.invokeSuper('getSettings',arguments);",!
 Write "}",!
 Quit 1 }
%DrawJSSerialize() public {
 Write "function BEDDAPPL_EDSystem_serialize(set,s)",!
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
 If '$D(pVisited("BEDDAPPL.EDSystem")) {
  Set tSC = ##class(%ZEN.Component.page)$this.%DrawJSStrings(.pVisited)
  Set pVisited("BEDDAPPL.EDSystem") = ""
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
   Write:'idx "throw new Error('Collection element is not part of the page model.\nClass: BEDDAPPL.EDSystem\nProperty: children\nElement Type:%ZEN.Component.component\nKey: ",i,"');",!
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
 Write "<!-- SVGDef: BEDDAPPL.EDSystem -->",!  }
%DrawStyleHTML(pLevel=2) public {
 Write "<!-- Style: BEDDAPPL.EDSystem -->",! 
 Write "",!
	Write "<style type=""text/css""> ",!
	Write ".textboxdisabled {",!
	Write "	background: #C0C0C0;",!
	Write "}",!
	Write "</style>",!
	Write " ",!  }
%DrawStyleSVG() public {
 Write "<!-- SVGStyle: BEDDAPPL.EDSystem -->",!  }
%GetClassCRC() public {
 Quit 1392427714 }
%GetDependentComponents(pPage) public {
   Set pPage.%ComponentClasses(6,"BEDDAPPL.EDSystem") = 1
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
 If $D(%zenClassList("BEDDAPPL.EDSystem")) Quit
 Set %zenClassList("BEDDAPPL.EDSystem") = ""
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
 Quit "%ZEN.Component.object,%ZEN.Component.component,%ZEN.Component.abstractGroup,%ZEN.Component.group,%ZEN.Component.abstractPage,%ZEN.Component.page,BEDDAPPL.EDSystem" }
%GetXMLName(pNamespace,pName) public {
 Set pNamespace = "http://www.intersystems.com/zen"
 Set pName = "EDSystem" }
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
   Write:'idx "throw new Error('Collection element is not part of the page model.\nClass: BEDDAPPL.EDSystem\nProperty: children\nElement Type:%ZEN.Component.component\nKey: ",i,"');",!
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
 Set tSC = $$Error^%apiOBJ(5002,"BEDDAPPL.EDSystem:ObjectSynch: "_$ZE)
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
zClearUser(pForm) public {
   	Do %page.%SetValueById("UserPrefDOB","")
    Do %page.%SetValueById("UserPrefComp","")
    Do %page.%SetValueById("UserPrefSex","")
    Do %page.%SetValueByName("Patient Name","")
    Do %page.%SetValueById("UserName","")
    Do %page.%SetValueById("DUZ","")
	Quit }
zLoadUser(pForm,pID) public {
    Set site=%page.%GetValueById("Site")
    Set duz=pID
    If pID="" {
    	Set duz=%page.%GetValueById("DUZ")
    }
    Set Result=$$LUPREF^BEDDPREF(site,duz)
   	Do %page.%SetValueById("UserPrefDOB",$P(Result,"^"))
    Do %page.%SetValueById("UserPrefComp",$P(Result,"^",2))
    Do %page.%SetValueById("UserPrefSex",$P(Result,"^",3))
    Do %page.%SetValueByName("Patient Name",$P(Result,"^",4))
    Do %page.%SetValueById("DUZ",duz)
	Quit }
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
zSaveUserPref(form) public {
	Set HideDOB = %page.%GetValueById("UserPrefDOB")
	Set HideCOMP = %page.%GetValueById("UserPrefComp")
	Set HideSex = %page.%GetValueById("UserPrefSex")
	Set NameFRMT = %page.%GetValueById("FLFF")
	Set Site = %page.%GetValueById("Site")
	Set DUZ = %page.%GetValueById("DUZ")
	Set Status=$$SUPREF^BEDDPREF(Site,DUZ,HideDOB,HideCOMP,HideSex,NameFRMT) }
zSaveWhiteboardPref(form) public {
	Set wVerify = %page.%GetValueById("WVERIFY")
	Set Status=$$WBPREF^BEDDPREF(wVerify) }
zXMLNew(document,node,containerOref="")
	Quit (##class(BEDDAPPL.EDSystem).%New())
zgetAppTimeout() public {
	quit %session.AppTimeout }
zgetWhiteboardAccess() public {
	If $G(%session.Data("DUZ"))
		{Q $$WACCESS^BEDDPREF($G(%session.Data("DUZ")))}
  	else
     {Q 0} }
