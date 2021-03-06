BGP3ASL1 ; IHS/CMI/LAB - DISPLAY IND LISTS 28 Apr 2006 2:10 PM ;
 ;;13.0;IHS CLINICAL REPORTING;;NOV 20, 2012;Build 81
 ;; ;
NGR ;EP
 K BGPTIND S BGPHIGH=""
 S BGPSUCNT=0,BGPSU="",BGPSUC=0
 S BGPX=0 F  S BGPX=$O(^BGPGPDCH(BGPX)) Q:BGPX'=+BGPX  S V=$G(^BGPGPDCH(BGPX,0)) D
 .Q:'$D(^BGPGPDCH(BGPX,0))
 .Q:$P(V,U)'=BGPBD
 .Q:$P(V,U,2)'=BGPED
 .Q:$P(V,U,7)'=BGPPER
 .I $G(BGPYGPU),$P(V,U,12)'=9 Q
 .I '$G(BGPYGPU),$P(V,U,12)'=1 Q
 .;I $G(BGPCHWE) Q:'$O(^BGPGPDCH(BGPX,88888,0))
 .Q:$P(V,U,5)'=BGPBBD
 .Q:$P(V,U,6)'=BGPBED
 .Q:$P(V,U,14)'=BGPBEN
 .S BGPSUC=BGPSUC+1,BGPTIND(BGPSUC,0)=BGPSUC_")"
 .S Y=""
 .S $E(Y,4)=$E($$SU($P(V,U,11)),1,10)
 .S $E(Y,15)=$E($$FAC($P(V,U,9)),1,13)_$S($P(^BGPGPDCH(BGPX,0),U,17):"+",1:"")
 .S $E(Y,30)=$$DATE^BGP3UTL($P(V,U))
 .S $E(Y,40)=$$DATE^BGP3UTL($P(V,U,2))
 .S $E(Y,50)=$$DATE^BGP3UTL($P(V,U,5))
 .S $E(Y,60)=$$DATE^BGP3UTL($P(V,U,6))
 .S $E(Y,70)=$$DATE^BGP3UTL($P(V,U,13))
 .S BGPTIND(BGPSUC,0)=BGPTIND(BGPSUC,0)_Y
 .S BGPTIND(BGPSUC,BGPSUC)=BGPX
 .I $D(BGPSUL(BGPX)) S BGPTIND(BGPSUC,0)="*"_BGPTIND(BGPSUC,0)
 .Q
 S (VALMCNT,BGPHIGH)=BGPSUC
 Q
 ;
ONM ;EP
 K BGPTIND S BGPHIGH=""
 S BGPSUCNT=0,BGPSU="",BGPSUC=0
 S BGPX=0 F  S BGPX=$O(^BGPGPDCH(BGPX)) Q:BGPX'=+BGPX  S V=$G(^BGPGPDCH(BGPX,0)) D
 .Q:'$D(^BGPGPDCH(BGPX,0))
 .Q:$P(V,U)'=BGPBD
 .Q:$P(V,U,2)'=BGPED
 .Q:$P(V,U,7)'=BGPPER
 .Q:$P(V,U,5)'=BGPBBD
 .Q:$P(V,U,6)'=BGPBED
 .Q:$P(V,U,14)'=BGPBEN
 .Q:$P(V,U,12)'=7
 .S BGPSUC=BGPSUC+1,BGPTIND(BGPSUC,0)=BGPSUC_")"
 .S Y=""
 .S $E(Y,4)=$E($$SU($P(V,U,11)),1,10)
 .S $E(Y,15)=$E($$FAC($P(V,U,9)),1,13)_$S($P(^BGPGPDCH(BGPX,0),U,17):"+",1:"")
 .S $E(Y,30)=$$DATE^BGP3UTL($P(V,U))
 .S $E(Y,40)=$$DATE^BGP3UTL($P(V,U,2))
 .S $E(Y,50)=$$DATE^BGP3UTL($P(V,U,5))
 .S $E(Y,60)=$$DATE^BGP3UTL($P(V,U,6))
 .S $E(Y,70)=$$DATE^BGP3UTL($P(V,U,13))
 .S BGPTIND(BGPSUC,0)=BGPTIND(BGPSUC,0)_Y
 .S BGPTIND(BGPSUC,BGPSUC)=BGPX
 .I $D(BGPSUL(BGPX)) S BGPTIND(BGPSUC,0)="*"_BGPTIND(BGPSUC,0)
 .Q
 S (VALMCNT,BGPHIGH)=BGPSUC
 Q
 ;
ELD ;EP
 K BGPTIND S BGPHIGH=""
 S BGPSUCNT=0,BGPSU="",BGPSUC=0
 S BGPX=0 F  S BGPX=$O(^BGPELDCH(BGPX)) Q:BGPX'=+BGPX  I BGPX S V=$G(^BGPELDCH(BGPX,0)) D
 .Q:'$D(^BGPELDCH(BGPX,0))
 .Q:$P(V,U)'=BGPBD
 .Q:$P(V,U,2)'=BGPED
 .Q:$P(V,U,7)'=BGPPER
 .Q:$P(V,U,12)'=5
 .Q:$P(V,U,5)'=BGPBBD
 .Q:$P(V,U,6)'=BGPBED
 .Q:$P(V,U,14)'=BGPBEN
 .S BGPSUC=BGPSUC+1,BGPTIND(BGPSUC,0)=BGPSUC_")"
 .S Y=""
 .S $E(Y,4)=$E($$SU($P(V,U,11)),1,10)
 .S $E(Y,15)=$E($$FAC($P(V,U,9)),1,13)_$S($P(^BGPELDCH(BGPX,0),U,17):"+",1:"")
 .S $E(Y,30)=$$DATE^BGP3UTL($P(V,U))
 .S $E(Y,40)=$$DATE^BGP3UTL($P(V,U,2))
 .S $E(Y,50)=$$DATE^BGP3UTL($P(V,U,5))
 .S $E(Y,60)=$$DATE^BGP3UTL($P(V,U,6))
 .S $E(Y,70)=$$DATE^BGP3UTL($P(V,U,13))
 .S BGPTIND(BGPSUC,0)=BGPTIND(BGPSUC,0)_Y
 .S BGPTIND(BGPSUC,BGPSUC)=BGPX
 .I $D(BGPSUL(BGPX)) S BGPTIND(BGPSUC,0)="*"_BGPTIND(BGPSUC,0)
 .Q
 S (VALMCNT,BGPHIGH)=BGPSUC
 Q
PED ;EP
 K BGPTIND S BGPHIGH=""
 S BGPSUCNT=0,BGPSU="",BGPSUC=0
 S BGPX=0 F  S BGPX=$O(^BGPPEDCH(BGPX)) Q:BGPX'=+BGPX  I BGPX S V=$G(^BGPPEDCH(BGPX,0)) D
 .Q:'$D(^BGPPEDCH(BGPX,0))
 .Q:$P(V,U)'=BGPBD
 .Q:$P(V,U,2)'=BGPED
 .Q:$P(V,U,7)'=BGPPER
 .Q:$P(V,U,5)'=BGPBBD
 .Q:$P(V,U,6)'=BGPBED
 .Q:$P(V,U,11)'=BGPBEN
 .S BGPSUC=BGPSUC+1,BGPTIND(BGPSUC,0)=BGPSUC_")"
 .S Y=""
 .S $E(Y,4)=$E($$SU($P(V,U,10)),1,10)
 .S $E(Y,15)=$E($$FAC($P(V,U,9)),1,13)_$S($P(^BGPPEDCH(BGPX,0),U,17):"+",1:"")
 .S $E(Y,30)=$$DATE^BGP3UTL($P(V,U))
 .S $E(Y,40)=$$DATE^BGP3UTL($P(V,U,2))
 .S $E(Y,50)=$$DATE^BGP3UTL($P(V,U,5))
 .S $E(Y,60)=$$DATE^BGP3UTL($P(V,U,6))
 .S $E(Y,70)=$$DATE^BGP3UTL($P(V,U,13))
 .S BGPTIND(BGPSUC,0)=BGPTIND(BGPSUC,0)_Y
 .S BGPTIND(BGPSUC,BGPSUC)=BGPX
 .I $D(BGPSUL(BGPX)) S BGPTIND(BGPSUC,0)="*"_BGPTIND(BGPSUC,0)
 .Q
 S (VALMCNT,BGPHIGH)=BGPSUC
 Q
FAC(S) ;
 NEW N S N=$O(^AUTTLOC("C",S,0))
 I N="" Q N
 Q $P(^DIC(4,N,0),U)
SU(S) ;
 NEW N S N=$O(^AUTTSU("C",S,0))
 I N="" Q N
 Q $P(^AUTTSU(N,0),U)
