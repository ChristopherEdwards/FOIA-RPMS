XBSIC ;IHS/SET/GTH - LIST ID,SP,FD NODES ON SELECTED FILES ; [ 12/05/2002  4:28 PM ]
 ;;3.0;IHS/VA UTILITIES;**9**;FEB 07, 1997
 ;IHS/SET/GTH XB*3*9 10/29/2002 New Routine.
 ; This routine lists the IDENTIFIERS, SPECIFIERS, and
 ; CONDITIONALS from selected files.
 ;
 ; Thanks to E. Don Enos for the original routine in Sep 1997.
 ;
START ;
 D INIT
 Q:XBQFLG
 D DBQUE
 Q
 ;
INIT ; INITIALIZATION
 D EN^XBVK("XB")
 S (XBBT)=$H,XBJOB=$J
 S XBQFLG=1
 I '$G(DUZ(2)) W !!,"Your DUZ(2) is not set!",!! Q
 I '$G(^AUTTLOC(DUZ(2),0)) W !!,"The site specified in your DUZ(2) does not exist!",!! Q
 KILL ^XTMP("XBSIC",XBJOB)
 D ^XBKVAR
 D ^XBDSET  ;                             get files to check
 I '$O(^UTILITY("XBDSET",XBJOB,0)) Q  ;  quit if no files selected
 S XBQFLG=0
 Q
 ;
DBQUE ; call to XBDBQUE
 W !
 S DIR(0)="S^P:PRINT Output;B:BROWSE Output on Screen",DIR("A")="Do you wish to",DIR("B")="P"
 KILL DA
 D ^DIR
 KILL DIR
 Q:$D(DIRUT)
 I Y="B" D BROWSE Q
 S XBRP="LIST^XBSIC",XBRC="FILES^XBSIC",XBRX="EOJ^XBSIC",XBNS="XB"
 D ^XBDBQUE
 Q
 ;
BROWSE ;
 S XBRP="VIEWR^XBLM(""LIST^XBSIC"")"
 S XBRC="FILES^XBSIC",XBRX="EOJ^XBSIC",XBIOP=0
 D ^XBDBQUE
 Q
 ;
FILES ; PROCESS ALL FILES
 S XBFILE=0
 F  S XBFILE=$O(^UTILITY("XBDSET",XBJOB,XBFILE)) Q:'XBFILE  D FILE(XBFILE)  Q:XBQFLG
 Q
 ;
FILE(XBFILE) ; PROCESS ONE FILE (CALLED RECURSIVELY)
 NEW L,V,W,X,Y
 I '$D(ZTQUEUED),'$D(IO("S")),$E(IOST,1,2)="C-" W "."
 S ^XTMP("XBSIC",XBJOB,XBFILE,"!")="" ;  file marker
 F X="FD","ID","SP" D
 .  I '$D(^DD(XBFILE,0,X)) Q  ;            quit if no node
 .  I X="ID",'$O(^DD(XBFILE,0,X,0)) Q  ;   quit if no real identifier
 .  S Y=0
 .  F  S Y=$O(^DD(XBFILE,0,X,Y)) Q:Y=""  I Y D
 ..  S V=$G(^DD(XBFILE,0,X,Y)) ;           get value & set $ZR
 ..  I X="SP" S W=$S(V'="":"="_V,1:"") D SET Q
 ..  I X="ID" S W="" D SET Q
 ..  S L=""
 ..  F  S L=$O(^DD(XBFILE,0,X,Y,L)) Q:L=""  D
 ...  S V=$G(^DD(XBFILE,0,X,Y,L)) ;        get value & set $ZR
 ...  S W="="_V D SET
 ...  Q
 ..  Q
 .  Q
 ;I $P($G(^DD(XBFILE,.01,0)),U,2)["P" S X=^(0) D RECURSE ;ptr chain
 I $P($G(^DD(XBFILE,.01,0)),U,2)["P" S X=^(0) I '(XBFILE=+$P($P(X,U,2),"P",2)) D FILE(+$P($P(X,U,2),"P",2))
 Q
 Q:$G(RECURSE)  ;                           quit if recursing
 S XBFLD=.01
 F  S XBFLD=$O(^DD(XBFILE,XBFLD)) Q:'XBFLD  I $D(^(XBFLD,0)) S X=^(0) D
 .  Q:$P(X,U,2)'["P"  ;                     quit if not pointer
 .  D RECURSE
 .  Q
 Q
 ;
SET ; SET ONE LINE
 S ^XTMP("XBSIC",XBJOB,XBFILE,$$LGR^%ZOSV_W)=""
 Q
 ;
RECURSE ; RECURSE FOR FILES BEING POINTED TO
 Q:XBFILE=+$P($P(X,U,2),"P",2)  ;          quit if self reference
 NEW XBFILE,RECURSE
 S RECURSE=1
 S XBFILE=+$P($P(X,U,2),"P",2)
 D FILE
 Q
 ;
LIST ; LIST OUTPUT
 U IO
 D HEAD
 S XBFILE=0
 F  S XBFILE=$O(^XTMP("XBSIC",XBJOB,XBFILE)) Q:'XBFILE  D  Q:XBQFLG
 .  D F Q:XBQFLG
 .  W !,?4,XBFILE_" ("_$P($G(^DIC(XBFILE,0)),U)_")",!
 .  S XBDEV=""
 .  F  S XBDEV=$O(^XTMP("XBSIC",XBJOB,XBFILE,XBDEV)) Q:XBDEV=""  D WRITE Q:XBQFLG
 .  Q
 Q
 ;
WRITE ; WRITE ONE LINE
 Q:XBDEV="!"  ;                               quit if file marker
 D F
 Q:XBQFLG
 W XBDEV,!
 Q
 ;
F ;Form feed
 I ($Y+4)>IOSL D
 . I '$D(ZTQUEUED),'$D(IO("S")),$E(IOST,1,2)'="P-" D PAUSE S:$D(DIRUT) XBQFLG=1
 . Q:XBQFLG
 . W @IOF
 . D HEAD
 . Q
 Q
 ;
PAUSE ; PAUSE FOR USER
 Q:$E(IOST)'="C"
 Q:$D(ZTQUEUED)!'(IOT="TRM")!$D(IO("S"))
 S DIR(0)="E",DIR("A")="Press any key to continue"
 KILL DIRUT
 D ^DIR
 KILL DIR
 Q
 ;
HEAD ; WRITE HEADER
 I '$D(ZTQUEUED),'$D(IO("S")),$E(IOST,1,2)="C-" W @IOF
 S XBPG=$G(XBPG)+1
 W "     ID/SP/FD REPORT run at ",$P(^AUTTLOC(DUZ(2),0),U,2)," on ",$$FMTE^XLFDT(DT),?75,$J(XBPG,5),!
 W $$REPEAT^XLFSTR("=",80),!
 Q
 ;
Q Q
 ;
EOJ ;
 S XBET=$H,XBTS=(86400*($P(XBET,",")-$P(XBBT,",")))+($P(XBET,",",2)-$P(XBBT,",",2)),XBH=+$P(XBTS/3600,"."),XBTS=XBTS-(XBH*3600),XBM=+$P(XBTS/60,"."),XBTS=XBTS-(XBM*60),XBS=XBTS
 W !!,"RUN TIME (H.M.S): "_XBH_"."_XBM_"."_XBS,!
 KILL ^XTMP("XBSIC",XBJOB)
 KILL ^UTILITY("XBDSET",XBJOB)
 D EN^XBVK("XB")
 Q
 ;
