AUTPOS3 ; IHS/DIRM/JDM/DFM - Post Init to AUT ;  [ 11/25/97  12:34 PM ]
 ;;98.1;IHS DICTIONARIES (POINTERS);;NOV 25, 1997
 ;
 ;
RECODE ;EP - Converts invalid phone #s to valid in INSURER file.
 S NX=0 D CONVRT
 Q
CONVRT ;
 Q:'$O(^AUTNINS(NX))
 S NX=$O(^AUTNINS(NX))
 S PN=$P(^AUTNINS(NX,0),U,6)
 S LN=$L(PN)
 Q:PN=""!(LN<13)
 I $E(PN,6)="-" S PN=$P(PN,"-",1)_$P(PN,"-",2)
 S DIE="^AUTNINS(",DA=NX,DR=".06//^S X=PN" D ^DIE
 G CONVRT
 Q
