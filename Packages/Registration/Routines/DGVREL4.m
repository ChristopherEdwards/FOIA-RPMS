DGVREL4 ;ALB/MRL - FORMAT RELEASE MESSAGE/LETTER, CONT. ; 2 JUN 87
 ;;5.3;Registration;;Aug 13, 1993
 S C=$S('DGFILE&('DGVRELSD):3,'DGFILE:4,'DGVRELSD:5,1:6),DGR="POOR^FAIR^GOOD^VERY GOOD^EXCELLENT",DGN=^DG(48,DGVREL,"S"),DGT=C_".  SURVEY RESPONSE" D S S DGT="    ---------------" D S
 F I=1:1:6 S J=$P($T(ST+I),";;",2),J1=+$P(DGN,"^",I+1),J2=$S('J1:"NONE PROVIDED",1:$P(DGR,"^",J1)),DGDOT="",$P(DGDOT,".",40)="",X=78-($L(J2)+1),DGT=$E("    "_J_DGDOT,1,X)_" "_J2 D S
 S DGT="" D S S DGT=$S('DGFILE&('DGVRELSD):4,'DGFILE:5,'DGVRELSD:6,1:7)_".  USER COMMENTS" D S S DGT="    -------------" D S S C=0 F I=0:0 S I=$O(^DG(48,DGVREL,"UC",I)) Q:'I  S C=C+1,DGT=^(I,0) D S
 I 'C S DGT="    No User Comments Submitted." D S
 Q
S S DGC=DGC+1,^UTILITY($J,"DGVREL",DGC,0)=DGT Q
 Q
ST ;
 ;;Quality of Documentation (if included) 
 ;;Installation Guide accuracy and quality 
 ;;Release Notes quality and accuracy 
 ;;Initialization Time Satisfaction 
 ;;Initial User Satisfaction with product 
 ;;Overall Satisfaction with this release 
