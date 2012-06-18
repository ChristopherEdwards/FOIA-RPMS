BSDX30 ; IHS/OIT/HMW/MSC/SAT - WINDOWS SCHEDULING RPCS ; [ 09/12/2007  1:54 PM ]
 ;;3.0;IHS WINDOWS SCHEDULING;;DEC 09, 2010
 ;
 ;
SPACED(BSDXY,BSDXDIC,BSDXVAL) ;EP
 ;Entry point for debugging
 ;
 D DEBUG^%Serenji("SPACE^BSDX30(.BSDXY,BSDXDIC,BSDXVAL)")
 Q
 ;
SPACE(BSDXY,BSDXDIC,BSDXVAL) ;EP
 ;Update ^DISV with most recent lookup value BSDXVAL from file BSDXDIC
 ;BSDXDIC is the data global in the form GLOBAL(
 ;BSDXVAL is the entry number (IEN) in the file
 ;
 ;Return Status = 1 if success, 0 if fail
 ;
 S BSDXY="^BSDXTMP("_$J_")"
 N BSDX1,BSDXRES
 S BSDXI=0
 S X="ETRAP^BSDX30",@^%ZOSF("TRAP")
 I (BSDXDIC="")!('+$G(BSDXVAL)) D ERR(BSDXI+1,99) Q
 S BSDXDIC="^"_BSDXDIC
 S ^BSDXTMP($J,0)="T00020ERRORID"_$C(30)
 I $D(@(BSDXDIC_"BSDXVAL,0)")),'$D(^(-9)) D     ;Note:  Naked reference is immediately preceded by the full global reference per SAC 2.2.2.8
 . S ^DISV(DUZ,BSDXDIC)=BSDXVAL
 . S BSDXRES=1
 E  S BSDXRES=0
 S BSDXI=BSDXI+1
 S ^BSDXTMP($J,BSDXI)=BSDXRES_$C(30)_$C(31)
 Q
 ;
ERR(BSDXI,BSDXERR) ;Error processing
 S BSDXI=BSDXI+1
 S ^BSDXTMP($J,BSDXI)=BSDXERR_$C(30)
 S BSDXI=BSDXI+1
 S ^BSDXTMP($J,BSDXI)=$C(31)
 Q
 ;
ETRAP ;EP Error trap entry
 I '$D(BSDXI) N BSDXI S BSDXI=999
 S BSDXI=BSDXI+1
 D ERR(99,0)
 Q
 ;
EHRPTD(BSDXY,BSDXWID,BSDXDFN) ;
 ;
 D DEBUG^%Serenji("EHRPT^BSDX30(.BSDXY,BSDXWID,BSDXDFN)")
 Q
 ;
EHRPT(BSDXY,BSDXWID,BSDXDFN) ;
 ;
 ;Return Status = 1 if success, 0 if error
 ;
 S BSDXY="^BSDXTMP("_$J_")"
 N BSDX1,BSDXRES
 S BSDXI=0,BSDXRES=1
 S X="ETRAP^BSDX30",@^%ZOSF("TRAP")
 S ^BSDXTMP($J,0)="T00020ERRORID"_$C(30)
 I '+BSDXDFN D ERR(BSDXI+1,0) Q
 ;
 D PEVENT(BSDXWID,BSDXDFN) ;Raise patient selected event
 ;
 S BSDXI=BSDXI+1
 S ^BSDXTMP($J,BSDXI)=BSDXRES_$C(30)_$C(31)
 Q
 ;
PEVENT(BSDXWID,DFN) ;EP - Raise patient selection event to EHR
 ;
 ;Change patient context to patient DFN
 ;on all EHR client sessions associated with user DUZ
 ;and workstation BSDXWID.
 ;
 ;If BSDXWID is "", the context change is sent to
 ;all EHR client sessions belonging to user DUZ.
 ;
 Q:'$G(DUZ)
 ;N X
 ;S X="CIANBUTL" X ^%ZOSF("TEST") Q:'$T
 ;S X="CIANBEVT" X ^%ZOSF("TEST") Q:'$T
 N UID,BRET
 S BRET=0,UID=0
 F  S BRET=$$NXTUID^CIANBUTL(.UID,1) Q:'UID  D
 . Q:DUZ'=$$GETVAR^CIANBUTL("DUZ",,,UID)
 . I BSDXWID'="" Q:BSDXWID'=$TR($$GETVAR^CIANBUTL("WID",,,UID),"abcdefghijklmnopqrstuvwxyz","ABCDEFGHIJKLMNOPQRSTUVWXYZ")
 . D QUEUE^CIANBEVT("CONTEXT.PATIENT",+DFN,UID)
 Q
