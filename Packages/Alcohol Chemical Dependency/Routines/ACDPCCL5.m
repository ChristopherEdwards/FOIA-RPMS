ACDPCCL5 ;IHS/ADC/EDE/KML - PCC LINK;
 ;;4.1;CHEMICAL DEPENDENCY MIS;;MAY 11, 1998
 ;
GENLINK ; EP-GENERATE PCC LINK
 ;W !,"Generating PCC link"
 D ECHK
 I $G(ACDQUIT) D VSERROR Q
 D @ACDEV("TYPE")
 D EOJ
 Q
 ;
ECHK ;ERROR CHECK
 S ACDQUIT=""
 I '$D(ACDEV) S ACDQUIT=4 Q  ;                 no array defined
 F X="CLINIC","LOCATION","PAT","POV","PRI PROV","SITE TYPE","SVC CAT","TYPE","V DATE","VISIT" D  Q:$G(ACDQUIT)
 . S X=""""_X_""""
 . S:X["POV" X=X_",1"
 . I '$D(@("ACDEV("_X_")")) S ACDQUIT=5 Q  ;   required var missing
 . I $G(@("ACDEV("_X_")"))="" S ACDQUIT=6 Q  ;  required var null
 . Q
 Q:$G(ACDQUIT)
 I "AED"'[ACDEV("TYPE") S ACDQUIT=7 Q  ;       no appropriate type
 Q
 ;
VSERROR ;
 S ACDFILE="CDMIS VISIT"
 S ACDIEN=$G(ACDEV("VISIT"))
 S ACDERR="VE"_ACDQUIT,ACDERR=$P($T(@ACDERR),";;",2)
 W !!,$G(IORVON)_"Notify your supervisor that the PCC LINK failed with the following error:",!,ACDFILE,"-",ACDERR_$G(IORVOFF),!!
 D PAUSE^ACDDEU
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
 ;
A ; ADD LOGIC
 I ACDEV("TC")="CS" D GENLCS Q
 S ACDDAY=1 ;                   ctls 2100 ien in CDMIS visit
 D ADDVISIT
 Q
 ;
E ; EDIT LOGIC
 W !!,$G(IORVON)_"Logic error at E^ACDPCCL5 - Notify programmer!"_$G(IORVOFF),!!
 D PAUSE^ACDDEU
 Q
 ;
GENLCS ; ADD CS VISITS
 S ACDCSDTE=0
 F  S ACDCSDTE=$O(ACDEV("PROC",ACDCSDTE)) Q:ACDCSDTE=""  D
 . S ACDEV("V DATE")=ACDCSDTE
 . S ACDLOC=0
 . F  S ACDLOC=$O(ACDEV("PROC",ACDCSDTE,ACDLOC)) Q:ACDLOC=""  D
 .. S ACDEV("CS LOC")=ACDEV("PROC",ACDCSDTE,ACDLOC,"CS LOC")
 .. S X=$G(ACDEV("PROC",ACDCSDTE,ACDLOC,"PCC LOC"))
 .. S:X ACDEV("LOCATION")=X
 .. S ACDDAY=+$E(ACDCSDTE,6,7)
 .. D ADDVISIT
 .. Q
 . Q
 Q
 ;
ADDVISIT ; ADD ONE PCC VISIT
 D VISIT ;                    set up and create visit
 I $G(ACDQUIT) Q
 D ^APCDALV ;                 create visit
 I $D(APCDALVR("ACDAFLG")) S ACDQUIT=APCDALVR("ACDAFLG") D VSERROR Q
 S APCDVSIT=APCDALVR("APCDVSIT")
 ; set PCC visit ien into CDMIS visit
 S X=ACDDAY,DA(1)=ACDEV("VISIT"),DIC="^ACDVIS("_DA(1)_",21,",DIC(0)="L",DIC("DR")=".02////"_APCDVSIT_";.03////"_ACDEV("LOCATION"),DIC("P")=$P(^DD(9002172.1,2100,0),U,2)
 D FILE^ACDFMC
 I Y<0 D ERROR^ACDPCCL("Adding of PCC VISIT LINKAGE to CDMIS VISIT failed",3) Q
 S ACD21IEN=+Y
 D VFILES^ACDPCCL6 ;          go add v file entries for this visit
 Q
 ;
VISIT ;
 D KILL
 S APCDALVR("AUPNTALK")=""
 S APCDALVR("APCDAUTO")=""
 S:ACDEV("TYPE")="A" APCDALVR("APCDADD")=""
 S APCDALVR("APCDANE")=""
 S APCDALVR("APCDPAT")=ACDEV("PAT")
 S (APCDALVR("APCDDATE"),APCDDATK)=ACDEV("V DATE")
 S APCDALVR("APCDLOC")=ACDEV("LOCATION")
 S APCDALVR("APCDTYPE")=ACDEV("SITE TYPE")
 S APCDALVR("APCDCAT")=ACDEV("SVC CAT")
 S APCDALVR("APCDCLN")=ACDEV("CLINIC")
 S APCDALVR("APCDAPPT")="U"
 Q
 ;
KILL ;
 K APCDAFLG,APCDALVR,APCDANE,APCDAPPT,APCDATMP,APCDAUTO
 K APCDCAT,APCDCLN
 K APCDLOC
 K APCDOLOC
 K APCDPAT
 K APCDTAT,APCDTLOU,APCDTNQ,APCDTPOV,ACDTPRO,ACDTPRV,APCDTPS,APCDTTOP,APCDTYPE
 K AUPNTALK
 Q
 ;
EOJ ;
 D KILL
 K ACD21IEN,ACDCSDTE,ACDDAY,ACDERR,ACDFILE,ACDIEN,ACDLOC,ACDQUIT
 Q
