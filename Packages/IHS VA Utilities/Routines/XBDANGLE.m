XBDANGLE ;IHS/SET/GTH - Q'ABLE CLEANUP DANGLING POINTERS OPTION HELP FRAME PROTOCOL FILES ; [ 10/29/2002   7:42 AM ]
 ;;3.0;IHS/VA UTILITIES;**9**;FEB 07, 1997
 ;XB*3*9 IHS/SET/GTH XB*3*9 10/29/2002 Cleanup dangling pointers.
 ;
 ; This utility can be scheduled to run via TaskMan.
 ;
 ; Actions are delivered to XUPROG key holders via MailMan.
 ;
 ; You can also run this interactively, but you'll still
 ; get the MailMan note, even after the interactive run.
 ;
 ; Thanks to the VA for the original interactive routine, XQ3.
 ;
 D INIT
 D OFIX,HFFIX,PFIX
 D MAIL
 D EXIT
 Q
 ;
 ; ----------------------------------------------------------
 ;
OFIX ;Kill any dangling pointers in the OPTION File (#19)
 NEW I,J,K,L,M,X,Y
 S (I,X)=0 ;X=Total Deletions
L1 ;
 S I=$O(^DIC(19,I))
 I I>0 S (Y,J)=0 G L2 ;Loop through menus
 D RSLT(X_" pointer"_$S(X=1:"",1:"s")_" fixed in your OPTION file.")
 Q
 ;
L2 ;
 S J=$O(^DIC(19,I,10,J))
 I J>0 G ITEM ;Loop through menu items
 I '$D(^DIC(19,I,10,0)) G L1
 S (K,J)=0
 F L=1:1 S J=$O(^DIC(19,I,10,J)) Q:J'>0  S K=J ;K=Last item
 S J=^DIC(19,I,10,0),^(0)=$P(J,"^",1,2)_"^"_K_"^"_Y ;fix counters
 G XREFS
 ;
ITEM ;
 S K=+^DIC(19,I,10,J,0)
 I $D(^DIC(19,K,0)) S Y=Y+1 G L2 ;Y=No. of items
 D RSLT("Option "_$P(^DIC(19,I,0),U,1)_" points to missing option "_K)
 S X=X+1
 KILL ^DIC(19,I,10,J) ;Kill invalid menu item
 G L2
 ;
XREFS ;
 S K=":"
L3 ;
 S K=$O(^DIC(19,I,10,K))
 I K="" G L1 ;Loop through cross references
 S L=-1
L4 ;
 S L=$O(^DIC(19,I,10,K,L))
 I L="" G L3
 S J=0
L5 ;
 S J=$O(^DIC(19,I,10,K,L,J))
 I J'>0 G L4
 I '$D(^DIC(19,I,10,J,0)) G KILLXR ;kill xref to invalid item
L6 ;
 S M=^DIC(19,I,10,J,0)
 I (M=L)!(M[L_"^") G L5
KILLXR ;
 KILL ^DIC(19,I,10,K,L,J)
 I $O(^DIC(19,I,10,K,L,-1))="" KILL ^DIC(19,I,10,K,L)
 G L5
 ;
 ; ----------------------------------------------------------
 ;
HFFIX ; Fix dangling pointers on help frame file
 NEW I,J,K,L,X,Y
 S (X,I)=0
 F  S I=$O(^DIC(9.2,I)) Q:I'>0  I $D(^(I,2)) D HF1,HF2,HF3
 D RSLT(X_" pointer"_$S(X=1:"",1:"s")_" fixed in your HELP FRAME file.")
 Q
 ;
HF1 ;
 S (Y,J)=0
 F  S J=$O(^DIC(9.2,I,2,J)) Q:J'>0  I $D(^(J,0)) S K=$P(^(0),U,2),Y=Y+1 I $L(K),'$D(^DIC(9.2,K)) S Y=Y-1,X=X+1 K ^DIC(9.2,I,2,J,0)
 Q
 ;
HF2 ;
 S (K,J)=0
 F  S J=$O(^DIC(9.2,I,2,J)) Q:J'>0  S K=J
 S J=^DIC(9.2,I,2,0),^(0)=$P(J,U,1,2)_U_K_U_Y
 Q
 ;
HF3 ;
 S K=":"
 F  S K=$O(^DIC(9.2,I,2,K)) Q:K=""  S J=-1 F  S J=$O(^DIC(9.2,I,2,K,J)) Q:J=""  D HF4
 Q
 ;
HF4 ;
 S L=0
 F  S L=$O(^DIC(9.2,I,2,K,J,L)) Q:L'>0  I '$D(^DIC(9.2,I,2,L,0)) K ^DIC(9.2,I,2,K,J,L)
 Q
 ;
 ; ----------------------------------------------------------
 ;
PFIX ;Kill any dangling pointers in the PROTOCOL File (#101)
 NEW I,J,K,L,M,X,Y
 S (I,X)=0 ;X=Total Deletions
P1 ;
 S I=$O(^ORD(101,I))
 I I>0 S (Y,J)=0 G P2 ;Loop through protocols
 D RSLT(X_" pointer"_$S(X=1:"",1:"s")_" fixed in your PROTOCOL file.")
 Q
 ;
P2 ;
 S J=$O(^ORD(101,I,10,J))
 I J>0 G PITEM ;Loop through items
 I '$D(^ORD(101,I,10,0)) G P1
 S (K,J)=0
 F L=1:1 S J=$O(^ORD(101,I,10,J)) Q:J'>0  S K=J ;K=Last item
 S J=^ORD(101,I,10,0),^(0)=$P(J,"^",1,2)_"^"_K_"^"_Y ;fix counters
 G PXREFS
 ;
PITEM ;
 S K=+^ORD(101,I,10,J,0)
 I $D(^ORD(101,K,0)) S Y=Y+1 G P2 ;Y=No. of items
 D RSLT("Protocol "_$P(^ORD(101,I,0),U,1)_" points to missing option "_K)
 S X=X+1
 KILL ^ORD(101,I,10,J) ;Kill invalid menu item
 G P2
 ;
PXREFS ;
 S K=":"
P3 ;
 S K=$O(^ORD(101,I,10,K))
 I K="" G P1 ;Loop through cross references
 S L=-1
P4 ;
 S L=$O(^ORD(101,I,10,K,L))
 I L="" G P3
 S J=0
P5 ;
 S J=$O(^ORD(101,I,10,K,L,J))
 I J'>0 G P4
 I '$D(^ORD(101,I,10,J,0)) G PKILLXR ;kill xref to invalid item
P6 ;
 S M=^ORD(101,I,10,J,0)
 I (M=L)!(M[L_"^") G P5
PKILLXR ;
 KILL ^ORD(101,I,10,K,L,J)
 I $O(^ORD(101,I,10,K,L,-1))="" KILL ^ORD(101,I,10,K,L)
 G P5
 ;
RSLT(%) S ^(0)=$G(^TMP("XBDANGLE",$J,0))+1,^(^(0))=% W:'$D(ZTQUEUED) !,% Q
 ;
 ;
INIT ; Set up.
 NEW XMSUB,XMDUZ,XMTEXT,XMY
 KILL ^TMP("XBDANGLE",$J)
 Q
 ;
MAIL ; Send a note to local programmers 'bout these results.
 S XMSUB=$P($P($T(+1),";",2)," ",4,99),XMDUZ=$G(DUZ,.5),XMTEXT="^TMP(""XBDANGLE"",$J,",XMY(DUZ)=""
 F %="XUPROGMODE" D SINGLE(%)
 D ^XMD
 Q
 ;
EXIT ;
 KILL ^TMP("XBDANGLE",$J)
 I $D(ZTQUEUED) S ZTREQ="@" Q
 Q
 ;
SINGLE(K) ; Get holders of a single key K.
 NEW Y
 S Y=0
 Q:'$D(^XUSEC(K))
 F  S Y=$O(^XUSEC(K,Y)) Q:'Y  S XMY(Y)=""
 Q
 ;
