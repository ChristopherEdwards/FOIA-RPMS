ADGGFL ;searhc/maw - ADG CONVERT V HOSP FILE POINTERS  [ 05/13/1999  2:45 PM ]
 ;;5.0;ADMISSION/DISCHARGE/TRANSFER;**1**;MAY 04, 1999
 ;
 ;this routine will go through the admission type file and the
 ;discharge type files and get their corresponding entries with
 ;the new facility movement file
 ;
MAIN ;-- this is the main routine driver
 D ADT,DIT
 D GET Q:POP
 D SET,END
 Q
 ;
ADT ;-- this is where i get the admission iens
 W !!,"I am getting the new admission type pointers"
 S FMNM=0 F  S FMNM=$O(^DIC(42.1,"B",FMNM)) Q:FMNM=""  D
 . S FMIEN=0 F  S FMIEN=$O(^DIC(42.1,"B",FMNM,FMIEN)) Q:FMIEN=""  D
 .. Q:'$D(^DG(405.1,"B",FMNM))
 .. S ADT(FMIEN)=$O(^DG(405.1,"B",FMNM,0))
 .. W "."
 Q
 ;
DIT ;-- this is where i get the discharge iens
 W !,"I am getting the new discharge type pointers..."
 S FMNM=0 F  S FMNM=$O(^DIC(42.2,"B",FMNM)) Q:FMNM=""  D
 . S FMIEN=0 F  S FMIEN=$O(^DIC(42.2,"B",FMNM,FMIEN)) Q:FMIEN=""  D
 .. Q:'$D(^DG(405.1,"B",FMNM))
 .. S DIT(FMIEN)=$O(^DG(405.1,"B",FMNM,0))
 .. W "."
 Q
 ;
GET ;-- go through the hospital location file and grab bad data nodes
 W !,"I will now search for entries in the V Hospitalization file "
 W "that are incomplete."
 W !,"At the end of this search, I will print a list of incomplete "
 W "data nodes."
 H 2
 ;IHS/DSD/ENM 01/26/99 NEXT LINE COPIED/MODIFIED
 ;S (ENT,HLF)=0 F  S HLF=$O(^AUPNVINP(HLF)) Q:HLF'?.N  D
 S (ENT,HLF)=0 F  S HLF=$O(^AUPNVINP(HLF)) Q:'HLF!(HLF'?.N)  D
 . S ENT=ENT+1
 . I ENT=25 W "." S ENT=0
 . I '$D(^AUPNVINP(HLF)) S ^TMP($J,HLF)="NO DATA IN NODE"
 . I $P(^AUPNVINP(HLF,0),U,7)="" S ^TMP($J,HLF)="NO ADMISSION TYPE"
 . I $P(^AUPNVINP(HLF,0),U,6)="" S ^TMP($J,HLF)="NO DISCHARGE TYPE"
 ;IHS/ASDST/ENM 12/29/98 ABOVE TWO LINES MODIFIED 6 AND 7 REV
 W @IOF
 D ^%ZIS
 I POP W !,"You must rerun this conversion before continuing, D ^ADGGFL when ready" Q
 W !,"The following data nodes have incomplete data:"
 S (CNT,TMPA)=0 F  S TMPA=$O(^TMP($J,TMPA)) Q:TMPA=""  D
 . Q:'$D(^TMP($J,TMPA))
 . W !,"^AUPNVINP("_TMPA_",0) has "_$G(^TMP($J,TMPA))
 . S CNT=CNT+1
 I CNT=0 W !!,"All data in ^AUPNVINP is acceptable for conversion",!
 D ^%ZISC
 Q
 ;
SET ;-- this is where i set the nodes with the new pointers
 ;-- i don't set any nodes that are incomplete
 S DIR(0)="Y",DIR("A")="I will update the V HOSP pointers, continue: "
 D ^DIR
 G SET:$D(DIRUT)
 I Y<1 W !,"You must update V HOSP pointers, D SET^ADGGFL when ready" Q
 W !,"I am now repointing the V Hospitalization file "
 S REC=0
 I $D(^TMP("VHOSP")) S (REC,AIEN)=$G(^TMP("VHOSP"))+1
 ;IHS/DSD/ENM 05/04/99 NEXT LINE COPIED/MODIFIED
 ;S (ACNT,AIEN)=0 F  S AIEN=$O(^AUPNVINP(AIEN)) Q:AIEN'?.N  D
 S (ACNT,AIEN)=0 F  S AIEN=$O(^AUPNVINP(AIEN)) Q:AIEN'=+AIEN  D
 . Q:'$D(^AUPNVINP(AIEN))
 . Q:$D(^TMP($J,AIEN))
 . S ADT=$P(^AUPNVINP(AIEN,0),U,7)
 . S DIT=$P(^AUPNVINP(AIEN,0),U,6)
 . S NAT=$G(ADT(ADT))
 . S NDT=$G(DIT(DIT))
 . S $P(^AUPNVINP(AIEN,0),U,7)=NAT
 . S $P(^AUPNVINP(AIEN,0),U,6)=NDT
 . S ACNT=ACNT+1
 . S REC=REC+1
 . S ^TMP("VHOSP")=REC
 . I ACNT=50 W "." S ACNT=0
 W !,"Conversion completed succsessfully, "_REC_" entries updated"
 Q
 ;
END ;-- kill the variables and quit
 K FMNM,FMIEN,AIEN,ADT,DIT,NAT,NDT,DIE,DR,DA,ACNT,ENT,TMPA
 K ^TMP($J),^TMP("VHOSP")
 Q
 ;
