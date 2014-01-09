DG53P769 ;ALB/JAT DELETE RECORDS ;5/10/07
 ;;5.3;PIMS;**1016**;JUN 30, 2012;Build 20
 ;; resets from ^DD(2,0,"ACT")="I '$G(DICR),$G(DIC(0))'[""I"" D ^DGSEC"
 ;
 S ^DD(2,0,"ACT")="I $G(DIC(0))'[""I"" D ^DGSEC"
 Q
