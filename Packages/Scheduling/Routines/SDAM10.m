SDAM10 ;MJK/ALB - Appt Mgt (Patient cont.); 12/1/91
 ;;5.3;Scheduling;**189,258,1004**;Aug 13, 1993
 ;IHS/ANMC/LJF 10/10/2001 moved mods to BSDAM10
 ;IHS/OIT/LJF  07/28/2005 PATCH 1004 added code to display waiting list info
 ;
HDR ; -- list screen header
 ;   input:       SDFN := ifn of pat
 ;  output:  VALMHDR() := hdr array
 D HDR^BSDAM10 Q      ;IHS/ANMC/LJF 10/10/2001
 ;
 N VAERR,VA,X
 S DFN=SDFN D PID^VADPT
 S VALMHDR(1)=$E($P("Patient: "_$G(^DPT(SDFN,0)),U),1,46)_" ("_VA("BID")_")"  ;for proper display of patient name for SD*5.3*189
 S X=$P($$FMT^SDUTL2(SDFN),U,2),X=$S(X["GMT":X,X]"":"MT: "_X,1:"")
 S VALMHDR(1)=$$SETSTR^VALM1(X,VALMHDR(1),47,15)  ;repositioned header to display clinic or patient name properly for SD*5.3*189
 S X=$S($D(^DPT(SDFN,.1)):"Ward: "_^(.1),1:"Outpatient")
 S VALMHDR(1)=$$SETSTR^VALM1(X,VALMHDR(1),81-$L(X),$L(X))
 Q
 ;
PAT ; -- change pat
 D FULL^VALM1 S VALMBCK="R"
 K X I $D(XQORNOD(0)) S X=$P($P(XQORNOD(0),U,4),"=",2)
 I X="" R !!,"Select Patient: ",X:DTIME
 D RT^SDAMEX S DIC="^DPT(",DIC(0)="EMQ" D ^DIC K DIC G PAT:X["?"
 I Y<0 D  G PATQ
 .I SDAMTYP="P" S VALMSG=$C(7)_"Patient has not been changed."
 .I SDAMTYP="C" S VALMSG=$C(7)_"View of clinic remains in affect."
 I SDAMTYP'="P" D CHGCAP^VALM("NAME","Clinic") S SDAMTYP="P"
 S SDFN=+Y K SDCLN D BLD^SDAM1
PATQ Q
 ;
INIT ; -- init bld vars
 K VALMHDR,SDDA,^TMP("SDAMIDX",$J)
 D CLEAN^VALM10
 S VALMBG=1,(VALMCNT,SDACNT)=0,BL="",$P(BL," ",30)="",SDMAX=100
 S SDAMDD=$P(^DD(2.98,3,0),U,3)
 ; -- format vars     |- column -| |- width -|
 S X=VALMDDF("APPT#"),AC=$P(X,U,2),AW=$P(X,U,3) ; A for appt
 S X=VALMDDF("DATE"),XC=$P(X,U,2),XW=$P(X,U,3) ;  X for date
 S X=VALMDDF("NAME"),NC=$P(X,U,2),NW=$P(X,U,3) ;  N for name
 S X=VALMDDF("STAT"),SC=$P(X,U,2),SW=$P(X,U,3) ;  S for status
 S X=VALMDDF("TIME"),TC=$P(X,U,2),TW=$P(X,U,3) ;  T for time
 Q
 ;
LARGE ; -- too large note
 W !!?5,*7,"Note: Ending Date was changed to '",$$FDATE^VALM1(SDEND),"' because"
 W !?11,"too many appointments met date range criteria." D PAUSE^VALM1
 Q
 ;
NUL ; -- set nul message
 ;IHS/OIT/LJF 7/28/2005 PATCH 1004
 ;I '$O(^TMP("SDAM",$J,0)) D SET^SDAM1(" "),SET^SDAM1("    No appointments meet criteria.")
 I '$O(^TMP("SDAM",$J,0)) D
 . D SET^SDAM1(" "),SET^SDAM1("    No appointments meet criteria.")
 . I SDAMTYP="P" D WLDIS^BSDAM(DFN)
 Q
 ;
