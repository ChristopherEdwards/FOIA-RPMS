APCHPAT ; IHS/CMI/GRL - Patient Health Summary ;
 ;;2.0;IHS RPMS/PCC Health Summary;**14**;JUN 24, 1997
 ;
 Q  ;not ready yet
 S DIR(0)="SM^1:Pre-visit Patient Medical Handout;2:Post-visit Patient Medical Handout"
 D ^DIR
 I +Y=1 D ^APCHPRE Q
 I +Y=2 D ^APCHPST Q
 Q
