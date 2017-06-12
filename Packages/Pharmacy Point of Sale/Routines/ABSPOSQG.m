ABSPOSQG ; IHS/FCS/DRS - form transmission packets ; 
 ;;1.0;PHARMACY POINT OF SALE;**37,42**;JUN 21, 2001;Build 15
 Q
 ; PACKET(), split off from ABSPOSQ2
 ;
PACKET() ;EP - ABSPOSQ2
 ; packetize one prescription (and possibly more prescriptions
 ; for the same patient, if they're ready now.)
 ; Called from ABSPOSQ2,
 ;  which gave us RXILIST(IEN59) array of claims to packetize.
 ;
 N X S X="PACKERR^"_$T(+0),@^%ZOSF("TRAP")
 N CLAIMIEN,DIALOUT,ERROR
 S DIALOUT=$$DIALOUT
 I DIALOUT="" D RELSLOT^ABSPOSL Q 1  ;IHS/IOT/SCR 012210 pre-patch 37 for Santa Rosa
 ;
 ; If it's a reversal, we already have an ^ABSPC(  It was
 ; created by the call to ABSPECA8, way back at the beginning.
 ; So, unlike claims, we need only the NCPDP formatting for it.
 N FIRST59 S FIRST59=$O(RXILIST(0))
 I $G(^ABSPT(FIRST59,4)) D  G POINTM
 . ; Mimic a few things that are set up in the code we're skipping
 . S CLAIMIEN=$P(^ABSPT(FIRST59,4),U)
 . S CLAIMIEN(CLAIMIEN)=""
 ; - - - - -  But if it's not a reversal, do all this stuff:  - - - - -
 I $O(RXILIST($O(RXILIST("")))) D
 . D LOG2LIST^ABSPOSQ("Packetizing - we have more than one claim:")
 . N I,X,Y S (X,Y)=""
 . F I=1:1 S X=$O(RXILIST(X)) Q:'X  D
 . . S $P(Y,", ",I-1#4+1)=X
 . . I I#4=0 D LOG2LIST^ABSPOSQ(Y) S Y=""
 . I Y]"" D LOG2LIST^ABSPOSQ(Y)
 ; - - - - -  
 ; Retrieve some important variables from the POS WORKING file
 ; The ones we retrieve are the same for all prescriptions in RXILIST(*)
 N PATDFN S PATDFN=$P(^ABSPT(FIRST59,0),U,6)
 N ABSBVISI S ABSBVISI=$P(^ABSPT(FIRST59,0),U,7)
 ;
 ;  ABSPOSCA calls ABSPOSCB,ABSPOSCC,ABSPOSCD to set up ABSP(*)
 ;           then  ABSPOSCE to create claims in 9002313.02
 ;
LOCK L +^ABSPC:300 ; may be multiple copies of this running!!!
 I '$T D  G LOCK:$$IMPOSS^ABSPOSUE("L","RIT","LOCK ^ABSPC claims file",,,$T(+0))
 . D LOG2LIST^ABSPOSQ($T(+0)_" - unable to lock file 9002313.02 - should never happen!")
 ; input RXILIST(*)
 D EN^ABSPOSCA(DIALOUT) ;
 ; output ERROR, CLAIMIEN, CLAIMIEN(*)
 I ERROR D LOG2LIST^ABSPOSQ($T(+0)_" - ERROR="_ERROR_" returned from ABSPOSCA")
 ; ABSPOSCA set up ERROR,CLAIMIEN,CLAIMIEN(*)
 L -^ABSPC
 I $G(CLAIMIEN)<1 Q $S(ERROR:ERROR,1:300)
 ;
 ; CLAIMIEN=last claim created
 ; CLAIMIEN(CLAIMIEN)=the list of all claims created
 ;
 ; Then, ABSPOSQH calls ABSPECA1 to build NCPDP claim format records
 ;
POINTM ; Reversals are joining again here
 D KSCRATCH^ABSPOSQ2 ; erase ^ABSPECX($J)
 D PASCII^ABSPOSQH(DIALOUT) ; gives you ^ABSPECX($J,"C",CLAIMIEN,...
 ;
 ;  Drop the NCPDP-formatted records into the list used by
 ;  the sender-receiver.  Too coarse to lock the whole list - 
 ;  you'll be blocked by a sender-receiver who has one claim locked.
 ; (Even though we fixed that recently so that a sender locks the
 ;  claim for only the minimal amount of time.)
 ;
 ;  Drop each claim in there individually.
 ;  And as soon as the very first one hits, rev up a sender-receiver.
 ; 
 N FIRST S FIRST=1
 N X S X="" F  S X=$O(^ABSPECX($J,"C",X)) Q:X=""  D
 . F  L +^ABSPECX("POS",DIALOUT,"C",X):60 Q:$T  Q:'$$IMPOSS^ABSPOSUE("L","RIT","LOCK claims list for DIALOUT="_DIALOUT,,"POINTM",$T(+0))
 . M ^ABSPECX("POS",DIALOUT,"C",X)=^ABSPECX($J,"C",X)
 . L -^ABSPECX("POS",DIALOUT,"C",X)
 . N MSG S MSG="Claim ID "_$P(^ABSPC(X,0),U)
 . S MSG=MSG_" queued for "_$P(^ABSP(9002313.55,DIALOUT,0),U)
 . D LOG2CLM^ABSPOSQ(MSG,X)
 . I FIRST D TASK^ABSPOSQ2 S FIRST=0
 D RELSLOT^ABSPOSL
 Q 0
DIALOUT()          ; RXILIST(*) should be sent to NDC? or what other processor?
 ; Return a pointer to File 9002313.55, the DIAL OUT file.
 N IEN59 S IEN59=$O(RXILIST(0))
 I IEN59="" Q ""   ;IHS/OIT/SCR 012210  patch 37 for if there is no IEN59 return an error Santa Rosa
 N X S X=$P(^ABSPT(IEN59,1),U,6) ; INSURER
 ;IHS/OIT/CASSEVER/RAN patch 42 03/31/2011 Get rid of undefined errors.
 Q:'$D(^ABSPEI(X)) ""
 S X=$P(^ABSPEI(X,100),U,7) ; which DIAL OUT it points to
 ; get the default dial-out, otherwise
 I 'X S X=$P($G(^ABSP(9002313.99,1,"DIAL-OUT DEFAULT")),U)
 I 'X S X=$O(^ABSP(9002313.55,"B","DEFAULT",0))
 I 'X S X=$O(^ABSP(9002313.55,0)) ; they deleted the DEFAULT one??
 Q X
PACKERR ; error trap comes here
 D @^%ZOSF("ERRTN") ; make error log entry, too
 Q "8899^INTERNAL ERROR: "_$$ZE^ABSPOS ; this will go in transaction and eventually on display screen for user
