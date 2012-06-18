%AZTGBLS ; CHECK FOR TRANSLATED GLOBALS [ 10/15/86  9:56 AM ]
 ;
 ; I plagerized ^%GSEL for this logic.  I do not undetstand it, but
 ;   it seems to work.  No warranty of course!
 ;
 ; This routine will leave U="^", AUDKTON=0 or 1.  If UCI
 ;   TRANSLATION is on it will be 1, if it is off it will
 ;   be 0.  *** warning ***  UCI TRANSLATION can be turned
 ;   on at any time from MGR (i.e. while you are running).
 ;   Entry at TON^%AZTGBLS will set AUKDTON to 0 or 1 only.
 ;
 ; Upon exiting, AUKDTRNL will not exist if there were no UCI
 ;   TRANSLATED globals.  If there were UCI TRANSLATED globals
 ;   AUKDTRNL will contains the entries from the UCI TRANSLATION
 ;   table separated by "^".
 ;
 ; This routine also KILLs ^UTILITY($J) upon entry, and
 ;   stores all UCI TRANSLATED globals for the current
 ;   UCI in ^UTILITY($J,.  Therefore, ^UTILITY($J) should
 ;   be KILLed by the calling routine, at EOJ.  Also, if there
 ;   where no UCI TRANSLATED globals for this UCI ^UTILITY($J)
 ;   will not exist.
 ;
 S U="^" K ^UTILITY($J)
 D TON
 W !!,"Now checking for UCI TRANSLATED globals.",!
 Q:'$D(^["MGR"]SYS(1,"TRANSLATION TABLE"))
 D ^%GUCI
 S AUKDUCI=%UCI,AUKDSYS=%SYS K %SYS,%UCI,%UCN
 S AUKDTRNL=""
 S AUKDX=0 F AUKDL=0:0 S AUKDX=$O(^["MGR"]SYS(1,"TRANSLATION TABLE",AUKDX)) Q:AUKDX'=+AUKDX  I $P(^(AUKDX),";",1,2)=(AUKDUCI_";"_AUKDSYS) S AUKDTRNL=AUKDTRNL_"^"_$P(^(AUKDX),";",3)
 K AUKDUCI,AUKDSYS,AUKDL,AUKDX
 I AUKDTRNL="" K AUKDTRNL Q
GSEL I '$D(%PGC) S %UCIN=$P($ZU(""),","),%SN=$P($ZU(""),",",2)
 S %ST=$V(44),%GO=1
 S %MM=$V(%SN*($V(%ST+34)#256)+$V(%ST+12)+2)
 S %DIR=$V(%UCIN-1*20+4,%MM)#256*65536+$V(%UCIN-1*20+2,%MM)
 S %VS="S"_%SN
 S:'$D(^UTILITY) ^UTILITY="" K ^UTILITY($J)
 F AUKDI=2:1 S %X=$P(AUKDTRNL,U,AUKDI) Q:%X=""  D
 . S (%MI,%ALL)=0 I $E(%X,1)="-" S %MI=1,%X=$E(%X,2,999)
 . I %X?.E1"*" S %ST=$E(%X,1,$L(%X)-1),%FI=%ST,%L=$L(%ST) D %GET^%GSEL C 63
 K AUKDI,%ALL,%DIR,%FI,%GO,%L,%MI,%MM,%SN,%ST,%T,%UCIN,%VS,%X
 Q
 ;
TON ; TRANSLATION ON/OFF
 S AUKDTON=($V($V(149,$J),$V($V(44)+276))#256)
 Q
