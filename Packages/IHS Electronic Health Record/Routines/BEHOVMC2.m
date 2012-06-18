BEHOVMC2 ;MSC/IND/MGH - CUMMULATIVE VITALS/MEASUREMENTS CONT ;09-Apr-2010 07:55;PLS
 ;;1.1;BEH COMPONENTS;**001004,001005**;Mar 20, 2007
 ;=================================================================
SETLN ; Store the data in the one line
 N BEH,ALTU,DEFU,DEFAULT,BEHVER,QUALS,VAL
 S BEHVER=^TMP("BEHV",$J,BEHDATE,BEHVTY,BEHVDA) N BEHVPO
 D:IOSL<($Y+9) HDR Q:BEHOUT  W ! W:BEHVER ?3,"(E)"
 I GPRT(BEHVTY)=0 D
 . W ?4,BEHVTY_": "
 S GPRT(BEHVTY)=1
 S BEHDAT=$G(^AUPNVMSR(BEHVDA,0))
 S BEHVX=BEHVTY,BEHVX(0)=$P(BEHDAT,"^",4) D
 .I "UNAVAILABLEPASSREFUSED"[$$UP^XLFSTR(BEHVX(0)) W ?9,BEHVX(0) Q
 .;Get the result
 .S TYP=$P(^AUPNVMSR(BEHVDA,0),U),VAL=$P(BEHDAT,U,4),MR=""
 . I BEHVTY="PA" D  Q
 . . I VAL=0 W ?9,VAL_" - No pain" Q
 . . I VAL=99 W ?9,VAL_" - Unable to respond" Q
 . . I VAL=10 W ?9,VAL_" - Worst imaginable pain" Q
 . . S QUALS=$$QUAL(BEHVDA)
 . . W ?9,VAL_" "_QUALS
 .S:'$G(DAT) DAT=DT
 .S AGE=$$PTAGE^BGOUTL(DFN,$S(X:X,1:DAT))
 .S BEH="" S BEH=$O(^BEHOVM(90460.01,"B",BEHVTY,BEH))
 .I BEHVTY="" D
 ..W ?9,$$RND(VAL)
 .E  D
 ..S DATA=$G(^BEHOVM(90460.01,BEH,0))
 ..S DEFAULT=$P(DATA,U,2)
 ..I DEFAULT=1 D
 ...S DEFU=$P(DATA,U,4),ALTU=$P(DATA,U,3)
 ...I ALTU=""!(DEFU=ALTU) D
 ....S QUALS=$$QUAL(BEHVDA)
 ....W ?9,$$RND(VAL)_" "_DEFU_" "_QUALS
 ...E  S X=VAL I $D(^BEHOVM(90460.01,BEH,2)) X $G(^BEHOVM(90460.01,BEH,2)) D
 ....S QUALS=$$QUAL(BEHVDA)
 ....W ?9,$$RND(VAL)_" "_DEFU_" ("_$$RND(X)_" "_ALTU_") "_QUALS
 ..I DEFAULT=0 D
 ...S DEFU=$P(DATA,U,3),ALTU=$P(DATA,U,4)
 ...I ALTU=""!(DEFU=ALTU) D
 ....S QUALS=$$QUAL(BEHVDA)
 ....W ?9,$$RND(VAL)_" "_DEFU
 ...E  S X=VAL I $D(^BEHOVM(90460.01,BEH,1)) X $G(^BEHOVM(90460.01,BEH,1)) D
 ....S QUALS=$$QUAL(BEHVDA)
 ....W ?9,$$RND(VAL)_" "_DEFU_" ("_$$RND(X)_" "_ALTU_") "_QUALS
 ..I DEFAULT="" D
 ...S QUALS=$$QUAL(BEHVDA)
 ...W ?9,$$RND(VAL)_" "_QUALS
 Q:$G(AGE)'>2!'$D(WT)!'$D(HT)
 S VAL=$$RND((WT*704.5)/(HT*HT))
 S MR=$S(AGE<20:"",VAL<18.5:"Underweight",VAL<25:"Normal Weight",VAL<30:"Overweight",VAL<35:"Obesity - Class 1",VAL<40:"Obesity - Class 2",1:"Extreme Obesity")
 W ?9,"BMI: "_VAL_" "_MR
 Q
RND(X) Q $S(X=+X:+$J(X,0,2),1:X)
HDR ;
 I 'BEH1ST D FOOTER^BEHVSC0
 I $E(IOST)'="P",'BEH1ST W "Press return to continue ""^"" to escape " R X:DTIME I X="^"!'$T S BEHOUT=1 Q
 W:'($E(IOST)'="C"&'$D(GFLAG)) @IOF S BEHPG=BEHPG+1,GFLAG=1
 W !,BEHPDT,?25,"Cumulative Vitals/Measurements Report",?70,"Page ",BEHPG,!!,$E(BEHDSH,1,78)
 I 'BEH1ST,$P(BEHDATE,".")=BEHDATE(0) W !,$E(BEHDATE(0),4,5)_"/"_$E(BEHDATE(0),6,7)_"/"_$E(BEHDATE,2,3)_" (continued)",!
 S BEH1ST=0
 Q
BLNK ;
 F I=1:1:$L(Z) Q:$E(Z,I)'=" "
 S Z=$E(Z,I,$L(Z))
 Q
QUAL(BEHIEN) ;Add on qualifiers
 N QUALSTR,MOD,QUAL
 S QUALSTR=""
 S MOD=0 F  S MOD=$O(^AUPNVMSR(BEHIEN,5,MOD)) Q:'+MOD  D
 .S QUAL=$G(^AUPNVMSR(BEHIEN,5,MOD,0))
 .S QUAL=$P($G(^GMRD(120.52,QUAL,0)),U,1)
 .S QUALSTR=QUALSTR_$S(QUALSTR'="":", ",1:"")_QUAL
 Q QUALSTR
