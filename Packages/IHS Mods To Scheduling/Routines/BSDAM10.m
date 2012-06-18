BSDAM10 ; IHS/ANMC/LJF - IHS CALLS FROM SDAM10 ;  [ 08/26/2004  2:10 PM ]
 ;;5.3;PIMS;**1001**;APR 26, 2002
 ;Mods to VA code: added "deceased" to patient status display
 ;                 added community to patient header
 ;                 added last reg update to message line
 ;                 added reverse video for patient name
 ;
HDR ;EP; -- list screen header
 ;   input:       SDFN := ifn of pat
 ;  output:  VALMHDR() := hdr array
 ;
 N VAERR,VA,X
 S DFN=SDFN D PID^VADPT
 S VALMHDR(1)=$E($P("Patient: "_$G(IORVON)_$G(^DPT(SDFN,0)),U),1,46)_$G(IORVOFF)_" ("_VA("BID")_")"
 S X=$P($$FMT^SDUTL2(SDFN),U,2),X=$S(X]"":"MT: "_X,1:"")
 S X=$$GET1^DIQ(9000001,SDFN,1118)                ;community
 ;IHS/ITSC/WAR 7/15/2004 PATCH #1001 Mod to handle long Pt names & chrt# etc.
 ;S VALMHDR(1)=$$SETSTR^VALM1(X,VALMHDR(1),47,15)
 S VALMHDR(1)=$$SETSTR^VALM1(X,VALMHDR(1),$L(VALMHDR(1))+2,15)
 ;6/19/2002 LJF8 (per Linda) Bold,RevVid,Underline,etc.
 ;S X=$S($D(^DPT(SDFN,.1)):"Ward: "_^(.1),$G(^DPT(SDFN,.35)):IORVON_"Deceased"_IORVOFF,1:"Outpatient")
 S X=$S($D(^DPT(SDFN,.1)):"Ward: "_^(.1),$G(^DPT(SDFN,.35)):$G(IORVON)_"Deceased"_$G(IORVOFF),1:"Outpatient")
 S VALMHDR(1)=$$SETSTR^VALM1(X,VALMHDR(1),81-$L(X),$L(X))
 S VALMSG="Last Registration Update: "_$$LASTREG^BDGF2(SDFN)
 Q
 ;
