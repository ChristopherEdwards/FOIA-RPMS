KMPRENV ;SF/RAK - RUM Environment Check ;16 Oct 98
 ;;1.0;CAPACITY MANAGEMENT - RUM;;Dec 09, 1998
 ;
EN ;-- entry point.
 ; quit if not KIDS install.
 Q:$G(XPDENV)'=1
 ; set default answer to 'no' for disabling options/protocols etc.
 S:+$G(XPDENV) XPDDIQ("XPZ1","B")="NO"
 N IEN
 S IEN=$O(^XPD(9.7,"B","XU*8.0*107",0))
 ; if kernel patch XU*8.0*107 does not exist then do not install.
 I 'IEN S XPDQUIT=2
 ; if kernel patch XU*8.0*107 has not been installed.
 I $P($G(^XPD(9.7,+IEN,0)),U,9)'=3 S XPDQUIT=2
 I $G(XPDQUIT)=2 D 
 .D MES^XPDUTL("Kernel patch XU*8.0*107 must be installed before proceeding!")
 Q
