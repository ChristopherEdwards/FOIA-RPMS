GMVUTL8 ;HIOFO/DS-RPC API TO RETURN ALL VITALS/CATOGORIES/QUALIFIERS ;12/4/02  16:17
 ;;5.0;GEN. MED. REC. - VITALS;**1**;Oct 31, 2002
 ;
 ; This routine uses the following IAs:
 ;  #3227 - ^NURAPI calls          (private)
 ;
APTLIST(ARRAY,LOC) ; Returns a list of active patients for a nursing
 ; location in the array specified. [RPC entry point]
 ;  input:   LOC - (Required) NURS LOCATION file (#211.4) ien
 ;  input: ARRAY - (Required) Name of the array to return entries in
 ; output: ARRAY - Subscripted by sequential number with DFN in first
 ;                 piece and patient name in second piece.
 ;         example: ARRAY(#)=DFN^patient name^SSN^DOB^SEX AND AGE
 ;                  ^ATTENDING^VETERAN^INTERNAL DATE/TIME DECEASED
 ;                  ^EXTERNAL DATE/TIME DECEASED
 ;
 I $G(LOC)="" S ARRAY(1)=-1
 N DFN,GMVARRAY,GMVCNT,GMVPAT,PATNAME
 D APTLIST^NURAPI(LOC,.GMVARRAY)
 I $G(GMVARRAY(1))'>0 S ARRAY(1)=-1 Q
 S GMVCNT=0
 F  S GMVCNT=$O(GMVARRAY(GMVCNT)) Q:'GMVCNT  D
 .S DFN=$P(GMVARRAY(GMVCNT),U,1)
 .Q:'DFN
 .S PATNAME=$P(GMVARRAY(GMVCNT),U,2)
 .D PTINFO^GMVUTL3(.GMVPAT,DFN)
 .S ARRAY(GMVCNT)=DFN_U_PATNAME_U_GMVPAT
 .Q
 Q
TYPE(RESULT,GMVTYPE) ;GMV GET VITAL TYPE IEN [RPC entry point]
 ; Input:
 ;   RESULT = variable name to hold result
 ;  GMVTYPE = Name of Vital Type (from FILE 120.51) (e.g., WEIGHT)
 ; Output: Returns the IEN if GMVTYPE exists in FILE 120.51
 ;         else returns -1
 ;
 I GMVTYPE="" S RESULT=-1 Q
 S RESULT=+$O(^GMRD(120.51,"B",GMVTYPE,0))
 Q
CATEGORY(RESULT,GMVCAT) ;GMV GET CATEGORY IEN [RPC entry point]
 ; Input
 ;  RESULT = variable name to hold result
 ;  GMVCAT = Name of Category (from FILE 120.53) (e.g., METHOD)
 ; Output: Returns the IEN if GMVTYPE exists in FILE 120.53
 ;         else returns -1
 I GMVCAT="" S RESULT=-1 Q
 S RESULT=+$O(^GMRD(120.53,"B",GMVCAT,0))
 Q
VITALIEN() ;Returns the Vital Type IENS in a list separated by commas.
 ; ex: ",,8,9,21,20,5,3,22,1,2,19,"
 ;
 N GMVABB,GMVIEN,GMVLIST
 S GMVLIST=""
 F GMVABB="BP","T","R","P","HT","WT","CVP","CG","PO2","PN" D
 .S GMVIEN=$O(^GMRD(120.51,"C",GMVABB,0))
 .Q:'GMVIEN
 .S GMVLIST=GMVLIST_","_GMVIEN
 .Q
 I $L(GMVLIST)'="," S GMVLIST=GMVLIST_","
 Q GMVLIST
 ;
