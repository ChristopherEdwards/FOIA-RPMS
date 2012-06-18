BLRCHGPL ; IHS/OIT/MKK - CHANGE PROVIDER AND/OR LOCATION UTILITY ;  07/22/2005  8:05 AM ]
 ;;5.2;LR;**1020,1021,1022**;September 20, 2007
 ;;
 ; Some code cloned from SINGLE^LRWRKLST and then modified
MAIN ; EP
 ; Temp vars -- discard after routine completes
 NEW LRDFN,LRSS,LRAA,LRAD,LRAN,LRIDT,LRAAS
 NEW LRODT,LRSN,BLRLOGDA
 NEW LRACC,LREND,LRSTOP,LRTSE,LRUNC,LRURG
 NEW PROVSTR,LOCSTR,CCN,EDD
 NEW PROVGET,LOCGET
 NEW NPN,OPN,FDA,STR,ERRS
 NEW OLN,ON,NLN,NLNMN
 NEW ESIGNODE
 ;
 S ESIGNODE=9009027          ; Node in the ^LR global where E-Sig data resides
 ;
 ; Setup array so that info can be gotten quickly
 D PEP^BLRCHGPW
 ;
 ; Setup standard parameters
 D URG^LRX
 ;
 ; Loop unil done
 F  D  Q:LREND!LRSTOP
 . W !!
 . S (LREND,LRUNC,LRSTOP,LRTSE,CCN)=0
 . S LRACC=""
 . D ^LRWU4                  ; Get Lab Data from Accession number
 . I LRAN<1 S LREND=1 Q      ; If nothing, then set END flag & Quit
 . ;
 . I '$D(^LRO(68,LRAA,1,LRAD,1,LRAN,0)) D  Q     ; Make sure Accession exists
 .. W !,"Doesn't exist."
 .. D BLRGPGR^BLRGMENU()     ; Press "Return" routine
 . ;
 . ; ----- BEGIN IHS/OIT/MKK MODIFICATION - Patch 1022
 . ; If order came from OERR, don't allow change
 . NEW LRSP
 . S LRSN=+$G(^LRO(68,LRAA,1,LRAD,1,LRAN,.1))              ; Order Number
 . S LRODT=+$P($G(^LRO(68,LRAA,1,LRAD,1,LRAN,0)),"^",4)    ; Order Date
 . S LRSP=+$O(^LRO(69,"C",LRSN,LRODT,""))
 . I +$P($G(^LRO(69,LRODT,1,LRSP,0)),"^",11)>0 D  Q
 .. W !,"Accession is tied to an OERR order.  This order cannot be modified.",!
 .. D BLRGPGR^BLRGMENU()     ; Press "Return" routine
 . ; ----- END IHS/OIT/MKK -- MODIFICATION 1022
 . ; 
 . ; Initialization
 . K BLRLOGDA
 . S LRDFN=$P($G(^LRO(68,LRAA,1,LRAD,1,LRAN,0)),"^",1)
 . S LRSS=$P($G(^LRO(68,LRAA,0)),"^",2)
 . ;
 . D CHNGPROV                ; Change Provider?
 . I LREND Q                 ; Quit if END flag set
 . D CHNGLOC                 ; Change Location?
 . ;
 . ; If all OK, then send changes to PCC via BLR Linker
 . ; I 'LREND&($D(BLRLOGDA)) D TOP^BLRQUE(BLRLOGDA,0)
 . ; ----- BEGIN IHS/OIT/MKK -- MODIFICATION 1022
 . ; All the BLRTXLOG transaction numbers are in the BLRLOGDA array --
 . ; have to send over notice about all of them.
 . I 'LREND&($D(BLRLOGDA)) D
 .. S BLRLOGDA=""
 .. F  S BLRLOGDA=$O(BLRLOGDA(BLRLOGDA))  Q:BLRLOGDA=""  D
 ... D TOP^BLRQUE(BLRLOGDA,0)
 . ; ----- END IHS/OIT/MKK -- MODIFICATION 1022
 ;
 Q
 ;
 ; Change Provider? -- Get provider cloned and modified from P^LRWU1
CHNGPROV ;
 S LRIDT=$P($G(^LRO(68,LRAA,1,LRAD,1,LRAN,3)),"^",5)
 S OPN=$$GETPHY              ; Provider in Lab Data File -- default
 ;
 ; If Provider not in Lab Data File, get from Order Entry File
 I OPN="" D
 . S ON=+$G(^LRO(68,LRAA,1,LRAD,1,LRAN,.1))             ; Order Number
 . S LRODT=$P($G(^LRO(68,LRAA,1,LRAD,1,LRAN,0)),"^",4)  ; Order Date
 . S LRSN=$O(^LRO(69,"C",ON,LRODT,""))                  ; Order Sequence Number
 . S OPN=$P($G(^LRO(69,LRODT,1,LRSN,0)),"^",6)          ; Prov from Order Entry
 ;
 D ^XBFMK                    ; Clear Fileman Variables
 S DIC("B")=OPN              ; Default is current Provider
 S DIC="^VA(200,"
 S DIC(0)="AMNEQ"
 S DIC("S")="I $D(^VA(200,""AK.PROVIDER"",$P(^(0),U))),$$ACTIVE^BLRUTIL2(Y)"
 S DIC("A")="PROVIDER: "
 S D="AK.PROVIDER"
 S DIC("W")="Q"
 D ^DIC  K DIC
 I Y<0 Q                     ; If Quit or nothing, exit
 ;
 S NPN=+Y
 I OPN=NPN Q                 ; If "Old" = "New" don't bother, just quit
 ;
 ; Change the provider in 4 Different files -- quit if LREND=1 (END Flag)
 Q:$$SETPLAB                 ; (1) Lab Data File
 Q:$$SETPACC                 ; (2) Accession File
 Q:$$SETPORD                 ; (3) Order File
 ; Q:$$SETPTXLG                ; (4) IHS Lab Transaction Log (BLRTXLOG)
 ; ----- BEGIN IHS/OIT/MKK -- MODIFICATION 1022
 ; Took out code from BLRCHGPL and put into BLRCHGPW because
 ; BLRCHGPL got too large
 Q:$$SETPTXLG^BLRCHGPW       ; (4) IHS Lab Transaction Log (BLRTXLOG)
 ; ----- END IHS/OIT/MKK -- MODIFICATION 1022
 ;
 W !?5,"Provider Change filed",!
 ;
 ; Create Audit entry
 D SETINDX("PHY",LRAA,LRAD,LRAN,OPN,NPN)
 Q
 ;
GETPHY() ;
 Q @$G(PROVGET(LRSS))     ; Return Provider location in file
 ;
 ; Change Provider in Lab Data file.
SETPLAB() ;
 NEW SUBFILE
 D ^XBFMK
 K DIE,ERRS,FDA,IENS
 S IENS=LRIDT_","_LRDFN_","
 S SUBFILE=$S(LRSS="CH":63.04,LRSS="MI":63.05,LRSS="BB":63.01)
 S FDA(SUBFILE,IENS,$G(PROVGET(LRSS,0)))=NPN
 D FILE^DIE("K","FDA","ERRS")
 ;
 I $D(ERRS("DIERR"))>0 D BADSTUFF^BLRCHGER("SETPLAB")  Q LREND
 I $D(ERRS("DIERR"))<1 S LREND=0
 ;
 ; D ESIGCHNG        ; E-SIG Changes
 ; ----- BEGIN IHS/OIT/MKK -- MODIFICATION - 1022
 ;  Moved the ESIGCHNG routine from BLRCHGPL to BLRCHGPW because
 ;  BLRCHGPL was getting too large
 D ESIGCHNG^BLRCHGPW
 ; ----- END IHS/OIT/MKK -- MODIFICATION - 1022
 ;
 Q LREND
 ;
 ; Change Provider in Accession file.
SETPACC() ;
 D ^XBFMK
 K DIE,FDA,ERRS,IENS
 S IENS=LRAN_","_LRAD_","_LRAA_","
 S FDA(68.02,IENS,$G(PROVGET("ACCESSION","PROV")))=NPN
 D FILE^DIE("K","FDA","ERRS")
 ;
 I $D(ERRS("DIERR"))>0 D BADSTUFF^BLRCHGER("SETPACC")  Q LREND
 I $D(ERRS("DIERR"))<1 S LREND=0
 ;
 Q LREND
 ;
 ; Change Provider in Order Entry File
SETPORD() ;
 ; Order file
 NEW DONE
 ;
 S ON=+$G(^LRO(68,LRAA,1,LRAD,1,LRAN,.1))             ; Order Number
 S LRODT=$P($G(^LRO(68,LRAA,1,LRAD,1,LRAN,0)),"^",4)  ; Order Date
 ;
 S (DONE,LRSN)=""
 F  S LRSN=$O(^LRO(69,"C",ON,LRODT,LRSN))  Q:LRSN=""!(DONE="D")  D
 . S LRDFN=$P($G(^LRO(69,LRODT,1,LRSN,0)),"^",1)
 . S LRTEST=0
 . F  S LRTEST=$O(^LRO(69,LRODT,1,LRSN,2,LRTEST))  Q:LRTEST=""!(LRTEST'?.N)!(DONE="D")  D
 .. S TSTSTR=(^LRO(69,LRODT,1,LRSN,2,LRTEST,0))
 .. I $P(TSTSTR,"^",3)'=LRODT Q   ; If Date doesn't match, skip
 .. I $P(TSTSTR,"^",4)'=LRAA Q    ; If Accession Area doesn't match, skip
 .. I $P(TSTSTR,"^",5)'=LRAN Q    ; If Accession Number doesn't match, skip
 .. ;
 .. ; Accession Matches -- Change Provider
 .. S DONE="D"                    ; No matter what, quit after this
 .. D ^XBFMK
 .. K DIE,FDA,ERRS,IENS
 .. S IENS=LRSN_","_LRODT_","
 .. S FDA(69.01,IENS,$G(PROVGET("ORDER ENTRY")))=NPN
 .. D FILE^DIE("K","FDA","ERRS")
 .. ;
 .. I $D(ERRS("DIERR"))>0 D BADSTUFF^BLRCHGER("SETPORD")
 .. I $D(ERRS("DIERR"))<1 S LREND=0
 .. ;
 .. ; Check to see if Provider REALLY changed
 .. I $P($G(^LRO(69,LRODT,1,LRSN,0)),"^",6)'=NPN D  Q
 ... W !!!,?5,$TR($J("",45)," ","*"),!!
 ... W ?5,$$CJ^XLFSTR("PROVIDER NOT CHANGED IN ORDER FILE",45),!!
 ... W ?5,"Old Provider IEN:",OPN
 ... W ?35,"New Prov IEN:",NPN
 ... W ?5,$TR($J("",45)," ","*"),!!
 ... S LREND=1
 .. ;
 .. ; Now, have to change X-Ref since FileMan isn't
 .. NEW PTPTR,PATNAME
 .. S PTPTR=$P($G(^LR(LRDFN,0)),"^",3)
 .. I $G(PTPTR)="" Q
 .. ;
 .. S PATNAME=$P($G(^DPT(PTPTR,0)),"^",1)   ; Patient Name
 .. I $G(PATNAME)="" Q
 .. ;
 .. NEW OPNAME          ; "Old" Provider Name"
 .. S OPNAME=$P($G(^VA(200,OPN,0)),"^",1)
 .. I $D(^LRO(69,LRODT,1,"AP",OPNAME))<1 Q
 .. ;
 .. NEW IEN,OKNOW,TODT,TON
 .. S (IEN,OKNOW)=""
 .. I $D(^LRO(69,LRODT,1,"AP",OPNAME,PATNAME,ON))<1 Q
 .. ;
 .. NEW NPNAME
 .. S NPNAME=$P($G(^VA(200,NPN,0)),"^",1)
 .. S STR="^LRO(69,"_LRODT_",1,AP,"_OPNAME_","_PATNAME_","_ON_")"
 .. K @STR
 .. S ^LRO(69,LRODT,1,"AP",NPNAME,PATNAME,ON)=""
 ;
 Q LREND
 ;
 ; Populate new global
SETINDX(WOT,LRAA,LRAD,LRAN,OLD,NEW)     ;
 NEW SUBNODE,DICT0,DICT1
 NEW ACCNDX,ACCSTR,ACCNXT
 ;
 S DICT0="90475.2"
 ;
 I WOT["PHY" S SUBNODE=1
 I WOT["LOC" S SUBNODE=2
 S DICT1="90475.2"_SUBNODE
 ;
 S ACCSTR=$G(^LRO(68,LRAA,1,LRAD,1,LRAN,.2))
 ;
 D ^XBFMK
 K ERRS,FDA,IENS,DIE
 S FDA(DICT0,"?+1,",.01)=ACCSTR   ; Find the Accession node, or create it.
 S FDA(DICT1,"+2,?+1,",.01)=OLD
 S FDA(DICT1,"+2,?+1,",1)=NEW
 S FDA(DICT1,"+2,?+1,",2)=$E($$NOW^XLFDT(),1,12)
 S FDA(DICT1,"+2,?+1,",3)=$G(DUZ)
 D UPDATE^DIE(,"FDA",,"ERRS")
 I $D(ERRS("DIERR"))>0 D  Q
 . D BADSTUFF^BLRCHGER("SETINDX")
 ;
 Q
 ;
 ; Change Location? -- Get location cloned and modified from ASK^LRWU
CHNGLOC ;
 S OLN=$P($G(^LRO(68,LRAA,1,LRAD,1,LRAN,0)),"^",13)
 ;
 D ^XBFMK
 S DIC("B")=OLN
 S DIC("A")="PATIENT LOCATION:"
 ; S DIC=44
 S DIC="^SC("
 S DIC(0)="AMNEQ"
 D ^DIC  K DIC
 I +Y<0 Q
 ;
 S NLN=+Y
 I OLN=NLN Q                 ; If "Old" = "New" don't bother, just quit
 ;
 S NLNMN=$P($G(^SC(NLN,0)),"^",2)      ; "New" Hospital Location Mnemonic
 ;
 ; Change the location in 4 Different files -- quit if LREND=1 (END Flag)
 Q:$$SETLLAB                 ; (1) Lab Data File
 Q:$$SETLACC                 ; (2) Accession File
 Q:$$SETLORD                 ; (3) Order File
 Q:$$SETLTXLG                ; (4) IHS Lab Transaction Log (BLRTXLOG)
 ;
 W !?5,"Location Change filed",!
 ;
 ; Create Audit entry
 D SETINDX("LOC",LRAA,LRAD,LRAN,OLN,NLN)
 ;
 Q
 ;
 ;  Lab Data file.
SETLLAB() ;
 NEW SUBFILE
 S SUBFILE=$S(LRSS="CH":63.04,LRSS="MI":63.05,LRSS="BB":63.01)
 D ^XBFMK
 K ERRS,FDA,IENS
 S IENS=LRIDT_","_LRDFN_","
 I $G(LOCGET(LRSS,0))'=""  D
 . S FDA(SUBFILE,IENS,$G(LOCGET(LRSS,0)))=NLN_";SC("
 I $G(LOCGET(LRSS,1))'=""  D
 . S FDA(SUBFILE,IENS,$G(LOCGET(LRSS,1)))=NLNMN
 D FILE^DIE("K","FDA","ERRS")
 ;
 I $D(ERRS("DIERR"))>0 D BADSTUFF^BLRCHGER("SETLLAB")
 I $D(ERRS("DIERR"))<1 S LREND=0
 ;
 ;
 Q LREND
 ;
 ; Accession file.
SETLACC() ;
 D ^XBFMK
 K DIE,ERRS,FDA,IENS
 S IENS=LRAN_","_LRAD_","_LRAA_","
 S FDA(68.02,IENS,$G(LOCGET("ACCESSION","ORDL")))=NLN
 S FDA(68.02,IENS,$G(LOCGET("ACCESSION","RPTL")))=NLNMN
 D FILE^DIE("K","FDA","ERRS")
 ;
 I $D(ERRS("DIERR"))>0 D BADSTUFF^BLRCHGER("SETLACC")
 I $D(ERRS("DIERR"))<1 S LREND=0
 ;
 Q LREND
 ;
 ; Order file
SETLORD() ;
 NEW DONE
 ;
 S ON=+$G(^LRO(68,LRAA,1,LRAD,1,LRAN,.1))             ; Order Number
 S LRODT=$P($G(^LRO(68,LRAA,1,LRAD,1,LRAN,0)),"^",4)  ; Order Date
 ;
 S (DONE,LRSN)=""
 F  S LRSN=$O(^LRO(69,"C",ON,LRODT,LRSN))  Q:LRSN=""!(DONE="D")  D
 . S LRTEST=0
 . F  S LRTEST=$O(^LRO(69,LRODT,1,LRSN,2,LRTEST))  Q:LRTEST=""!(LRTEST'?.N)!(DONE="D")  D
 .. S TSTSTR=(^LRO(69,LRODT,1,LRSN,2,LRTEST,0))
 .. I $P(TSTSTR,"^",3)'=LRODT Q   ; If Date doesn't match, skip
 .. I $P(TSTSTR,"^",4)'=LRAA Q    ; If Accession Area doesn't match, skip
 .. I $P(TSTSTR,"^",5)'=LRAN Q    ; If Accession Number doesn't match, skip
 .. ;
 .. ; Accession Matches -- Change Location
 .. ;
 .. S DONE="D"                    ; No matter what, quit after this
 .. D ^XBFMK
 .. K ERRS,FDA,IENS,DIE
 .. S IENS=LRSN_","_LRODT_","
 .. S FDA(69.01,IENS,$G(LOCGET("ORDER ENTRY","ORDL")))=NLN
 .. S FDA(69.01,IENS,$G(LOCGET("ORDER ENTRY","RPTL")))=NLNMN
 .. D FILE^DIE("K","FDA","ERRS")
 .. ;
 .. I $D(ERRS("DIERR"))>0 D BADSTUFF^BLRCHGER("SETLORD - 1")
 .. ;
 .. I $D(ERRS("DIERR"))<1 S LREND=0
 ;
 Q LREND
 ;
 ; IHS Lab Transaction Log
SETLTXLG() ;
 NEW BLRSN
 S ON=+$G(^LRO(68,LRAA,1,LRAD,1,LRAN,.1))   ; Order Number
 S BLRSN=$O(^BLRTXLOG("C",ON,""))
 I BLRSN="" D  Q LREND
 . D BADJUJU^BLRCHGER("SETLTXLG",$G(^LRO(68,LRAA,1,LRAD,1,LRAN,.2)),ON)
 ;
 S DICT0="9009022"
 ;
 D ^XBFMK
 K ERRS,FDA,IENS,DIE
 S IENS=BLRSN_","
 S FDA(DICT0,IENS,1106)=NLN
 D FILE^DIE("K","FDA","ERRS")
 ;
 I $D(ERRS("DIERR"))>0 D
 . W !!
 . W "BLRSN:",BLRSN,!
 . W " IENS:",IENS,!
 . W "  NPN:",NPN,!
 . W "   ON:",ON,!
 . D BADSTUFF^BLRCHGER("SETLTXLG")
 ;
 I $D(ERRS("DIERR"))<1 D
 . S LREND=0
 . S BLRLOGDA=BLRSN
 ;
 Q LREND
 ;
PROVREPT ; EP - Provider Report
 D ^XBFMK
 S L="",DIC=90475.2,FLDS="[LAB PROV CHNG]",BY="[LAB PROV CHNG ACC SRT]",FR=""
 S DHD="PROVIDER CHANGED AFTER ORDER FINALIZED"
 D EN1^DIP
 D BLRGPGR^BLRGMENU()        ; Press Return
 Q
 ;
LOCREPT ; EP - Location Report
 D ^XBFMK
 S L="",DIC=90475.2,FLDS="[LAB LOC CHNG]",BY="[LAB LOC CHNG ACC SRT]",FR=""
 S DHD="LOCATION CHANGED AFTER ORDER FINALIZED"
 D EN1^DIP
 D BLRGPGR^BLRGMENU()
 Q
 ;
BOTHREPT ; EP - Provider and/or Location Report (Combined)
 D ^XBFMK
 S L="",DIC=90475.2,FLDS="[LAB PROV LOC BOTH]",BY="ACCESSION",FR=""
 S DHD="PROVIDER AND/OR LOCATION CHANGED AFTER ORDER FINALIZED"
 D EN1^DIP
 D BLRGPGR^BLRGMENU()
 Q
