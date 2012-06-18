XBHFMAN1 ; IHS/ADC/GTH - HELP FRAME MANUAL (2/2) ; [ 02/07/97   3:02 PM ]
 ;;3.0;IHS/VA UTILITIES;;FEB 07, 1997
 ;
 ; ----- Print Title and Preface page.
 ;
 ;
 S X=XBNS_"HFMN"
 X ^%ZOSF("TEST")
 E  G MAIN
 S XBNOHDR=1
 NEW A,B
 F A="TITLE","PREFACE" Q:$D(DIRUT)  D ^DIWW,TOF F B=1:1 S X=$T(@A+B^@(XBNS_"UMAN")) Q:$L($P(X,";",1))>1  D PR($P(X,";",3)) Q:$D(DIRUT)
 ;
 I $D(DIRUT) G HATOUT
 D ^DIWW
 ;
MAIN ; ----- $ORDER thru the list of OPTIONS, and print them.
 S (XBNAME,XBNOHDR)=0
 F  S XBNAME=$O(^TMP("XBHFMAN",$J,XBNAME)) Q:'XBNAME  D MAKEHDRS,TOF Q:$D(DIRUT)  D HDR(XBNAME),DESC(+^TMP("XBHFMAN",$J,XBNAME)),HF($P($G(^DIC(19,+^TMP("XBHFMAN",$J,XBNAME),0)),U,7)),^DIWW
 I $D(DIRUT) G HATOUT
 ;
INDEX ; ----- Print the index.
 S XBHDR="Index"
 D TOF
 I $D(DIRUT) G HATOUT
 W !!!
 S X="|NOWRAP||SETTAB(""C"")||TAB|INDEX"
 D ^DIWP,^DIWW
 W !!!
 D CONT("INDEX^^"_XBPG)
 S (XB,XBCONT)="",$P(XBCONT,".",81)=""
 F  S XB=$O(^TMP("XBHFMAN-INDEX",$J,XB)) Q:XB=""  S X="" D  Q:$D(DIRUT)
 .F XBX=0:0 S XBX=$O(^TMP("XBHFMAN-INDEX",$J,XB,XBX)) S X=X_XBX_"," I '$O(^(XBX)) D  Q
 ..S X=XB_"..."_$E(XBCONT,1,DIWR-DIWL-$L(XB)-3-$L(X))_$E(X,1,$L(X)-1)
 ..S XBSAVX=X
 ..F  S X=$E(XBSAVX,1,DIWR-DIWL),XBSAVX=$E(XBSAVX,DIWR-DIWL+1,$L(XBSAVX)) Q:'$L(X)  D TOF:$Y>XBBM Q:$D(DIRUT)  D ^DIWP
 ..Q
 .Q
 I $D(DIRUT) G HATOUT
 D ^DIWW,RTRN^XBHFMAN
 I $D(DIRUT) G HATOUT
 ;
CONTENTS ; ----- Print the table of Contents.
 S XBNOHDR=1
 W @IOF,!!!!!
 S X="|SETTAB(""C"")||TAB|CONTENTS"
 D ^DIWP,^DIWW
 W !!
 S XB=0
 F  S XB=$O(^TMP("XBHFMAN-CONTENTS",$J,XB)) Q:'+XB  S X=^(XB),X=$P(X,U)_" "_$P(X,U,2)_$E(XBCONT,1,DIWR-DIWL-$L(X)+1)_$P(X,U,3) D TOF:$Y>XBBM Q:$D(DIRUT)  D ^DIWP
 I $D(DIRUT) G HATOUT
 D ^DIWW,RTRN^XBHFMAN
 I $D(DIRUT) G HATOUT
END ;EP - Paginate, close, kill, quit.
 W @IOF
HATOUT ;  
 D ^%ZISC
 KILL ^TMP("XBHFMAN",$J),XB,XBBM,XBCHAP,XBCONT,XBODD,XBHDR,XBIEN,XBPARA,XBPG,XBROOT,XBTITL,XBTM,XBX,XBY,DIC,DIWF,DIWL,DIWR
 Q
 ;
PR(X) ;EP - Process one line of text.
 NEW A,B,I,N,Y
 I X="|TOP|" D TOF Q
 D INDX(X),^DIWP,TOF:$Y>XBBM
 Q
 ;
INDX(X) ; ----- Parse/capitalize one line of text.  Check for indexed words.
 Q:'$D(XBPG)
 NEW Y,Z
 S X=$TR(X,"abcdefghijklmnopqrstuvwxyz","ABCDEFGHIJKLMNOPQRSTUVWXYZ")
 S X=$TR(X,"~`!@#$%^&*()_-+=|\{[}]:;""""'<,>.?/"," ")
 X XBSTRIP
 F  S %=$F(X,"  ") Q:'%  S X=$E(X,1,%-2)_$E(X,%,$L(X))
 F %=1:1 S Y=$P(X," ",%) Q:Y=""  I $D(^TMP("XBHFMAN-I",$J,Y)) S ^TMP("XBHFMAN-INDEX",$J,Y,XBPG)=""
 Q
 ;
HDR(XB) ; ----- Print a chapter heading.
 S %=$P(^TMP("XBHFMAN",$J,XB),U,2),XB=%_U_$P($G(^DIC(19,+^TMP("XBHFMAN",$J,XB),0)),U,2)
 F X="|SETTAB(""C"")||TAB|Chapter "_$P(XB,U),"|SETTAB(""C"")||TAB|"_$P(XB,U,2) D ^DIWP
 W !!
 D CONT($P(XB,U)_U_$P(XB,U,2)_U_XBPG)
 Q
 ;
TOF ;EP ----- Move to bottom of page, print footer, paginate, print header.
 I XBNOHDR D RTRN^XBHFMAN Q:$D(DIRUT)  W @IOF Q
 F  Q:$Y>XBBM  W !
 I XBPG W !?(DIWL-1),XBDASH,!,?$S(XBODD:DIWR-$L(XBTITL),1:DIWL-1),XBTITL
 D RTRN^XBHFMAN
 I $D(DIRUT) Q
 W @IOF
 S XBPG=XBPG+1,XBODD=XBPG#2
 F  Q:$Y=(XBTM-2)  W !
 W ?$S(XBODD:DIWR-$L("Page "_XBPG),1:DIWL-1),"Page ",XBPG
 I '(XBHDR="Index") W !?DIWL-1,$S(XBODD:XBHDRO,1:XBHDRE)
 W !?(DIWL-1),XBDASH,!!
 Q
 ;
MAKEHDRS ; ----- Make headers for odd and even pages.
 S (XBHDRE,XBHDRO)=$P($G(^DIC(19,+^TMP("XBHFMAN",$J,XBNAME),0)),U,2)
 S XBCHAP=$P(^TMP("XBHFMAN",$J,XBNAME),U,2)
 F %=1:1 I '$P(XBCHAP,".",%) S XBCHAP=$P(XBCHAP,".",1,%-1) Q
 S XBHDRO=XBHDRO_$J("",DIWR-DIWL-$L(XBHDRO)-$L("Chapter "_XBCHAP)+1)_"Chapter "_XBCHAP
 S XBHDRE="Chapter "_XBCHAP_$J("",DIWR-DIWL-$L(XBHDRE)-$L("Chapter "_XBCHAP)+1)_XBHDRE
 Q
 ;
CONT(X) ; ----- Add chapter number, title, and page number to list.
 S XBCONT=XBCONT+1,^TMP("XBHFMAN-CONTENTS",$J,XBCONT)=X
 Q
 ;
DESC(A) ; ----- Print descriptions of the OPTIONs as the first of the chapter.
 NEW B,I,N,Y
 I '$D(^DIC(19,A,1)) D PR("<NO DESCRIPTION>") Q
 S B=0
 F  S B=$O(^DIC(19,A,1,B)) Q:'B  D PR(^(B,0)) Q:$D(DIRUT)
 Q
 ;
HF(A) ; ----- Print the HELP FRAME text.
 I 'A D PR("<NO HELP FRAME>") Q
 I '$D(^DIC(9.2,A,1)) D PR("<NO HELP FRAME TEXT>") Q
 NEW B,I,N,Y
 S B=0
 F  S B=$O(^DIC(9.2,A,1,B)) Q:'B  D PR(^(B,0)) Q:$D(DIRUT)
 ; ----- Print any tied HELP FRAMEs.
 I $O(^DIC(9.2,A,2,0)) S B=0 F  S B=$O(^DIC(9.2,A,2,B)) Q:'B  D HF($P($G(^(B,0)),U,2)) Q:$D(DIRUT)
 Q
 ;
