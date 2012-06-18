ACHSYES ; IHS/ITSC/PMF - REGENERATE "ES" CROSSREF OF CHS FACILITY FROM GIVEN IEN ;  [ 10/16/2001   8:16 AM ]
 ;;3.1;CONTRACT HEALTH MGMT SYSTEM;;JUN 11, 2001
 ;
 ; This utility rebuilds the "ES" x-ref (ESTIMATED DATE OF SERVICE),
 ; in the CHS FACILITY file.
 ;
 ; DUZ & DUZ(2) must be defined.
 ;
 ; You'll be asked for the beginning internal entry number at the "D"
 ; level of the ^ACHSF(DUZ(2),"D", global.  The re-build will begin
 ; with that entry and proceed to the last entry number.
 ;
 ; The entire file can be x-ref'd using FM x-ref utility,
 ; CHS FACILITY file, DOCUMENT sub-file, ESTIMATED DATE
 ; OF SERVICE field, "ES" x-ref.
 ;
 I '$G(DUZ) W !,"DUZ UNDEFINED OR 0." Q
 I '$G(DUZ(2)) W !,"DUZ(2) UNDEFINED OR 0." Q
 D HOME^%ZIS,DT^DICRW
START ;
 S Y=$$DIR^XBDIR("NO^1:"_$P(^ACHSF(DUZ(2),"D",0),U,3),"ENTER BEGINNING IEN")
 Q:'Y
 D WAIT^DICD
 N D,E
 S D=+Y
 F  S D=$O(^ACHSF(DUZ(2),"D",D)) Q:'D  S E=$P($G(^ACHSF(DUZ(2),"D",D,3)),U,9) W "." I E]"" S ^ACHSF(DUZ(2),"ES",E,D)=""
 Q
 ;
