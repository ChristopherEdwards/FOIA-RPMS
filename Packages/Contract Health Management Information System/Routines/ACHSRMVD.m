ACHSRMVD ;IHS/OIT/FCJ - REMOVE DOC CAUSING THE DUPLICATE DOC ERROR;JUL 10, 2008
 ;;3.1;CONTRACT HEALTH MGMT SYSTEM;**13,14**;JUN 11,2001
 ;ACHS*3.1*13 IHS/OIT/FCJ NEW ROUTINE FOR PATCH 13
 ;ACHS*3.1*14 IHS/OIT/FCJ 
ST ;
 W @IOF
 W ?5,"This routine removes documents that have been added",!
 W ?5,"after the site manager has removed the entire fiscal",!
 W ?5,"year documents.  You will need to enter the 4 digit",!
 W ?5,"fiscal year.  The duplicate documents will then be",!
 W ?5,"displayed.  You will need to confirm deletion of the",!
 W ?5,"documents.",!!
 W ?5,"NOTE: FY ON DISPLAYED DOCUMENTS SHOULD DISPLAY 10 YRS PRIOR TO FY ENTERED,",!
 W ?5,"EXAMPLE: IF 2008 ENTERED THEN THE FY: 1998 SHOULD DISPLAY FOR DOCUMENTS."
 W !
FY ;Enter FY to remove documents from
 S DIR(0)="N^1996:"_ACHSCFY,DIR("A")="Enter the 4 digit FY the duplicate error is occurring in"
 D ^DIR K DIR
 G:$D(DIRUT) EXT
 G:Y<1 FY
 S ACHSEFY=Y
 ;
PROC ; Beg process to display and delete documents
 ;ACHS*3.1*14 IHS/OIT/FCJ USER READ PROMPT AS CURRENT FY
 S (ACHSTMP,ACHSDOC)=""
 I '$D(^ACHS(9,DUZ(2),"FY",ACHSEFY)) W !,"This FY is not valid for this facility" G FY
 S (ACHSTMP,ACHSDOC)=1_$E(ACHSEFY,4)_"00000"+$P(^ACHS(9,DUZ(2),"FY",ACHSEFY,"C"),U)  ;BEG DOC NUMBER
 ;I $D(^ACHS(9,DUZ(2),"FY",ACHSEFY)) S (ACHSTMP,ACHSDOC)=1_$E(ACHSEFY,4)_"00000"+$P(^ACHS(9,DUZ(2),"FY",ACHSEFY,"C"),U)
 ;I ACHSDOC="",ACHSEFY+10'>ACHSCFY S (ACHSTMP,ACHSDOC)=1_$E(ACHSEFY,4)_"00000"+$P(^ACHS(9,DUZ(2),"FY",ACHSEFY+10,"C"),U)
 W !,"Documents to be Removed:"
 S ACHSCTN=0,LISTCNT=1
 I ACHSDOC'="" D LOOP
 I LISTCNT=1 W !,"There are no documents to be removed...." D RTRN^ACHS G EXT
 S DIR(0)="Y",DIR("A")="Would you like to continue with deletion of these documents",DIR("B")="N"
 D ^DIR K DIR
 I Y=1 S ACHSCTN=1,LISTCNT=1 W !,"Deleting Documents: " D LOOP
 G EXT
 Q
LOOP ;
 F  S ACHSDOC=$O(^ACHSF(DUZ(2),"D","B",ACHSDOC)) Q:(ACHSDOC'?1N.N)!($E(ACHSDOC,2)>$E(ACHSEFY,4))  D
 . S ACHSDIEN=0
 . F  S ACHSDIEN=$O(^ACHSF(DUZ(2),"D","B",ACHSDOC,ACHSDIEN)) Q:ACHSDIEN'?1N.N  D
 . .D DSPL
 I ACHSCTN=1 W !,"Removed ",LISTCNT-1," Documents"
 S ACHSDOC=ACHSTMP
 Q
DSPL ;Display document information
 W !,LISTCNT,". Document: "
 S Y=ACHSDIEN D Q3^ACHSUD
 S Y=$P(DOCDATA,U,2) X ^DD("DD")
 W !?13," FY: ",$P(DOCDATA,U,27),"  Date Entered: ",Y
 Q:'ACHSCTN
DEL ;Delete the records
 S DIK="^ACHSF("_DUZ(2)_",""D"",",DA(1)=DUZ(2),DA=ACHSDIEN
 D ^DIK K DIK
 W "     DELETED"
 Q
EXT ;
 K ACHSDOC,ACHSTMP,ACHSCTN,ACHSDIEN,LISTCNT,DOCDATA,ACHSEFY
 Q
