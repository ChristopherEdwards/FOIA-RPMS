BARUPCHK ; IHS/SD/LSL - CHECK 3P UPLOAD ;
 ;;1.8;IHS ACCOUNTS RECEIVABLE;;OCT 26, 2005
 ;;
 ; IHS/SD/LSL - 12/17/02 - V1.7 - NHA-0601-180049
 ;      Modified to find bill in 3P correctly.  Responsible for
 ;      entire routine.  Removed TPR (Reload by date) option and
 ;      related code.
 ;
 ; *********************************************************************
 ;
CMP(BARUPDA)         ;EP Compare 3p abma to a/r called from BARUP1
 S BARDSP=$G(^TMP("BAR",$J,"BARUPDSP",$J))
 S BARDIF=0,BARSHOW=0
 D BILL^BARUPCH2
 S BARDSP=$G(^TMP("BAR",$J,"BARUPDSP",$J))
 I BARDSP,BARDIF D DIF
 S BARDIF=+$G(BARDIF)
 Q BARDIF
 ; ********************************************************************
 ;
DIF ;EP display differences
 Q:'BARDSP
 S BARSHOW=1
 D BILL^BARUPCH2
 D IT^BARUPCH2
 Q
