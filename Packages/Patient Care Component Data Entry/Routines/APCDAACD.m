APCDAACD ; IHS/CMI/LAB - CDMIS TO PCC LINK ;
 ;;2.0;IHS PCC SUITE;;MAY 14, 2009
 ;
 ;
 ;cdmis to pcc link
 ;cdmis system will pass array ACDEV
 ;ACDEV("TYPE")=A,E OR D
 ;
EP ;EP - call from APCDALD DRIVER
 D MAIN
 D EOJ
 Q
 ;
MAIN ;
 W:'$D(ZTQUEUED) !!,"Updating PCC .. hold on.."
 K APCDQUIT,APCDALVR
 D ECHK
 I $G(APCDQUIT) D VSERROR Q
 D @ACDEV("TYPE")
 Q
 ;
ECHK ;ERROR CHECK
 I '$D(ACDEV) S APCDQUIT=4 Q  ;                 no array defined
 F X="CLINIC","LOCATION","PAT","POV","PRI PROV","SITE TYPE","SVC CAT","TYPE","V DATE","VISIT" D  Q:$G(APCDQUIT)
 . S X=""""_X_""""
 . S:X["POV" X=X_",1"
 . I '$D(@("ACDEV("_X_")")) S APCDQUIT=5 Q  ;   required var missing
 . I $G(@("ACDEV("_X_")"))="" S APCDQUIT=6 Q  ;  required var null
 . Q
 Q:$G(APCDQUIT)
 I "AED"'[ACDEV("TYPE") S APCDQUIT=7 Q  ;       no appropriate type
 Q
 ;
A ;EP-added a record
 ;//^APCDAAC2
 D CHECK
 I $G(APCDQUIT) Q  ;          quit if not a visit pcc wants
 D VISIT ;                    set up and create visit
 I $G(APCDQUIT) Q
 D ^APCDALV ;                 create visit
 I $D(APCDALVR("APCDAFLG")) S APCDQUIT=APCDALVR("APCDAFLG") D VSERROR Q
 S APCDVSIT=APCDALVR("APCDVSIT")
 D VFILES^APCDAAC1
 ;call protocol signifying a complete visit added to pcc files
 S APCDV("9000010")=APCDVSIT
 D COMPLETE^APCDALD
 Q
 ;
CHECK ; SEE IF PCC WANTS VISIT
 Q
 ;
VISIT ;EP
 ;//^APCDAAC2
 S APCDALVR("APCDAUTO")="" S:ACDEV("TYPE")="A" APCDALVR("APCDADD")=""
 S APCDALVR("APCDPAT")=ACDEV("PAT")
 S (APCDALVR("APCDDATE"),APCDDATK)=ACDEV("V DATE")
 D GETLOC ;                    get location of visit
 I $G(APCDQUIT) D VSERROR Q
 D GETTYPE ;                   get type of visit
 I $G(APCDQUIT) D VSERROR Q
 S APCDALVR("APCDCAT")=ACDEV("SVC CAT")
 S APCDALVR("APCDCLN")=ACDEV("CLINIC")
 S APCDALVR("APCDAPPT")="U"
DEBUG ;ZW APCDALVR D PAUSE^ACDDEU
 Q
 ;
GETLOC ;get location of encounter
 S APCDALVR("APCDLOC")=ACDEV("LOCATION")
 Q
 ; ********** DO WE NEED SOMETHING HERE **********
 I '$D(ACDEV("ACTLOC")) S APCDQUIT=21 Q  ;can't tell activity location
 S APCDACTL=$P(ACDEV("ACTLOC"),U,5)
 S APCDLOC=$P(ACDEV("DATA0"),U,5)
 I APCDLOC S APCDALVR("APCDLOC")=APCDLOC Q  ;quit if have a hosp/clinic pointer
 I APCDACTL="HC" S APCDQUIT=24 Q
 ;home visit
 I APCDACTL="HM" S APCDLOC=$P(ACDEV("SITE"),U,5) I APCDLOC="" S APCDQUIT=22 Q
 I APCDACTL="CH" S APCDLOC=$P(ACDEV("SITE"),U,6) I APCDLOC="" S APCDQUIT=27 Q
 I 'APCDLOC S APCDLOC=$P(ACDEV("SITE"),U,9) I APCDLOC="" S APCDQUIT=23 Q
 S APCDALVR("APCDLOC")=APCDLOC
 Q
 ;
GETTYPE ;get type of visit
 S APCDALVR("APCDTYPE")=ACDEV("SITE TYPE")
 Q
 ; ********** DO WE NEED SOMETHING HERE *********
 S APCDLOC=$P(^AUTTLOC(APCDALVR("APCDLOC"),0),U,10) I $E(APCDLOC,5,6)>49 S APCDALVR("APCDTYPE")="T" Q  ;if not a clinic, set to tribal and quit
 S APCDALVR("APCDTYPE")=$P(ACDEV("SITE"),U,4) Q:APCDALVR("APCDTYPE")'=""
 S X=$P(^AUTTLOC(APCDALVR("APCDLOC"),0),U,25) I X]"" S APCDALVR("APCDTYPE")=$S(X=1:"I",X=2:"6",X=3:"C",X=6:"T",1:"O") Q  ;if loc updated use it
 S X=$P($G(^APCCCTRL(DUZ(2),0)),U,4) I X]"" S APCDALVR("APCDTYPE")=X Q  ;use pcc master control if all else fails
 S APCDALVR("APCDTYPE")="T" ;default to T if can't determine
 Q
 ;
E ;edited a cdmis record
 D E^APCDAAC2
 Q
 ;
D ;deleted a cdmis record
 D D^APCDAAC2
 Q
 ;
EOJ ;
 K APCDLINK,APCDFILE,APCDERR,APCDQUIT,APCDALVR,APCDTYPE,APCDLOC,APCDDATK,APCDACTL,APCDIEN,APCDX,APCDGOT,APCDVSIT
 K ACDEV
 Q
 ;
VSERROR ;EP
 S APCDFILE="VISIT"
 S APCDIEN=$G(ACDEV("VISIT"))
 S APCDERR="VE"_APCDQUIT,APCDERR=$P($T(@APCDERR),";;",2)
 D LBULL^APCDALD
 Q
 ;
VE2 ;;inability to create visit
VE3 ;;invalid visit parameters (date, location etc.)
VE4 ;;ACDEV array not passed
VE5 ;;Required variable not passed
VE6 ;;Required variable is null
VE7 ;;No appropriate type (i.e., A,E,D)
VE21 ;;No activity location passed. No Location determined.
VE22 ;;No IHS Location for HOME in CDMIS SITE PARAMETER File.
VE23 ;;No IHS Location for OTHER in CDMIS SITE PARAMETER File.
VE24 ;;No Location of Encounter when Activity location is Hospital/Clinic.
VE27 ;;No Location of Encounter for OFFICE in CDMIS SITE PARAMETER file.
VE28 ;;Error attempting to modify visit
