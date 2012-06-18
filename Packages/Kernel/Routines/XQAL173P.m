XQAL173P ;OIFO-SF.SEA/JLI - ALERT PATCH 173 POST-INSTALL ROUTINE ;3/13/02  11:39 [ 03/13/2003  1:28 PM ]
 ;;8.0;KERNEL;**173**;Jul 05, 1995
 ;
 ; Re-run "B" X-Ref on file 8992.1  (ISL-0200-52883)
 ;
 ; This routine is marked for deletion after the install completes
 ;
EN ; 
 N I,X
 K ^XTV(8992.1,"B")
 F I=0:0 S I=$O(^XTV(8992.1,I)) Q:I'>0  I $G(^(I,0))'="" S X=$P(^(0),U),^XTV(8992.1,"B",$E(X,1,50),I)=""
 Q
