ACHSDOCR ; IHS/ITSC/PMF - extract standard vars from 0 level of document   [ 10/16/2001   8:16 AM ]
 ;;3.1;CONTRACT HEALTH MGMT SYSTEM;;JUN 11, 2001
 ;
 ;standard call to fetch data.  Pass in the document IEN, and
 ; get back a whole set of vars.
 ;
 ;INPUT:
 ;   ACHSDIEN - the index number to the document
 ;
 ;OUTPUT:
 ;   ACHSDOCR - the string from ACHSF(fac,"D",ACHSDIEN,0)
 ;   OK       - true if the process completed, otherwise false
 ;
 ;here are the variables that get returned, in alphabetical order
 ;in the software, they are set in the order of the ACHSDOCR string
 ;
 ;       AMTOBLG         total amount obligated
 ;       BLNKT           blanket order flag
 ;       CAN             CAN number
 ;       CANP            CAN number pointer
 ;       CHART           chart number
 ;       CLERK           clerk
 ;       CNTRPTR         contract pointer
 ;       COMMENT         comment
 ;       DCRACCT         dcr account number
 ;       DESTN           destination
 ;       DRGRATE         drg rate
 ;       FAC             facility code
 ;       FSCLYR          fiscal year of the doc
 ;       IHSADJ          HIS adjustments
 ;       LSUP            last supplement number 
 ;       LSTCNC          last cancel number
 ;       OCC             object class code
 ;       OCCPTR          pointer to object class code
 ;       ORDDAT          order date 
 ;       ORDNUM          order number
 ;       PATNUM          patient number
 ;       SCC             service class code 
 ;       SCCP            service class code pointer 
 ;       STATUS          status 
 ;       TRBPRN          tribal purchase request number
 ;       TRIBE           tribal number
 ;       TYPSER2         type of service encoded as 1/2/3
 ;       TYPSERV         type of service
 ;       VNAGRPT         vendor agreement pointer
 ;       VNDEST          vendor estimate
 ;       VNDNAM          vendor name
 ;       VNDPTR          vendor pointer
 ;       VNDREF          vendor reference number
 ;
 S OK=0
 I $G(ACHSDIEN)="" Q
 ;
 S ACHSDOCR=$G(^ACHSF(DUZ(2),"D",ACHSDIEN,0))
 I ACHSDOCR="" Q
 ;
 S ORDNUM=$P(ACHSDOCR,U,1)
 S ORDDAT=$P(ACHSDOCR,U,2)
 S BLNKT=$P(ACHSDOCR,U,3)
 S TYPSERV=$P(ACHSDOCR,U,4),TYPSER2=$S(TYPSERV=1:43,TYPSERV=2:57,TYPSERV=3:64,1:"  ")
 ;
 S CNTRPTR=$P(ACHSDOCR,U,5)
 ;
 S CANP=$P(ACHSDOCR,U,6),CAN="" I CANP'="" S CAN=$P($G(^ACHS(2,CANP,0)),U)
 ;
 S SCCP=$P(ACHSDOCR,U,7),SCC="" I SCCP'="" S SCC=$P($G(^ACHS(3,DUZ(2),1,SCCP,0)),U)
 ;
 S VNDPTR=$P(ACHSDOCR,U,8),VNDNAM="" I VNDPTR'="" S VNDNAM=$G(^AUTTVNDR(VNDPTR,0))
 ;
 S AMTOBLG=$P(ACHSDOCR,U,9)
 S OCCPTR=$P(ACHSDOCR,U,10),OCC="" I OCCPTR'="" S OCC=$P($G(^ACHSOCC(OCCPTR,0)),U)
 ;
 S IHSADJ=$P(ACHSDOCR,U,11)
 S STATUS=$P(ACHSDOCR,U,12)
 S COMMENT=$P(ACHSDOCR,U,13)
 S FSCLYR=$P(ACHSDOCR,U,14)
 S LSTSUP=$P(ACHSDOCR,U,15)
 S LSTCNC=$P(ACHSDOCR,U,16)
 S DESTN=$P(ACHSDOCR,U,17)
 S CLERK=$P(ACHSDOCR,U,18)
 S DCRACCT=$P(ACHSDOCR,U,19)
 S FAC=$P(ACHSDOCR,U,20)
 S CHART=$P(ACHSDOCR,U,21)
 S (DFN,PATNUM)=$P(ACHSDOCR,U,22)
 S TRIBE="   "
 I DFN'="" D
 . S TRIBE=$P($G(^AUPNPAT(DFN,11)),U,8)
 . I TRIBE'="" S TRIBE=$P($G(^AUTTTRI(TRIBE,0)),U,2)
 . I TRIBE=""!(TRIBE'?3N) S TRIBE="   "
 . Q
 ;
 S VNAGPTR=$P(ACHSDOCR,U,23)
 S VNDREFN=$P(ACHSDOCR,U,24)
 S DRGRATE=$P(ACHSDOCR,U,25)
 S TRBPRN=$P(ACHSDOCR,U,26)
 S OK=1
 ;
 Q
 ;
INIT ;
 ;init the vars to null
 S (ACHSDOCR,AMTOBLG,BLNKT,CAN,CANP,CHART,CLERK,COMMENT)=""
 S (CNTRPTR,FSCLYR,DCRACCT,DESTN,DRGRATE,FAC,IHSADJ,LSTSUP)=""
 S (LSTCNC,OCC,OCCPTR,ORDDAT,ORDNUM,PATNUM,SCC,SCCP,STATUS)=""
 S (TRBPRN,TRIBE,TYPSER2,TYPSERV,VNAGPTR,VNDEST,VNDPTR,VNDNAM,VNDREFN)=""
 Q
 ;
KLL ;EP from ACHSTX11
 ;kill the vars normally set by this program
 K ACHSDORC,AMTOBLG,BLNKT,CAN,CANP,CHART,CLERK,COMMENT
 K CNTRPTR,FSCLYR,DCRACCT,DESTN,DRGRATE,FAC,IHSADJ,LSTSUP
 K LSTCNC,OCC,OCCPTR,ORDDAT,ORDNUM,PATNUM,SCC,SCCP,STATUS
 K TRBPRN,TRIBE,TYPSER2,TYPSERV,VNDEST,VNAGPTR,VNDPTR,VNDNAM,VNDREFN
 Q
