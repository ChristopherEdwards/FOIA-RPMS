AMHLEL ; IHS/CMI/LAB - GETLAYS DAILY ACTIVITY RECORDS ;
 ;;4.0;IHS BEHAVIORAL HEALTH;**1**;JUN 18, 2010;Build 8
 ;
 ;CMI/TUCSON/LAB - 10/01/97 - patch 1 - reformatted display to put back in activity time in minutes
 ;Display all records for the provider, program, on this date.
 ;
 ;caller must pass AMHDATE - date of encounter
 ;                 AMHDATE - date in fileman format, no time or sec
 ;passed back to caller:  AMHRCNT - number of records found
 ;                        ^TMP("AMHVRECS",$J,n,ien)=""  n is consecutive
 ;                                                number
 ;
 Q
EN ;EP
 Q:'$G(AMHRS)
 D REC
 S AMHVREC=AMHX
 D EOJ
 Q
GATHER ;EP - called from AMHUAR
 K AMHQUIT,^TMP("AMHVRECS",$J) S AMHRCNT=0
 S AMHSD=$P(AMHDATE,".")-1,(AMHODAT,AMHSD)=AMHSD_".9999",AMHSD=$O(^AMHREC("B",AMHSD))
 I $P(AMHSD,".")>AMHDATE!(AMHSD="") S Y=AMHDATE D DD^%DT S ^TMP("AMHVRECS",$J,1,0)="No records currently on file for "_Y S AMHRCNT=1 D EOJ Q
 D GETRECS
EOJ K AMHQUIT,AMHPG,AMHREC,AMHV,AMHP,Y,AMHPREC,AMHHRN,X,Y,Z,%,AMHX,AMHSD,AMHODAT,AMHX,I,L,V,AMHRS
 Q
GETRECS ;
 S (AMHRCNT,AMHV)=0 F  S AMHODAT=$O(^AMHREC("B",AMHODAT)) Q:AMHODAT=""!($P(AMHODAT,".")>$P(AMHDATE,"."))!($D(AMHQUIT))  D
 .S AMHV=0 F  S AMHV=$O(^AMHREC("B",AMHODAT,AMHV)) Q:AMHV'=+AMHV!($D(AMHQUIT))  D
 ..;I '$$ALLOW(AMHV) Q
 ..I '$$ALLOWVI^AMHUTIL(DUZ,AMHV) Q  ;can't see visits to this location/this user
 ..S X=$P(^AMHREC(AMHV,0),U,8) I X,'$$ALLOWP^AMHUTIL(DUZ,X) Q  ;can't look at data for this patient
 ..S P=$$PPNAME^AMHUTIL(AMHV),N=$S($P(^AMHREC(AMHV,0),U,8):$P(^DPT($P(^AMHREC(AMHV,0),U,8),0),U),1:"ZZZZZZZ"),AMHHOLD($S(P]"":P,1:"ZZZZ"),N,AMHV)=""
 S AMHP1="" F  S AMHP1=$O(AMHHOLD(AMHP1)) Q:AMHP1=""  S AMHN1="" F  S AMHN1=$O(AMHHOLD(AMHP1,AMHN1)) Q:AMHN1=""  S AMHV=0 F  S AMHV=$O(AMHHOLD(AMHP1,AMHN1,AMHV)) Q:AMHV'=+AMHV  D
 .S AMHRCNT=AMHRCNT+1,AMHRS=AMHRCNT,^TMP("AMHVRECS",$J,"IDX",AMHRCNT,AMHRCNT)=AMHV,AMHREC=^AMHREC(AMHV,0) D REC S ^TMP("AMHVRECS",$J,AMHRCNT,0)=AMHX
 K AMHHOLD,P,N,V,AMHN1,AMHP1
 D EOJ
 Q
 ;
REC ;
 S AMHX=" " I $$ESIGREQ^AMHESIG(AMHV),$P($G(^AMHREC(AMHV,11)),U,12)="" S AMHX="*"
 S AMHX=AMHX_$J(AMHRS,3)_" " S X=$$PPINI^AMHUTIL(AMHV),X=$$LBLK(X,4) S AMHX=AMHX_X_" "_$S($P(AMHREC,U,8):$E($P(^DPT($P(AMHREC,U,8),0),U),1,15),1:"    --")
 S AMHX=$$RBLK(AMHX,26)
 I $P(AMHREC,U,8)]""  D
 .I $P(AMHREC,U,4),$D(^AUPNPAT($P(AMHREC,U,8),41,$P(AMHREC,U,4))) S AMHHRN=$P(^AUTTLOC($P(AMHREC,U,4),0),U,7)_$P(^AUPNPAT($P(AMHREC,U,8),41,$P(AMHREC,U,4),0),U,2) Q
 .I $D(^AUPNPAT($P(AMHREC,U,8),41,DUZ(2))) S AMHHRN=$P(^AUTTLOC(DUZ(2),0),U,7)_$P(^AUPNPAT($P(AMHREC,U,8),41,DUZ(2),0),U,2) Q
 .S AMHHRN="<*****>"
 E  S AMHHRN="-----"
 S AMHHRN=$$RBLK(AMHHRN,10)
 S AMHX=AMHX_AMHHRN S AMHX=$$RBLK(AMHX,38)
 ;S AMHX=AMHX_$S($P(AMHREC,U,4)]"":$E($P(^DIC(4,$P(AMHREC,U,4),0),U),1,6),1:"???") ;CMI/TUCSON/LAB - 10/06/97 - patch 1 reformatted loc
 ;S AMHX=$$RBLK(AMHX,44) ;CMI/TUCSON/LAB
 S AMHX=AMHX_$S($P(AMHREC,U,4):$P(^AUTTLOC($P(AMHREC,U,4),0),U,7),1:"??")
 S AMHX=$$RBLK(AMHX,42)
 I $P(AMHREC,U,4) S AMHX=AMHX_" "_$$VAL^XBDIQ1(9002011,AMHV,.06)
 S AMHX=$$RBLK(AMHX,46)
 S AMHP=$O(^AMHRPRO("AD",AMHV,0)) I AMHP="" S X="    <No Problems recorded.>",X=$$RBLK(X,29),AMHX=AMHX_X Q
 D GETPROB
 Q
GETPROB ;
 S AMHP=$O(^AMHRPRO("AD",AMHV,0)),AMHPREC=^AMHRPRO(AMHP,0)
 S X=$P(^AMHPROB($P(AMHPREC,U),0),U),X=$$LBLK(X,6)_" "
 S X=X_$S($P(AMHPREC,U,4)]"":$P(^AUTNPOV($P(AMHPREC,U,4),0),U),1:"<provider narrative missing>")
 S AMHX=AMHX_" "_X
 Q
GETHRN ;
 S AMHHRN=""
 I $P(AMHREC,U,4)]""  D
 .I $D(^AUPNPAT($P(AMHREC,U,4),41,$P(AMHREC,U,4))) S AMHHRN=$P(^AUTTLOC($P(AMHREC,U,4),0),U,7)_$P(^AUPNPAT($P(AMHREC,U,4),41,$P(AMHREC,U,4),0),U,2) Q
 .I $D(^AUPNPAT($P(AMHREC,U,4),41,DUZ(2))) S AMHHRN=$P(^AUTTLOC(DUZ(2),0),U,7)_$P(^AUPNPAT($P(AMHREC,U,4),41,DUZ(2),0),U,2) Q
 .S AMHHRN="<none>"
 E  S AMHHRN="  --  "
 Q
RBLK(V,L) ;left blank fill
 NEW %,I
 S %=$L(V),Z=L-% F I=1:1:Z S V=V_" "
 Q V
LBLK(V,L) ;left blank fill
 NEW %,I
 S %=$L(V),Z=L-% F I=1:1:Z S V=" "_V
 Q V
ALLOW(R) ;
 I $D(^AMHSITE(DUZ(2),16,DUZ)) Q 1  ;allow all with access
 NEW X,G S G=0 S X=0 F  S X=$O(^AMHRPROV("AD",R,X)) Q:X'=+X  I $P(^AMHRPROV(X,0),U)=DUZ S G=1
 I G Q 1
 I $P(^AMHREC(R,0),U,19)=DUZ Q 1
 Q 0
