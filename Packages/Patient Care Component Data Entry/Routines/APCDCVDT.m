APCDCVDT ; IHS/CMI/LAB - CHANGE VISIT DATE ;
 ;;2.0;IHS PCC SUITE;;MAY 14, 2009
 ;
 ; ***** WARNING ***** This routine executes the cross-references
 ; on the .03 field (except the "AD") in order to reset the "AA"
 ; cross-reference.  Very dangerous assumptions here.  For one,
 ; if the date of the VISIT was used on any other field it would
 ; not be reset.
 ;
 ; Array APCDCVDT must be passed as follows:
 ;
 ;  APCDCVDT("VISIT DFN")=DFN of VISIT entry being changed.
 ;  APCDCVDT("VISIT DATE/TIME")=date and time to be changed to in
 ;                              internal FileMan form.
 ;  APCDCVDT("TALK")=any value including NULL
 ;
 ; If APCDCVDT("TALK") exists a dot (.) will be printed for
 ; each V FILE entry processed during both passes.
 ;
 ; Upon exit APCDCVDT("ERROR FLAG") will exist if an error was
 ; detected.
 ;
 ; It is the callers responsibility to KILL APCDCVDT.
 ;
START ;PEP - CALLED TO DELETE A PCC VISIT
 D CHK
 Q:$D(APCDCVDT("ERROR FLAG"))
 D PROCESS
 D MOD
 D EOJ
 Q
 ;
MOD ;
 S AUPNVSIT=APCDCVDT("VISIT DFN") D MOD^AUPNVSIT
 Q
CHK ; CHECK PASSED ARRAY
 K APCDCVDT("ERROR FLAG")
 I $D(APCDCVDT("VISIT DFN"))#2,APCDCVDT("VISIT DFN"),$D(APCDCVDT("VISIT DATE/TIME"))#2,APCDCVDT("VISIT DATE/TIME"),APCDCVDT("VISIT DATE/TIME")#1 Q
 S APCDCVDT("ERROR FLAG")=1
 Q
 ;
PROCESS ;
 I '$D(^AUPNVSIT(APCDCVDT("VISIT DFN"),0)) S APCDCVDT("ERROR FLAG")=2 Q
 S AUPNVSIT=APCDCVDT("VISIT DFN")
 S APCDCVOD=+^AUPNVSIT(AUPNVSIT,0),APCDCVOT=APCDCVOD#1,APCDCVOD=APCDCVOD\1
 S APCDCVND=APCDCVDT("VISIT DATE/TIME")\1,APCDCVNT=APCDCVDT("VISIT DATE/TIME")#1
 I APCDCVOD=APCDCVND,APCDCVOT=APCDCVNT Q
 I '$D(AUPNPAT),$P(^AUPNVSIT(AUPNVSIT,0),U,5) S Y=$P(^(0),U,5) D ^AUPNPAT
 I APCDCVOD=APCDCVND D TIME Q
 D DATE
 Q
 ;
TIME ; CHANGE TIME ONLY
 D CHGVISIT
 Q
 ;
DATE ; CHANGE DATE/TIME
 S APCDCVDZ=2 D VFILES
 D CHGVISIT
 S APCDCVDZ=1 D VFILES
 Q
 ;
CHGVISIT ; CHANGE VISIT ENTRY
 S DA=AUPNVSIT,DIE="^AUPNVSIT(",DR=".01///"_APCDCVND_APCDCVNT D ^DIE K DA,DIE,DR
 Q
 ;
VFILES ; CHANGE V FILES
 S APCDCVDF=9000010 F APCDCVDL=0:0 S APCDCVDF=$O(^DIC(APCDCVDF)) Q:APCDCVDF>9000010.99!(APCDCVDF'=+APCDCVDF)  D VFILE
 K APCDCVDF,APCDCVDG,APCDCVDL,APCDCVDE,APCDCVDX
 Q
 ;
VFILE ; CHANGE ONE V FILE
 S APCDCVDG=^DIC(APCDCVDF,0,"GL")
 Q:'$D(@(APCDCVDG_"""AD"","_AUPNVSIT_")"))
 S APCDCVDE="" F APCDCVDL=0:0 S APCDCVDE=$O(@(APCDCVDG_"""AD"","_AUPNVSIT_",APCDCVDE)")) Q:APCDCVDE=""  D VFILEE
 Q
VFILEE ; CHANGE ONE V FILE ENTRY
 ;
 ; ***** WARNING ****** Using ^DIK here will not work!
 ;
 S APCDCVDX=0 F APCDCVDL=0:0 S APCDCVDX=$O(^DD(APCDCVDF,.03,1,APCDCVDX)) Q:APCDCVDX'=+APCDCVDX  I ^DD(APCDCVDF,.03,1,APCDCVDX,APCDCVDZ)'["""AD""" S DA=APCDCVDE,X=AUPNVSIT X ^DD(APCDCVDF,.03,1,APCDCVDX,APCDCVDZ)
 W:$D(APCDCVDT("TALK")) "."
 Q
 ;
EOJ ; EOJ CLEANUP
 K %,%DT,C,D,D0,DA,DIC,DICR,DIE,DIG,DIH,DIU,DIV,DIW,DQ,DR,I,X,Y
 K APCDCVDE,APCDCVDF,APCDCVDG,APCDCVDL,APCDCVDX,APCDCVDZ,APCDCVND,APCDCVNT,APCDCVOD,APCDCVOT
 Q