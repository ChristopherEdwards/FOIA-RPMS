VAFCRPC ;BIR/DLR-RPC ENTRY POINTS ;10/24/02  13:07
 ;;5.3;Registration;**414,440,474,477**;Aug 13, 1993
 ;;Routine uses the following supported IAs #2701 and #3027.
PDAT(RETURN,ICN,SSN) ;remote pdat display
 N TYPE,REP,ARRAY,DFN,VAFCSEN
 I ICN="" S RETURN(1)="-1^Invalid ICN passed into RPC" Q
 S DFN=$$GETDFN^MPIF001(ICN) ;IA 2701
 ;IF DFN=null check SSN in cases where ICN x-ref isn't set
 ;log patient sensitivity on receiving system and send msg bulletin
 I +DFN<1 S RETURN(1)="-1^Unknown ICN" Q
 ;D NOTICE^DGSEC4(.VAFCSEN,DFN,"RPC - VAFC REMOTE PDAT FROM THE MPI^MPI/PD Patient Inquiry",3) ;IA #3027
 S ARRAY="^TMP(""VAFCHFS"","_$J_")"
 S TYPE="I",REP=1 D HFS^VAFCHFS("START^VAFCPDAT")
 ;M RETURN=@ARRAY
 D DSPPDAT^VAFCHFS(.RETURN)
 K ^TMP("VAFCHFS",$J)
 Q
AUDIT(RETURN,VALUE,SSN,SDT,EDT) ;remote audit display
 ;'value' will pass in either an icn, ssn, dfn or patient name
 N ARRAY,DFN,ICN,NAME,SSN,VAFCSEN
 S ICN=$G(VALUE("ICN")) ;icn (local or national) passed in
 S NAME=$G(VALUE("NAME")) ;patient name passed in
 S SSN=$G(VALUE("SSN")) ;social security number passed in
 S DFN=$G(VALUE("DFN")) ;patient file ien passed in
 I $G(SSN)'="" S DFN=$O(^DPT("SSN",SSN,0)) I DFN="" S RETURN(1)="-1^Invalid SSN passed into RPC" Q
 I $G(ICN)'="" S DFN=$$GETDFN^MPIF001(ICN) I DFN="" S RETURN(1)="-1^Invalid ICN passed into RPC" Q  ;IA 2701
 I $G(NAME)'="" S DFN=$O(^DPT("B",NAME,0)) I DFN="" S RETURN(1)="-1^Invalid NAME passed into RPC" Q
 I $S('$G(DFN):1,'$D(^DPT(DFN,0)):1,1:0) S RETURN(1)="-1^Invalid DFN passed into RPC" Q
 ;log patient sensitivity on receiving system and send msg bulletin
 ;D NOTICE^DGSEC4(.VAFCSEN,DFN,"RPC - VAFC REMOTE AUDIT FROM THE MPI^Remote Audit Query",3) ;IA #3027
 S ARRAY="^TMP(""VAFCHFS"","_$J_")"
 D HFS^VAFCHFS("START^VAFCAUD(DFN,SDT,EDT,1)")
 ;M RETURN=@ARRAY
 D DSPPDAT^VAFCHFS(.RETURN)
 K ^TMP("VAFCHFS",$J)
 Q
