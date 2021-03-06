BRNRUP3 ; IHS/OIT/LJF - CONTINUED REPORT UTILITY PRINT LOGIC
 ;;2.0;RELEASE OF INFO SYSTEM;*1*;APR 10, 2003
 ;IHS/OIT/LJF 10/25/2007 PATCH 1 Added this routine
 ;
DELIMIT ;EP - Set up header line, dash line for delimited output
 S BRNFCNT=0
 K ^TMP($J,"BRNDELIMITED")
 S BRNDELC=0,BRNPIEC=0
 S BRNHDR="PATIENT IEN"_U_"REQUEST IEN",BRNPIEC=2
 S X=0,BRNHEAD="" F  S X=$O(^BRNRPT(BRNRPT,12,X)) Q:X'=+X  D
 . S BRNPIEC=BRNPIEC+1
 . S H=$P(^BRNSORT($P(^BRNRPT(BRNRPT,12,X,0),U),0),U,6)
 . S $P(BRNHDR,U,BRNPIEC)=H
 ;
 D COVPAGE^BRNRUP1 ;print cover page - note: if user ^'s out of cover page, processing continues
 ;
PROC ;process printing of report
 I BRNDELT="F" D OPEN Q:Y=1
 W !,BRNHDR,!
 I '$D(^XTMP("BRNVL",BRNJOB,BRNBTH)) W !,"NO DATA TO REPORT" G DONE
 S (BRNSRTV,BRNFRST)="" K BRNQUIT
 F  S BRNSRTV=$O(^XTMP("BRNVL",BRNJOB,BRNBTH,"DATA HITS",BRNSRTV)) Q:BRNSRTV=""!($D(BRNQUIT))  D V
DONE ;
 ;write out delimited file
 I BRNDELT="F" D ^%ZISC
 K ^XTMP("BRNVL",BRNJOB,BRNBT),^XTMP("BRNFLAT",$J),^TMP($J,"BRNDELIMITED")
 D DEL^BRNRU
 D EN^XBVK("BRN"),EN^XBVK("VALM")
 Q
V ;GETS DATA HITS
 S BRNCNT=0
 ;get readable sort value
 K BRNPRNT
 S BRNSRTR="",BRNVIEN=$O(^XTMP("BRNVL",BRNJOB,BRNBTH,"DATA HITS",BRNSRTV,0)) I BRNVIEN]"" S BRNCRIT=BRNSORT D
 . S BRNVREC=^BRNREC(BRNVIEN,0),DFN=$P(BRNVREC,U,3) X:$D(^BRNSORT(BRNSORT,3)) ^(3) S BRNSRTR=BRNPRNT
 K BRNFRST
 S BRNVIEN=0 F  S BRNVIEN=$O(^XTMP("BRNVL",BRNJOB,BRNBTH,"DATA HITS",BRNSRTV,BRNVIEN)) Q:BRNVIEN'=+BRNVIEN!($D(BRNQUIT))  D
 . S BRNVREC=^BRNREC(BRNVIEN,0),DFN=$P(BRNVREC,U,3) D PRINT Q
 ;
 Q
PRINT ;
 K ^XTMP("BRNLINE",$J) S ^XTMP("BRNLINE",$J,1)=""
 K BRNDELD
 S BRNPIEC=0,BRNLINE=1,BRNCNT=BRNCNT+1
 S BRNDELD(1,"S")=DFN,BRNDELD(2,"S")=BRNVIEN,BRNPIEC=2
 S BRNI=0 F  S BRNI=$O(^BRNRPT(BRNRPT,12,BRNI)) Q:BRNI'=+BRNI!($D(BRNQUIT))  S BRNCRIT=$P(^BRNRPT(BRNRPT,12,BRNI,0),U) D
 . S BRNPIEC=BRNPIEC+1
 . I '$P(^BRNSORT(BRNCRIT,0),U,8) D SINGLE Q
 . D MULT
 ;
 K BRNDELP
 F X=1:1:BRNLINE D
 . S BRNCNT=BRNCNT+1
 . F P=1:1:BRNPIEC D
 . . S V=$O(BRNDELD(P,""))
 . . I V="S" S D=BRNDELD(P,V),$P(BRNDELP(BRNCNT),U,P)=D
 . . I V="M" S D=$S($P(BRNDELD(P,V),"|",X)]"":$P(BRNDELD(P,V),"|",X),1:"--"),$P(BRNDELP(BRNCNT),U,P)=D
 S X=0 F  S X=$O(BRNDELP(X)) Q:X'=+X  W BRNDELP(X),!
 Q
 ;
SINGLE ;process single valued item
 K BRNPRNT
 S BRNX=0
 X:$D(^BRNSORT(BRNCRIT,3)) ^(3)
 I BRNPRNT="" S BRNPRNT="--"
 S BRNDELD(BRNPIEC,"S")=BRNPRNT
 Q
 ;
MULT ;process multiple valued item
 K BRNPRNT,BRNPRNM,BRNY S (BRNX,BRNPCNT)=0
 X:$D(^BRNSORT(BRNCRIT,3)) ^(3)
 ;if 13th, then $o through delete bad ones and then reorder/number
 ;new logic here to screen if user wants to screen
 I $P(^BRNRPT(BRNRPT,12,BRNI,0),U,3) D
 .;does this one match selected ones?
 . S X=0 F  S X=$O(BRNPRNM(X)) Q:X'=+X  D
 . . S Z=$G(BRNPRNM(X,"I")) I Z="" K BRNPRNM(X) Q
 . . I '$D(^BRNRPT(BRNRPT,11,BRNCRIT,11,"B",Z)) K BRNPRNM(X)
 K Y S (X,C)=0 F  S X=$O(BRNPRNM(X)) Q:X'=+X  S C=C+1,Y(C)=BRNPRNM(X)
 I C>BRNLINE S BRNLINE=C
 K BRNPRNM S X=0 F  S X=$O(Y(X)) Q:X'=+X  S BRNPRNM(X)=Y(X)
 I '$D(BRNPRNM) S BRNPRNT="--" D
 . S BRNDELD(BRNPIEC,"M")=BRNPRNT
 S X=0 F  S X=$O(BRNPRNM(X)) Q:X'=+X  D
 . S $P(BRNDELD(BRNPIEC,"M"),"|",X)=BRNPRNM(X)
 Q
 ;
DIQ ;
 K BRNPRNT,BRNFILE,BRNFIEL
 S BRNFILE=$P($P(^BRNSORT(BRNCRIT,0),U,4),","),BRNFIEL=$P($P(^(0),U,4),",",2)
 S DIQ(0)="EN",DIQ="BRNPRNT(",DIC=BRNFILE,DR=BRNFIEL D EN^DIQ1 K DIC,DR,DIQ
 I '$D(BRNPRNT(BRNFILE,DA,BRNFIEL,"E")) S BRNPRNT(BRNFILE,DA,BRNFIEL,"E")="--"
 S BRNPRNT=BRNPRNT(BRNFILE,DA,BRNFIEL,"E")
 Q
OPEN ;write flat file from global
 ;if screen selected do screen
 ;USE GS FROM GPRA TO OPEN AND WRITE FILE
 S Y=$$OPEN^%ZISH(BRNHDIR,BRNDELF,"W")
 I Y=1 W:'$D(ZTQUEUED) !!,"Cannot open host file to write out DELIMITED data.  Notify programmer." Q
 U IO
 Q
