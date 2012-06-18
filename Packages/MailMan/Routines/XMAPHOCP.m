XMAPHOST ;(WASH ISC)/KMB/CAP-PRINT TO MESSAGE (P-MESSAGE) ;08/05/96  09:16 [ 12/04/96  3:56 PM ]
 ;;7.1;Mailman;**1003**;OCT 27, 1998
 ;;7.1;MailMan;**7,14,27**;Sep 12, 1994
 ;
 ;This routine is called as a close execute for the P-Message device
 ;to put reports written to host files (DOS,VMS...) into mail messages.
 ;
 ;It has one idiosyncracy.  If the report contains one single line
 ;or two lines separated with only a $C(13) instead of a CR/LF that is
 ;more than 254 characters long, there will be unexpected results.
 ;
 ;
 K ^TMP("XMY",$J),^TMP("XMY0",$J) I '$D(ZTQUEUED) K XMY,XMY0
 S Y=0
 N XMDUZ S XMDUZ=DUZ I '$G(XMDUZ) S XMDUZ=.5 I '$D(ZTQUEUED) U IO(0) W !!,*7,"No user identity.  Using Postmaster as sender and receiver." U IO
 S %=$G(XMSUB) N XMXUSEC,XMSUB,XMR S XMSUB=%
 I '$D(^XMB(3.7,$S($D(XMDUZ):XMDUZ,1:DUZ))),'$D(ZTQUEUED) U IO(0) W !,*7,"You do not have a mail box.  MailMan will not deliver messages to you." U IO
 I '$D(ZTQUEUED) U IO(0) W !!,"Moving text to MailMan message... (Creating now) " U IO
 N XMZ D DUN S XMSUB=$S($L($G(XMSUB))>3:XMSUB,$D(ZTQUEUED):"QUEUED MAIL REPORT FROM "_%,1:"")
 I '$D(ZTQUEUED) D 0
 D GET^XMA2
 S XMAPHOST("XMZ")=XMZ,XMAPHOST("XMSUB")=XMSUB
 Q
 ;
 ;Read the host file into a message, send it, erase it
READ ;Read record from file
 ;Each time <CR> is found in record it ends a message line
 N %,XMA0,XMB0,XMR,XMZ,Y
 I $$NEWERR^%ZTER N $ETRAP,$ESTACK S $ETRAP=""
 S X="EOF^XMAPHOST",@^%ZOSF("TRAP")
 S %=0,I=0,X="",XMZ=XMAPHOST("XMZ"),XMB0=^%ZOSF("OS")
 O IO:("/m/XM"_DUZ_"."_$J:"R")   ;IHS/MFD added line 
 U IO F  D  G EOF:$G(XMAPHOST("EOF"))
 . S X=$$GET(),XMA0=$L(X) S:X="" %=%+1 Q:%>999!$G(XMAPHOST("EOF"))
 . I X[""!(%<9) F  D  Q:X=""!$G(XMAPHOST("EOF"))
 . . S I=$$PUT(XMZ,$P(X,$C(13)),I),X=$P(X,$C(13),2,999)
 . . I $L(X),XMA0>254 S X=X_$$GET(),XMA0=0
 . . Q
 . Q
 Q
PUT(XMZ,X,I) ;Put data into message.
 S I=I+1,^XMB(3.9,XMZ,2,I,0)=$$STRIP(X),%=0
 I '$D(ZTQUEUED),I#10=0 U IO(0) W "." U IO
 Q I
GET() ;Read a record from the file
 N Y,X
 G:$D(XMAPHOST("EOF")) GETR
 I $$NEWERR^%ZTER N $ETRAP,$ESTACK S $ETRAP=""
 S X="GETQ^XMAPHOST",@^%ZOSF("TRAP")
GETR R Y#255:1
 I XMB0["MSM" G GETQ:$ZC'=0 Q Y
 Q Y
GETQ S XMAPHOST("EOF")=1
 Q ""
EOF ;
 I '$$NEWERR^%ZTER S X="ERR^ZU",@^%ZOSF("TRAP")
 I '$D(ZTQUEUED) U IO(0) W !,"END OF FILE",!
 S ^XMB(3.9,XMAPHOST("XMZ"),2,0)="^3.92A^"_I_"^"_I
 ;Here, send the message to recipient.
 N XMZ S XMZ=XMAPHOST("XMZ") I $D(ZTQUEUED) S XMY($S($G(XMDUZ):XMDUZ,$G(DUZ):DUZ,1:.5))="" D REDO^XMA21 G FINAL
 ;Here, we ask the user for recipients.
 I '$D(ZTQUEUED) U IO(0) D DUN N DIC,XMDUZ,XMDUN S XMDUZ=$S(DUZ:DUZ,1:.5),XMDUN=% D DESTXM^XMA21 G FINAL
FINAL I '$D(^TMP("XMY",$J)) S TMP("XMY",$J,.5)="",^TMP("XMY0",$J,.5)=""
 D ENT^XMAD1
 I '$D(ZTQUEUED) U IO(0) W !,"Message subject: ",XMAPHOST("XMSUB"),", Message number: ",XMZ,! H 3
Q1 S IONOFF=1 ;Prevent form feed during device close
 K %,X,XMAPHOST,XMY,^TMP("XMY",$J),^TMP("XMY0",$J),Y,I Q
STRIP(X) ;Remove Control Characters
 N % S %=0 I X'?.ANP N % F %=1:1:$L(X) I $E(X,%)?1C S X=$E(X,1,%-1)_$E(X,%+1,999) Q:X?.ANP  S %=%-1
 Q X
DUN ;GET NAME IN %
 S %=$S($D(^VA(200,DUZ,0))#2:$P(^(0),U),'$D(^DIC(3,DUZ,0)):"POSTMASTER",1:$P(^DIC(3,DUZ,0),U))
 Q
0 U IO(0) S XMAPHOST("XMSUB")=XMSUB D ENTS^XMA20
 I X'["^" S XMSUB=$S($L(X):X,1:XMAPHOST("XMSUB")) U IO Q
 W !!,"Sorry, I cannot stop the creation of this message at this point.",!,"You must enter a valid SUBJECT.",!
 G 0
