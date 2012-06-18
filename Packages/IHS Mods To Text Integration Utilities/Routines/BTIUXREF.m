BTIUXREF ; IHS/ITSC/LJF - IHS XREFERENCE CODE ;
 ;;1.0;TEXT INTEGRATION UTILITIES;;NOV 04, 2004
 ;
AIHS1A ;EP; add code for AIHS xref on Patient field
 NEW TIU S TIU=$G(^TIU(8925,+DA,0)) Q:TIU=""
 I $P(TIU,U),$P(TIU,U,3),$P(TIU,U,5) D
 . S ^TIU(8925,"AIHS1",+X,+$P(TIU,U),+$P(TIU,U,5),(9999999-$P($G(^AUPNVSIT(+$P(TIU,U,3),0)),".")),+DA)=""
 Q
 ;
AIHS1K ;EP; kill code for AIHS xref on Patient field
 NEW TIU S TIU=$G(^TIU(8925,+DA,0)) Q:TIU=""
 I $P(TIU,U),$P(TIU,U,3),$P(TIU,U,5) D
 . K ^TIU(8925,"AIHS1",+X,+$P(TIU,U),+$P(TIU,U,5),(9999999-$P($G(^AUPNVSIT(+$P(TIU,U,3),0)),".")),+DA)
 Q
 ;
AIHS11A ;EP; add code for AIHS xref on Visit field
 NEW TIU S TIU=$G(^TIU(8925,+DA,0)) Q:TIU=""
 I $P(TIU,U),$P(TIU,U,2),$P(TIU,U,5) D
 . S ^TIU(8925,"AIHS1",+$P(TIU,U,2),+$P(TIU,U),+$P(TIU,U,5),(9999999-$P($G(^AUPNVSIT(X,0)),".")),+DA)=""
 Q
 ;
AIHS11K ;EP; kill code for AIHS xref on Visit field
 NEW TIU S TIU=$G(^TIU(8925,+DA,0)) Q:TIU=""
 I $P(TIU,U),$P(TIU,U,2),$P(TIU,U,5) D
 . K ^TIU(8925,"AIHS1",+$P(TIU,U,2),+$P(TIU,U),+$P(TIU,U,5),(9999999-$P($G(^AUPNVSIT(X,0)),".")),+DA)
 Q
 ;
AIHS12A ;EP; add code for AIHS xref on Doc Type field
 NEW TIU S TIU=$G(^TIU(8925,+DA,0)) Q:TIU=""
 I $P(TIU,U,2),$P(TIU,U,3),$P(TIU,U,5) D
 . S ^TIU(8925,"AIHS1",+$P(TIU,U,2),+X,+$P(TIU,U,5),(9999999-$P($G(^AUPNVSIT(+$P(TIU,U,3),0)),".")),+DA)=""
 Q
 ;
AIHS12K ;EP; kill code for AIHS xref on Doc Type field
 NEW TIU S TIU=$G(^TIU(8925,+DA,0)) Q:TIU=""
 I $P(TIU,U,2),$P(TIU,U,3),$P(TIU,U,5) D
 . K ^TIU(8925,"AIHS1",+$P(TIU,U,2),+X,+$P(TIU,U,5),(9999999-$P($G(^AUPNVSIT(+$P(TIU,U,3),0)),".")),+DA)
 Q
 ;
AIHS13A ;EP; add code for AIHS xref on Status field
 NEW TIU S TIU=$G(^TIU(8925,+DA,0)) Q:TIU=""
 I $P(TIU,U),$P(TIU,U,2),$P(TIU,U,3) D
 . S ^TIU(8925,"AIHS1",+$P(TIU,U,2),+$P(TIU,U),+X,(9999999-$P($G(^AUPNVSIT(+$P(TIU,U,3),0)),".")),+DA)=""
 Q
 ;
AIHS13K ;EP; kill code for AIHS xref on Status field
 NEW TIU S TIU=$G(^TIU(8925,+DA,0)) Q:TIU=""
 I $P(TIU,U),$P(TIU,U,2),$P(TIU,U,3) D
 . K ^TIU(8925,"AIHS1",+$P(TIU,U,2),+$P(TIU,U),+X,(9999999-$P($G(^AUPNVSIT(+$P(TIU,U,3),0)),".")),+DA)
 Q
