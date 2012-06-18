VENPCCM4 ; IHS/OIT/GIS - MANAGE TEMPLATE SYNCHRONIZATION AND VALIDATION - ;
 ;;2.6;PCC+;;NOV 12, 2007
 ;
 ;
 ;
ONE ; EP-ENTRY POINT FOR CHECKING JUST ONE TEMPLATE
 N DIR,IPA,IPB,FILE,Y,X,%,TSTG,Z
 W !,"Enter the file name of the template you want to validate =>"
ASK S DIR(0)="FO^14:44",DIR("A")="Template file name",DIR("?")="Must be in format: X_template.doc ;e.g.,wic_template.doc" KILL DA D ^DIR KILL DIR
 I Y?1."^" Q
 S Z=Y S Z=$TR(Z," ","")
 I Z'?1.30A1"_template.doc",Z'?1.30A1"_TEMPLATE.DOC" W !,"Must use format: {mnemonic}_template.doc; e.g. 'wic_template.doc'. Try again..." G ASK
 I '$$IP Q
 S FILE=Y,TSTG=$$TSTG(IPA)
 S IP=IPA D VAL
 Q
 ; 
ALL ; EP-CHECK ALL TEMPLATES
 N TNO,IPA,IPB,IP,TSTG,FILE,FIN
 I '$$IP Q
 W !,"Checking all templates on Print Server #1......."
 S TSTG=$$TSTG(IPA),IP=IPA,FIN=0
 F TNO=1:1:$L(TSTG,U) S FILE=$P(TSTG,U,TNO) D  I FIN=1 Q
 . I FILE["hs2_"!(FILE["HS2_") Q  ; IGNORE THE HS TEMPLATE
 . W !,"Evaluating '",FILE,"'"
 . D VAL
 . W ! I '$$WAIT^VENPCCU S FIN=1
 . Q
 Q
 ; 
VAL ; EP-VALIDATE A TEMPLATE
 N X,Y,%,IFILE,ISTG,HSTG,ESTG,CNT,PAUSE,TEX,TEX1,CEX,CFSTG,TSTG1,BAR,IEX,CNAME,MNAME,LOC,TYPE,HNAME,DESC,BY,ON,AT,VER,TNAME,HSTG,ISTG,CNT,VAL,DSTG,PCE,TOT,MAX,ORD,ERR,MN,RPT
 N PROB,POV,EXAM,HMR,IMM,INJ,LAB,PTED,ROS,RAD,SUPL,TRT,RX,ALL,EDITNAME,OK
 W !,"One moment please...."
VAR S HSTG=$$FILE^VENPCCM2("c:\program files\ilc\ilc forms print service\templates\ef_header.txt",IP)
 I HSTG'[U W !,"Unable to access this template's header file.  Request terminated!" Q
 S IFILE=$P(FILE,".")_"_info.txt" S IFILE=$$LOW^XLFSTR(IFILE),FILE=$$LOW^XLFSTR(FILE)
 S ISTG=$$FILE^VENPCCM2(("c:\program files\ilc\ilc forms print service\templates\"_IFILE),IP)
 S IEX=(ISTG[U)
 S TEX=(U_TSTG_U)[(U_FILE_U)
 S TEX1=1 I IPA'=IPB S TSTG1=$$TSTG(IPB) S TEX1=(U_TSTG1_U)[(U_FILE_U)
DUP S CFSTG="",TIEN=0 F  S TIEN=$O(^VEN(7.41,TIEN)) Q:'TIEN  S %=$P($G(^VEN(7.41,TIEN,0)),U,3) I %=$P(FILE,"_") S:CFSTG'="" CFSTG=CFSTG_U S CFSTG=CFSTG_TIEN_";"_$P($G(^VEN(7.41,TIEN,0)),U)
 S CEX=(CFSTG'="")
 I CEX,CFSTG'[U S CIEN=+CFSTG,CNAME=$P(CFSTG,";",2)
MSG1 ; INITIAL MESSAGE
 I 'TEX,'CEX W !,"File '",FILE,"' was not found on RPMS or Print Servers!" W:'IEX !,"File '",IFILE,"' is also missing" Q
 I CEX,('TEX!('TEX1)) W !,"File '",FILE,"' was not found on one of the Print Servers",!,"Add this file now!" Q
 I CEX,'TEX I '$$REM1 Q
 I CEX,CFSTG[U Q:'$$REM2  G DUP
 I 'IEX W !,"File '",IFILE,"' not found on Print Server #1!,",!,"Create this file using the 'template info.dot' form and try again." Q
 I 'CEX,'$$ADD(1) Q
 I CEX,'$$ADD(2) Q
 I '$$INIT(ISTG,HSTG) W !,"Invalid template information file! Request terminated..." Q  ; GET REST OF LOCAL VARIABLES
 I $G(TNAME)'="",$G(CNAME)'="" S TNAME=CNAME
 ; S BAR=$$BAR(+$G(CIEN)) I BAR="" W !,"Invald or missing Bar Code Caracter.  Session terminated..." Q  ; BAR CODES NO LONGER REQUIRED
 D CAP,FLD,WARN,SET
 Q
 ; 
REM1() ; MISSING TEMPLATE
 N %,X,Y,%Y
 W !,"The template '",FILE,"' is missing from the print servers",!,"but it is registered in the PCC+ EF TEMPLATE file on the RPMS server"
 W !,"This may cause the Print Server to lock up!"
 W !,"Want to remove this template from the EF TEMPLATE file"
 S %=2 D YN^DICN I %=1 D  Q 1
 . S DIK="^VEN(7.41.",TIEN=0
 . F  S DA=$O(^VEN(7.41,DA)) Q:'DA  S %=$P($G(^VEN(7.41,DA,0)),U,3) I %=$P(FILE,"_") W !?5,$P(^VEN(7.41,DA,0),U)," removed..." D ^DIK
 . K DIK,DA
 . W !,"DONE!"
 . Q
 I $G(%Y)?1."^" Q 0
 W !,"OK, You must add this file to the print servers before proceeding"
 W !,"Also, create the companion file on Print Server #1 using 'template info.dot'"
 Q 0
 ; 
REM2() ; EP-REDUNDANT CONFIG FILE ENTRIES
 W !,"The EF TEMPLATE file has multiple entries linked to '",FILE,"'"
 F I=1:1:$L(CFSTG,U) S %=$P(CFSTG,U,I) W !?5,$P(%,";",2)
 W !!,"Please remove one of these entries..."
 S DIC="^VEN(7.41,",DIC(0)="AEQ",DIC("A")="Template: ",DIC("S")="I $P(^(0),U,3)=$P(FILE,$C(999))" D ^DIC K DIC I Y=-1 Q 0
 S DIK="^VEN(7.41,",DA=+Y D ^DIK
 Q 1
 ; 
ADD(X) ; EP-ADD A NEW FILE
 I X=1 W !,"File '",FILE,"' is on the Print Server",!,"but it is not registered in the EF TEMPLATE file.  Want to register it now"
 I X=2 W !,"Want to update the PCC+ cnfig file for '",FILE,"'"
 S %=1 D YN^DICN I %=1 Q 1
 Q 0
 ; 
BAR(CIEN) ; EP-CHECK BAR CODE UNIQUENESS ; DEAD CODE IN 2.2
 N TIEN,BAR,%,Y,STG
 S TIEN=0,BAR="",%=""
 I $P($G(^VEN(7.41,CIEN,0)),U,4)="" D  Q BAR
 . F  S TIEN=$O(^VEN(7.41,TIEN)) Q:'TIEN  S Y=$P($G(^VEN(7.41,TIEN,0)),U,4) S:%'="" %=%_U S %=%_Y
 . F Y=65:1:90,97:1:122 I %'[$C(Y) S BAR=$C(Y) Q
 . Q
 S %=""
 F  S TIEN=$O(^VEN(7.41,TIEN)) Q:'TIEN  I TIEN'=CIEN S Y=$P($G(^VEN(7.41,TIEN,0)),U,4) S:%'="" %=%_U S %=%_Y
 S BAR=$P($G(^VEN(7.41,CIEN,0)),U,4),STG=%
 I (U_STG_U)'[(U_BAR_U) Q BAR
 W !,"The Bar Code '"_BAR_"' assigned to this template is not unique"
 W !,"Want to change it to a unique value" S %=1 D YN^DICN I %'=1 Q ""
 S BAR="" F Y=65:1:90,97:1:122 I (U_STG_U)'[(U_$C(Y)_U) S BAR=$C(Y) Q
 I $L(BAR) W !,"OK, The Bar Code '",BAR,"' has been assigned to this template"
 Q BAR
 ; 
INIT(ISTG,HSTG) ; EP-CHECK ELEMENTS
 S %="MNAME^LOC^TYPE^HNAME^DESC^BY^ON^AT^VER"
 F I=1:1:$L(%,U) X ("S "_$P(%,U,I)_"="""_$P(ISTG,U,I))_""""
 I BY="" S BY="ITSC"
 I AT="" S AT="ITSC"
 I ON="" S Y=DT X ^DD("DD") S ON=Y
 I VER="" S VER=1.1
 I $L(MNAME),$L(LOC),$L(TYPE),$L(HNAME)
 E  Q 0
 S TNAME=LOC_" "_TYPE,MNAME=$$LOW^XLFSTR(MNAME),TNAME=$$UP^XLFSTR(TNAME)
 S HSTG=HSTG_U,ISTG=ISTG_U,ESTG="p^d^e^i^s^l^y^r^z^t^mm^md^ms^mq^mr",CNT=0 K VAL
 S DSTG="Active problems / Recent POVs^ICD Preferences^Exams^Immunizations^Injections^Lab tests^Patient education topics^Radiology exams^Supplies^Treatments^Prescriptions^Allergies^Prescriptions"
 F PCE=1:1:$L(ESTG,U) S MN=$P(ESTG,U,PCE) D
 . S TOT=0,ERR="",RPT="",ORD=0
 . S DNAME=$P(DSTG,U,PCE)
 . F I=1:1:$L(ISTG,U) S X=$P(ISTG,U,I) X "I X?1"""_MN_"""1.3N" I  D
 .. S TOT=TOT+1
 .. I ISTG'[(U_MN_TOT_U) D
 ... I $L(ISTG,(U_X_U))>2 S:RPT'="" RPT=RPT_U S RPT=RPT_X Q
 ... I ERR'="" S ERR=ERR_U S ERR=ERR_TOT
 ... Q
 .. I 'ORD,+$P(X,MN,2)'=TOT S ORD=1
 .. Q
 . F I=1:1 Q:HSTG'[(U_MN_I_U)
 . S MAX=I-1
 . S VAL(MN)=TOT_U_MAX_U_DNAME
 . I $L(ERR) S VAL(MN,1)=ERR
 . I TOT>MAX S VAL(MN,2)=TOT_U_MAX
 . I ORD S VAL(MN,3)=1
 . I $L(RPT) S VAL(MN,4)=RPT
 . I $D(VAL(MN,4)) F %=1:1:3 K VAL(MN,%)
 . Q
 S PROB=+$G(VAL("p")),POV=+$G(VAL("d")),EXAM=+$G(VAL("e")),HMR=26,IMM=+$G(VAL("i")),INJ=+$G(VAL("s")),LAB=+$G(VAL("l")),PTED=+$G(VAL("y"))
 S ROS=13,RAD=+$G(VAL("r")),SUPL=+$G(VAL("z")),TRT=+$G(VAL("t")),RX=+$G(VAL("mm")),ALL=+$G(VAL("a"))
 Q 1
 ; 
CAP ; EP-CAPTIONED TEMPLATE DESCRIPTION
 W !,"Template: ",MNAME,?40,"Header file: ",HNAME
 W !,"Descriptive name: ",TNAME
 I DESC="" S DESC="NONE"
 W !,"Description: ",DESC
 I BY="" S BY="UNK"
 W !,"Created by: ",BY
 I ON="" S ON="UNK"
 W ?40,"Created on: ",ON
 I AT="" S AT="UNK"
 W !,"Created at: ",AT
 I VER="" S VER="1.1"
 W ?40,"Version: ",VER
 Q
 ; 
FLD ; EP-TABLE OF FIELDS
 N N,T,Y,X,MN
 W !!,"Field",?7,"Description",?38,"# on this form",?55,"Max allowed on this form"
 W !,"-----",?7,"---------------------------",?38,"---------------",?55,"------------------------"
 S MN="" F  S MN=$O(VAL(MN)) Q:MN=""  D
 . I "^md^ms^mq^mr^"[(U_MN_U) Q
 . S X=VAL(MN) I $L(X)'>3 Q
 . S N=+X,T=+$P(X,U,2),Y=$P(X,U,3)
 . W !,MN,?7,Y,?38,N,?55,T
 . Q
 Q
 ; 
WARN ; EP-PRINT WARNINGS
 N MN,A,B,C
 S MN="",OK=0 F  Q:OK  S MN=$O(VAL(MN)) Q:MN=""  I MN'="x",MN'="d" F I=1:1:4 I $D(VAL(MN,I)) S OK=1 Q
 I 'OK Q
 W ! I '$$WAIT^VENPCCU Q
 I %?1."^" Q
 W *13,?79,*13,?20,"*****  WARNINGS  *****",!
 S MN="" F  S MN=$O(VAL(MN)) Q:MN=""  I $D(VAL(MN))=11,MN'="d" W ! D
 . I $D(VAL(MN,1)) S %=VAL(MN,1) W !,"Missing elements: " F I=1:1:$L(%,U) W:I>1 ", " W MN,$P(%,U,I)
 . I $D(VAL(MN,2)) W !,"The number of '",MN,"' fields exceeds the maximum number allowed!"
 . I $G(VAL(MN,3)) W !,"Fields of type '",MN,"' appear to be out of order!"
 . I $D(VAL(MN,4)) S %=VAL(MN,4) W !,"Repeated elements: " F I=1:1:$L(%,U) W:I>1 ", " W $P(%,U,I)
 . Q
 Q
 ; 
SET ; EP-UPDATE THE CONFIG FILE
 N DIC,DIE,DR,DA,X,Y,%
 W !!,"Do you want to update your EF TEMPLATE file now"
 S %=$S($G(OK):2,1:1) D YN^DICN I %'=1 W !,"Configuration file not updated" Q
 D DIE
 W !,"The VEN EHP EF TEMPLATE file has been updated!"
 Q
 ; 
DIE S X=$G(CNAME,TNAME),DIC="^VEN(7.41,",DIC(0)="L",DLAYGO=19707.41 D ^DIC S:Y>0 DA=+Y
 I Y=-1 W !,"Unable to update EF TEMPLATE file!  Request terminated..." Q
 S DIE="^VEN(7.41,",BAR=$G(BAR)
 S DR=".02///"_$P(HNAME,$C(95))_";.03///^S X=$P(MNAME,$C(95));.04///^S X=BAR;.05///^S X=VER;.06///^S X=ON;.07///^S X=AT;.08///^S X=BY;1.1///^S X=PROB;1.2///^S X=POV;1.3///^S X=TRT;1.4///^S X=HMR;1.5///^S X=IMM;1.6///^S X=INJ;1.7///^S X=LAB"
 L +^VEN(7.41,DA):0 I $T D ^DIE L -^VEN(7.41,DA)
 S DR="1.8///^S X=PTED;1.9///^S X=ROS;2.1///^S X=RAD;2.2///^S X=SUPL;2.3///^S X=TRT;2.4///^S X=RX;2.5///^S X=ALL"
 L +^VEN(7.41,DA):0 I $T D ^DIE L -^VEN(7.41,DA)
 I $D(EDITNAME) S DR=".01///^S X=EDITNAME" L +^VEN(7.41,DA):0 I $T D ^DIE L -^VEN(7.41,DA)
 S ^VEN(7.41,DA,3,0)="^^1^1^"_DT
 S ^VEN(7.41,DA,3,1,0)=DESC
 D LINK(DA)
 D ^XBFMK
 Q
 ; 
IP() ; EP-GET IP ADDRESSES FOR PRINT SERVERS
 I $L($G(IP1)),$L($G(SOCKET)) S IPA=IP1,SOCK=SOCKET,IPB=$G(IP2,IP1) Q 1
 S IPA=$P($G(^VEN(7.5,+$$CFG^VENPCCU,11)),U,1)
 S IPB=$P($G(^VEN(7.5,+$$CFG^VENPCCU,11)),U,2)
 S SOCK=$P($G(^VEN(7.5,+$$CFG^VENPCCU,11)),U,3)
 I IPA'="",IPB="" S IPB=IPA
 I IPB'="",IPA="" S IPA=IPB
 I IPA="",IPB="" W !,"Unable to find the IP address for any Print Server. Request terminated..." Q 0
 Q 1
 ; 
TSTG(IP) ; EP-RETURN THE TEMPLATE STRING IN THE PROPER FORMAT
 N TSTG
 S TSTG=$$TEMPLATE^VENPCCM2(IP)
 I $L(TSTG) S TSTG=$$LOW^XLFSTR(TSTG)
 Q TSTG
 ; 
LINK(LINK) ; EP-LINK THE TEMPLATE TO AN ORDERABLE SET
 N X,Y,DIC,DIE,DR,DA
 I '$O(^VEN(7.92,0)) Q
 I '$D(^VEN(7.93,"AS")) Q
 W !,"Want to link this template to an order set"
 S %=1 D YN^DICN I %'=1 Q
 S DIC="^VEN(7.92,",DIC(0)="AEQ",DIC("A")="Order set: "
 D ^DIC I Y=-1 Q
 S DIE="^VEN(7.41,",DA=LINK,DR=".09////"_+Y
 L +^VEN(7.41):0 I $T D ^DIE L -^VEN(7.41)
 W !,"The template and order set have been linked..."
 Q
 ; 
