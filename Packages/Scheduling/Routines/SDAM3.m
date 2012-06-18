SDAM3 ;MJK/ALB - Appt Mgt (Clinic) ; [ 09/13/2001  2:12 PM ]
 ;;5.3;Scheduling;**63,189,1003**;Aug 13, 1993
 ;IHS/ANMC/LJF 8/18/2000 added warnings that clinic was inactivated
 ;             7/12/2001 changed default list to all appts
 ;IHS/ITSC/LJF 6/17/2005 PATCH 1003 allow appt threshold of zero
 ;
INIT ; -- get init clinic appt data
 ;  input:        SDCLN := ifn of pat
 ; output:  ^TMP("SDAM" := appt array
 ;
 I '$$ACTV^BSDU(SDCLN,DT) D   ;IHS/ANMC/LJF 8/18/2000
 . S X="** Inactivated on "_$$INACTVDT^BSDU(SDCLN)_" **"  ;IHS/ANMC/LJF 8/18/2000
 . D EN^DDIOL(.X)   ;IHS/ANMC/LJF 8/18/2000
 ;
 ;IHS/ITSC/LJF 6/17/2005 PATCH 1003
 ;S X=$P($G(^DG(43,1,"SCLR")),U,12),SDPRD=$S(X:X,1:2)
 S X=$P($G(^DG(43,1,"SCLR")),U,12),SDPRD=$S(X]"":X,1:2)
 ;
 S X1=DT,X2=-SDPRD D C^%DTC S VALMB=X D RANGE^VALM11
 I '$D(VALMBEG) S VALMQUIT="" G INITQ
 S SDBEG=VALMBEG,SDEND=VALMEND
 D CHGCAP^VALM("NAME","Patient")
 ;
 ;IHS/ANMC/LJF 7/12/2001 default to all appts
 ;S X="NO ACTION TAKEN" D LIST^SDAM
 S X="ALL" D LIST^SDAM
 ;IHS/ANMC/LJF 7/12/2001 end of changes
 ;
INITQ K VALMB,VALMBEG,VALMEND Q
 ;
BLD ; -- scan apts
 N VA,SDAMDD,SDNAME,SDMAX,SDLARGE,DFN,SDCL,BL,XC,XW,AC,AW,TC,TW,NC,NW,SC,SW,SDT,SDDA ; done for speed see INIT^SDAM10
 D INIT^SDAM10
 F SDT=SDBEG:0 S SDT=$O(^SC(SDCLN,"S",SDT)) Q:'SDT!($P(SDT,".",1)>SDEND)  D
 .F SDDA=0:0 S SDDA=$O(^SC(SDCLN,"S",SDT,1,SDDA)) Q:'SDDA  D
 ..I $D(^(SDDA,0)) S DFN=+^(0) D PID^VADPT I $D(^DPT(DFN,"S",SDT,0)),$$VALID^SDAM2(DFN,SDCLN,SDT,SDDA) S SDATA=^DPT(DFN,"S",SDT,0),SDCL=SDCLN,SDNAME=VA("BID")_" "_$P($G(^DPT(DFN,0)),U) D:SDCLN=+SDATA BLD1^SDAM1
 D NUL^SDAM10,LARGE^SDAM10:$D(SDLARGE)
 S $P(^TMP("SDAM",$J,0),U,4)=VALMCNT
 Q
 ;
HDR ; -- list screen header
 ;   input:      SDCLN := ifn of pat
 ;  output:  VALMHDR() := hdr array
 ;
 S VALMHDR(1)=$E($P("Clinic: "_$G(^SC(SDCLN,0)),"^",1),1,45)  ;for proper display of clinic name for SD*5.3*189
 Q
 ;
CLN ; -- change clinic
 I $G(SDAMLIST)["CANCELLED" S VALMBCK="" W !!,*7,"You must be viewing a patient to list cancelled appointments." D PAUSE^VALM1 G CLNQ
 D FULL^VALM1 S VALMBCK="R"
 S X="" I $D(XQORNOD(0)) S X=$P($P(XQORNOD(0),U,4),"=",2)
 W ! S DIC="^SC(",DIC(0)=$S(X]"":"",1:"A")_"EMQ",DIC("A")="Select Clinic: ",DIC("S")="I $P(^(0),U,3)=""C"",'$G(^(""OOS""))"
 S DIC("W")=$$INACTMSG^BSDU   ;IHS/ANMC/LJF 8/18/2000
 D ^DIC K DIC
 I Y<0 D  G CLNQ
 .I SDAMTYP="C" S VALMSG=$C(7)_"Clinic has not been changed."
 .I SDAMTYP="P" S VALMSG=$C(7)_"View of patient remains in affect."
 I SDAMTYP'="C" D CHGCAP^VALM("NAME","Patient") S SDAMTYP="C"
 S SDCLN=+Y K SDFN D BLD
CLNQ Q
 ;
