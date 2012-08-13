INHVA5 ;FRW ; ; Load files into the data mappaing file (#4090.1)
 ;;3.01;BHL IHS Interfaces with GIS;;JUL 01, 2001
 ;COPYRIGHT 1991-2000 SAIC
EN ;Main entry point
 ;
 ;GET SYSTEM - PROMPT USER IF OK - INSYS
 S INSYS="SC"
 ;
 ;Get MAP FUNCTION
 K DIC S DIC=4090.2,DIC(0)="AEQMZ" D ^DIC Q:Y<0  S INOK=1 D  Q:'INOK
 .S INMAP=+Y,INMAP(0)=Y(0)
 .;Must be static map
 .I '$P(INMAP(0),U,3) W !!,*7,"Must be a STATIC Map Function" S INOK=0 Q
 .;Must have a local file
 .I '$P($G(^INVD(4090.2,INMAP,INSYS)),U,1) W *7,!!,"Map Function must have a loacl file (",INSYS," FILE field)." S INOK=0 Q
 .;
A ;
 I $D(^INVD(4090.1,"VA",INMAP))!$D(^INVD(4090.1,"SC",INMAP)) W *7,!!,"WARNING! - There is mapped data for this function in fiel 4090.1",!!
 ;
 ;Get local file reference
 S INFILN=$P(^INVD(4090.2,INMAP,INSYS),U,1),INFILR=$G(^DIC(INFILN,0,"GL"))
 I '$L(INFILR) W *7,!!,"No global storage location for local file - ^DIC(file,0,""GL"")" Q
 ;Convert lcoal file reference
 S L=$L(INFILR),INFILR=$E(INFILR,1,L-1)_$S($E(INFILR,L)="(":"",$E(INFILR,L)=",":")",1:"")
 ;
 ;Add device & taskman calls
 ;
ENQUE ;Taskman entry point
 ;
 K ^UTILITY($J)
 ;Loop through entries in the file
 F  S INDA=$O(@INFILR@(INDA)) Q:'INDA  D
 .Q:'$D(@INFILR@(INDA,0))  I $L(INFILSC) X INFILSC Q:'$T
 .K DIC S DIC=4090.1,DIC(0)="XL",X=INFILN_"-"_INDA D ^DIC
 .I Y<0 W !!,"WARNING: Map value not added for entry #",INDA,!! Q
