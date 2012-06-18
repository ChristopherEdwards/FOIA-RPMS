BCHABCH ; IHS/TUCSON/LAB - CHR TO PCC LINK ROUTINE ; 27 Apr 2006  11:53 AM [ 04/28/06  3:20 PM ]
 ;;1.0;IHS RPMS CHR SYSTEM;**3,11,14,16**;OCT 28, 1996
 ;
 ;IHS/TUCSON/LAB - PATCH 3 6/26/97 - DON'T PASS VISITS WITH NO SERVICE TIME
 ;chr to pcc link
 ;chr system will pass array BCHEV
 ;BCHEV("TYPE")=A,E OR D
 ;Called from BCHALD routine to check BCHEV array and then
 ;create, edit or delete a PCC Visit as appropriate.
 ;
EP ;EP - call from BCHALD DRIVER
 W:'$D(ZTQUEUED) !!,"Updating PCC .. hold on.." H 2 ;IHS/CMI/TMJ PATCH #16
 K BCHQUIT,APCDALVR
 I '$D(BCHEV) Q  ;no array defined
 I "AED"'[$G(BCHEV("TYPE")) Q  ;no appropriate type
 D @BCHEV("TYPE")
 D EOJ
 Q
 ;
CHECK ;EP
 I '$D(BCHEV("DATA0")) S BCHQUIT=20 Q  ;no data array
 I '$P(BCHEV("DATA0"),U,4) S BCHQUIT=21 Q  ;no patient
 I '$P(BCHEV("DATA0"),U,27) S BCHQUIT=1 Q  ;ihs/tucson/lab - added this line, patch 3 if no service time don't pass visit
 S (BCHX,BCHGOT)=0 F  S BCHX=$O(BCHEV("POV",BCHX)) Q:BCHX'=+BCHX   D
 .S X=$G(BCHEV("POV",BCHX,"SRV")) Q:'$P(X,U,4)  ;don't pass non-pcc services
 .S BCHGOT=1
 .Q
 S:'BCHGOT BCHQUIT=1
 ;make sure there is at least one codeable problem - patch 11
 S (BCHX,BCHGOT)=0 F  S BCHX=$O(BCHEV("POV",BCHX)) Q:BCHX'=+BCHX   D
 .S X=$G(BCHEV("POV",BCHX,"ICD9")) Q:X=""  ;don't pass non-pcc services
 .S BCHGOT=1
 .Q
 S:'BCHGOT BCHQUIT=1
 Q
A ;EP - added a record
 K APCDALVR,BCHQUIT
 D CHECK
 I $G(BCHQUIT) D EOJ Q  ;quit if not a visit pcc wants
 I $L($T(^BSDAPI4)),$L($T(^APCDAPI4)) D  D EOJ Q
 .D BSD
 .I '$G(BCHVSIT) S BCHQUIT=2 D VSERROR Q
 .D VFILES^BCHABC1
 .S BCHV("9000010")=BCHVSIT
 .D COMPLETE^BCHALD
 .Q
 D VISIT ;set up and create visit
 I $G(BCHQUIT) D EOJ Q
 D ^APCDALV ;create visit
 I $D(APCDALVR("APCDAFLG")) S BCHQUIT=APCDALVR("APCDAFLG") D VSERROR Q
 S BCHVSIT=APCDALVR("APCDVSIT")
 D VFILES^BCHABC1
 ;call protocol signifying a complete visit added to pcc files
 S BCHV("9000010")=BCHVSIT
 D COMPLETE^BCHALD
 D EOJ
 Q
E ;edited a chr record
 D E^BCHABC2
 Q
D ;
 D D^BCHABC2
 Q
VISIT ;EP
 S APCDALVR("APCDAUTO")="" S:BCHEV("TYPE")="A" APCDALVR("APCDADD")=""
 S APCDALVR("APCDPAT")=$P(BCHEV("DATA0"),U,4)
 S (APCDALVR("APCDDATE"),BCHDATK)=$P(BCHEV("DATA0"),U) ;date of visit .01
 D GETLOC
 I $G(BCHQUIT) D VSERROR Q
 D GETTYPE ; get type of visit
 I $G(BCHQUIT) D VSERROR Q
SERVCAT ;get service category - if radio/telephone act loc use T
 ;otherwise use A
 ;I can't distinguish hospital from clinic
 S APCDALVR("APCDCAT")=$S(BCHACTL="RT":"T",1:"A")
CLINIC ;get clinic - if act. loc is home use 11 otherwise 01
 S APCDALVR("APCDCLN")=$S(BCHACTL="HM":$O(^DIC(40.7,"C",11,"")),BCHACTL="SC":$O(^DIC(40.7,"C",22,0)),1:$O(^DIC(40.7,"C","25","")))
 S APCDALVR("APCDAPPT")="U"
 S APCDALVR("APCDCAF")="R"
 Q
 ;
GETLOC ;get location of encounter
 I '$D(BCHEV("ACTLOC")) S BCHQUIT=21 Q  ;can't tell activity location
 S BCHACTL=$P(BCHEV("ACTLOC"),U,5)
 S BCHLOC=$P(BCHEV("DATA0"),U,5)
 I BCHLOC S APCDALVR("APCDLOC")=BCHLOC Q  ;quit if have a hosp/clinic pointer
 I BCHACTL="HC" S BCHQUIT=24 Q
 ;home visit
 I BCHACTL="HM" S BCHLOC=$P(BCHEV("SITE"),U,5) I BCHLOC="" S BCHQUIT=22 Q
 I BCHACTL="CH" S BCHLOC=$P(BCHEV("SITE"),U,6) I BCHLOC="" S BCHQUIT=27 Q
 I BCHACTL="SC" S BCHLOC=$P(BCHEV("SITE"),U,16) I BCHLOC="" S BCHQUIT=28 Q
 I 'BCHLOC S BCHLOC=$P(BCHEV("SITE"),U,9) I BCHLOC="" S BCHQUIT=23 Q
 S APCDALVR("APCDLOC")=BCHLOC
 Q
GETTYPE ;get type of visit
 S BCHLOC=$P(^AUTTLOC(APCDALVR("APCDLOC"),0),U,10) ;I $E(BCHLOC,5,6)>49 S APCDALVR("APCDTYPE")="T" Q  ;if not a clinic, set to tribal and quit
 S X=$P(BCHEV("DATA0"),U,6)
 I X="" S APCDALVR("APCDTYPE")=$S($P(BCHEV("SITE"),U,2)]"":$P(BCHEV("SITE"),U,2),1:"T") Q
 I $P($G(^BCHTACTL(X,0)),U,2)=4 S APCDALVR("APCDTYPE")=$S($P(BCHEV("SITE"),U,4)]"":$P(BCHEV("SITE"),U,4),$P(BCHEV("SITE"),U,2)]"":$P(BCHEV("SITE"),U,2),1:"T") Q
 S APCDALVR("APCDTYPE")=$P(BCHEV("SITE"),U,2) Q:APCDALVR("APCDTYPE")]""
 S APCDALVR("APCDTYPE")="T"  ;if site parameters not set use T
 Q
 S APCDALVR("APCDTYPE")=$P(BCHEV("SITE"),U,4) Q:APCDALVR("APCDTYPE")'=""
 S X=$P(^AUTTLOC(APCDALVR("APCDLOC"),0),U,25) I X]"" S APCDALVR("APCDTYPE")=$S(X=1:"I",X=2:"6",X=3:"C",X=6:"T",1:"O") Q  ;if loc updated use it
 S X=$P($G(^APCCCTRL(DUZ(2),0)),U,4) I X]"" S APCDALVR("APCDTYPE")=X Q  ;use pcc master control if all else fails
 S APCDALVR("APCDTYPE")="T" ;default to T if can't determine
 Q
 ;
BSD ;
 ;use BSDAPI4 and always force an add
 K APCDALVR
 S BCHVSIT=""
 S BCHIN("FORCE ADD")=1
 D VISIT
 I $G(BCHQUIT) Q
 S BCHIN("VISIT DATE")=APCDALVR("APCDDATE")
 S BCHIN("VISIT TYPE")=APCDALVR("APCDTYPE")
 S BCHIN("PAT")=APCDALVR("APCDPAT")
 S BCHIN("SITE")=APCDALVR("APCDLOC")
 S BCHIN("SRV CAT")=APCDALVR("APCDCAT")
 S BCHIN("CLINIC CODE")=APCDALVR("APCDCLN")
 S BCHIN("APCDAPPT")="U"
 S BCHIN("APCDOPT")=$P($G(XQY0,U),U) I BCHIN("APCDOPT")]"" S BCHIN("APCDOPT")=$O(^DIC(19,"B",BCHIN("APCDOPT"),0))
 S BCHIN("APCDCAF")="R"
 S BCHIN("USR")=DUZ
 S BCHIN("TIME RANGE")=-1
BSDADD1 ;
 K APCDALVR
 S BCHVSIT=""
 D GETVISIT^APCDAPI4(.BCHIN,.BCHV)
 S BCHERR=$P(BCHV(0),U,2)
 K BCHIN,APCDALVR
 I BCHERR]"" S BCHQUIT=2 Q  ;errored
 I $P(BCHV(0),U)=1 S V=$O(BCHV(0)) I BCHV(V)="ADD" S BCHVSIT=V Q
 Q
EOJ ;
 K BCHLINK,BCHFILE,BCHERR,BCHQUIT,APCDALVR,BCHTYPE,BCHLOC,BCHDATK,BCHACTL,BCHIEN,BCHX,BCHGOT,BCHVSIT
 K BCHEV
 Q
VSERROR ;EP
 S BCHFILE="VISIT"
 S BCHIEN=BCHEV("CHR IEN")
 S BCHERR="VE"_BCHQUIT,BCHERR=$P($T(@BCHERR),";;",2)
 S DFN=$P(BCHEV("DATA0"),U,4)
 D LBULL^BCHALD
 K DFN
 Q
 ;
VE2 ;;inability to create visit
VE3 ;;invalid visit parameters (date, location etc.)
VE21 ;;No activity location passed. No Location determined.
VE22 ;;No IHS Location for HOME in CHR SITE PARAMETER File.
VE23 ;;No IHS Location for OTHER in CHR SITE PARAMETER File.
VE24 ;;No Location of Encounter when Activity location is Hospital/Clinic.
VE27 ;;No Location of Encounter for OFFICE in CHR SITE PARAMETER file.
VE28 ;;No Location of Encounter for SCHOOL in CHR SITE PARAMETER file.
VE29 ;;Error attempting to modify visit
