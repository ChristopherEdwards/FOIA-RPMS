BKMVQCR ;VNGT/HS/ALA-Quality of Care Report Roll&Scroll ; 20 Jun 2011  12:38 PM
 ;;2.1;HIV MANAGEMENT SYSTEM;**1**;FEB 7, 2011;Build 30
 Q
 ;
EN(REG) ;EP - Primary
 NEW BACK,BKMRPOP,EDATE,BKMTAG,BQDFN,PN,QFL,DIR,DTOUT,DUOUT,Y,X
EN1 ;
 S BACK=0
 ;D NOW^%DTC
 S BKMRPOP=$$SELPOP()
 I BKMRPOP=""!(BKMRPOP="^") G XIT
 ;Active HIV/AIDS Diagnostic Tag
 I BKMRPOP="D" D ACT I $D(DTOUT)!$D(DUOUT) G XIT
 ; Selected Patient(s)
 I BKMRPOP="P" D PTL
 ;
 D ENDATE
 I EDATE=-1 G XIT
 D RUN^BKMQQCR(.DATA,BKMRPOP,EDATE,$G(OWNR),$G(PLIEN),$G(BKMTAG),.BQDFN,1)
 ;
EN3 ; print the report
 D ^%ZIS
 I IOST["C-" W @IOF
 S PN=0,QFL=0
 F  S PN=$O(^TMP("BQIQOC",$J,PN)) Q:'PN!(QFL)  D
 . I (IOSL-$Y)<6 D  Q:QFL
 .. I IOST["C-",$$PAUSE^BKMIXX3 W @IOF I X="^" S QFL=1 Q
 .. W @IOF
 . U IO W !,^TMP("BQIQOC",$J,PN)
 D CLEAN,^%ZISC,XIT
 Q
 ;
SELPOP() ; Select Report population
SELPOP1 ; GOTO return
 K DIR
 S DIR("A")="Report Population"
 S DIR(0)="SO^D:Active HIV/AIDS Diagnostic Tag;R:Active HMS Register Patients;P:Selected Patient(s)"
 D ^DIR I $D(DTOUT)!$D(DUOUT) S Y=""
 I '(",R,P,D,"[(","_Y_",")) G SELPOP1
 Q Y
 ;
ENDATE ; ending date selection
 NEW %DT,Y
 S %DT="AE"
 S %DT("A")="Select ending date for report: ",%DT("B")="TODAY"
 D ^%DT
 S EDATE=Y
 Q
 ;
ACT ; Diagnostic Tag Status
 K DIR
 S DIR("A")="Select Diagnostic Tag Status"
 S DIR(0)="SO^A:Accepted;P:Proposed;B:Proposed and Accepted"
 D ^DIR
 I $D(DTOUT)!$D(DUOUT) Q
 I Y="" S BACK=1 Q
 S BKMTAG=Y
 Q
 ;
CLEAN ;clean up variables
 K ^TMP("BQIQOC",$J)
 Q
XIT ;
 D ^XBFMK
 Q
DICW ;EP - This is a specially written FileMan 'WRITE' statement
 N NZ,NAME,COUNTY,STATE,CODE,STCTYCOM
 S NZ=$G(^(0))
 S NAME=$P(NZ,U)
 S COUNTY=$P(NZ,U,2) I COUNTY'="" S COUNTY=$P($G(^AUTTCTY(COUNTY,0)),U)
 S STATE=$P(NZ,U,3) I STATE'="" S STATE=$P($G(^DIC(5,STATE,0)),U)
 S CODE=$P(NZ,U,7)
 S STCTYCOM=$P(NZ,U,8)
 S COUNTY=$J($E(COUNTY,1,15),15)
 S STATE=$J($E(STATE,1,17),17)
 S CODE=$J($E(CODE,1,6),6)
 S STCTYCOM=$J($E(STCTYCOM,1,10),10)
 W ?27,COUNTY," ",STATE," ",CODE," ",STCTYCOM
 Q
 ;
PTL ; Patient Lookup
 D PLK^BKMPLKP
 I $G(DFN)="" Q
 S BQDFN(DFN)=""
 G PTL
