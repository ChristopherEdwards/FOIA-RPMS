BMXSQL4 ; IHS/OIT/HMW - BMX REMOTE PROCEDURE CALLS ;
 ;;4.0;BMX;;JUN 28, 2010
 ;
 ;
JOIN ;EP - Join processing
 ;Create a pointer chain back to the primary file
 ;or to a reverse pointer file, E.G.:
 ;Either executable code or an expression that returns the
 ;IEN of the terminal pointed-to file
 ;
 ; S IEN1=$P(^DIZ(1000,IEN2,0),U,4)
 ; I +IEN1 S IEN=$P(^AUTTLOC(IEN1,0),U,23)
 ;
 Q:'$D(BMXFJ("JOIN"))
 N C,D,E,BMXSTOP,BMXPTF,BMXPTG,BMXPTL,BMXPTN,BMXPTP,BMXPTC
 S C=0 F  S C=$O(BMXFF(C)) Q:'+C  D
 . Q:'$D(BMXFF(C,"JOIN"))
 . S BMXPTL=1,BMXPTC="",D=C ;Pointer level
 . F  S BMXPTF=$P(BMXFF(D),U,5) D  Q:BMXPTF=BMXFO(1)
 . . S BMXPTG=$P(BMXFF(D),U,7,99) ;Pf Global
 . . S BMXPTN=$P(BMXFF(D,0),U,4) ;Pf Node
 . . S BMXPTP=$P(BMXPTN,";",2) ;Pf Piece
 . . S BMXPTN=$P(BMXPTN,";")
 . . S BMXPTC="I +IEN"_BMXPTL_" S IEN"_(BMXPTL-1)_"=$P($G("_BMXPTG_"IEN"_BMXPTL_","_BMXPTN_")),U,"_BMXPTP_") "_BMXPTC
 . . S BMXPTL=BMXPTL+1
 . . ;S D To the index of the pointed to file's entry in BMXFF
 . . Q:BMXPTF=BMXFO(1)
 . . S E=0,BMXSTOP=0 F  S E=$O(BMXFF(E)) Q:'+E  Q:BMXSTOP  D
 . . . I $D(BMXFF(E,0)),+$P($P(BMXFF(E,0),U,2),"P",2)=BMXPTF S D=E,BMXSTOP=1 Q
 . . . I $D(BMXFF(E,0)),BMXPTF=9000001,+$P($P(BMXFF(E,0),U,2),"P",2)=2 S D=E,BMXSTOP=1 Q  ;IHS auto join PATIENT to VA PATIENT
 . S BMXFF(C,"JOIN")=BMXPTC
 . S BMXFF(C,"JOIN","IEN")="IEN"_(BMXPTL-1)
 Q
