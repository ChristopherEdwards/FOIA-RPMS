AMQQEMAN ; IHS/CMI/THL - Q-MAN TO DOS EXPORT UTILITY. BUILDS FLAT ASCII FILES ACCORDING TO SPECS. ;
 ;;2.0;IHS PCC SUITE;;MAY 14, 2009
 ;-----
RUN S U="^"
 F AMQQERUN=1:1:11 D @$P("EXIT^INIT^STUFF^LEN^TYPE^DEL^MLEN^FIX^HLEN^DATA^PATH",U,AMQQERUN) I $D(AMQQQUIT) Q
 I '$D(AMQQQUIT) D ^AMQQEM2 ; FORMAT
 I '$D(AMQQQUIT) D ^AMQQEM4
 K AMQQERUN,AMQQQUIT
EXIT ; - EP -
 K AMQQEMS,DIRUT,DUOUT,DTOUT,DIROUT,AMQQEM,%ZA,%ZB,AMQQEM,AMQQEMFS,AMQQEMP,AMQQEMS,AMQQEMZ,AMQQEMN,G,C,P,X,Y,Z,H,I,J,A,N,T,W,AMQQEFN,AMQQEMI,AMQQEMX
 Q
 ;
INIT I '$D(DUZ(2)) W !!,"Kernel variables not present...Session cancelled",*7,!! S AMQQQUIT="" Q
 I '$D(IOSL) D HOME^%ZIS
 S %=$G(AMQQCCLS)
 I %'="P",%'="V" W !!,"The subject of your search must be a PATIENT or a VISIT to create an ASCI file.",!,*7,"Sorry...",!!! H 3 S AMQQQUIT="" Q
 S AMQQEMS=""
HEADER W @IOF,!!,?20,"*****  E-MAN DATA EXPORT UTILITY  *****"
 W !!!,"You are about to create a flat, ASCII file in the MUMPS environment."
 W !,"This file will be imported by your analytic/graphic software (e.g., dBase)."
 W !!,"Before you create the file, please answer the following questions =>",!
 Q
 ;
STUFF ; 3
 D MARK
 W "EXPORT TO WHAT APPLICATION",!
 S DIR(0)="P^9009073:EQM"
 S DIR("A")="Select export format"
 S DIR("B")="CUSTOM CONFIG"
 S DIR("??")="AMQQEMANCONFIG"
 D ^DIR
 K DIR
 S:$D(DUOUT) DIRUT=1
 I X="" K AMQQEM("STUFF") Q
 I X?1."^" S AMQQQUIT="" K DIRUT,DUOUT,DIROUT,DTOUT Q
 I Y["CUSTOM CONFIG" K AMQQEM("STUFF") D FWD Q
 S AMQQEM("STUFF")=^AMQQ(3,+Y,0)
 D FWD
 I $G(^AMQQ(3,+Y,2))]"" S AMQQEM("DATE FORMAT")=^(2)
 Q
 ;
CK ; EP FROM MANY ROUTINES
 I $D(DIRUT)!($D(DUOUT))!($D(DTOUT))!($D(DIROUT))!(X="^^") K DIRUT,DUOUT,DTOUT,DIROUT S AMQQQUIT=""
 Q
 ;
MARK ; - EP -
 W !!,"---------",!!
 Q
 ;
FWD S AMQQEMS=AMQQERUN_U_AMQQEMS
 Q
 ;
BACKUP S AMQQERUN=$P(AMQQEMS,U)-1
 S AMQQEMS=$P(AMQQEMS,U,2,99)
 Q
 ;
LEN ; RECORD LENGTH ; 4
 S %=$P($G(AMQQEM("STUFF")),U,2)
 I % S AMQQEM("LEN")=% Q
 D MARK
 W "MAXIMUM RECORD LENGTH",!
 S DIR("B")=$S($D(AMQQEM("LEN")):AMQQEM("LEN"),1:256)
 S DIR(0)="N^1:256:0"
 S DIR("A")="Enter the max. number of characters in ea. record"
 S DIR("?")="Most analytic/graphics software can import 256 character records"
 D ^DIR
 K DIR
 S:$D(DUOUT) DIRUT=1
 I X=U D BACKUP Q
 D CK
 I $D(AMQQQUIT) Q
 I 'Y W "??",*7 G LEN
 S AMQQEM("LEN")=Y
 D FWD
 Q
 ;
TYPE ; RECORD TYPE ; 5
 S %=$P($G(AMQQEM("STUFF")),U,3)
 I %=1 K AMQQEM("FIX") S AMQQEM("TYPE")=1 Q
 I %=2 K AMQQEM("MLEN"),AMQQEM("HLEN") S AMQQERUN=7,AMQQEM("TYPE")=2 Q
 D MARK
 W "RECORD FORMAT",!
 S DIR("B")=$S($D(AMQQEM("TYPE")):AMQQEM("TYPE"),1:1)
 S DIR("??")="AMQQEMANFIXDEL"
 S DIR(0)="S^1:DELIMITED;2:FIXED LENGTH"
 S DIR("A")="     Your choice"
 D ^DIR
 K DIR
 S:$D(DUOUT) DIRUT=1
 I X=U D BACKUP Q
 D CK
 I $D(AMQQQUIT) Q
 I Y=2 K AMQQEM("DEL"),AMQQEM("MLEN") D FWD S AMQQERUN=7,AMQQEM("TYPE")=2 Q
 K AMQQEM("FIX")
 D FWD
 S AMQQEM("TYPE")=1
 Q
 ;
DEL ; DELIMITER CHARACTER ; 6
 S %=$P($G(AMQQEM("STUFF")),U,4)
 I %'="" S AMQQEM("DEL")=% Q
 D MARK
 W "DELIMITER CHARACTER",!
 I $D(AMQQEM("DEL")) S DIR("B")=AMQQEM("DEL")
 S DIR(0)="F^:^K:((X'=""UP ARROW"")&(X'=""TAB"")&((X'?1P)!(X=$C(34)))) X"
 S DIR("A")="Enter the character to be used as a delimiter"
 S DIR("?")="Usually the delimiter is a single non-alphanumeric character such as a comma or space.  A quotation mark may not be used as a delimiter.  Enter 'UP ARROW' to use '^' as a delimiter."
 D ^DIR
 K DIR
 S:$D(DUOUT) DIRUT=1
 I X=U D BACKUP Q
 D CK
 I $D(AMQQQUIT) Q
 I Y'?1NUP,Y'="TAB",Y'="UP ARROW" W " ??",*7 G DEL
 D FWD
 S AMQQEM("DEL")=Y
 Q
 ;
MLEN ; DEL FIELD LENGTH ; 7
 S %=$P($G(AMQQEM("STUFF")),U,5)
 I % S AMQQEM("MLEN")=%,AMQQERUN=8 Q
 D MLEN^AMQQEM11
 Q
 ;
FIX ; FIXED FIELD LENGTH ; 8
 S %=$P($G(AMQQEM("STUFF")),U,7)
 I % S AMQQEM("FIX")=% Q
 D FIX^AMQQEM11
 Q
 ;
HLEN ; DEL FIELD LENGTH ; 9
 S %=$P($G(AMQQEM("STUFF")),U,6)
 I % S AMQQEM("HLEN")=% Q
 I '$D(AMQQEM("HLEN")),$D(AMQQEM("FIX")) S AMQQEM("HLEN")=AMQQEM("FIX")
 D HLEN^AMQQEM11
 Q
 ;
DATA ; ASSIGN DATA TYPE ; 10
 S %=$P($G(AMQQEM("STUFF")),U,8)
 I %'="" S AMQQEM("DATA")=% Q
 D DATA^AMQQEM11
 Q
 ;
ACCN ; ACCESSION NUMBER ; 11
 D MARK
 W "MAKE THE FIRST FIELD A SEQUENTIAL NUMBER",!
 S DIR("B")=$S($D(AMQQEM("ACCN")):AMQQEM("ACCN"),1:"NO")
 S DIR(0)="Y"
 S DIR("A")="Want to make the 1st field a sequential (serial) number"
 S DIR("?")="In some cases you may want to enter an serial number (starting with 1 and incrementing by 1 for each entry) as the first field of each record"
 D ^DIR
 K DIR
 S:$D(DUOUT) DIRUT=1
 I X=U D BACKUP Q
 D CK
 I $D(AMQQQUIT) Q
 D FWD
 S AMQQEM("ACCN")=$S(Y:"YES",1:"NO")
 Q
 ;
PATH ; PATH AND FILE...MSM ON ; 11
 I ^DD("OS")=18 D  Q
 .S AMQQEX("PATH")=$P(^AMQQ(8,DUZ(2),0),U,12)
 .I AMQQEX("PATH")="" D  Q
 ..W !!,"No secured path available to save a host file."
 ..W !,"Contact your site manager for assistance."
 ..H 3
 ..S AMQQQUIT=""
 .K DIR
 .S DIR(0)="FO^3:50"
 .S DIR("A")="Enter file name"
 .S DIR("A",1)="File will be saved in '"_$P(^AMQQ(8,DUZ(2),0),U,12)_"'"
 .W !!
 .D ^DIR
 .K DIR
 .I X=""!(X[U) S AMQQQUIT="" Q
 .S AMQQEX("FILE")=X
 .S AMQQEX("PATH")=$P(^AMQQ(8,DUZ(2),0),U,12)
 .K POP
 .S POP=$$LIST^%ZISH(AMQQEX("PATH"),AMQQEX("FILE"),.POP)
 .I $G(POP(1))="" D CLOSE^%ZISH(),VAR Q
 .D CLOSE^%ZISH()
 .S DIR(0)="YO"
 .S DIR("A")="File already exists.  Replace it with new data"
 .S DIR("B")="NO"
 .W !!
 .D ^DIR
 .K DIR
 .I 'Y G PATH
 .S X=$$DEL^%ZISH(AMQQEX("PATH"),AMQQEX("FILE"))
VAR .D VAR^AMQQEM1
 D ^AMQQEM1
 I '$D(AMQQQUIT),AMQQEM("FORMAT")="MUMPS" D NAME^AMQQEM4
 I $D(AMQQFNMP) K AMQQFNMP,DUOUT,AMQQQUIT G PATH
 Q
 ;
