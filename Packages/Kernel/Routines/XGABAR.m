XGABAR ;JSH,DJW ;4/21/93  11:39 AM
 ;;3.01;BHL IHS Interfaces with GIS;;JUL 01, 2001
 ;CHCS TLS_4602; GEN 2; 12-NOV-1998
 ;COPYRIGHT 1993 SAIC
 ;
 Q
BBASK(XGABARN) ;Button bar
 S XGABPOP=0 N X,XGABVAL S X=$$GET^XGABU(XGABARN,2) I 'X Q:XGABPOP "" S XGABPOP=3 Q ""
 K XGABESCF S XGABVAL="" D RUN^XGABR(X,0,2)
 Q XGABVAL
 ;
ABASK(XGABARN) ;Action bar
 S XGABPOP=0 K XGABESCF N X S X=$$GET^XGABU(XGABARN,2,1) I 'X Q:XGABPOP  S XGABPOP=3 Q
 D RUN^XGABR(X) Q
 ;
STDHLP ;Standard help
 W "To choose an item you may either:"
 W !?5,"1.  Use arrow keys to move to desired choice and press RETURN."
 W !?5,"2.  Press the highlighted letter on the desired item (no RETURN needed)."
 W !!,"Press '^' or "_$$KEY^DWUTL("EXIT TEXT OR MULTIPLE")_" to exit."
 Q
