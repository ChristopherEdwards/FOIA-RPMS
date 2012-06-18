AGSCANP ; IHS/ASDS/EFG - PRINT IDENTIFIERS ON SCAN ;  
 ;;7.1;PATIENT REGISTRATION;;AUG 25,2005
 ;
 W ?50,$P($G(^DPT(+Y,0)),U,9)    ;SSN
 W ?65,$E($P($G(^(0)),U,3),4,5)  ;DOB
 W "-"
 W $E($P($G(^(0)),U,3),6,7)      ;DOB
 W "-"
 W $E($P($G(^(0)),U,3),1,3)+1700,!  ;DOB
 D DEADY^AGMAN                   ;IS PATIENT DECEASED
 I $D(AG("DEAD")) D
 . W ?5,"(D)"
 . K AG("DEAD")
 ;If 'Add extra IDENTIFIERS to SCAN' in REGISTRATION PARAMETERES FILE
 ;is set to YES
 I $G(AGOPT(10))="Y" D
 . W:$D(^AUPNPAT(+Y,11)) ?10,$P(^(11),U,18)  ;CURRENT COMMUNITY
 . W ?40,"MOTHER'S (MDN): "
 . I $D(^DPT(+Y,.24)) W $P(^(.24),U,3)       ;
 I $D(^AUPNPAT(+Y,41)) D
 . F L=0:0 S L=$O(^AUPNPAT(+Y,41,L)) Q:'L  I $D(^DIC(4,L,0)) W !?21,$J($P(^AUPNPAT(+Y,41,L,0),U,2),6) W:$P(^(0),U,3) "(*)" W ?29,$P(^DIC(4,L,0),U)
 K L
 Q
