BLRCHGPW ; IHS/OIT/MKK - CHANGE PROVIDER AND/OR LOCATION UTILITY -- Part 2;  08/30/2005  8:05 AM ]
 ;;5.2;LR;**1020,1022**;September 20, 2007
 ;;
 ; Information as to where the provider or location are stored
PEP ; EP
 ; Provider information
 S PROVGET("ACCESSION","PROV")=6.5
 S PROVGET("ORDER ENTRY")=7
 S PROVGET("AU")="$P($G(^LR(LRDFN,LRSS)),""^"",7)"              ; Autopsy
 S PROVGET("AU",0)=13.5
 S PROVGET("BB")="$P($G(^LR(LRDFN,LRSS,LRIDT,0)),""^"",7)"      ; Blood Bank
 S PROVGET("BB",0)=.07
 S PROVGET("CH")="$P($G(^LR(LRDFN,LRSS,LRIDT,0)),""^"",10)"     ; Chemistry
 S PROVGET("CH",0)=.1
 S PROVGET("CY")="$P($G(^LR(LRDFN,LRSS,LRIDT,0)),""^"",7)"      ; Cytology
 S PROVGET("CY",0)=.07
 S PROVGET("MI")="$P($G(^LR(LRDFN,LRSS,LRIDT,0)),""^"",7)"      ; Microbiology
 S PROVGET("MI",0)=.07
 S PROVGET("SP")="$P($G(^LR(LRDFN,LRSS,LRIDT,0)),""^"",7)"      ; Surgical Pathology
 S PROVGET("SP",0)=.07
 ;
 ; Location information
 S LOCGET("ACCESSION","ORDL")=94                               ; Accession File
 S LOCGET("ACCESSION","RPTL")=6
 S LOCGET("ORDER ENTRY","ORDL")=23                             ; Order Entry File
 S LOCGET("ORDER ENTRY","RPTL")=8
 ;
 S LOCGET("AU")="$P($G(^LR(LRDFN,LRSS)),""^"",5)"              ; Autopsy
 S LOCGET("AU",0)=14.1
 S LOCGET("BB")="$P($G(^LR(LRDFN,LRSS,LRIDT,0)),""^"",8)"      ; Blood Bank
 S LOCGET("BB",0)=.08
 S LOCGET("CH")="$P($G(^LR(LRDFN,LRSS,LRIDT,0)),""^"",10)"     ; Chemistry
 S LOCGET("CH",0)=.111
 S LOCGET("CH",1)=.11
 S LOCGET("CY")="$P($G(^LR(LRDFN,LRSS,LRIDT,0)),""^"",8)"      ; Cytology
 S LOCGET("CY",0)=.08
 S LOCGET("MI")="$P($G(^LR(LRDFN,LRSS,LRIDT,0)),""^"",8)"      ; Microbiology
 S LOCGET("MI",0)=.08
 S LOCGET("SP")="$P($G(^LR(LRDFN,LRSS,LRIDT,0)),""^"",8)"      ; Surgical Pathology
 S LOCGET("SP",0)=.08
 ;
 Q
 ;
 ; Change Provider in IHS Lab Transaction Log
 ; Orignally this code was in the BLRCHGPL routine, but taken out and put
 ; here because the BLRCHGPL routine became too large.
SETPTXLG() ; EP
 NEW BLRSN,DICT0
 S ON=+$G(^LRO(68,LRAA,1,LRAD,1,LRAN,.1))   ; Order Number
 ;
 ; ----- BEGIN IHS/OIT/MKK -- MODIFICATION - 1022
 ;            Need to modify ALL the transactions, not
 ;            just the first one found.  This means a
 ;            total rewrite of the code.
 ; 
 ; S BLRSN=$O(^BLRTXLOG("C",ON,""))
 ; I BLRSN="" D  Q LREND
 ; . D BADJUJU("SETPTXLG",$G(^LRO(68,LRAA,1,LRAD,1,LRAN,.2)),ON)
 ;
 ; S DICT0="9009022"
 ;
 ; D ^XBFMK
 ; K ERRS,FDA,IENS,DIE
 ; S IENS=BLRSN_","
 ; S FDA(DICT0,IENS,1104)=NPN
 ; D FILE^DIE("K","FDA","ERRS")
 ; I $D(ERRS("DIERR"))<1 D
 ; . S LREND=0
 ; . S BLRLOGDA=BLRSN          ; IHS Lab Transaction Sequence Number
 ;
 ; I $D(ERRS("DIERR"))>0 D
 ; . W !!
 ; . W "BLRSN:",BLRSN,!
 ; . W " IENS:",IENS,!
 ; . W "  NPN:",NPN,!
 ; . W "   ON:",ON,!
 ; . D BADSTUFF("SETPTXLG")
 ;
 ; ----- IHS/OIT/MKK -- REWRITE begins here
 NEW CNT,QFLG
 ;
 S DICT0="9009022"
 S BLRSN="",CNT=0
 F  S BLRSN=$O(^BLRTXLOG("C",ON,BLRSN))  Q:BLRSN=""!(LREND=1)  D
 . D ^XBFMK
 . K ERRS,FDA,IENS,DIE
 . S IENS=BLRSN_","
 . S FDA(DICT0,IENS,1104)=NPN
 . D FILE^DIE("K","FDA","ERRS")
 . ;
 . I $D(ERRS("DIERR"))<1 D
 .. S LREND=0
 .. S BLRLOGDA(BLRSN)=""          ; IHS Lab Transaction Log Sequence Number
 .. S CNT=CNT+1
 . ;
 . I $D(ERRS("DIERR"))>0 D
 .. W !!
 .. W "BLRSN:",BLRSN,!
 .. W " IENS:",IENS,!
 .. W "  NPN:",NPN,!
 .. W "   ON:",ON,!
 .. D BADSTUFF^BLRCHGER("SETPTXLG")
 ; 
 I CNT<1 D  Q LREND
 . D BADJUJU^BLRCHGER("SETPTXLG",$G(^LRO(68,LRAA,1,LRAD,1,LRAN,.2)),ON)
 ; ----- END IHS/OIT/MKK -- MODIFICATION - 1022
 ;
 Q LREND
 ;
 ;
 ; ----- BEGIN IHS/OIT/MKK -- MODIFICATION - 1022
 ; Moved the following routine from BLRCHGPL because the BLRCHGPL routine
 ; was becoming too large.
 ; 
 ; Delete "Old" Provider from E-SIG entry and add "New" Provider
 ; in E-SIG.  If possible.
ESIGCHNG ; EP
 ; If no E-SIG data for the accession, quit
 I $G(^LR(LRDFN,LRSS,LRIDT,ESIGNODE))="" Q
 ;
 ; If not CH nor MI, quit -- BB doesn't have E-SIG
 I $G(LRSS)="BB" Q
 ;
 NEW OESIG,NESIG,MID,IMNOTE,SUBFILE
 S SUBFILE=$S(LRSS="CH":63.04,LRSS="MI":63.05)
 ;
 ; Setup NOTE string -- may be needed
 S MID=(IOM\2)-10
 S IMNOTE=$TR($J("",IOM)," ","*")
 S $E(IMNOTE,MID,MID+15)=" IMPORTANT NOTE "
 ;
 ; If Review Status is NOT 0, give message & quit
 I $P($G(^LR(LRDFN,LRSS,LRIDT,ESIGNODE)),"^",1)>0  D  Q
 . W !!,IMNOTE,!!
 . W $$CJ^XLFSTR("Accession's E-SIG Status is not Zero.",IOM),!
 . W $$CJ^XLFSTR("No Change to E-SIG file.",IOM),!!
 . W IMNOTE,!!
 . D BLRGPGR^BLRGMENU()
 ; 
 S NESIG=$P($G(^VA(200,NPN,20)),"^",4)      ; "New" Provider E-SIG value
 ;
 I $G(NESIG)="" D  Q
 . W !!,IMNOTE,!!
 . W $$CJ^XLFSTR("'New' Provider "_$E($P($G(^VA(200,NPN,0)),"^",1),1,18),IOM)
 . W $$CJ^XLFSTR("IS NOT an E-SIG participant",IOM),!
 . W $$CJ^XLFSTR("No Change to E-SIG file.",IOM),!!
 . W IMNOTE,!!
 . D BLRGPGR^BLRGMENU()
 ;
 S OESIG=$P($G(^VA(200,OPN,20)),"^",4)      ; "Old" Provider E-SIG value
 ;
 I $G(OESIG)="" D  Q
 . W !!,IMNOTE,!!
 . W $$CJ^XLFSTR("'Original' Provider "_$E($P($G(^VA(200,OPN,0)),"^",1),1,18),IOM)
 . W $$CJ^XLFSTR("IS NOT an E-SIG participant",IOM),!
 . W $$CJ^XLFSTR("No Change to E-SIG file.",IOM),!!
 . W IMNOTE,!!
 . D BLRGPGR^BLRGMENU()
 ;
 ; Both are E-SIG participants.  Valid to change.
 ; 
 ; Change Responsible Physician
 D ^XBFMK
 K DIE,ERRS,FDA,IENS
 S IENS=LRIDT_","_LRDFN_","
 S FDA(SUBFILE,IENS,.9009026)=NPN
 D FILE^DIE("K","FDA","ERRS")
 I $D(ERRS("DIERR"))>0 D BADSTUFF^BLRCHGER("ESIGCHNG - Responsible Phy")  Q LREND
 ;
 ; Change Review Status
 D ^XBFMK
 K DIE,ERRS,FDA,IENS
 S IENS=LRIDT_","_LRDFN_","
 S FDA(SUBFILE,IENS,.9009025)=0
 D FILE^DIE("K","FDA","ERRS")
 ;
 I $D(ERRS("DIERR"))>0 D BADSTUFF^BLRCHGER("ESIGCHNG - Review Status")  Q LREND
 ;
 ; Make sure INDEX is also reset
 NEW ILRIDT
 S ILRIDT=-LRIDT
 M ^LR("BLRA",NPN,0,ILRIDT)=^LR("BLRA",OPN,0,ILRIDT)
 K ^LR("BLRA",OPN,0,ILRIDT)
 ;
 Q
 ; ----- END IHS/OIT/MKK -- MODIFICATION - 1022
