BHLBCH2 ; IHS/TUCSON/DCP - HL7 ORU Message Processor (continued) ;
 ;;1.0;IHS SUPPORT FOR HL7 INTERFACES;;JUL 7, 1997
 ;
 ; This routine is a continuation of BHLBCH1.
 ; It is not independently callable.
 ;
A ; ENTRY POINT from BHLBCH1
 ;
 D FILEREC Q:BHLQUIT
 D FILEDMO
 D FILEPOV
 D FILETEST
 Q
 ;
E ; ENTRY POINT from BHLBCH1 - edit - delete original and do add
 ;
 S BCHR=BHLR,BCHSTOP=1 D DELETE^BCHUDEL K BCHSTOP
 D A
 Q
 ;
FMKILL ; ENTRY POINT from BHLBCH1
 ;
 K DIE,DIC,DA,DR,DLAYGO,DIADD,DIU,DIY,DIX,DIV,DIW,DD,D0,DO,DI,DK,DIG,DIH,DL,DQ
 Q
FILEREC ;create and file chr record
 S BHLFDA(90002,BHLR_",",.21)=BHLID
 D FILE^DIE("KS","BHLFDA","BHLERR")
 Q
FILEPOV ;file povs
 K BHLTPOV
 D FMKILL
 Q:'$D(BHLBCH("POV"))
 S APCDOVRR=1
 S BHLN=0 F  S BHLN=$O(BHLBCH("POV",BHLN)) Q:BHLN'=+BHLN  D
 .S X=$P(BHLBCH("POV",BHLN),U),X=$O(^BCHTPROB("C",X,0)) I X="" S HLERR="POV PROBLEM CODE FAILED",BHLQUIT=1 Q
 .S DIC="^BCHRPROB(",DIC("DR")=".02////^S X=$G(IEN);.03////^S X=BHLR",DLAYGO=90002.01,DIADD=1,DIC(0)="L" D FILE^DICN
 .I Y=-1 S HLERR="ERROR IN DICN ADDING A POV",BHLQUIT=1 Q
 .S BHLPOV=+Y
 .D FMKILL
 .S DA=BHLPOV,DIE="^BCHRPROB("
 .S BHLSRV=$O(^BCHTSERV("D",$P(BHLBCH("POV",BHLN),U,2),0)),BHLSRV="`"_BHLSRV
 .S DR=".04///"_BHLSRV_";.05///"_$P(BHLBCH("POV",BHLN),U,3)_";.06///"_$P(BHLBCH("POV",BHLN),U,4)_";.07///"_$P(BHLBCH("POV",BHLN),U,5)
 .D ^DIE
 .I $D(Y) S HLERR="ERROR UPDATING POV RECORD - DIE",BHLQUIT=1
 .D FMKILL
 K APCDOVRR
 I '$D(HLERR) S BHLTPOV(BHLPOV)=""
 Q
FILEDMO ;
 ;get patient based on chart number passed, check dob and sex - if same use IEN, otherwise do not
 S IEN=""
 Q:'$D(BHLBCH("DEMO"))
 S F=$P(BHLBCH("DEMO"),U,8) I F]"" S F=$O(^AUTTLOC("C",F,0))
 S C=$P(BHLBCH("DEMO"),U,7),SEX=$P(BHLBCH("DEMO"),U,3),DOB=$P(BHLBCH("DEMO"),U,2)
 I 'F!(C="") D NOIEN Q
 S BHLDUZ2=DUZ(2),DUZ(2)=F,X=C,DIC="^AUPNPAT(",DIC(0)="M" D ^DIC
 S DUZ(2)=BHLDUZ2 K BHLDUZ2 I +Y>0,SEX=$P(^DPT(+Y,0),U,2),DOB=$P(^DPT(+Y,0),U,3) S IEN=+Y,DIE="^BCHR(",DA=BHLR,DR=".04////^S X=IEN" D ^DIE D FMKILL D:$P(BHLBCH("DEMO"),U,9)]""   Q
 .S DIE="^BCHR(",DA=BHLR,DR="1108///"_$P(BHLBCH("DEMO"),U,9) D ^DIE I $D(Y) S HLERR="TEMPORARY RESIDENCE FAILED",BHLQUIT=1 Q
 .Q
 D NOIEN
 Q
NOIEN ;stuff demo stuff - no IEN found
 D FMKILL
 S DIE="^BCHR(",DA=BHLR,DR="1101///"_$P(BHLBCH("DEMO"),U)_";1102///"_$P(BHLBCH("DEMO"),U,2)_";1103///"_$P(BHLBCH("DEMO"),U,3)_";1104///"_$P(BHLBCH("DEMO"),U,4)_";1111///"_$P(BHLBCH("DEMO"),U,7)_";1109///"_$P(BHLBCH("DEMO"),U,8)
 S DR=DR_";1107///"_$P(BHLBCH("DEMO"),U,6)_";1108///"_$P(BHLBCH("DEMO"),U,9)_";1105///"_$P(BHLBCH("DEMO"),U,5)_";1106///"_$P(BHLBCH("DEMO"),U,6)
 D ^DIE
 I $D(Y) S HLERR="ERROR UPDATING AN ITEM IN THE DEMO NODE",BHLQUIT=1
 Q
FILETEST ;file all tests
 Q:'$D(BHLBCH("MSR"))
 S BHLN=0 F  S BHLN=$O(BHLBCH("MSR",BHLN)) Q:BHLN'=+BHLN!(BHLQUIT)  S BHLMTYP=$P(BHLBCH("MSR",BHLN),U),BHLVALUE=$P(BHLBCH("MSR",BHLN),U,2) D
 .S BHLTIEN=$O(^BCHTMT("B",BHLMTYP,0)) I BHLTIEN="" S BHLQUIT=1,HLERR="MEASUREMENT TYPE NOT FOUND IN TABLE" Q
 .S BHLFIELD=$P(^BCHTMT(BHLTIEN,0),U,3) I BHLFIELD="" Q  ;this is temporary ************ only fields 1201-1210 work, will do lab tests later
 .;file measurement
 .D FMKILL S DIE="^BCHR(",DA=BHLR,DR=BHLFIELD_"///"_BHLVALUE D ^DIE
 .I $D(Y) S HLERR="DIE FAILED UPDATING "_BHLMTYP_" VALUE",BHLQUIT=1 Q
 .Q
 Q
