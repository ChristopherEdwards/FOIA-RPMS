BSDCHKIN ;cmi/anch/maw - BSD CheckIn Auto Refresh 1/25/2007 1:06:21 PM
 ;;5.3;PIMS;**1007,1009**;FEB 27, 2007
 ;
EN ;EP; -- main entry point for BSDAM CHECKIN LIST
 ; variables already set coming into this routine:
 ;   SDCLN = clinic ien in file
 ;   BSDDT = date of clinic appointments to list
 ;
 K ^TMP("BSDCHK",$J)
 K ^TMP("SDAM",$J)
 S SDAMTYP="C"
 D CLN
 ;Q:'$D(SDCLN)  cmi/anch/maw 8/15/2007 orig line
 Q:'$D(BSDCLN)  ;cmi/anch/maw 8/15/2007 new line
 D DR
 Q:'$G(BSDDT)
 D EN1
 Q
 ;
 ;D REFRESH(BSDDT,.VAUTC)
EN1 ;PEP; entry point when clinic or clinic array is known - see technical documentation
 D TERM^VALM0
 NEW VALMCNT D EN^VALM("BSDAM CHECKIN LIST")
 D KILL^AUPNPAT,KVA^VADPT,CLEAR^VALM1
 Q
 ;
GUI(BSDCLN,BSDDT) ;-- future GUI entry point for display
 Q
 ;
CLN ;-- lets get the clinic
 K VAUTD
 I $G(BSDDIV) D                         ;division assumed
 . I '$D(DIV) Q                         ;no division variable set
 . I DIV="" S VAUTD=1 Q                 ;already set to all divisions
 . S VAUTD=0,VAUTD(DIV)=$$DIVNM^BSDU(DIV)    ;division already set
 I '$D(VAUTD) D ASK2^SDDIV I Y<0 S BSDQ="" Q
 D GETCLN
 Q
 ;
GETCLN ;-- get clinics
 S DIC(0)="AEMQZ",DIC="^SC(",DIC("A")="Select Clinic: "
 S DIC("S")="I $P(^(0),U,3)=""C""&'$G(^(""OOS""))&$S(VAUTD:1,$D(VAUTD(+$P(^(0),U,15))):1,'+$P(^(0),U,15)&$D(VAUTD(+$O(^DG(40.8,0)))):1,1:0)"
 S DIC("W")=$$INACTMSG^BSDU  ;IHS/ANMC/LJF 8/17/2000 added this line
 D ^DIC
 I $D(DUOUT) K BSDCLN Q
 Q:Y<0
 ;S SDCLN=+Y  ;cmi/anch/maw 8/15/2007 orig line
 I '$$ACTV^BSDU(+Y,DT) D
 . S X="** Inactivated on "_$$INACTVDT^BSDU(+Y)_" **"
 . D EN^DDIOL(.X)
 S BSDCLN(+Y)=""  ;cmi/anch/maw multiple clinics
 ;D EXPNDPC^BSDU(2,.SDCLN)  ;cmi/anch/maw 8/15/2007 orig line
 D EXPNDPC^BSDU(2,.Y)
 G GETCLN
 Q
 ;
DR ;-- select date range
 S %DT="AE",%DT("A")="Select Date: ",%DT("B")=$$FMTE^XLFDT(DT)
 D ^%DT
 I Y=-1 K BSDDT Q
 S BSDDT=+Y
 S SDBEG=BSDDT_".0001"
 S SDEND=BSDDT_".9999"
 Q
 ;
REFRESH(BSDDT,BSDCLNA) ;-- lets build the date/time order array
 N BSDA,BSDB,BSDE
 S BSDB=BSDDT_".0001",BSDE=BSDDT_".9999"
 S BSDA=0 F  S BSDA=$O(BSDCLNA(BSDA)) Q:'BSDA  D
 . N BSDDTA
 . S BSDDTA=BSDB F  S BSDDTA=$O(^SC(BSDA,"S",BSDDTA)) Q:BSDDTA>BSDE!('BSDDTA)  D
 .. N BSDDA
 .. S BSDDA=0 F  S BSDDA=$O(^SC(BSDA,"S",BSDDTA,1,BSDDA)) Q:'BSDDA  D
 ... Q:'$P($G(^SC(BSDA,"S",BSDDTA,1,BSDDA,"C")),U)
 ... N BSDCHK,BSDPAT
 ... S BSDPAT=$P($G(^SC(BSDA,"S",BSDDTA,1,BSDDA,0)),U)
 ... S BSDCHK=$P($G(^SC(BSDA,"S",BSDDTA,1,BSDDA,"C")),U)
 ... S ^TMP("SDAM",$J,BSDA,BSDCHK,BSDPAT)=""
 Q
 ;
INIT1 ; added line label
 D CLEAR^VALM1  ;IHS/ANMC/LJF 8/18/2000
 S X="CHECKED IN" D LIST
INITQ Q
 ;
HDR ; -- screen head
 N X,SDX,SDLNX S SDLNX=2
 S SDLNX=1
 ;I SDAMTYP="C" D HDRC
 S X=$P(SDAMLIST,"^",2)
 S VALMHDR(SDLNX)=X
 ;S X="* - New GAF Required",VALMHDR(SDLNX)=$$SETSTR^VALM1(X,VALMHDR(SDLNX),34,30)              ;IHS/ANMC/LJF 6/1/2000
 S VALMHDR(SDLNX)=$$SETSTR^VALM1($$FDATE^VALM1(SDBEG)_" thru "_$$FDATE^VALM1(SDEND),VALMHDR(SDLNX),59,22)
 S SDLNX=SDLNX+1
 S X=IORVON_"Auto Refresh is: "_IORVOFF_"  "_$S($G(BSDRF):"ON",1:"OFF")
 S VALMHDR(SDLNX)=X
 Q
 ;
HDRC ;-- clinic header
 ;   input:      SDCLN := ifn of pat
 ;  output:  VALMHDR() := hdr array
 ;
 N BSDDA,BSDCLNA
 S BSDCLNA=""
 S BSDDA=0 F  S BSDDA=$O(BSDCLN(BSDDA)) Q:'BSDDA  D
 . N BSDCLNE
 . S BSDCLNE=$E($P(^SC(BSDDA,0),U),1,45)
 . S BSDCLNA=BSDCLNE_"/"_BSDCLNA
 ;S VALMHDR(1)=$E($P("Clinic: "_$G(^SC(SDCLN,0)),"^",1),1,45)  ;for proper display of clinic name for SD*5.3*189
 S VALMHDR(1)="Clinic: "_BSDCLNA  ;for proper display of clinic name for SD*5.3*189
 Q
 ;
FNL ; -- what to do after action
 K ^TMP("SDAM",$J),^TMP("SDAMIDX",$J),^TMP("VALMIDX",$J),^BSDTMP("BSDCHK",$J)
 K SDAMCNT,SDFLDD,SDACNT,VALMHCNT,SDPRD,SDFN,SDCLN,SDAMLIST,SDT,SDATA,SDBEG,SDEND,DFN,Y,SDAMTYP,SDY,X,SDCL,Y,SDDA,VALMY
 K BSDCLN,BSDCLNA
 Q
 ;
BLD ; -- entry point to bld list
 ; input:  SDAMLIST := list to build
 D:'$D(SDAMLIST) GROUP("ALL",.SDAMLIST)
 ;I SDAMTYP="C" D BLD1  ;cmi/anch/maw 8/15/2007 orig line
 I SDAMTYP="C" D MCLN(.BSDCLN)
BLDQ Q
 ;
LIST ; -- find and build
 ;  input:        X := status group
 ; output: SDAMLIST := array of status'
 ;
 I X["CANCELLED",$G(SDAMTYP)="C" S VALMBCK="" W !!,*7,"You must be viewing a patient to list cancelled appointments." D PAUSE^VALM1 G LISTQ
 D GROUP(X,.SDAMLIST),BLD
 S VALMBCK="R"
LISTQ Q
 ;
GROUP(GROUP,SDAMLIST) ; -- find list
 S (I,SDAMLIST)="" F  S I=$O(SDAMLIST(I)) Q:I=""  K SDAMLIST(I)
 S GROUP=+$O(^SD(409.62,"B",GROUP,0))
 G GROUPQ:'$D(^SD(409.62,GROUP,0)) S SDAMLIST=^(0)
 S I=$G(^SD(409.62,GROUP,1)) S:I]"" SDAMLIST("SCR")=I
 S I=0 F  S I=$O(^SD(409.63,"C",GROUP,I)) Q:'I  S SDAMLIST(I)=""
GROUPQ Q
 ;
FUT ; -- change date range
 S X1=DT,X2=999 D C^%DTC
 S SDEBG=DT,SDEND=X,X="FUTURE" K VALMHDR
 D LIST
FUTQ Q
 ;
MCLN(BSDCLNM) ;-- loop through array and call BLD1
 N VA,SDAMDD,SDNAME,SDMAX,SDLARGE,DFN,SDCL,BL,XC,XW,AC,AW,TC,TW,NC,NW,SC,SW,SDT,SDDA ; done for speed see INIT^SDAM10
 D INIT^SDAM10
 S VALMBG=2  ;to reset top of data
 N BSDDA
 S BSDDA=0 F  S BSDDA=$O(BSDCLNM(BSDDA)) Q:'BSDDA  D
 . N BSDCLNE,BSDLN
 . S BSDLN=" "
 . S BSDACNT=SDACNT
 . S SDACNT=0
 . D SET^BSDCHKI1(BSDLN)
 . S SDACNT=BSDACNT
 . S SDCLN=BSDDA
 . S BSDCLNE=$P(^SC(SDCLN,0),U)
 . S BSDLN="Clinic:  "_BSDCLNE
 . S BSDACNT=SDACNT
 . S SDACNT=0
 . D SET^BSDCHKI1(BSDLN)
 . S SDACNT=BSDACNT
 . D BLD1
 Q
 ;
BLD1 ; -- scan apts
 ;N VA,SDAMDD,SDNAME,SDMAX,SDLARGE,DFN,SDCL,BL,XC,XW,AC,AW,TC,TW,NC,NW,SC,SW,SDT,SDDA ; done for speed see INIT^SDAM10
 ;D INIT^SDAM10  cmi/anch/maw moved to MCLN
 N BSDCHK,BSDDFN
 F SDT=SDBEG:0 S SDT=$O(^SC(SDCLN,"S",SDT)) Q:'SDT!($P(SDT,".",1)>SDEND)  D
 .F SDDA=0:0 S SDDA=$O(^SC(SDCLN,"S",SDT,1,SDDA)) Q:'SDDA  D
 .. Q:'$P($G(^SC(SDCLN,"S",SDT,1,SDDA,"C")),U)
 .. S BSDCHK=$P($G(^SC(SDCLN,"S",SDT,1,SDDA,"C")),U)
 .. S BSDDFN=$P($G(^SC(SDCLN,"S",SDT,1,SDDA,0)),U)
 .. S ^TMP("BSDCHK",$J,SDCLN,BSDCHK,BSDDFN)=SDT_U_SDDA
 N BSDTDA,BSDTIEN
 S BSDTDA="" F  S BSDTDA=$O(^TMP("BSDCHK",$J,SDCLN,BSDTDA),-1) Q:'BSDTDA  D
 . S BSDTIEN=0 F  S BSDTIEN=$O(^TMP("BSDCHK",$J,SDCLN,BSDTDA,BSDTIEN)) Q:'BSDTIEN  D
 .. N BSDTDTA
 .. S BSDTDTA=$G(^TMP("BSDCHK",$J,SDCLN,BSDTDA,BSDTIEN))
 .. S SDDA=$P(BSDTDTA,U,2)
 .. S SDT=$P(BSDTDTA,U)
 .. S DFN=BSDTIEN
 .. S BSDCHKIN=BSDTDA
 .. I $D(^SC(SDCLN,"S",SDT,1,SDDA,0)) S DFN=+^(0) D PID^VADPT I $D(^DPT(DFN,"S",SDT,0)),$$VALID^SDAM2(DFN,SDCLN,SDT,SDDA) S SDATA=^DPT(DFN,"S",SDT,0),SDCL=SDCLN,SDNAME=VA("BID")_" "_$P($G(^DPT(DFN,0)),U) D:SDCLN=+SDATA BLD1^BSDCHKI1
 D NUL^SDAM10,LARGE^SDAM10:$D(SDLARGE)
 S $P(^TMP("SDAM",$J,0),U,4)=VALMCNT
 Q
 ;
TOFF ;-- toggle off auto refresh
 S BSDRF=0
 D RF
 Q
 ;
TON ;-- toggle on auto refresh
 S BSDCNT=0
 S BSDRF=1
 F  D RF Q:'$G(BSDRF)
 Q
 ;
RF ;-- refresh the screen now
 S X="CHECKED IN" D LIST  ;cmi/maw 7/16/2008 to auto refresh clinic checkin list will add to patch 1009
 S VALMBCK="R"
 D EXIT
 Q:'$G(BSDRF)
 S DIR(0)="Y"
 S DIR("A")="Turn Auto Refresh Off "
 S DIR("B")="N"
 S DIR("T")=58
 D ^DIR
 K DIR
 I $G(Y) D TOFF
 Q
 ;
EXIT ; -- exit action for protocol
 I $D(VALMBCK),VALMBCK="R" D REFRESH^VALM S VALMBCK=$P(VALMBCK,"R")_$P(VALMBCK,"R",2)
 Q
 ;
HLP ; -- help for list
 I $D(X),X'["??" D HLPS,PAUSE^VALM1 G HLPQ
 D CLEAR^VALM1
 F I=1:1 S SDX=$P($T(HELPTXT+I),";",3,99) Q:SDX="$END"  D PAUSE^VALM1:SDX="$PAUSE" Q:'Y  W !,$S(SDX["$PAUSE":"",1:SDX)
 ;
 ;IHS/ANMC/LJF 10/10/2001 modified lines below
 ;W !,"Possible actions are the following:"
 ;D HLPS,PAUSE^VALM1 S VALMBCK="R"
 D CLEAR^VALM1           ;new line
 ;IHS/ANMC/LJF 10/10/2001 end of mods
 ;
HLPQ K SDX,Y Q
 ;
EX ;-- expand the entry
 S VALMBG=3
 D EN^SDAMEP
 S VALMBG=2
 Q
 ;
HLPS ; -- short help
 S X="?" D DISP^XQORM1 W ! Q
 ;
HELPTXT ; -- help text
 ;;Enter action by typing the name(s), or abbreviation(s).
 ;;
 ;;$END
