AGOPT2 ; IHS/ASDS/EFG - ENTER OPTIONAL ITEMS ;  
 ;;7.1;PATIENT REGISTRATION;;AUG 25,2005
 ;
TQTM ;EP - Tribal Blood Quantum.
 D S1
 S DR=1109
 D END
 Q
TRINUM ;EP - Tribal Enrollment Number.
 D S1
 S DR=.07
 D END
 Q
ALIAS ;EP - Other Names.
 D S2
 S DR=1
 D END
 Q
OTHRTR ;EP - Other Tribes & Quanta.
 D S1
 S DR=4301
 D END
 Q
S1 ;
 K DUOUT
 S DIE="^AUPNPAT("
 S DA=DFN
 W !
 Q
S2 ;
 K DUOUT
 S DIE="^DPT("
 S DA=DFN
 W !
 Q
END ;
 D ^DIE
 S:$D(Y) DUOUT=""
 Q
