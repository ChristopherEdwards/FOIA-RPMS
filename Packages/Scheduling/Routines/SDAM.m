SDAM ;MJK/ALB - Appt Mgt ; 8/30/99 9:09am [ 01/05/2005  8:18 AM ]
 ;;5.3;Scheduling;**149,177,76,242,1001,1005**;Aug 13, 1993
 ;IHS/ANMC/LJF  6/01/2000 removed "* - New GAF Required" from header
 ;              8/18/2000 cleared screen before entering list template
 ;              9/29/2000 added kill of patient variables
 ;              8/29/2001 changed so can be called with patient set(VPR)
 ;                        also changed list temp entry code to INIT1
 ;             10/19/2001 added insurance coverage to heading
 ;             10/22/2001 cleaned up call to VALM
 ;IHS/ITSC/WAR 10/20/2004 PATCH 1001 clear DFN if viewing by clinic
 ;IHS/OIT/LJF  12/29/2005 PATCH 1005 added age to header display
 ;
 D HDLKILL^SDAMEVT
EN ; -- main entry point
 ;IHS/ANMC/LJF 8/29/2001 start of changes
 ;N XQORS,VALMEVL D EN^VALM("SDAM APPT MGT")  ;original VA code
 K VALMQUIT D INIT Q:$D(VALMQUIT)
EN1 ;PEP; entry point when patient is known - see technical documentation
 D TERM^VALM0                            ;IHS/ANMC/LJF 10/22/2001 added for clean VALM call
 NEW VALMCNT D EN^VALM("SDAM APPT MGT")
 D KILL^AUPNPAT,KVA^VADPT,CLEAR^VALM1    ;IHS/ANMC/LJF 9/29/2000 added
 ;IHS/ANMC/LJF 8/29/2001 end of new code
 Q
 ;
INIT ; -- set up appt man vars
 K I,X,SDBEG,SDEND,SDB,XQORNOD,SDFN,SDCLN,DA,DR,DIE,DNM,DQ,%B
 S DIR(0)="43,213",DIR("A")="Select Patient name or Clinic name"
 D ^DIR K DIR I $D(DIRUT) S VALMQUIT="" G INITQ
 S SDY=Y
 I SDY["DPT(" S DFN=+SDY D 2^VADPT I +VADM(6) D  G:SDUP="^" INIT
 . W !!,"WARNING ",VADM(7),!!
 . R "Press Return to Continue or ^ to Quit: ",SDUP:DTIME
 ;
 ;IHS/ANMC/LJF 8/29/2001 changed code so can be called with patient set
 Q
 ;
INIT1 ; added line label
 ;IHS/ANMC/LJF 8/29/2001 end of mods
 ;
 I SDY["DPT(" S SDAMTYP="P",SDFN=+SDY D INIT^SDAM1
 ;IHS/ITSC/WAR 10/20/04 PATCH #1001 clear Pt DFN if a Clinic is chosen
 ;I SDY["SC(" S SDAMTYP="C",SDCLN=+SDY D INIT^SDAM3
 I SDY["SC(" S SDAMTYP="C",SDCLN=+SDY K DFN D INIT^SDAM3
 D CLEAR^VALM1  ;IHS/ANMC/LJF 8/18/2000
INITQ Q
 ;
HDR ; -- screen head
 N X,SDX,SDLNX S SDLNX=2
 ;I SDAMTYP="P" D HDR^SDAM10 S VALM("TM")=5 D
 I SDAMTYP="P" D HDR^SDAM10 D
 .;
 .;IHS/OIT/LJF 12/29/2005 PATCH 1005 added patient age to PCP line
 .;S SDX=$$PCLINE^SDPPTEM(SDFN,DT) Q:'$L(SDX)
 .S SDX="    Age:  "_$$AGE^AUPNPAT(SDFN,DT,"R")_"  "_$$PCLINE^SDPPTEM(SDFN,DT) Q:'$L(SDX)
 .;
 .S VALMHDR(SDLNX)=SDX,SDLNX=3
 .;S VALMHDR(SDLNX)=SDX,SDLNX=3,VALM("TM")=6
 .;Increment Top & Bottom margins to allow for additional line
 .;S VALM("TM")=VALM("TM")+1
 .;S VALM("BM")=VALM("BM")+1
 .Q
 I SDAMTYP="C" D HDR^SDAM3
 S X=$P(SDAMLIST,"^",2)
 S VALMHDR(SDLNX)=X
 ;S X="* - New GAF Required",VALMHDR(SDLNX)=$$SETSTR^VALM1(X,VALMHDR(SDLNX),34,30)              ;IHS/ANMC/LJF 6/1/2000
 I SDAMTYP="P" S VALMHDR(SDLNX)=$$SETSTR^VALM1($$INSUR^BDGF2(SDFN,SDBEG),VALMHDR(SDLNX),40,15)  ;IHS/ANMC/LJF 10/19/2001
 S VALMHDR(SDLNX)=$$SETSTR^VALM1($$FDATE^VALM1(SDBEG)_" thru "_$$FDATE^VALM1(SDEND),VALMHDR(SDLNX),59,22)
 Q
 ;
FNL ; -- what to do after action
 K ^TMP("SDAM",$J),^TMP("SDAMIDX",$J),^TMP("VALMIDX",$J)
 K SDAMCNT,SDFLDD,SDACNT,VALMHCNT,SDPRD,SDFN,SDCLN,SDAMLIST,SDT,SDATA,SDBEG,SDEND,DFN,Y,SDAMTYP,SDY,X,SDCL,Y,SDDA,VALMY
 Q
 ;
BLD ; -- entry point to bld list
 ; input:  SDAMLIST := list to build
 D:'$D(SDAMLIST) GROUP("ALL",.SDAMLIST)
 I SDAMTYP="P" D BLD^SDAM1
 I SDAMTYP="C" D BLD^SDAM3
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
EXIT ; -- exit action for protocol
 I $D(VALMBCK),VALMBCK="R" D REFRESH^VALM S VALMBCK=$P(VALMBCK,"R")_$P(VALMBCK,"R",2)
 Q
 ;
