BGUGUTL ; IHS/OIT/MJL - GENERAL UTILITIES FOR GUI LOGOFF ;
 ;;1.5;BGU;;MAY 26, 2005
LOG(DUZ,BGUIP,BGUSKT,BGUETH,BGUAPP,BGUPRM) ;EP Called by BGUTCPH
 ;Creates da for statistic tracking entry at logoff
 N I,DA,DIK
 S I=$$HTFM^XLFDT($H)
 F I=I:.000001 L +^BGUSEC(I):1 Q:'$D(^BGUSEC(I))  L -^BGUSEC(I)
 S ^BGUSEC(I,0)=DUZ_"^"_$I_"^"_$J_"^^"_BGUIP_"^"_BGUAPP_"^"_BGUSKT_"^"_BGUETH_"^^"_BGUPRM
 L -^BGUSEC(I)
 S $P(^BGUSEC(0),"^",3,4)=I_"^"_(1+$P(^BGUSEC(0),"^",4))
 S DA=I,DIK="^BGUSEC(" D IX^DIK
 Q I