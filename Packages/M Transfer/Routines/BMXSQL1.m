BMXSQL1 ; IHS/OIT/HMW - BMX REMOTE PROCEDURE CALLS ; 
 ;;4.0;BMX;;JUN 28, 2010
 ;
 ;
KW(BMXTK)          ;EP
 ;Identify and mark keywords in BMXTK
 ;MODIFIES BMXTK
 ;
 N J,BMXSTOP,BMXTMP
 ;Combine ORDER BY and GROUP BY into a single token
 ;
 S J=0
 F  S J=$O(BMXTK(J)) Q:'+J  D
 . S BMXTMP=$$UCASE(BMXTK(J))
 . I BMXTMP="ORDER"!(BMXTMP="GROUP") D
 . . I $D(BMXTK(J+1)),$$UCASE(BMXTK(J+1))="BY" D
 . . . S BMXTK(J)=BMXTK(J)_" "_BMXTK(J+1)
 . . . S BMXTK(J)=$$UCASE(BMXTK(J))
 . . . S BMXTK(BMXTK(J))=J
 . . . K BMXTK(J+1)
 . . . Q
 . . Q
 . Q
 ;
 ;Find SELECT
 S J=0,BMXSTOP=0
 F  S J=$O(BMXTK(J)) Q:'+J  D  Q:BMXSTOP
 . I $$UCASE(BMXTK(J))="SELECT" D
 . . S BMXTK(J)=$$UCASE(BMXTK(J))
 . . S BMXTK("SELECT")=J
 . . S BMXSTOP=1
 . . Q
 . Q
 I '+J S BMXERR="SELECT KEYWORD NOT FOUND" Q
 ;
 ;DISTINCT
 S BMXSTOP=0
 F  S J=$O(BMXTK(J)) Q:'+J  Q:$$UCASE(BMXTK(J))="FROM"  D  Q:BMXSTOP
 . I $$UCASE(BMXTK(J))="DISTINCT" D
 . . S BMXTK("DISTINCT")="TRUE"
 . . K BMXTK(J)
 . . S J=J-1
 . . S BMXSTOP=1
 . Q
 ;
 ;FROM
 S BMXSTOP=0
 S J=J-1
 F  S J=$O(BMXTK(J)) Q:'+J  Q:$$UCASE(BMXTK(J))="WHERE"  D  Q:BMXSTOP
 . I $$UCASE(BMXTK(J))="FROM" D
 . . S BMXTK(J)=$$UCASE(BMXTK(J))
 . . S BMXTK("FROM")=J
 . . S BMXSTOP=1
 . . Q
 . Q
 ;
 I '$D(BMXTK("FROM")) S BMXERR="'FROM' KEYWORD NOT FOUND" Q
 ;
 ;WHERE
 S BMXSTOP=0
 F  S J=$O(BMXTK(J)) Q:'+J  Q:BMXTK(J)="ORDER BY"  Q:BMXTK(J)="GROUP BY"  D  Q:BMXSTOP
 . I $$UCASE(BMXTK(J))="WHERE" D
 . . S BMXTK(J)=$$UCASE(BMXTK(J))
 . . S BMXTK("WHERE")=J
 . . S BMXSTOP=1
 . Q
 ;
 ;SHOWPLAN
 S J=BMXTK("FROM")
 S BMXSTOP=0
 F  S J=$O(BMXTK(J)) Q:'+J  D  Q:BMXSTOP
 . I $$UCASE(BMXTK(J))="SHOWPLAN" D
 . . S BMXTK("SHOWPLAN")="TRUE"
 . . K BMXTK(J)
 . . S J=J-1
 . . S BMXSTOP=1
 . Q
 ;
 ;MAXRECORDS
 S J=BMXTK("FROM")
 S BMXSTOP=0
 F  S J=$O(BMXTK(J)) Q:'+J  D  Q:BMXSTOP
 . I $$UCASE(BMXTK(J))["MAXRECORDS" D
 . . S BMXXMAX=+$P(BMXTK(J),":",2)-1
 . . S:+BMXXMAX<0 BMXXMAX=0
 . . K BMXTK(J)
 . . S J=J-1
 . . S BMXSTOP=1
 . Q
 Q
 ;
SCREEN ;EP
 ;Set up BMXFG() array of executable screen code
 N F,BMXNOD,BMXFNUM,BMXFLDNM,BMXHIT,BMXREF
 N BMXRNAM,BMXRET,BMXOP,Q,BMXPC,BMXV,BMXFLDLO,BMXFLDNO
 N BMXGL
 S BMXRET=""
 S Q=$C(34)
 S BMXFG=BMXFF
 S BMXFG("C")=0
 I 'BMXFF Q
 S F=0,BMXHIT=0
 F F=1:1:BMXFF S BMXNOD=BMXFF(F) D  Q:$D(BMXERR)  Q:BMXHIT
 . I $G(BMXFF(F,"INDEXED"))=1 D  Q
 . . S BMXFG(F)="1"
 . . Q
 . I $D(BMXFF(F,"JOIN")) D  Q
 . . S BMXFG(F)="1"
 . . Q
 . I "(^)"[BMXFF(F) D  Q
 . . S BMXFG(F)=BMXFF(F)
 . . Q
 . I "AND^OR"[BMXFF(F) D  Q
 . . I BMXFF(F)="AND" S BMXFG(F)="&" Q
 . . S BMXFG(F)="!"
 . . Q
 . S BMXFNUM=$S(+$P(BMXNOD,U):$P(BMXNOD,U),1:$O(^DIC("B",$P(BMXNOD,U),0)))
 . I '+BMXFNUM D  ;Not a fileman field
 . . S BMXFLDNM=0,BMXFLDNO=""
 . . S BMXFLDLO=$P(BMXFF(F),U,2)
 . . ;
 . E  D  ;Get fileman field data
 . . S BMXGL=^DIC(BMXFNUM,0,"GL")
 . . I $D(BMXFF(F,"IEN")) D
 . . . S BMXFLDNM=".001"
 . . . S BMXFLDNO="IEN"
 . . E  D
 . . . S BMXFLDNM=$O(^DD(BMXFNUM,"B",$P(BMXNOD,U,2),0))
 . . . S BMXFLDNO=^DD(BMXFNUM,BMXFLDNM,0)
 . I BMXFLDNO="IEN" D  ;BMXIEN field
 . . N BMXEXT,C S BMXEXT=0
 . . ;S BMXPC=$P(BMXFLDNO,U,4)
 . . I $P(BMXFF(F),U,5)'=BMXFO(1) S BMXEXT=1 D EXP ;Extended pointer
 . . S BMXFLDLO="D0"
 . . I BMXEXT S BMXFG("C",C)=BMXFG("C",C)_BMXFLDLO,BMXFLDLO="BMXSCR(""X"","_C_")"
 . I $P(BMXFLDNO,U,2)["D" D  ;Date field
 . . N BMXEXT,C S BMXEXT=0
 . . S BMXPC=$P(BMXFLDNO,U,4)
 . . I $P(BMXFF(F),U,5)'=BMXFO(1) S BMXEXT=1 D EXP ;Extended pointer
 . . S BMXFLDLO="$P($G("_BMXGL_"D0,"_Q_$P(BMXPC,";")_Q_")),U,"_$P(BMXPC,";",2)_")"
 . . I BMXEXT S BMXFG("C",C)=BMXFG("C",C)_BMXFLDLO,BMXFLDLO="BMXSCR(""X"","_C_")"
 . I $P(BMXFLDNO,U,2)["S" D  ;Set field
 . . N BMXEXT,C S BMXEXT=0
 . . S BMXPC=$P(BMXFLDNO,U,4)
 . . I $P(BMXFF(F),U,5)'=BMXFO(1) S BMXEXT=1 D EXP ;Extended pointer
 . . S BMXFLDLO="$P("_BMXGL_"D0,"_$P(BMXPC,";")_"),U,"_$P(BMXPC,";",2)_")"
 . . I BMXEXT S BMXFG("C",C)=BMXFG("C",C)_BMXFLDLO,BMXFLDLO="BMXSCR(""X"","_C_")"
 . ;
 . I $P(BMXFLDNO,U,2)["P" D  ;Pointer field
 . . N C,BMXEXT
 . . S BMXEXT=0
 . . I $P(BMXFF(F),U,5)'=BMXFO(1) D
 . . . N R,G,BMXJN,BMXMSCR
 . . . S BMXMXCR=1 ;Remove after testing.  Find out if the field is from a subfile.
 . . . I BMXMXCR D  Q
 . . . . ;Set up a screen in BMXSCR and in BMXMFL(
 . . . . Q
 . . . ;
 . . . ;Find the node of BMXFF that has the join info
 . . . S BMXEXT=1
 . . . S BMXFG("C")=BMXFG("C")+1
 . . . S C=BMXFG("C")
 . . . S R=0 F  S R=$O(BMXFJ("JOIN",R)) Q:'+R  I R=$P(BMXFF(F),U,5) S G=BMXFJ("JOIN",R) Q
 . . . S BMXJN=BMXFF(G,"JOIN")
 . . . S BMXJN=$P(BMXJN,"IEN0",1)_"D0"_$P(BMXJN,"IEN0",2)
 . . . S BMXJN="S X="""","_BMXFF(G,"JOIN","IEN")_"=D0 N D0 "_BMXJN_"I +D0 S X="
 . . . S BMXFG("C",C)=BMXJN
 . . S BMXFLDLO=$$SCRNP(F,BMXGL,BMXFLDNM,BMXFLDNO)
 . . I BMXEXT S BMXFG("C",C)=BMXFG("C",C)_BMXFLDLO,BMXFLDLO="BMXSCR(""X"","_C_")"
 . I $P(BMXFLDNO,U,2)["C" D  ;Computed field
 . . N C
 . . S BMXPC=$P(BMXFLDNO,U,5,99)
 . . S BMXFG("C")=BMXFG("C")+1
 . . S C=BMXFG("C")
 . . ;If computed field not in primary file, connect navigation code
 . . I $P(BMXFF(F),U,5)'=BMXFO(1) D
 . . . ;Find the node of BMXFF that has the join info
 . . . N R,G,BMXJN
 . . . S R=0 F  S R=$O(BMXFJ("JOIN",R)) Q:'+R  I R=$P(BMXFF(F),U,5) S G=BMXFJ("JOIN",R) Q
 . . . S BMXJN=BMXFF(G,"JOIN")
 . . . S BMXJN=$P(BMXJN,"IEN0",1)_"D0"_$P(BMXJN,"IEN0",2)
 . . . S BMXJN="S X="""","_BMXFF(G,"JOIN","IEN")_"=D0 N D0 "_BMXJN_"I +D0 "
 . . . S BMXJN=BMXJN_BMXPC
 . . . S BMXFF(F,0)=$P(BMXFF(F,0),U,1,4)
 . . . S $P(BMXFF(F,0),U,5)=BMXJN
 . . . S BMXPC=BMXJN
 . . S BMXFG("C",C)=BMXPC
 . . S BMXFLDLO="BMXSCR(""X"","_C_")"
 . I $P(BMXFLDNO,U,2)["N"  D  ;Numeric field
 . . N BMXEXT,C S BMXEXT=0
 . . S BMXPC=$P(BMXFLDNO,U,4)
 . . I $P(BMXFF(F),U,5)'=BMXFO(1) S BMXEXT=1 D EXP ;Extended pointer
 . . S BMXFLDLO="$P("_BMXGL_"D0,"_$P(BMXPC,";")_"),U,"_$P(BMXPC,";",2)_")"
 . . I BMXEXT S BMXFG("C",C)=BMXFG("C",C)_BMXFLDLO,BMXFLDLO="BMXSCR(""X"","_C_")"
 . ;
 . I $P(BMXFLDNO,U,2)["F"  D  ;Free Text field
 . . N BMXEXT,C S BMXEXT=0,C=0
 . . S BMXPC=$P(BMXFLDNO,U,4)
 . . I $P(BMXFF(F),U,5)'=BMXFO(1) S BMXEXT=1 D
 . . . N R,G,BMXJN
 . . . S BMXFG("C")=BMXFG("C")+1
 . . . S C=BMXFG("C")
 . . . S R=0 F  S R=$O(BMXFJ("JOIN",R)) Q:'+R  I R=$P(BMXFF(F),U,5) S G=BMXFJ("JOIN",R) Q
 . . . S BMXJN=BMXFF(G,"JOIN")
 . . . S BMXJN=$P(BMXJN,"IEN0",1)_"D0"_$P(BMXJN,"IEN0",2)
 . . . S BMXJN="S X="""","_BMXFF(G,"JOIN","IEN")_"=D0 N D0 "_BMXJN
 . . . S BMXJN=BMXJN_"I +D0 S X="
 . . . S BMXFG("C",C)=BMXJN
 . . . S BMXFLDLO="BMXSCR(""X"","_C_")"
 . . I $P(BMXFLDNO,U,4)["E" D
 . . . N BMXPC2,BMXTMP
 . . . S BMXPC2=$P(BMXPC,"E",2)
 . . . S BMXTMP="$E("_BMXGL_"D0,"_$P(BMXPC,";")_"),"_$P(BMXPC2,",")_","_$P(BMXPC2,",",2)_")"
 . . . I BMXEXT S BMXFG("C",C)=BMXFG("C",C)_BMXTMP
 . . . E  S BMXFLDLO=BMXTMP
 . . E  D
 . . . N BMXTMP
 . . . S BMXTMP="$P("_BMXGL_"D0,"_$P(BMXPC,";")_"),U,"_$P(BMXPC,";",2)_")"
 . . . S BMXTMP="$S($D("_BMXGL_"D0,"_$P(BMXPC,";")_")):"_BMXTMP_",1:"""")"
 . . . I BMXEXT S BMXFG("C",C)=BMXFG("C",C)_BMXTMP
 . . . E  S BMXFLDLO=BMXTMP
 . ;
 . S BMXOP=$P(BMXNOD,U,3)
 . S BMXV=$P(BMXFF(F),U,4)
 . I "<^>^=^["[BMXOP D
 . . I BMXOP=">",BMXV?.A S BMXOP="]"
 . . I BMXOP="<",BMXV?.A S BMXOP="']"
 . . S BMXRET="("_BMXFLDLO_BMXOP_Q_BMXV_Q_")"
 . . Q
 . I "<>"=BMXOP D
 . . S BMXOP="'="
 . . S BMXRET="("_BMXFLDLO_BMXOP_Q_BMXV_Q_")"
 . I ">="=BMXOP D
 . . I BMXV="" S BMXRET="(I 1)" Q
 . . I +BMXV=BMXV D  Q
 . . . S BMXOP="'<"
 . . . S BMXRET="("_BMXFLDLO_BMXOP_Q_BMXV_Q_")"
 . . S BMXV=$$DECSTR^BMXSQL2(BMXV)
 . . S BMXOP="]"
 . . S BMXRET="("_BMXFLDLO_BMXOP_Q_BMXV_Q_")"
 . I "<="=BMXOP D
 . . I BMXV="" S BMXRET="(I 0)" Q
 . . I +BMXV=BMXV D  Q
 . . . S BMXOP="'>"
 . . . S BMXRET="("_BMXFLDLO_BMXOP_Q_BMXV_Q_")"
 . . S BMXV=$$INCSTR^BMXSQL2(BMXV)
 . . S BMXOP="']"
 . . S BMXRET="("_BMXFLDLO_BMXOP_Q_BMXV_Q_")"
 . I BMXOP="BETWEEN" D
 . . I +$P(BMXV,"~")'=$P(BMXV,"~") D  ;BMXV a string
 . . . N W,X,Y,Z
 . . . S X=$P(BMXV,"~")
 . . . S Y=$E(X,1,$L(X)-1)
 . . . S Z=$E(X,$L(X))
 . . . S Z=$A(Z)
 . . . S Z=Z-1
 . . . S Z=$C(Z)
 . . . S W=Y_Z
 . . . S $P(BMXV,"~")=W
 . . . S BMXRET="(("_BMXFLDLO_"]"_Q_$P(BMXV,"~")_Q_")&("_BMXFLDLO_"']"_Q_$P(BMXV,"~",2)_Q_"))"
 . . E  D  ;BMXV a number
 . . . S BMXRET="(("_BMXFLDLO_"'<"_$P(BMXV,"~")_")&("_BMXFLDLO_"'>"_$P(BMXV,"~",2)_"))"
 . . Q
 . I BMXOP="LIKE" D
 . . S BMXRET="("_BMXFLDLO_"?1"_Q_BMXV_Q_".E)"
 . I BMXRET]"" D
 . . S BMXFG(F)=BMXRET
 . . Q
 . ;TODO:  Pointer fields
 . ;TODO:  Computed fields
 . ;TODO:  Sets of codes
 . ;TODO:  Dates
 . Q
 Q
 ;
SCRNP(F,BMXGL,BMXFLDNU,BMXFLDNO) ;
 ;Requires BMXFF()
 ;Sets up expression for pointer field
 N BMX,BMXCOR,BMXRET,BMXPC
 S BMXPC=$P(BMXFLDNO,U,4)
 S BMXCOR="$P($G("_BMXGL_"D0,"_Q_$P(BMXPC,";")_Q_")),U,"_$P(BMXPC,";",2)_")"
 S BMXRET=BMXCOR
 Q:$D(BMXFF(F,"INTERNAL")) BMXRET
 S BMXFNUM=$P(BMXFLDNO,U,2)
 S BMXFNUM=+$P(BMXFNUM,"P",2)
 S BMXGL=^DIC(BMXFNUM,0,"GL")
 S BMXFLDNM=".01"
 S BMXFLDNO=^DD(BMXFNUM,BMXFLDNM,0)
 F  D:$P(BMXFLDNO,U,2)["P"  Q:$P(BMXFLDNO,U,2)'["P"
 . S BMXPC=$P(BMXFLDNO,U,4)
 . S BMXRET="$P($G("_BMXGL_BMXRET_","_Q_$P(BMXPC,";")_Q_")),U,"_$P(BMXPC,";",2)_")"
 . S BMXFNUM=$P(BMXFLDNO,U,2)
 . S BMXFNUM=+$P(BMXFNUM,"P",2)
 . S BMXGL=^DIC(BMXFNUM,0,"GL")
 . S BMXFLDNM=".01"
 . S BMXFLDNO=^DD(BMXFNUM,BMXFLDNM,0)
 ;B  ;SCRN2 After chain
 ;I 0 D  ;$P(BMXFLDNO,U,2)["D" D  ;Pointer to a date
 ;. Q:+$G(BMXFF(F,"INDEXED"))  ;Dates converted when iterator built
 ;. N BMXD,J
 ;. S BMXD=$P(BMXFF(F),U,4)
 ;. S %DT="T"
 ;. F J=1:1:$L(BMXD,"~") D
 ;. . S X=$P(BMXD,"~",J)
 ;. . D ^%DT
 ;. . S $P(BMXD,"~",J)=Y
 ;. S $P(BMXFF(F),U,4)=BMXD
 S BMXRET="$P($G("_BMXGL_BMXRET_",0)),U,1)"
 S BMXRET="$S(+"_BMXCOR_":"_BMXRET_",1:"""")"
 Q BMXRET
 ;
CASE(BMXTK)       ;EP
 ;Convert keywords to uppercase
 N J
 S J=0
 F  S J=$O(BMXTK(J)) Q:'+J  D
 . F K="DISTINCT","SELECT","WHERE","FROM","SHOWPLAN" D
 . . I $$UCASE(BMXTK(J))=K S BMXTK(J)=$$UCASE(BMXTK(J))
 . Q
 Q
 ;
UCASE(X) ;EP Convert X to uppercase
 F %=1:1:$L(X) S:$E(X,%)?1L X=$E(X,0,%-1)_$C($A(X,%)-32)_$E(X,%+1,999)
 Q X
 ;
EXP ;Extended pointer
 N R,G,BMXJN
 S BMXEXT=1
 S BMXFG("C")=BMXFG("C")+1
 S C=BMXFG("C")
 S R=0 F  S R=$O(BMXFJ("JOIN",R)) Q:'+R  I R=$P(BMXFF(F),U,5) S G=BMXFJ("JOIN",R) Q
 S BMXJN=BMXFF(G,"JOIN")
 S BMXJN=$P(BMXJN,"IEN0",1)_"D0"_$P(BMXJN,"IEN0",2)
 S BMXJN="S X="""","_BMXFF(G,"JOIN","IEN")_"=D0 N D0 "_BMXJN_"I +D0 S X="
 S BMXFG("C",C)=BMXJN
 Q
