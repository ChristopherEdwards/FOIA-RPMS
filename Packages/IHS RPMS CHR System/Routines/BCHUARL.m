BCHUARL ; IHS/TUCSON/LAB - GETLAYS DAILY ACTIVITY RECORDS ;  [ 10/28/96  2:05 PM ]
 ;;1.0;IHS RPMS CHR SYSTEM;;OCT 28, 1996
 ;
 ;Display all records for the provider, program, on this date.
 ;
 ;caller must pass BCHPROV - provider IEN
 ;                 BCHDATE - date in fileman format, no time or sec
 ;passed back to caller:  BCHRCNT - number of records found
 ;                        BCHVRECS(n,ien)=""  n is consecutive
 ;                                                number
 ;
GATHER ;EP - called from BCHUAR
 K BCHQUIT,BCHVRECS,BCHRCNT S BCHPG=0
 I '$D(^BCHR("AA",$P(BCHDATE,"."),BCHPROV)) S Y=BCHDATE D DD^%DT S BCHVRECS(1,0)="No records currently on file for "_$P(^VA(200,BCHPROV,0),U)_" on "_Y S BCHRCNT=1 G EOJ
 D GETRECS
EOJ K BCHQUIT,BCHPG,BCHREC,BCHV,BCHP,Y,DTOUT,DUOUT,BCHPREC,BCHHRN,X,Y,Z,%,BCHX
 Q
GETRECS ;
 S (BCHV,BCHRCNT)=0 F  S BCHV=$O(^BCHR("AA",$P(BCHDATE,"."),BCHPROV,BCHV)) Q:BCHV'=+BCHV!($D(BCHQUIT))  S BCHRCNT=BCHRCNT+1,BCHVRECS("IDX",BCHRCNT,BCHRCNT)=BCHV,BCHREC=^BCHR(BCHV,0) D
 .S BCHX=$J(BCHRCNT,3)_"  "_$S($P(^BCHR(BCHV,0),U,4)]"":$E($P(^DPT($P(^BCHR(BCHV,0),U,4),0),U),1,15),$P($G(^BCHR(BCHV,11)),U)]"":$E($P(^(11),U),1,15),1:"  <none>  ") S BCHX=$$RBLK(BCHX,22)
 .D GETHRN
 .S BCHHRN=$$LBLK(BCHHRN,10)
 .S BCHX=BCHX_BCHHRN_"  "
 .S BCHP=$O(^BCHRPROB("AD",BCHV,0)) I BCHP="" S X="<No Assessments recorded.>",X=$$RBLK(X,31),BCHX=BCHX_X
 .E  D GETPROB
 .S BCHX=BCHX_$S($P(BCHREC,U,6)]"":$E($P(^BCHTACTL($P(BCHREC,U,6),0),U),1,4),1:"    ")_"  "
 .S BCHX=BCHX_$J($P(BCHREC,U,11),4)
 .S BCHVRECS(BCHRCNT,0)=BCHX
 .Q
 D EOJ
 Q
GETPROB ;
 S BCHP=$O(^BCHRPROB("AD",BCHV,0)),BCHPREC=^BCHRPROB(BCHP,0)
 S X=$P(^BCHTPROB($P(BCHPREC,U),0),U,2)_"  "
 S X=X_$S($P(BCHPREC,U,4)]"":$P(^BCHTSERV($P(BCHPREC,U,4),0),U,3),1:"  ")_"  "
 S X=X_$J($P(BCHPREC,U,5),3)_"  "
 S X=X_$S($P(BCHPREC,U,6)]"":$E($P(^AUTNPOV($P(BCHPREC,U,6),0),U),1,16),1:"  ")
 S X=$$RBLK(X,31)
 S BCHX=BCHX_X
 Q
GETHRN ;
 S BCHHRN=""
 I $P(BCHREC,U,4)]""  D
 .I $D(^AUPNPAT($P(BCHREC,U,4),41,$P(BCHREC,U,4))) S BCHHRN=$P(^AUTTLOC($P(BCHREC,U,4),0),U,7)_$P(^AUPNPAT($P(BCHREC,U,4),41,$P(BCHREC,U,4),0),U,2) Q
 .I $D(^AUPNPAT($P(BCHREC,U,4),41,DUZ(2))) S BCHHRN=$P(^AUTTLOC(DUZ(2),0),U,7)_$P(^AUPNPAT($P(BCHREC,U,4),41,DUZ(2),0),U,2) Q
 .S BCHHRN="<none>"
 E  S BCHHRN="  --  "
 Q
RBLK(V,L) ;EP left blank fill
 NEW %,I
 S %=$L(V),Z=L-% F I=1:1:Z S V=V_" "
 Q V
LBLK(V,L) ;left blank fill
 NEW %,I
 S %=$L(V),Z=L-% F I=1:1:Z S V=" "_V
 Q V
