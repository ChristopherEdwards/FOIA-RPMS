BLSULLF ; IHS/CMI/LAB - ADD NEW LOINC CODES FROM REGENSTIEF ; [ 12/19/2002  7:08 AM ]
 ;;5.2;LR;**1015**;NOV 18, 2002
 ;
 ;
 ;
 Q  ;NOT AT TOP
 ;
UPLOAD ;EP
 S ADDS=0
 S BLSX=0 F  S BLSX=$O(^BLSLDATA("TEMP",BLSX)) Q:BLSX'=+BLSX  D
 .Q:$G(^BLSLDATA("TEMP",BLSX,35,1))'=1
 .S CODE=^BLSLDATA("TEMP",BLSX,1,1)
 .S V1=$P(CODE,"-")
 .S BLSIEN=$O(^LAB(95.3,"B",V1,0)) I 'BLSIEN S NEWADD=1 D ADD Q
 .S NEWADD=0 D EDIT
 .D CU
 .Q
 Q
 ;
ADD ;
 S ADDS=ADDS+1
 W !,"ADDING ",CODE
 D ^XBFMK K DLAYGO,DIADD
 S DINUM=V1,X=V1,DIC="^LAB(95.3,",DIC(0)="L",DIADD=1
 D FILE^DICN
 I Y=-1 W !,"Adding new code failed ",V1 D ^XBFMK K DIADD,DLAYGO Q
 S BLSIEN=+Y
 K DIADD,DLAYGO,DIC,DR,DA
 D ^XBFMK
 D EDIT
 Q
L9531(V) ;
 I $G(V)="" Q ""
 NEW DIC,DA,DR
 S Y=$O(^LAB(95.31,"CIHS",V,0)) I Y Q Y
 S Y=$O(^LAB(95.31,"C",V,0)) I Y Q Y
 S Y=$O(^LAB(95.31,"B",V,0)) I Y Q Y
 S DIC=95.31,DIC(0)="LMX",X=V D ^DIC
 I Y=-1 Q ""
 S ^LAB(95.31,+Y,1)=$E(V)_$$LOW^XLFSTR($E(V,2,999))
 S ^LAB(95.31,+Y,2)=$E(V)_$$LOW^XLFSTR($E(V,2,999))
 ;W !,"added to 95.31 ",V
 Q +Y
L061(V,T) ;Lookup ien in LAB(64.061
 I $G(V)="" Q ""
 S T=$G(T)
 NEW DIC,DA,DR
 S Y=$O(^LAB(64.061,"E",V,0)) I Y Q Y
 S Y=$O(^LAB(64.061,"C",$$UP^XLFSTR(V),0)) I Y Q Y
 S Y=$O(^LAB(64.061,"DIHS",V,0)) I Y Q Y
 S DIC=64.061,DIC(0)="MLX",X=V,DIC("DR")="7///"_$G(T) D ^DIC
 I Y=-1 Q ""
 S $P(^LAB(64.061,+Y,0),U,8)="from LOINC system list 1/6/2002"
 ;W !,"added to 64.061 ",V
 Q +Y
L642(V) ;
 I $G(V)="" Q ""
 NEW DIC,DA,DR
 S Y=$O(^LAB(64.2,"CIHS",V,0)) I Y Q Y
 S DIC=64.2,DIC(0)="MLX",X=V D ^DIC
 I Y=-1 Q ""
 ;W !,"added to 64.2 ",V
 Q +Y
EDIT ;edit an existing entry
 D ^XBFMK
 S DR="",DIE="^LAB(95.3,",DA=BLSIEN
 ;each field value is set and then DR string built
F1 ;field 1, piece 1 of piece 2
 S F1=$G(^BLSLDATA("TEMP",BLSX,2,1)),F1=$P(F1,"~",1)
 I F1]"" D
 .S F1V=$$L9531(F1) I F1V="" W !,"LOINC CODE: ",CODE," failed COMPONENT COLUMN B-1 "_F1 Q
 .S DR=DR_"1////"_F1V
F15 ;
 S F15=$G(^BLSLDATA("TEMP",BLSX,2,1)),F15=$P(F15,"~",2)
 I F15]"" D
 .S F15V=$$L061(F15,"C") I F15V="" W !,"LOINC CODE: ",CODE," failed CHALLENGE COLUMN B-2 "_F15 Q
 .S DR=DR_";1.5////"_F15V
F16 ;field 1.6 col b piece 2
 S F16=$G(^BLSLDATA("TEMP",BLSX,2,1)),F16=$P(F16,"~",3)
 I F16]"" D
 .S F16V=$$L061(F16,"A") I F16V="" W !,"LOINC CODE: ",CODE," failed ADJUSTMENT COLUMN B-2 "_F16 Q
 .S DR=DR_";1.6////"_F16V
F17 ;field 1.7 col e piece 2
 S F17=$G(^BLSLDATA("TEMP",BLSX,5,1)),F17=$P(F17,"~",2)
 I F17]"" D
 .S F17V=$$L061(F17,"S") I F17V="" W !,"LOINC CODE: ",CODE," failed NON-PATIENT SPECIMEN COLUMN E-2 "_F17 Q
 .S DR=DR_";1.7////"_F17V
F2 ;
 S F2=$G(^BLSLDATA("TEMP",BLSX,3,1)) I F2="-" S F2=""
 I F2]"" D
 .S F2V=$$L061(F2,"PR") I F2V="" W !,"LOINC CODE: ",CODE," failed PROPERTY COLUMN C ",F2 Q
 .S DR=DR_";2////"_F2V
F3 ;
 S F3=$G(^BLSLDATA("TEMP",BLSX,4,1)),F3=$P(F3,"~",1)
 I F3]"" D
 .S F3V=$$L061(F3) I F3="" W !,"LOINC CODE: ",CODE," failed TIME ASPECT COLUMN D-1 ",F3 Q
 .S DR=DR_";3////"_F3V
F31 ;
 S F31=$G(^BLSLDATA("TEMP",BLSX,4,1)),F31=$P(F31,"~",2)
 I F31]"" D
 .S F31V=$$L061(F31,"M") I F31V="" W !,"LOINC CODE: ",CODE," failed TIME MODIFIER COLUMN D-2 ",F31 Q
 .S DR=DR_";3.1////"_F31V
F4 ;
 S F4=$G(^BLSLDATA("TEMP",BLSX,5,1)),F4=$P(F4,"~",1)
 I F4]"" D
 .S F4V=$$L061(F4) I F4V="" W !,"LOINC CODE: ",CODE," failed SYSTEM COLUMN E-1 ",F4 Q
 .S DR=DR_";4////"_F4V
F5 ;
 S F5=$G(^BLSLDATA("TEMP",BLSX,6,1)) I F5="-" S F5=""
 I F5]"" D
 .S F5V=$$L061(F5) I F5V="" W !,"LOINC CODE: ",CODE," failed SCALE TYPE COLUMN F ",F5 Q
 .S DR=DR_";5////"_F5V
F6 ;
 S F6=$G(^BLSLDATA("TEMP",BLSX,7,1)),F6=$TR(F6,"."," ") S:F6="*" F6=""
 I F6]"" D
 .S F6V=$$L642(F6) I F6V="" W !,"LOINC CODE: ",CODE," failed METHOD TYPE COLUMN C ",F6 Q
 .S DR=DR_";6////"_F6V
F7 ;
 S F7=$G(^BLSLDATA("TEMP",BLSX,9,1))
 I F7]"" D
 .S F7V=$$L061(F7) I F7V="" W !,"LOINC CODE: ",CODE," failed CLASS COLUMN I ",F7 Q
 .S DR=DR_";7////"_F7V
F10 ;
 S F10=$G(^BLSLDATA("TEMP",BLSX,28,1)),F10=$TR(F10,"[",""),F10=$TR(F10,"]",""),F10=$TR(F10,"{",""),F10=$TR(F10,"}",""),F10=$$TRIMLS(F10)
 I F10]"" D
 .S F10V=$$L061(F10) I F10V="" W !,"LOINC CODE: ",CODE," failed UNITS COLUMN AB ",F10 Q
 .S DR=DR_";10////"_F10V
F11 ;
 S F11=$G(^BLSLDATA("TEMP",BLSX,27,1))
 I F11]"" S DR=DR_";11///"_F11
F13 ;
 S F13=$G(^BLSLDATA("TEMP",BLSX,33,1))
 I F13]"" S DR=DR_";13///"_F13
F20 ;
 S F20=$G(^BLSLDATA("TEMP",BLSX,19,1))
 I F20]"" S DR=DR_";20///"_F20
F21 ;
 S F21=$G(^BLSLDATA("TEMP",BLSX,1,1)),F21=$P(F21,"-",1)
 I F21]"" D
 .S F21=$O(^LAB(95.3,"B",F21,0)) I F21="" W !,"LOINC CODE: ",CODE," failed MAP TO COLUMN T" Q
 .S DR=DR_";21////"_F21
F22 ;
 S F22=$G(^BLSLDATA("TEMP",BLSX,14,1))
 I F22]"" S F22=$E(F22,5,6)_"/"_$E(F22,7,8)_"/"_$E(F22,1,4),DR=DR_";22///"_F22
F23 ;
 S F23=$G(^BLSLDATA("TEMP",BLSX,16,1))
 I F23]"" S DR=DR_";23///"_F23
F30 ;
 S F30=$G(^BLSLDATA("TEMP",BLSX,11,1))
 I F30]"" S DR=DR_";30///"_F30
F32 ;
 S F32=$G(^BLSLDATA("TEMP",BLSX,13,1))
 I F32]"" S DR=DR_";32///"_F32
F33 ;
 S F33=$G(^BLSLDATA("TEMP",BLSX,22,1))
 I F33]"" S DR=DR_";33///"_F33
F34 ;
 S F34=$G(^BLSLDATA("TEMP",BLSX,23,1))
 I F34]"" S DR=DR_";34///"_F34
F35 ;
 S F35=$G(^BLSLDATA("TEMP",BLSX,24,1))
 I F35]"" S DR=DR_";35///"_F35
F37 ;
 S F37=$G(^BLSLDATA("TEMP",BLSX,26,1))
 I F37]"" S DR=DR_";37///"_F37
F38 ;
 S F38=$G(^BLSLDATA("TEMP",BLSX,30,1))
 I F38]"" S DR=DR_";38///"_F38
F40 ;
 S F40=$G(^BLSLDATA("TEMP",BLSX,34,1))
 I F40]"" S DR=DR_";40///"_F40
F50 ;
 S BLSRN=$G(^BLSLDATA("TEMP",BLSX,8,1))
 I BLSRN]"" D
 .S L=$L(BLSRN,";")
 .F Z=1:1:L S X=$P(BLSRN,";",Z) Q:X=""  S X=$$TrimAll(X) D
 ..I X="" Q
 ..S G=0,Y=0 F  S Y=$O(^LAB(95.3,DA,50,Y)) Q:Y'=+Y  I X=$P(^LAB(95.3,DA,50,Y,0),U) S G=1
 ..Q:G
 ..S (Y,NIEN)=0 F  S Y=$O(^LAB(95.3,DA,50,Y)) Q:Y'=+Y  S NIEN=Y
 ..S NIEN=NIEN+1
 ..S ^LAB(95.3,DA,50,NIEN,0)=X,^LAB(95.3,DA,50,"B",X,NIEN)="",$P(^LAB(95.3,DA,50,0),U,3)=NIEN,$P(^LAB(95.3,DA,50,0),U,4)=$P(^LAB(95.3,DA,50,0),U,4)+1,$P(^LAB(95.3,DA,50,0),U,2)=95.39
F60 ;
 S BLSAL=0 F  S BLSAL=$O(^BLSLDATA("TEMP",BLSX,18,BLSAL)) Q:BLSAL'=+BLSAL  D
 .S BLSDV=^BLSLDATA("TEMP",BLSX,18,BLSAL) Q:BLSDV=""
 .S X=$$TrimAll(BLSDV) D
 ..S G=0,Y=0 F  S Y=$O(^LAB(95.3,DA,2,Y)) Q:Y'=+Y  I X=$P(^LAB(95.3,DA,2,Y,0),U) S G=1
 ..Q:G
 ..S (Y,NIEN)=0 F  S Y=$O(^LAB(95.3,DA,2,Y)) Q:Y'=+Y  S NIEN=Y
 ..S NIEN=NIEN+1
 ..S ^LAB(95.3,DA,2,NIEN,0)=X,^LAB(95.3,DA,2,"B",X,NIEN)="",$P(^LAB(95.3,DA,2,0),U,3)=NIEN,$P(^LAB(95.3,DA,2,0),U,4)=$P(^LAB(95.3,DA,2,0),U,4)+1,$P(^LAB(95.3,DA,2,0),U,2)=95.33
F70 ;
 ;NO DATA IN REG FILE
F80 ;
 S FULLSN=$G(^BLSLDATA("TEMP",BLSX,2,1))_":"_$G(^BLSLDATA("TEMP",BLSX,3,1))_":"_$G(^BLSLDATA("TEMP",BLSX,4,1))_":"_$G(^BLSLDATA("TEMP",BLSX,5,1))_":"_$G(^BLSLDATA("TEMP",BLSX,6,1))_":"_$G(^BLSLDATA("TEMP",BLSX,7,1))
 S FULLSN=$$TRIMTC(FULLSN)
 S DR=DR_";80///"_FULLSN
 ;I 'NEWADD,FULLSN'=$P($G(^LAB(95.3,DA,80)),U) W !,"NOT SAME ",CODE
 S DR=DR_";9999999.01///"_$P(CODE,"-",2)_";9999999.02///"_CODE
F99 ;
 ;leave out comments for now.  Exisiting data not fileman compatible with WP field type.
DIE ;call die
 D ^DIE
 I $D(Y) W !,"die failed with code ",CODE," dR=",DR D ^XBFMK Q
 ;
 S $P(^LAB(95.3,BLSIEN,9999999),U,1)=$P(CODE,"-",2)
 S $P(^LAB(95.3,BLSIEN,9999999),U,2)=CODE
F24 ;
 S F24=$G(^BLSLDATA("TEMP",BLSX,15,1))
 I F24]"" S $P(^LAB(95.3,BLSIEN,4),U,5)=F24
F36 ;
 S F36=$G(^BLSLDATA("TEMP",BLSX,25,1))
 I F36]"" S $P(^LAB(95.3,BLSIEN,1),U,7)=F36
CU ;
 K CODE,V1,F1,V22,V3,V41,V42,F1V,F2,F2V,F3,F3V,F4,F4V,F5,F5V,F6,F6V
 D ^XBFMK
 K DLAYGO,DIADD
 Q
FILE ;upload global
DIR ;
 S BLSDIR=""
 S DIR(0)="F^2:60",DIR("A")="Enter directory path (i.e. /usr/spool/uucppublic/)" K DA D ^DIR K DIR
 I $D(DIRUT) W !!,"Directory not entered!!  Bye." S BLSQUIT=1 Q
 S BLSDIR=Y
 S BLSFILE=""
 S DIR(0)="F^2:30",DIR("A")="Enter filename w /ext (i.e. NCIDATA.TXT)" K DA D ^DIR K DIR
 G:$D(DIRUT) DIR
 S BLSFILE=Y
 W !,"Directory=",BLSDIR,"  ","File=",BLSFILE,"  reading file into ^BLSLDATA...",!
READF ;read file
 NEW Y,X,I
 S BLSC=0
 S Y=$$OPEN^%ZISH(BLSDIR,BLSFILE,"R")
 I Y W !,*7,"CANNOT OPEN (OR ACCESS) FILE '",BLSDIR,BLSFILE,"'." S BLSQUIT=1 Q
 KILL ^BLSLDATA("TEMP")
 F I=1:1 U IO R BLSDATA:DTIME Q:BLSDATA=""!($$STATUS^%ZISH=-1)  D LOOP
 D ^%ZISC
 W !!,"All done reading file",!
 Q
LOOP ;
 S BLSC=BLSC+1
 S BLSDATA=$TR(BLSDATA,$C(9),"|")
 S BLSDATA=$TR(BLSDATA,"$","")
 S BLSDATA=$TR(BLSDATA,"""","")
 S BLSDATA=$TR(BLSDATA,"^","~")
 S BLSX=BLSDATA,BLSY=$L(BLSDATA,"|")
 S $P(BLSX,"|",45)="" ;THIS IS THE SYNONYMS OR SOME SUCH LONG FIELD COLUMN AT - DO NOT LOAD
 F BLSZ=1:1:BLSY D
 .S BLSLC=1
 .I BLSZ=17 D  Q  ;handle field 17, column Q comments for WP field
 ..K ^UTILITY($J,"W") S DIWL=1,DIWR=70,X=$P(BLSX,"|",17) D ^DIWP
 ..S Y=0 F  S Y=$O(^UTILITY($J,"W",DIWL,Y)) Q:Y'=+Y  S ^BLSLDATA("TEMP",BLSC,BLSZ,BLSLC)=^UTILITY($J,"W",DIWL,Y,0),BLSLC=BLSLC+1
 ..K DIWL,DIWR,X
 ..K ^UTILITY($J,"W")
 ..Q
 .I BLSZ=18 S BLSLC=1 D  Q  ;handle answer back for multiple field ; pieces
 ..S Y=$P(BLSX,"|",18) F Z=1:1 S Y=$P(BLSX,";",Z) Q:Y=""  S Y=$$TrimLSpc(Y),Y=$TR(Y,"^","~"),^BLSLDATA("TEMP",BLSC,BLSZ,BLSLC)=Y,BLSLC=BLSLC+1
 ..Q
 .I $P(BLSX,"|",BLSZ)]"" S ^BLSLDATA("TEMP",BLSC,BLSZ,BLSLC)=$P(BLSX,"|",BLSZ)
 Q
 ;-------------------------------------------------------------------
TrimLSpc(X) ;
 F  Q:$E(X,1)'=" "  S X=$E(X,2,$L(X))
 Q X
 ;--------------------------------------------------------------------
 ;Trim Trailing Spaces
TrimTSpc(X) ;
 F  Q:$E(X,$L(X))'=" "  S X=$E(X,1,$L(X)-1)
 Q X
 ;--------------------------------------------------------------------
 ;Trim All Leading and Trailing Spaces
TRIMLS(X) ;
 F  Q:$E(X,1)'="/"  S X=$E(X,2,$L(X))
 Q X
 ;--------------------------------------------------------------------
TRIMTC(X) ;
 F  Q:$E(X,$L(X))'=":"  S X=$E(X,1,$L(X)-1)
 Q X
 ;--------------------------------------------------------------------
 ;Trim All Leading and Trailing Spaces
TrimAll(X) ;
 Q $$TrimLSpc($$TrimTSpc(X))
 ;--------------------------------------------------------------------
 ;Remove Extra Spaces
PackStr(X) ;
 F  Q:X'["  "  S X=$P(X,"  ",1)_" "_$P(X,"  ",2,9999)
 Q X
 ;--------------------------------------------------------------------
UCase(X) ;
 Q $TR(X,"abcdefghijklmnopqrstuvwxyz","ABCDEFGHIJKLMNOPQRSTUVWXYZ")
 ;--------------------------------------------------------------------
Clean(X) ;
 Q $$UCase($$TrimAll(X))
 ;--------------------------------------------------------------------
