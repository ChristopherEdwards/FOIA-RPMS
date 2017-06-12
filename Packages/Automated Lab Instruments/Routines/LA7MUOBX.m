LA7MUOBX ;ihs/cmi/maw - MU2 OBX Ask at Order Questions ; 22-Oct-2013 09:22 ; MAW
 ;;5.2;BLR IHS REFERENCE LAB;**1033**;NOV 01, 1997
 ;
OBX3(CS,AC,RI,RA)  ;-- observation identifier
 N OBX3,ROI,CD,TX
 S CD=$P($G(^BLRRLO(RI,4,RA,0)),U,5)
 S TX=$P($G(^BLRRLO(RI,4,RA,0)),U,3)
 S OBX3=CD_CS_TX_CS_"LN"_CS_$E(TX,1,3)_CS_TX_CS_"L"_CS_"2.40"_CS_LA7VER
 Q OBX3
 ;
OBX5(CS,AC,RI,RA)  ;-- observation value
 N OBX5,CMP,NM,VAL
 S VAL=$P($G(^BLRRLO(RI,4,RA,0)),U,4)
 I $E(VAL)?.N S CMP="",NM=VAL
 I $E(VAL)="=" S CMP=$E(VAL,1),NM=$E(VAL,2,99)
 I $E(VAL)="<" S CMP=$E(VAL,1),NM=$E(VAL,2,99)
 I $E(VAL)=">" S CMP=$E(VAL,1),NM=$E(VAL,2,99)
 S OBX5=CMP_CS_NM_CS_CS
 Q OBX5
 ;
OBX6(CS)  ;-- observation units
 N OBX6
 S OBX6="a"_CS_"Year"_CS_"UCUM"_CS_"Y"_CS_"Years"_CS_"L"_CS_"1.1"_CS_LA7VER  ;hardcoded
 Q OBX6
 ;
