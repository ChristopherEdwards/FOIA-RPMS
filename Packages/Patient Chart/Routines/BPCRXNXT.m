BPCRXNXT ; IHS/OIT/MJL - FINDS NEXT PERSCRIPTION NUMBER FOR BPC GUI ;
 ;;1.5;BPC;;MAY 26, 2005
 ;Gets last prescription from OUTPATINE SITE file for DUZ(2)
 ;Checks to determine if not in use by prescription file and pass
 ;to BPC GUI for next RX number
 ;Branch to Narcotic RX Number if flag is set and drug contains an "A"
 ;
GETDEA(BGUARRAY,DEAVALUE) ;EP CALL FROM REMOTE PROC: BPC GET RX NEXT NUMBER
EN ;S DEAVALUE=0
 S X="" K ^TMP($J)
 S XWBWRAP=1,BGUARRAY="^TMP("_$J_")"
 I +$G(DUZ(2))=0 S ^TMP($J,1)=-1,^TMP($J,2)="NO DUZ(2)DEFINED!" Q
 S BPCVAL="",BPCVAL=$O(^PS(59,"C",DUZ(2),BPCVAL)) I BPCVAL=""!('$D(^PS(59,"C",DUZ(2),BPCVAL))) S ^TMP($J,1)=-1,^TMP($J,2)="OUT PATIENT SITE File not defined for "_DUZ(2) Q
 S PSOSITE=$O(^PS(59,0))
 S PSODRUG("DEA")=DEAVALUE
 D AUTO^PSONRXN
 I +$G(PSONEW("RX #"))=0 S ^TMP($J,1)=-1,^TMP($J,2)="PRESCRIPTION NUMBER NOT ASSIGNED!" Q
 S ^TMP($J,1)=1,^TMP($J,2)=PSONEW("RX #")
 K PSOSITE,PSODRUG,DEAVALUE
 Q
