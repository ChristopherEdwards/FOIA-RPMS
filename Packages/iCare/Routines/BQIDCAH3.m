BQIDCAH3 ;VNGT/HS/ALA-Ad Hoc continued ; 22 Apr 2011  12:02 PM
 ;;2.3;ICARE MANAGEMENT SYSTEM;;Apr 18, 2012;Build 59
 ;
LAB(FGLOB,TGLOB,LAB,LABTX,FDT,TDT,LNOT,MPARMS) ;EP - Lab test search
 NEW LBPT,LTAX,TREF,NGLOB,LCT,CT,IEN
 S NGLOB=$NA(^TMP("BQIDCLAB",$J)) K @NGLOB
 I $G(TGLOB)="" Q
 I $G(LAB)'="" D LB
 I $G(LABTX)'="" D
 . S TREF=$NA(MPARMS("LAB"))
 . K @TREF
 . S LTAX=$P(@("^"_$P(LABTX,";",2)_$P(LABTX,";",1)_",0)"),"^",1)
 . D BLD^BQITUTL(LTAX,TREF)
 I LBOP="!" D
 . I $D(MPARMS("LAB")) S LAB="" F  S LAB=$O(MPARMS("LAB",LAB)) Q:LAB=""  D LB
 I LBOP="&" D
 . K LBPT
 . S LAB="",CT=0 F  S LAB=$O(MPARMS("LAB",LAB)) Q:LAB=""  D LB S CT=CT+1
 . S IEN=""
 . F  S IEN=$O(LBPT(IEN)) Q:IEN=""  D
 .. S LCT=0,LB=""
 .. F  S LB=$O(LBPT(IEN,LB)) Q:LB=""  S LCT=LCT+1
 .. I LCT=CT,'LNOT S @TGLOB@(IEN)="" Q
 .. I LCT=CT,LNOT S @NGLOB@(IEN)=""
 ;
 I LNOT,$G(FGLOB)'="" D
 . S IEN="" F  S IEN=$O(@FGLOB@(IEN)) Q:IEN=""  D
 .. I '$D(@NGLOB@(IEN)) S @TGLOB@(IEN)=""
 I LNOT,$G(FGLOB)="" D
 . S IEN=0 F  S IEN=$O(^AUPNPAT(IEN)) Q:'IEN  I '$D(@NGLOB@(IEN)) S @TGLOB@(IEN)=""
 K @NGLOB
 Q
 ;
LB ;EP
 NEW DFN,IEN
 S TDT=$S(TDT'="":TDT,1:DT)
 I $G(FGLOB)'="" D  Q
 . NEW IEN
 . S IEN=""
 . F  S IEN=$O(@FGLOB@(IEN)) Q:'IEN  D
 .. I $O(^AUPNVLAB("AA",IEN,LAB,""))="" Q
 .. S BDT="",EDT=9999999-DT
 .. I FDT'="" S BDT=9999999-FDT+1,EDT=9999999-TDT
 .. F  S BDT=$O(^AUPNVLAB("AA",IEN,LAB,BDT)) Q:BDT=""!(BDT<EDT)  D
 ... S LIEN=""
 ... F  S LIEN=$O(^AUPNVLAB("AA",IEN,LAB,BDT,LIEN)) Q:LIEN=""  D
 .... S VIS=$P($G(^AUPNVLAB(LIEN,0)),U,3) I VIS="" Q
 .... I $G(^AUPNVSIT(VIS,0))="" Q
 .... Q:"DXCTI"[$P(^AUPNVSIT(VIS,0),U,7)
 .... I LBOP="!",'LNOT S @TGLOB@(IEN)="" Q
 .... I LBOP="!",LNOT S @NGLOB@(IEN)="" Q
 .... I LBOP="&" S LBPT(IEN,LAB)=""
 ;
 S IEN=""
 F  S IEN=$O(^AUPNVLAB("B",LAB,IEN)) Q:IEN=""  D
 . I $G(^AUPNVLAB(IEN,0))="" Q
 . S DFN=$P($G(^AUPNVLAB(IEN,0)),U,2),VIS=$P(^AUPNVLAB(IEN,0),U,3) I VIS="" Q
 . I $G(^AUPNVSIT(VIS,0))="" Q
 . Q:"DXCTI"[$P(^AUPNVSIT(VIS,0),U,7)
 . S VSDTM=$P(^AUPNVSIT(VIS,0),U,1)\1
 . I FDT'="",VSDTM<FDT!(VSDTM>TDT) Q
 . I DFN'="",LBOP="!",'LNOT S @TGLOB@(DFN)="" Q
 . I DFN'="",LBOP="!",LNOT S @NGLOB@(DFN)="" Q
 . I DFN'="",LBOP="&" S LBPT(DFN,LAB)=""
 ;
 Q
 ;
MED(FGLOB,TGLOB,MED,MEDTX,FDT,TDT,MNOT,MPARMS) ;EP - Medication search
 NEW MDPT,TREF,MTAX,NGLOB
 S NGLOB=$NA(^TMP("BQIDCMED",$J)) K @NGLOB
 I $G(TGLOB)="" Q
 I $G(MED)'="" D MD
 I $G(MEDTX)'="" D
 . S TREF=$NA(MPARMS("MED"))
 . K @TREF
 . S MTAX=$P(@("^"_$P(MEDTX,";",2)_$P(MEDTX,";",1)_",0)"),"^",1)
 . D BLD^BQITUTL(MTAX,TREF)
 I MDOP="!" D
 . I $D(MPARMS("MED")) S MED="" F  S MED=$O(MPARMS("MED",MED)) Q:MED=""  D MD
 I MDOP="&" D
 . K MDPT
 . S MED="",CT=0 F  S MED=$O(MPARMS("MED",MED)) Q:MED=""  D MD S CT=CT+1
 . S IEN=""
 . F  S IEN=$O(MDPT(IEN)) Q:IEN=""  D
 .. S MCT=0,MD=""
 .. F  S MD=$O(MDPT(IEN,MD)) Q:MD=""  S MCT=MCT+1
 .. I MCT=CT,'MNOT S @TGLOB@(IEN)="" Q
 .. I MCT=CT,MNOT S @NGLOB@(IEN)=""
 ;
 I MNOT,$G(FGLOB)'="" D
 . S IEN="" F  S IEN=$O(@FGLOB@(IEN)) Q:IEN=""  D
 .. I '$D(@NGLOB@(IEN)) S @TGLOB@(IEN)=""
 I MNOT,$G(FGLOB)="" D
 . S IEN=0 F  S IEN=$O(^AUPNPAT(IEN)) Q:'IEN  I '$D(@NGLOB@(IEN)) S @TGLOB@(IEN)=""
 K @NGLOB
 Q
 ;
MD ;EP
 NEW DFN,IEN
 S TDT=$S(TDT'="":TDT,1:DT)
 I $G(FGLOB)'="" D  Q
 . NEW IEN,MDP
 . S IEN=""
 . F  S IEN=$O(@FGLOB@(IEN)) Q:'IEN  D
 .. S BDT="",EDT=9999999-DT
 .. I FDT'="" S BDT=9999999-FDT+1,EDT=9999999-TDT
 .. F  S BDT=$O(^AUPNVMED("AA",IEN,BDT)) Q:BDT=""!(BDT<EDT)  D
 ... S MIEN=""
 ... F  S MIEN=$O(^AUPNVMED("AA",IEN,BDT,MIEN)) Q:MIEN=""  D
 .... S MDP=$P($G(^AUPNVMED(MIEN,0)),U,1)
 .... I MDOP="!",MDP=MED,MNOT S @NGLOB@(IEN)="" Q
 .... I MDOP="!",MDP=MED,'MNOT S @TGLOB@(IEN)="" Q
 .... I MDOP="&",MDP=MED S MDPT(IEN,MED)=""
 ;
 S IEN=""
 F  S IEN=$O(^AUPNVMED("B",MED,IEN)) Q:IEN=""  D
 . I $G(^AUPNVMED(IEN,0))="" Q
 . S DFN=$P(^AUPNVMED(IEN,0),U,2),VIS=$P(^AUPNVMED(IEN,0),U,3) I VIS="" Q
 . I $G(^AUPNVSIT(VIS,0))="" Q
 . Q:"DXCTI"[$P(^AUPNVSIT(VIS,0),U,7)
 . S VSDTM=$P(^AUPNVSIT(VIS,0),U,1)\1
 . I FDT'="",VSDTM<FDT!(VSDTM>TDT) Q
 . I DFN'="",MDOP="!",MNOT S @NGLOB@(DFN)="" Q
 . I DFN'="",MDOP="!",'MNOT S @TGLOB@(DFN)="" Q
 . I DFN'="",MDOP="&" S MDPT(DFN,MED)=""
 Q
