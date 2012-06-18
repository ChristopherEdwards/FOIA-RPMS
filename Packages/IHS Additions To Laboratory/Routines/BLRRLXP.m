BLRRLXP ; cmi/anch/maw - BLR Reference Lab Batch Export ;
 ;;5.2;LR;**1021**;Jul 27, 2006
 ;;1.0;BLR REFERENCE LAB;;MAR 14, 2005
 ;
 ;
 ;this routine will call the lookup the lab destination and write
 ;out the file nightly
 ;
MAIN ;PEP - Main routine driver
 I '$D(ZTQUEUED) D PCHK(DUZ(2))
 Q:$G(BLRQFLG)
 D HFS(DUZ(2))
 Q
 ;
HFS(BLRSDA) ;-- get the destination and call HFS filer
 W:'$D(ZTQUEUED) !,"Now exporting reference lab orders.."
 ;S BLRSDA=0 F  S BLRSDA=$O(^BLRSITE("B",BLRSDA)) Q:'BLRSDA  D
 S BLRRL=+$P($G(^BLRSITE(BLRSDA,"RL")),U)
 Q:BLRRL=""
 S BLRRLNM=$P($G(^BLRRL(BLRRL,0)),U)
 S BLRRLDS=$O(^INRHD("B","HL IHS LAB "_BLRRLNM,0))
 Q:BLRRLDS=""
 S BLRTID=$P($G(^BLRRL(BLRRL,0)),U,6)
 Q:BLRTID=""
 S BLRTFNM=BLRTID_"_"_$E($$DATE^INHUT($$NOW,1),1,14)_".ord"
 S BLRDIR=$P($G(^BLRRL(BLRRL,0)),U,2)
 Q:BLRDIR=""
 I '$D(ZTQUEUED) D
 . W !,"Writing file "_BLRTFNM_" to directory "_BLRDIR
 D HFSRL^BHLU(BLRRLDS,BLRDIR,BLRTFNM)
 S BLRLMSG=$$LOG^BLRRLU(BLRTFNM,"O",DUZ)
 I $G(BLRLMSG),$O(BHLUI(0)) S BLRLLMSG=$$LOGM^BLRRLU(BLRTFNM,.BHLUI)
 I $P($G(^BLRRL(BLRRL,0)),U,3)'="" D
 . D FTP(BLRRL,BLRTID,BLRDIR)
 Q
 ;
FTP(RL,BLRFNM,BLRSDIR) ;-- send the file across to the sending machine
 S BLRIP=$P($G(^BLRRL(RL,0)),U,3)
 S BLRUSER=$P($G(^BLRRL(RL,0)),U,4)
 S BLRPASS=$P($G(^BLRRL(RL,0)),U,5)
 I BLRUSER="" S BLRUPAS=""
 I '$G(BLRUPAS) S BLRUPAS=BLRUSER_":"_BLRPASS
 I '$D(ZTQUEUED) D
 . W !,"Sending reference lab orders to IP "_BLRIP
 D SENDFILE^BHLU(BLRFNM,BLRSDIR,BLRIP,BLRPASS)
 Q
 ;
NOW() ;-- get now
 D NOW^%DTC
 Q %
 ;
PCHK(BLRSDA) ;EP - check to make sure parameters are set
 I '$P($G(^BLRSITE(BLRSDA,"RL")),U) D  Q
 . S BLRQFLG=1
 . W !,"Reference Lab not defined in BLR MASTER CONTROL file"
 S BLRRL=$P($G(^BLRSITE(BLRSDA,"RL")),U)
 I $P($G(^BLRRL(BLRRL,0)),U,6)="" D
 . S BLRQFLG=1
 . W !,"Reference Lab file name prefix not defined"
 I $P($G(^BLRRL(BLRRL,0)),U,2)="" D
 . S BLRQFLG=1
 . W !,"Reference Lab directory not defined"
 I $P($G(^BLRRL(BLRRL,0)),U,3)="" D
 . W !,"IP address not defined, file will be written to local host"
 Q
 ;
